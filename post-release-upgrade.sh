#!/usr/bin/env bash
# Post-release-upgrade checklist for this Ubuntu host.
# Run interactively after `do-release-upgrade` completes.
# Safe to re-run; nothing here is destructive without a prompt.

set -u

GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'; RED=$'\033[0;31m'; BOLD=$'\033[1m'; NC=$'\033[0m'
step() { printf '\n%s==> %s%s\n' "$BOLD$GREEN" "$1" "$NC"; }
warn() { printf '%s!!  %s%s\n' "$YELLOW" "$1" "$NC"; }
err()  { printf '%sXX  %s%s\n' "$RED" "$1" "$NC"; }
ask()  { local p="$1"; read -r -p "$p [y/N] " a; [[ "$a" =~ ^[Yy]$ ]]; }

if [[ $EUID -ne 0 ]]; then
  warn "Re-running under sudo..."
  exec sudo -E bash "$0" "$@"
fi

step "1. Release / kernel"
lsb_release -a 2>/dev/null || cat /etc/os-release
echo
echo "Running kernel:  $(uname -r)"
LATEST_KERNEL=$(dpkg -l 'linux-image-[0-9]*' 2>/dev/null | awk '/^ii/ {print $2}' | sort -V | tail -n1 | sed 's/linux-image-//')
echo "Latest installed: ${LATEST_KERNEL:-unknown}"
if [[ -n "${LATEST_KERNEL:-}" && "$(uname -r)" != "$LATEST_KERNEL" ]]; then
  warn "Running kernel differs from latest installed — reboot needed before continuing is recommended."
fi

step "2. apt update + full-upgrade"
if ask "Run apt update && apt full-upgrade?"; then
  apt update
  apt full-upgrade -y
fi

step "3. Autoremove / autoclean"
if ask "Run apt autoremove --purge && autoclean?"; then
  apt autoremove --purge -y
  apt autoclean -y
fi

step "4. Disabled third-party repos"
mapfile -t DISABLED < <(find /etc/apt/sources.list.d -maxdepth 1 -name '*.disabled' 2>/dev/null)
if (( ${#DISABLED[@]} == 0 )); then
  echo "None found."
else
  echo "Found ${#DISABLED[@]} disabled source file(s):"
  printf '  %s\n' "${DISABLED[@]}"
  echo
  echo "Inspect each, update the suite/codename to the new release if needed, then rename to drop .disabled."
  echo "Quick re-enable (DOES NOT update codename — review first):"
  for f in "${DISABLED[@]}"; do
    echo "  mv '$f' '${f%.disabled}'"
  done
fi

step "5. Residual config (rc) packages"
RC_PKGS=$(dpkg -l | awk '/^rc/ {print $2}')
if [[ -z "$RC_PKGS" ]]; then
  echo "None."
else
  echo "$RC_PKGS"
  if ask "Purge these?"; then
    # shellcheck disable=SC2086
    apt purge -y $RC_PKGS
  fi
fi

step "6. New default configs (.dpkg-dist / .ucf-dist / .dpkg-old)"
mapfile -t DIST_FILES < <(find /etc \( -name '*.dpkg-dist' -o -name '*.dpkg-old' -o -name '*.ucf-dist' \) 2>/dev/null)
if (( ${#DIST_FILES[@]} == 0 )); then
  echo "None — all configs accepted/merged."
else
  warn "Review and merge each of these by hand:"
  printf '  %s\n' "${DIST_FILES[@]}"
fi

step "7. Failed systemd units"
FAILED=$(systemctl --failed --no-legend | awk '{print $1}')
if [[ -z "$FAILED" ]]; then
  echo "None."
else
  warn "Failed units:"
  echo "$FAILED"
fi

step "8. Snap refresh"
if command -v snap >/dev/null 2>&1; then
  snap refresh || warn "snap refresh returned non-zero"
else
  echo "snap not installed — skipping."
fi

step "9. Docker daemon + stacks (/home/kit/docker)"
if systemctl is-active --quiet docker; then
  echo "docker.service: active"
else
  err "docker.service is NOT active"
  systemctl status docker --no-pager | sed -n '1,8p'
fi
echo
echo "Docker version: $(docker --version 2>/dev/null || echo missing)"
echo "Compose plugin: $(docker compose version 2>/dev/null || echo missing)"

DOCKER_ROOT=/home/kit/docker
if [[ -d "$DOCKER_ROOT" ]]; then
  mapfile -t STACKS < <(find "$DOCKER_ROOT" -maxdepth 3 -type f \( -name 'docker-compose.yml' -o -name 'docker-compose.yaml' -o -name 'compose.yml' -o -name 'compose.yaml' \) -printf '%h\n' | sort -u)
  echo
  echo "Found ${#STACKS[@]} compose stack(s) under $DOCKER_ROOT."
  echo "Only services currently running will be refreshed — stopped services stay stopped."
  if (( ${#STACKS[@]} > 0 )) && ask "Pull + recreate running services in each stack?"; then
    for d in "${STACKS[@]}"; do
      echo
      echo "${BOLD}-- $d --${NC}"
      mapfile -t RUNNING < <(cd "$d" && docker compose ps --services --filter status=running 2>/dev/null)
      if (( ${#RUNNING[@]} == 0 )); then
        echo "  (no running services — skipping)"
        continue
      fi
      echo "  running: ${RUNNING[*]}"
      ( cd "$d" && docker compose pull "${RUNNING[@]}" && docker compose up -d "${RUNNING[@]}" ) \
        || warn "stack at $d failed"
    done
  fi
fi

step "10. Reboot check"
if [[ -f /var/run/reboot-required ]]; then
  warn "Reboot required:"
  [[ -f /var/run/reboot-required.pkgs ]] && cat /var/run/reboot-required.pkgs
  if ask "Reboot now?"; then
    systemctl reboot
  fi
else
  echo "No reboot flag set."
  if [[ -n "${LATEST_KERNEL:-}" && "$(uname -r)" != "$LATEST_KERNEL" ]]; then
    warn "But running kernel != latest installed — consider rebooting anyway."
  fi
fi

step "Done."
echo "Suggested follow-ups not handled by this script:"
echo "  - Verify Traefik / certs are healthy (acme.json, router status)"
echo "  - Spot-check a couple of services in the browser"
echo "  - Take a fresh backup/snapshot once you're satisfied"
