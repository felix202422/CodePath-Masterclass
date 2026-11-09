#!/usr/bin/env node
/**
 * check-mermaid.mjs — render every Mermaid diagram in the curriculum.
 *
 * WHAT THIS TOOL CAN DO:
 *   * find every ```mermaid fenced block in every Markdown file
 *   * render each one in headless Chromium with Mermaid, the same way a browser would
 *   * fail (non-zero exit) and name file:line for any diagram that does not parse or render
 *
 * WHAT THIS TOOL CANNOT DO (and never claims to):
 *   * judge whether a diagram matches the prose around it
 *   * prove a diagram is readable at a given width, or accessible beyond the alt text
 *
 * Usage:
 *   node scripts/mermaid/check.mjs            # render all diagrams
 *   CHROME_PATH=/path/to/chrome node ...      # reuse an installed Chrome (skips the download)
 */

import { createRequire } from "node:module";
import { readFile, readdir } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const require = createRequire(import.meta.url);
const HERE = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(HERE, "../..");

// Mirrors scripts/check-links.py: generated, ignored and third-party trees are not curriculum.
const SKIP = new Set([
  ".git", ".github", ".scratch", "node_modules", "target", "build", "dist",
  ".dart_tool", "__pycache__", "templates", "scratch", "tmp",
]);

async function markdownFiles(dir, out = []) {
  const entries = await readdir(dir, { withFileTypes: true });
  for (const entry of entries.sort((a, b) => a.name.localeCompare(b.name))) {
    if (SKIP.has(entry.name)) continue;
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) await markdownFiles(full, out);
    else if (entry.name.endsWith(".md")) out.push(full);
  }
  return out;
}

/** Fenced-block extraction, fence-length aware so ```mermaid inside a block is not a block. */
function mermaidBlocks(text) {
  const lines = text.split(/\r?\n/);
  const blocks = [];
  let inside = false;
  let fence = "";
  let lang = "";
  let start = 0;
  let buf = [];
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i];
    const opened = line.match(/^(`{3,})\s*([\w-]*)\s*$/);
    if (opened && (!inside || line.startsWith(fence))) {
      if (inside && lang === "mermaid") blocks.push({ line: start, code: buf.join("\n") });
      inside = !inside;
      fence = opened[1];
      lang = inside ? opened[2].trim().toLowerCase() : "";
      buf = [];
      start = i + 2; // first code line, 1-based
      continue;
    }
    if (inside) buf.push(line);
  }
  return blocks;
}

async function loadMermaid() {
  for (const candidate of ["mermaid/dist/mermaid.min.js", "mermaid/dist/mermaid.esm.min.mjs"]) {
    try {
      return { file: require.resolve(candidate), esm: candidate.endsWith(".mjs") };
    } catch {
      /* try the next build */
    }
  }
  throw new Error("cannot find a Mermaid build in node_modules — run npm ci --prefix scripts/mermaid");
}

async function main() {
  const files = await markdownFiles(ROOT);
  const diagrams = [];
  for (const file of files) {
    const text = await readFile(file, "utf8").catch(() => "");
    for (const block of mermaidBlocks(text)) {
      diagrams.push({
        file: path.relative(ROOT, file).split(path.sep).join("/"),
        line: block.line,
        code: block.code,
      });
    }
  }
  if (diagrams.length === 0) {
    console.log("check-mermaid: no diagrams found — that is a failure in itself");
    process.exit(1);
  }

  const { default: puppeteer } = await import("puppeteer");
  const browser = await puppeteer.launch({
    headless: true,
    executablePath: process.env.CHROME_PATH || undefined,
    args: ["--no-sandbox", "--disable-dev-shm-usage", "--disable-gpu"],
    protocolTimeout: 300000,
  });
  try {
    const page = await browser.newPage();
    page.setDefaultTimeout(300000);
    await page.setContent("<!doctype html><html><head><meta charset='utf-8'></head><body></body></html>");

    const mermaid = await loadMermaid();
    if (mermaid.esm) {
      await page.addScriptTag({ type: "module", url: pathToFileURL(mermaid.file).href });
      await page.waitForFunction("window.mermaid !== undefined", { timeout: 60000 });
    } else {
      await page.addScriptTag({ content: await readFile(mermaid.file, "utf8") });
    }

    const results = await page.evaluate(async (blocks) => {
      /* global mermaid */
      mermaid.initialize({ startOnLoad: false, securityLevel: "loose" });
      const out = [];
      for (let i = 0; i < blocks.length; i += 1) {
        const block = blocks[i];
        const record = { index: i, ok: true, error: "" };
        try {
          await mermaid.parse(block.code);
        } catch (error) {
          record.ok = false;
          record.error = String(error && error.message ? error.message : error).split("\n")[0];
        }
        if (record.ok) {
          try {
            const { svg } = await mermaid.render(`diagram-${i}`, block.code);
            if (!svg || !svg.startsWith("<svg") || svg.length < 100) {
              record.ok = false;
              record.error = "render produced no usable SVG";
            }
          } catch (error) {
            record.ok = false;
            record.error = `render: ${String(error && error.message ? error.message : error).split("\n")[0]}`;
          }
        }
        out.push(record);
      }
      return out;
    }, diagrams.map(({ code }) => ({ code })));

    const failed = results.filter((r) => !r.ok);
    for (const failure of failed) {
      const where = `${diagrams[failure.index].file}:${diagrams[failure.index].line}`;
      console.error(`  FAIL ${where} — ${failure.error}`);
    }
    console.log(
      `check-mermaid: ${results.length} diagram(s) rendered, ${failed.length} failed` +
        (failed.length === 0 ? "." : ` — first is ${diagrams[failed[0].index].file}:${diagrams[failed[0].index].line}`),
    );
    process.exit(failed.length === 0 ? 0 : 1);
  } finally {
    await browser.close();
  }
}

main().catch((error) => {
  console.error(`check-mermaid: crashed — ${error && error.message ? error.message : error}`);
  process.exit(2);
});
