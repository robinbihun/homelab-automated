#!/usr/bin/env bash
#MISE description="Encrypt configuration files using sops and age"
#MISE tools=["jq", "sops", "age"]

SECRET_FILES=$(find "$BOOTSTRAP_DIR" "$KUBERNETES_DIR" "$TALOS_DIR" -type f -name "*.sops.*" -print)

for FILE in $SECRET_FILES; do
    if [ "$(sops filestatus "$FILE" | jq ".encrypted")" == "false" ]; then
        sops --encrypt --in-place "$FILE"
    fi
done
