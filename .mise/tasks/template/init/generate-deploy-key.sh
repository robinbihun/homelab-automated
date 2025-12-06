#!/usr/bin/env bash
#MISE description="Generate deploy SSH keys for GitHub and FluxCD"
#MISE outputs=["github-deploy.key", "github-deploy.key.pub"]
#MISE hide=true

if [ -f "github-deploy.key" ] && [ -f "github-deploy.key.pub" ]; then
  echo "Deploy SSH keys already exist. Skipping generation."
  exit 0
fi

ssh-keygen -t ed25519 -C "deploy-key" -f github-deploy.key -q -P ""
