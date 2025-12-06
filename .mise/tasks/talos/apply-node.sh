#!/usr/bin/env bash
#MISE description="Apply Talos config to a node [ip]"
#MISE dir="{{ env.TALOS_DIR }}"
#MISE tools=["talhelper"]

#USAGE arg "<ip>" help="The IP address of the Talos node to apply the configuration to"
#USAGE flag "-m --mode <mode>" help="The mode to apply the configuration." default="auto"

talhelper gencommand apply --node "${usage_ip?}" --extra-flags "--mode='${usage_mode:-auto}'" | bash
