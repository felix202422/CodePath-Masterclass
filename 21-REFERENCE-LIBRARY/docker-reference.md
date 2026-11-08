# Docker Reference

Commands, Dockerfile instructions, multi-stage patterns and Compose equivalents for Docker Engine 29.

> **Baseline.** Docker Engine 29 / Docker Desktop 4.95, Compose v2 (`docker compose`, two words, no
> hyphen). The CLI is installed on the authoring machine, but **its daemon was not running when this
> page was written**, so the commands below were not executed here — they follow the official
> reference. Everything marked *verified* elsewhere on this page would need a running daemon.

## The mental model

| Thing | Is | Lives |
|---|---|---|
| Image | An immutable, layered filesystem plus metadata (entrypoint, env, ports). | Local cache, then a registry. |
| Container | A running process isolated with namespaces and cgroups, started from an image plus a writable layer. | The host's Docker engine. |
| Layer | One filesystem diff per Dockerfile instruction (`RUN`, `COPY`, `ADD`). | Cached by content hash; reused across builds. |
| Registry | A store of named images (`repo:tag`, or `repo@sha256:...`). | Docker Hub, GHCR, ECR, a private registry. |
| Volume | Docker-managed persistent storage. | `/var/lib/docker/volumes` on the host. |
| Bind mount | A host path mapped into the container. | Wherever the host keeps it. |
| Network | A virtual switch giving containers DNS names and isolation. | Docker's bridge, overlay or host network. |

A container is not a small virtual machine: it shares the host kernel, so a kernel exploit escapes the
container, and `--privileged` removes most of the isolation.

## Commands by task

| Task | Command |
|---|---|
| Build an image | `docker build -t notes:1.0 .` |
| Build for another architecture | `docker buildx build --platform linux/amd64 -t notes:1.0 .` |
| List images | `docker images`, `docker image ls` |
| Run a container | `docker run --rm -p 8080:8080 notes:1.0` |
| Run interactively | `docker run --rm -it --entrypoint sh notes:1.0` |
| Run in the background | `docker run -d --name notes -p 8080:8080 notes:1.0` |
| List containers | `docker ps`, `docker ps -a` (include stopped) |
| Logs | `docker logs -f --tail 100 notes` |
| Shell into a running container | `docker exec -it notes sh` |
| Inspect metadata | `docker inspect notes` (JSON), `--format '{{.State.Health.Status}}'` |
| Resource usage | `docker stats --no-stream` |
| Copy files in/out | `docker cp notes:/app/log.txt .` |
| Stop / start / restart | `docker stop notes`, `docker start notes`, `docker restart notes` |
| Remove a container | `docker rm notes` (`-f` stops it first) |
| Remove an image | `docker rmi notes:1.0` |
| Tag for a registry | `docker tag notes:1.0 ghcr.io/me/notes:1.0` |
| Push | `docker push ghcr.io/me/notes:1.0` |
| Pull | `docker pull postgres:18` |
| Save / load an image | `docker save notes:1.0 -o notes.tar`, `docker load -i notes.tar` |
| Disk usage | `docker system df` |
| Prune | `docker system prune` (all unused), `docker builder prune` (build cache only) |

`docker system prune -a --volumes` deletes every unused image, network **and volume** — data loss.
Read the confirmation prompt before typing `y`.

## `docker run` flags worth knowing

| Flag | Effect |
|---|---|
| `-d` | Detached (background). |
| `-it` | Interactive with a TTY — for shells. |
| `--rm` | Remove the container when it exits. |
| `--name <n>` | Stable name; otherwise Docker invents one. |
| `-p 8080:8080` | Publish host port to container port. `127.0.0.1:8080:8080` binds loopback only. |
| `-e KEY=value` | Environment variable. Prefer `--env-file` for several. |
| `--env-file .env` | Load variables from a file. |
| `-v notes-data:/var/lib/postgresql/data` | Named volume. |
| `-v "$PWD":/app` | Bind mount the current directory. |
| `--network app-net` | Attach to a user-defined network. |
| `--restart unless-stopped` | Restart policy; `on-failure` is the conservative choice. |
| `--memory 512m --cpus 1.0` | Resource limits. |
| `--health-cmd`, `--health-interval` | Health check without a Dockerfile. |
| `--user 1000:1000` | Run as a non-root UID. |
| `--read-only` | Read-only root filesystem; pair with `--tmpfs /tmp`. |
| `--entrypoint sh` | Override the image entrypoint. |

## Dockerfile instructions

| Instruction | Purpose | Notes |
|---|---|---|
| `FROM` | Base image. | Pin a tag (`eclipse-temurin:21-jre`), ideally a digest, never `latest`. |
| `WORKDIR` | Set and create the working directory. | All later relative paths resolve here. |
| `COPY` | Copy from the build context. | `COPY --chown=app:app src/ ./`; use it over `ADD` unless you need a URL or tar extraction. |
| `ADD` | Like `COPY` plus URL and auto-extract. | Surprising; prefer `COPY` + `RUN curl`. |
| `RUN` | Execute a command in a new layer. | Chain with `&&` and clean caches in the same layer. |
| `ENV` | Environment variable baked into the image. | Not for secrets — they persist in image history. |
| `ARG` | Build-time variable. | Visible in `docker history`; not a secret store either. |
| `EXPOSE` | Document a port. | Metadata only; publishing needs `-p`. |
| `USER` | Switch to a non-root user. | Create it first (`RUN useradd -r app`). |
| `ENTRYPOINT` | Executable to run. | Exec form `["java","-jar","app.jar"]` receives signals directly. |
| `CMD` | Default arguments to the entrypoint. | Only one `CMD`; overridden by `docker run <image> <args>`. |
| `VOLUME` | Declare a mount point. | Creates an anonymous volume if none is provided. |
| `HEALTHCHECK` | Command reporting container health. | `--interval`, `--timeout`, `--retries`, `--start-period`. |
| `SHELL` | Change the shell used by `RUN` on Windows images. | Rarely needed in Linux images. |
| `ONBUILD` | Deferred instruction for child images. | Rarely a good idea. |

**Exec form versus shell form:** `ENTRYPOINT ["java", "-jar", "app.jar"]` runs java as PID 1 and gets
`SIGTERM` on `docker stop`; `ENTRYPOINT java -jar app.jar` runs `/bin/sh -c`, which may not forward the
signal, and the container is `SIGKILL`ed after the timeout.

## Layer order: the single biggest build-speed lever

```dockerfile
FROM node:24-alpine
WORKDIR /app

# dependencies first: this layer is cached until package files change
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# source last: a code change invalidates only the layers below
COPY src/ ./src/
EXPOSE 3000
USER node
CMD ["node", "src/server.js"]
```

Copying the whole project before `npm ci` means every source edit re-installs dependencies. The same
rule applies to `pom.xml` before `mvn dependency:go-offline`, and to `requirements.txt` before
`pip install`.

## Multi-stage builds

**Java (Spring Boot), JRE-only final image:**

```dockerfile
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn -B dependency:go-offline
COPY src ./src
RUN mvn -B package -DskipTests

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /build/target/app.jar app.jar
USER 1000:1000
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Node, production dependencies only:**

```dockerfile
FROM node:24-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM node:24-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:24-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force
COPY --from=build /app/dist ./dist
USER node
CMD ["node", "dist/server.js"]
```

**Go, static binary on an empty base:**

```dockerfile
FROM golang:1.24-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /out/app ./cmd/app

FROM gcr.io/distroless/static-debian12
COPY --from=build /out/app /app
USER 65532:65532
ENTRYPOINT ["/app"]
```

The build toolchain stays in the build stage; the runtime image contains only what the process needs.
`-DskipTests` in the Java stage is acceptable only because CI runs the tests separately — never as a
substitute for them.

## Health checks

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -fsS http://localhost:8080/actuator/health || exit 1
```

`start-period` is the grace window before failures count — Spring Boot and JVM apps need it, or the
container is marked unhealthy while it is still starting. `curl` must exist in the image; on distroless
use the app's own CLI or a tiny checker.

## Volumes and persistence

| Kind | Syntax | When |
|---|---|---|
| Named volume | `-v pgdata:/var/lib/postgresql/data` | Database data you want Docker to manage and back up. |
| Bind mount | `-v "$PWD/src":/app/src` | Development: edit on the host, run in the container. |
| Anonymous volume | `VOLUME /data` in the Dockerfile | Rarely wanted; hard to find and prune. |
| tmpfs | `--tmpfs /tmp` | Scratch data that must never touch disk. |

A bind mount overwrites whatever the image had at that path — mounting an empty directory over
`/app/node_modules` deletes the installed dependencies from the container's view.

## Networking

| Command | Meaning |
|---|---|
| `docker network create app-net` | User-defined bridge with DNS by container name. |
| `docker network ls` | Networks. |
| `docker network inspect app-net` | Which containers are attached, and their IPs. |
| `--network host` | Share the host's network namespace (Linux only). |
| `docker run --network app-net --name db postgres:18` | Then `app` connects to host `db`. |

On the default bridge network, containers resolve each other only by IP. On a user-defined network,
the container name is the hostname — which is why Compose services reach each other as `db:5432`.

## Compose

```yaml
services:
  db:
    image: postgres:18
    environment:
      POSTGRES_DB: notes
      POSTGRES_USER: notes
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U notes -d notes"]
      interval: 5s
      timeout: 3s
      retries: 10
    secrets:
      - db_password

  app:
    build: .
    depends_on:
      db:
        condition: service_healthy
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/notes
    ports:
      - "8080:8080"

volumes:
  pgdata:

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

| Task | Command |
|---|---|
| Start services | `docker compose up -d` |
| Rebuild after a Dockerfile change | `docker compose up -d --build` |
| Status | `docker compose ps` |
| Logs | `docker compose logs -f app` |
| Shell into a service | `docker compose exec app sh` |
| Run a one-off command | `docker compose run --rm app mvn test` |
| Stop and remove containers | `docker compose down` |
| Also remove volumes | `docker compose down -v` (**deletes the database**) |
| Validate the file | `docker compose config` |

`depends_on` with `condition: service_healthy` is the difference between "the container started" and
"the database accepts connections". Without it, the app races the database on every fresh start.

## Debugging a container that will not stay up

1. `docker ps -a` — read the exit code: `0` means the main process finished, `137` means `SIGKILL`
   (often OOM), `1` means the application errored.
2. `docker logs <container>` — the application's own output; for a crashed process, the last lines.
3. `docker inspect -f '{{.State.ExitCode}} {{.State.OOMKilled}}' <container>` — confirm OOM.
4. `docker run --rm -it --entrypoint sh <image>` — explore the image without the entrypoint.
5. `docker stats` — memory near the limit explains `137`.

## `.dockerignore`

```text
.git
node_modules
target
dist
*.log
.env
secrets/
```

An image built without a `.dockerignore` copies `.git` and local dependencies into the build context,
making builds slower and images larger — and can leak `.env` files into a layer.

## Related pages

- [Command Reference](command-reference.md) — the shell commands used inside containers
- [Linux Reference](linux-reference.md) — the userland in the image
- [Common Errors](common-errors.md) — daemon, port, architecture and permission failures
- [16-DEVOPS-AND-INFRASTRUCTURE/docker-fundamentals.md](../16-DEVOPS-AND-INFRASTRUCTURE/docker-fundamentals.md) — the lesson
- [16-DEVOPS-AND-INFRASTRUCTURE/docker-compose.md](../16-DEVOPS-AND-INFRASTRUCTURE/docker-compose.md) — multi-service development
