#!/usr/bin/env bash
#MISE description="Setup blank configuration files for configuration"
#MISE outputs=["cluster.yaml", "nodes.yaml"]
#MISE hide=true

if [ -f "cluster.yaml" ] || [ -f "nodes.yaml" ]; then
  echo "Configuration files already exist. Skipping generation."
  exit 0
fi

cp ".mise/tasks/init/resources/cluster.yaml" "cluster.yaml"
cp ".mise/tasks/init/resources/nodes.yaml" "nodes.yaml"
