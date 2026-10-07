#!/usr/bin/env bash
#MISE description="Upgrade Talos on a single node [ip]"
#MISE dir="{{ env.TALOS_DIR }}"
#MISE tools=["talhelper", "yq"]

#USAGE arg "<ip>" help="The IP address of the Talos node to apply the configuration to"

TALOS_IMAGE=$(yq ".nodes[] | select(.ipAddress == '${usage_ip?}') | .talosImageURL" talconfig.yaml)
TALOS_VERSION=$(yq '.talosVersion' talenv.yaml)

talhelper gencommand upgrade --node "${usage_ip?}" --extra-flags "--image='${TALOS_IMAGE}:${TALOS_VERSION}' --timeout=10m" | bash
