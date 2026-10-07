#!/usr/bin/env bash
#MISE description="Bootstrap the Talos Cluster"
#MISE dir="{{ env.TALOS_DIR }}"
#MISE tools=["talhelper","sops"]

[ -f talsecret.sops.yaml ] || talhelper gensecret | sops --filename-override talos/talsecret.sops.yaml --encrypt /dev/stdin > talsecret.sops.yaml
talhelper genconfig
talhelper gencommand apply --extra-flags="--insecure" | bash
until talhelper gencommand bootstrap | bash; do sleep 10; done
until talhelper gencommand kubeconfig --extra-flags="${MISE_ORIGINAL_CWD} --force" | bash; do sleep 10; done
