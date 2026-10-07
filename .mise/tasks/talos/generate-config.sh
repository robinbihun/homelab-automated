#!/usr/bin/env bash
#MISE description="Generate Talos configuration"
#MISE dir="{{ env.TALOS_DIR }}"
#MISE tools=["talhelper"]

talhelper genconfig
