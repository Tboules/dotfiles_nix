#!/usr/bin/env bash
# herdr-session.sh <workspace-label> [cwd]
#
# Ensures a herdr workspace with the given label exists, laid out with
# neovim/shell/git/claude tabs (mirrors mac_dotfiles/scripts/bin/tmux-session.sh),
# then focuses and attaches to it.
set -euo pipefail

LABEL="${1:?Usage: $0 <workspace-label> [cwd]}"
CWD="${2:-$PWD}"

existing_id=$(herdr workspace list | jq -r --arg l "$LABEL" '.result.workspaces[] | select(.label==$l) | .workspace_id')

if [ -z "$existing_id" ]; then
  created=$(herdr workspace create --label "$LABEL" --cwd "$CWD" --focus)
  ws_id=$(jq -r '.result.workspace.workspace_id' <<<"$created")
  tab1_id=$(jq -r '.result.tab.tab_id' <<<"$created")
  pane1_id=$(jq -r '.result.root_pane.pane_id' <<<"$created")

  herdr tab rename "$tab1_id" neovim >/dev/null
  herdr pane run "$pane1_id" nvim >/dev/null

  for pair in shell: git:lazygit claude:claude; do
    name="${pair%%:*}"
    cmd="${pair#*:}"
    tab=$(herdr tab create --workspace "$ws_id" --label "$name" --cwd "$CWD" --no-focus)
    if [ -n "$cmd" ]; then
      pane_id=$(jq -r '.result.root_pane.pane_id' <<<"$tab")
      herdr pane run "$pane_id" "$cmd" >/dev/null
    fi
  done

  herdr tab focus "$tab1_id"
else
  ws_id="$existing_id"
fi

herdr workspace focus "$ws_id" >/dev/null

# If we're not already inside a herdr pane, attach a client so the
# workspace we just focused is actually visible.
if [ -z "${HERDR_ENV:-}" ]; then
  exec herdr
fi
