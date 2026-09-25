#!/usr/bin/env node
// Opens the jump picker popup. Bound to a key via type = "plugin_action".
"use strict";

const { execFileSync } = require("node:child_process");

const herdr = process.env.HERDR_BIN_PATH ?? "herdr";
execFileSync(herdr, ["plugin", "pane", "open", "--plugin", "tboules.jump", "--entrypoint", "picker"], {
  stdio: "inherit",
});
