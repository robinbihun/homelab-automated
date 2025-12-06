#!/usr/bin/env bash
#MISE description="Generate push token for GitHub and FluxCD"
#MISE outputs=["github-push-token.txt"]
#MISE hide=true
#MISE tools=["python"]

if [ -f "github-push-token.txt" ]; then
  echo "Push token already exists. Skipping generation."
  exit 0
fi

python -c "import secrets; print(secrets.token_hex(16))" > github-push-token.txt
