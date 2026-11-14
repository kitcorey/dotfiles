#!/usr/bin/env bash
# Claude Code status line: model name + context progress bar
#
# Runs on every status refresh, so keep it to one jq + one awk. awk does the
# math under LC_ALL=C so the decimal point is '.' regardless of locale, and
# rounds half-up (printf %.0f rounds half-to-even, making the bar uneven).

jq -r '[.model.display_name // "Claude", .context_window.used_percentage // ""] | @tsv' |
  LC_ALL=C awk -F'\t' '{
    model = $1; used = $2
    if (used == "") { printf "\033[2m%s\033[0m", model; exit }
    pct = int(used + 0.5)
    filled = int(used / 10 + 0.5)
    if (filled > 10) filled = 10
    if (filled < 0) filled = 0
    bar = ""
    for (i = 1; i <= 10; i++) bar = bar (i <= filled ? "█" : "░")
    printf "\033[2m%s\033[0m  \033[2m[%s] %d%%\033[0m", model, bar, pct
  }'
