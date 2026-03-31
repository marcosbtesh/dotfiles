#!/usr/bin/env bash
# Merges dotfiles/claude/mcp-servers.json into ~/.claude.json
# Requires: jq

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_SOURCE="$DOTFILES_DIR/mcp-servers.json"
CLAUDE_CONFIG="$HOME/.claude.json"

if ! command -v jq &>/dev/null; then
  echo "jq is required: brew install jq or apt install jq"
  exit 1
fi

# Create ~/.claude.json if it doesn't exist
if [ ! -f "$CLAUDE_CONFIG" ]; then
  echo '{}' > "$CLAUDE_CONFIG"
fi

# Deep-merge mcpServers into existing config, preserving everything else
MERGED=$(jq --slurpfile mcp "$MCP_SOURCE" \
  '.mcpServers = (.mcpServers // {} | . * $mcp[0])' \
  "$CLAUDE_CONFIG")

echo "$MERGED" > "$CLAUDE_CONFIG"
echo "Claude MCP servers merged into $CLAUDE_CONFIG"
