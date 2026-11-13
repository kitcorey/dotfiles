# Over SSH on Linux, block suspend (idle + lid) for the life of the session.
#
# zshrc sources this file first, before anything else, because it may exec a
# new login shell; the zshrc.d loop sources it again later, which the guard
# below turns into a no-op.
#
# Needs the polkit rule from the ansible laptop role (ssh_sleep_inhibit). Probe
# first: without the rule logind refuses the lock, and a failed exec here would
# close the SSH session immediately. --no-ask-password keeps logind from
# prompting for admin auth at login on hosts without the rule.
[[ -n $_SSH_INHIBIT_CHECKED ]] && return
_SSH_INHIBIT_CHECKED=1

if [[ -n $SSH_CONNECTION && -z $SSH_INHIBITED ]] && (( $+commands[systemd-inhibit] )) \
   && systemd-inhibit --no-ask-password --what=sleep:idle:handle-lid-switch --mode=block true &>/dev/null; then
  export SSH_INHIBITED=1
  exec systemd-inhibit --no-ask-password --what=sleep:idle:handle-lid-switch --why="SSH session" --mode=block zsh -l
fi
