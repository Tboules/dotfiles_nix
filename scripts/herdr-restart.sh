#!/usr/bin/env bash
# herdr-restart.sh — restart the herdr background server from a shell that has
# macOS Full Disk Access (i.e. a plain Ghostty window, NOT a herdr pane).
#
# Why: the herdr server is a detached daemon. macOS TCC validates the server's
# on-disk binary on every protected-folder access. When brew upgrades herdr the
# old Cellar path is deleted, the running server can no longer be validated, and
# every pane under ~/Documents starts failing with "Operation not permitted"
# (nvim config, plugins, workspaces). A fresh server launched from Ghostty
# inherits Ghostty's Full Disk Access grant. One launched from inside a herdr
# pane inherits nothing and stays broken.
set -euo pipefail

# Refuse to run from inside a herdr pane: the new server would be a child of the
# old (unprivileged) server tree and would lack Documents access.
pid=$$
while [ "$pid" -gt 1 ]; do
  comm="$(ps -o comm= -p "$pid" 2>/dev/null || true)"
  case "$comm" in
    *herdr*)
      echo "herdr-restart: this shell is running inside a herdr pane." >&2
      echo "  Open a plain Ghostty window and run:  ~/.dotfiles_nix/scripts/herdr-restart.sh" >&2
      exit 2 ;;
  esac
  pid="$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')"
  [ -n "$pid" ] || break
done

if pgrep -x herdr >/dev/null; then
  echo "herdr-restart: stopping running server (this closes all herdr panes)"
  herdr server stop || true
  for _ in $(seq 1 20); do
    pgrep -x herdr >/dev/null || break
    sleep 0.25
  done
  pkill -x herdr 2>/dev/null || true
fi

echo "herdr-restart: starting server from $(ps -o comm= -p "$PPID" 2>/dev/null || echo this shell)"
( nohup herdr server >/dev/null 2>&1 & )

for _ in $(seq 1 40); do
  if herdr status server 2>/dev/null | grep -q '^status: running'; then break; fi
  sleep 0.25
done
herdr status server | head -2

# Verify Documents access: the jump plugin lives under ~/Documents, so the
# server's manifest read is a direct probe of the TCC grant.
if herdr plugin list 2>&1 | grep -q 'Operation not permitted'; then
  echo "herdr-restart: server is up but still cannot read ~/Documents." >&2
  echo "  Check System Settings > Privacy & Security > Full Disk Access for Ghostty," >&2
  echo "  then rerun this script from a plain Ghostty window." >&2
  exit 1
fi
echo "herdr-restart: OK — server can read ~/Documents. Run 'herdr' to reattach."
