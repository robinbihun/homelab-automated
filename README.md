# Homelab

GitOps-managed Kubernetes cluster running on [Talos Linux](https://www.talos.dev/). Everything in the cluster is declared in this repository and reconciled by Flux; secrets are stored encrypted with SOPS/age or pulled from 1Password at runtime.

## Cluster

- 5 nodes: 3 control-plane nodes that also run workloads, and 2 workers
- Node configuration is generated with talhelper from `talos/talconfig.yaml`
- Bootstrapped with Helmfile (`bootstrap/`), after which Flux takes over

## Stack

| Area | Components |
| --- | --- |
| GitOps | Flux (flux-operator / flux-instance) |
| Networking | Cilium, Envoy Gateway, Cloudflare Tunnel, Cloudflare DNS, k8s-gateway, Pi-hole DNS, UniFi |
| Certificates | cert-manager |
| Secrets | SOPS + age, External Secrets with 1Password |
| Storage | Rook-Ceph, Velero (backups), snapshot-controller |
| Security | Kyverno, Pocket ID |
| Observability | kube-prometheus-stack, Grafana, Loki, Fluent Bit, Gatus |
| Cluster services | CoreDNS, metrics-server, Reloader, Spegel, tuppr (upgrades) |
| Databases | StackGres |

### Applications

- **Media:** Jellyfin, Radarr, Sonarr, Recyclarr, Seerr
- **Automation and dev:** n8n, Forgejo, CrowCI, Renovate
- **Other:** Homarr, Rocket.Chat, nebula-sync

## Repository layout

```text
.
├── bootstrap/     # Helmfile and encrypted secrets used for the initial bring-up
├── kubernetes/
│   ├── apps/      # One directory per namespace, one per app
│   └── flux/      # Flux cluster configuration
├── talos/         # talhelper config and Talos patches
├── scripts/       # Helper scripts
└── .mise/tasks/   # mise tasks for Talos and bootstrap operations
```

## Tooling

- [mise](https://mise.jdx.dev/) manages the toolchain (see `mise.toml`) and exposes the project tasks
- [Task](https://taskfile.dev/) wraps bootstrap and Talos operations
- Renovate keeps dependencies up to date
- GitHub Actions render and diff Flux `HelmRelease` and `Kustomization` changes on pull requests with flux-local
- hk runs linters (yamllint, shellcheck, prettier, ruff, typos) as git hooks

## Getting started

Prerequisites: a set of machines for Talos, a 1Password vault for External Secrets, and a Cloudflare account for DNS and the tunnel.

1. Install the tools: `mise install`
2. Generate an age key (`age.key`) and configure `.sops.yaml` for your own key
3. Adjust `talos/talconfig.yaml` and `talos/talenv.yaml` for your nodes
4. Generate and apply the Talos configuration, then bootstrap the cluster:

   ```sh
   mise run talos:generate-config
   mise run bootstrap:talos
   mise run bootstrap:apps
   ```

5. Flux then reconciles `kubernetes/` from this repository. Force a sync with `mise run reconcile`.

Secrets in `*.sops.yaml` files are encrypted with the age key. Never commit `age.key`, `kubeconfig` or anything under `talos/clusterconfig/`; they are gitignored.

## Common operations

```sh
mise run reconcile                      # force Flux to pull changes
mise run talos:apply-node <ip>          # apply Talos config to a node
mise run talos:upgrade-node <ip>        # upgrade Talos on a node
mise run talos:upgrade-k8s              # upgrade Kubernetes
```
