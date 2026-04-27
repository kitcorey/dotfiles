# Resource-limited Claude Code wrapper.
#
# Why: Claude can allocate aggressively (parallel agents, large contexts) and
# on a 17G/2-core host that means swap thrash → unresponsive desktop. Capping
# memory AND forbidding swap means a runaway gets OOM-killed instead of
# dragging the system under.
#
# Bypass with: CLAUDE_NO_SANDBOX=1 claude ...
# Inspect live:  systemctl --user status     (look for run-*.scope)
claude() {
  local claude_bin
  claude_bin=$(whence -p claude) || { print -u2 "claude: not found in PATH"; return 127 }

  if [[ -n $CLAUDE_NO_SANDBOX ]]; then
    "$claude_bin" "$@"
    return
  fi

  # Fall through if systemd or the user manager isn't available
  # (non-Linux, minimal container, ssh exec without lingering, etc).
  if ! command -v systemd-run >/dev/null 2>&1 || [[ ! -d /run/user/$UID/systemd ]]; then
    "$claude_bin" "$@"
    return
  fi

  systemd-run --user --scope --quiet \
    -p MemoryMax=60% \
    -p MemorySwapMax=0 \
    -p CPUQuota=150% \
    "$claude_bin" "$@"
}
