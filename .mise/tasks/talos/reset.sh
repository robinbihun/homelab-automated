#!/usr/bin/env bash
#MISE description="Resets nodes back to maintenance mode"
#MISE dir="{{ env.TALOS_DIR }}"
#MISE tools=["talhelper"]
#MISE confirm="This will destroy your cluster and reset the nodes back to maintenance mode... continue?"

#USAGE flag "-f --force" help="Force the reset operation." default="false"

if [ "$usage_force" = "true" ]; then
  echo "Force flag detected: proceeding with forced reset."
  talhelper gencommand reset --extra-flags="--reboot --graceful=false --wait=false" | bash
else
  echo "Performing standard reset."
  talhelper gencommand reset --extra-flags="--reboot --system-labels-to-wipe STATE --system-labels-to-wipe EPHEMERAL --graceful=false --wait=false" | bash
fi
