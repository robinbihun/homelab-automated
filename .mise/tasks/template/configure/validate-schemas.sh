#!/usr/bin/env bash
#MISE description="Validate configuration schemas"
#MISE tools=["cue"]
#MISE hide=true

# Check if cue has output and exit with error code if so
if ! cue vet .mise/tasks/template/configure/resources/cluster.schema.cue cluster.yaml; then
    echo "cluster.yaml schema validation failed."
    exit 2
fi
if ! cue vet .mise/tasks/template/configure/resources/nodes.schema.cue nodes.yaml; then
    echo "nodes.yaml schema validation failed."
    exit 3
fi
