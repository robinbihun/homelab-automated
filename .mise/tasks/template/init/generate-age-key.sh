#!/usr/bin/env bash
#MISE description="Generate age encryption keys for the cluster"
#MISE outputs=["{{ env.SOPS_AGE_KEY_FILE }}"]
#MISE hide=true
#MISE tools=["age"]

if [ -f "${SOPS_AGE_KEY_FILE}" ]; then
  echo "Age encryption files already exist. Skipping generation."
  exit 0
fi

age-keygen --output "${SOPS_AGE_KEY_FILE}"
