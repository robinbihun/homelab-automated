#!/usr/bin/env bash
#MISE description="Validate Talos configuration files"
#MISE dir="{{ env.TALOS_DIR }}"
#MISE tools=["talhelper"]
#MISE hide=true

talhelper validate talconfig "$TALOS_DIR/talconfig.yaml"
