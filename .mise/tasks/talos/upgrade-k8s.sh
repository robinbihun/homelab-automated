#!/usr/bin/env bash
#MISE description="Upgrade Kubernetes"
#MISE dir="{{ env.TALOS_DIR }}"
#MISE tools=["talhelper", "yq"]

KUBERNETES_VERSION=$(yq '.kubernetesVersion' talenv.yaml)

talhelper gencommand upgrade-k8s --extra-flags "--to '${KUBERNETES_VERSION}'" | bash
