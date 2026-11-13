# Over SSH on Linux, block suspend (idle + lid) for the life of the session.
#
# The lock is held by a background systemd-inhibit whose child (tail --pid)
# exits when this shell does, releasing the lock. Running it in the background
# leaves this shell alone: `zsh -ic cmd` still runs cmd, and on hosts where
# logind refuses the lock (no polkit rule from the ansible laptop role's
# ssh_sleep_inhibit) it just fails quietly. --no-ask-password keeps logind
# from prompting for admin auth instead of refusing.
#
# SSH_INHIBITED is exported once the lock has been tried, so nested shells
# don't try again. It doesn't say whether the lock was granted; check with
# `systemd-inhibit --list`.
#
# Skipped inside tmux: panes inherit SSH_CONNECTION but would hold their own
# lock after the SSH session ends. The SSH shell running `tmux attach` holds
# the lock while attached.
if [[ -n $SSH_CONNECTION && -z $SSH_INHIBITED && -z $TMUX ]] \
   && (( $+commands[systemd-inhibit] && $+commands[tail] )); then
  export SSH_INHIBITED=1
  systemd-inhibit --no-ask-password --what=sleep:idle:handle-lid-switch \
    --why="SSH session" --mode=block tail --pid=$$ -f /dev/null \
    </dev/null &>/dev/null &!
fi
