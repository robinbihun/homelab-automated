#!/usr/bin/env bash
#MISE description="Render configuration files"
#MISE sources=["templates/overrides/**/*.j2", "templates/config/**/*.j2", "templates/scripts", "cluster.yaml", "nodes.yaml"]
#MISE outputs=["bootstrap/**/*", "kubernetes/**/*", "talos/**/*", ".sops.yaml"]
#MISE tools=["pipx:makejinja"]
#MISE confirm="Any conflicting files in the kubernetes directory will be overwritten... continue?"
#MISE env={ PYTHONDONTWRITEBYTECODE = "1" }
#MISE hide=true

makejinja
