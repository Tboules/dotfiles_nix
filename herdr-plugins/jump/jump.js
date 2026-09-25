#!/usr/bin/env node
// jump.js — one-keystroke jump picker for herdr spaces and agents.
//
// Runs as a plugin popup pane (see herdr-plugin.toml): draws spaces on 1-9
// (herdr's own sidebar numbers) and agents on alt+1-9 (matching the global
// keys.indexed agents = "alt" binding), waits for a single keypress, focuses
// the target, and exits so the popup closes itself. shift+1-9 works as a
// US-layout alias for agents; agents beyond nine get letters. q / esc cancels.
"use strict";

const { execFileSync } = require("node:child_process");

const HERDR = process.env.HERDR_BIN_PATH ?? "herdr";
const ESC = "\x1b";

const dim = `${ESC}[2m`;
const bold = `${ESC}[1m`;
const reset = `${ESC}[0m`;
const yellow = `${ESC}[33m`;
const red = `${ESC}[31m`;
const green = `${ESC}[32m`;
const cyan = `${ESC}[36m`;

// ---------------------------------------------------------------- data

function herdr(...args) {
  const out = execFileSync(HERDR, args, { encoding: "utf8" });
  return JSON.parse(out).result;
}

function loadTargets() {
  const workspaces = herdr("workspace", "list").workspaces;
  let agents = [];
  try {
    agents = herdr("agent", "list").agents;
  } catch {
    // no agents is fine
  }

  const byId = new Map(workspaces.map((w) => [w.workspace_id, w]));
  agents = agents
    .map((a) => {
      const ws = byId.get(a.workspace_id);
      return {
        paneId: a.pane_id,
        wsNumber: ws?.number ?? 99,
        wsLabel: ws?.label ?? "?",
        status: a.agent_status,
        title: a.terminal_title_stripped || a.agent || "agent",
        focused: a.focused,
      };
    })
    .sort((a, b) => a.wsNumber - b.wsNumber || a.paneId.localeCompare(b.paneId));

  return { workspaces, agents };
}

// ------------------------------------------------------------- render

const cols = Math.max(process.stdout.columns || 80, 40);
const LABEL_W = 12;
const STATUS_W = 9; // "◐ working" is the widest
const TITLE_W = Math.max(cols - 34, 12); // 34 = margins + key + label + status + gutters
const SPACE_LABEL_W = LABEL_W + 2 + TITLE_W;

const trunc = (s, w) => (s.length > w ? s.slice(0, w - 1) + "…" : s.padEnd(w));

const STATUS_CELLS = {
  working: `${yellow}${"◐ working".padEnd(STATUS_W)}${reset}`,
  blocked: `${red}${"● blocked".padEnd(STATUS_W)}${reset}`,
  done: `${green}${"✓ done".padEnd(STATUS_W)}${reset}`,
  idle: `${dim}${"· idle".padEnd(STATUS_W)}${reset}`,
};
const statusCell = (status) => STATUS_CELLS[status] ?? "".padEnd(STATUS_W);

const header = (name, hint) => ` ${bold}${name}${reset}  ${dim}${hint}${reset}`;
const rule = ` ${dim}${"─".repeat(cols - 4)}${reset}`;

// key is pre-formatted to exactly two display columns (" 1", "⌥1", " a").
function spaceRow({ focused, key, label, status }) {
  const labelCol = trunc(label, SPACE_LABEL_W);
  return focused
    ? ` ${cyan}▸ ${key}${reset}  ${bold}${labelCol}${reset}  ${statusCell(status)}`
    : `   ${bold}${key}${reset}  ${labelCol}  ${statusCell(status)}`;
}

function agentRow({ focused, key, wsLabel, title, status }) {
  const labelCol = trunc(wsLabel, LABEL_W);
  const titleCol = trunc(title, TITLE_W);
  const busy = status === "working" || status === "blocked" || status === "done";
  if (focused) {
    return ` ${cyan}▸ ${key}${reset}  ${bold}${labelCol}  ${titleCol}${reset}  ${statusCell(status)}`;
  }
  return busy
    ? `   ${bold}${key}${reset}  ${labelCol}  ${titleCol}  ${statusCell(status)}`
    : `   ${bold}${key}${reset}  ${dim}${labelCol}  ${titleCol}${reset}  ${statusCell(status)}`;
}

// -------------------------------------------------------------- input

// Alt+key arrives as ESC followed by the key (usually in one chunk); a lone
// ESC is cancel. Returns "M-<key>" for alt chords, the character otherwise,
// or null for cancel.
function readKey() {
  return new Promise((resolve) => {
    const stdin = process.stdin;
    if (stdin.isTTY) stdin.setRawMode(true);
    stdin.resume();

    let escTimer = null;
    const finish = (key) => {
      stdin.removeListener("data", onData);
      if (stdin.isTTY) stdin.setRawMode(false);
      stdin.pause();
      resolve(key);
    };
    const onData = (buf) => {
      const s = buf.toString("utf8");
      if (escTimer) {
        clearTimeout(escTimer);
        return finish(`M-${s[0]}`);
      }
      if (s === ESC) {
        escTimer = setTimeout(() => finish(null), 60);
        return;
      }
      if (s.startsWith(ESC) && s.length > 1) return finish(`M-${s[1]}`);
      if (s === "\x03" || s === "q") return finish(null); // ctrl+c / q
      finish(s[0]);
    };
    stdin.on("data", onData);
  });
}

// US-layout shift+digit alias for agents.
const SHIFT_DIGITS = { "!": 1, "@": 2, "#": 3, $: 4, "%": 5, "^": 6, "&": 7, "*": 8, "(": 9 };

// --------------------------------------------------------------- main

async function main() {
  let data;
  try {
    data = loadTargets();
  } catch {
    console.log("herdr socket unavailable");
    return;
  }

  const bindings = new Map(); // hotkey -> herdr argv
  const lines = ["", header("SPACES", "number"), rule];

  for (const w of data.workspaces) {
    if (w.number > 9) continue;
    lines.push(spaceRow({ focused: w.focused, key: ` ${w.number}`, label: w.label, status: w.agent_status }));
    bindings.set(String(w.number), ["workspace", "focus", w.workspace_id]);
  }

  if (data.agents.length > 0) {
    lines.push("", header("AGENTS", "⌥ + number"), rule);
    const overflowLetters = "abcdefghijklmnoprstuvwxyz"; // q reserved for quit
    data.agents.forEach((a, i) => {
      let hotkey, key;
      if (i < 9) {
        hotkey = `M-${i + 1}`;
        key = `⌥${i + 1}`;
      } else if (i - 9 < overflowLetters.length) {
        hotkey = overflowLetters[i - 9];
        key = ` ${hotkey}`;
      } else {
        return;
      }
      lines.push(agentRow({ ...a, key }));
      bindings.set(hotkey, ["agent", "focus", a.paneId]);
    });
  }

  lines.push("", ` ${dim}1-9 space · ⌥1-9 agent · q cancel${reset}`, "");
  process.stdout.write(lines.join("\n"));

  let key = await readKey();
  if (key == null) return;
  if (key in SHIFT_DIGITS) key = `M-${SHIFT_DIGITS[key]}`;

  const argv = bindings.get(key);
  if (argv) {
    try {
      execFileSync(HERDR, argv, { stdio: "ignore" });
    } catch {
      // target vanished between render and keypress; nothing to do
    }
  }
}

main();
