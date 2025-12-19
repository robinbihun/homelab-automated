Split-Horizon DNS:
	bihun.dev (require SSL Certs on EVERYTHING)


Firewall:
	firewall.bihun.dev

Proxmox Virtualization:
	pve.bihun.dev

Storage Server (TrueNas):
	storage.bihun.dev
	
Plex Server
	plex.bihun.dev (container on truenas box)

DNS:
	cloudflare managed, tunnels for public services

Kubernetes Services:
	Control plane clustered API Address: 10.10.10.30 (cluster.bihun.dev)
	k8s-01: 10.10.10.31
	k8s-02: 10.10.10.32
	k8s-03: 10.10.10.33
	k8s_gateway (DNS): 10.10.10.40
	internal_gateway load balancer ip: 10.10.10.41
	external_gateway load balancer ip: 10.10.10.42

Security:
	User Identity and Authentication using KeyCloak
		auth.bihun.dev
		
Code Management:
	Using forgejo
		code.bihun.dev (:443, web ui)
		code.bihun.dev (:22, ssh)

Generic Tools and Utilities:
	PDF Tools
		BentoPDF
			pdf.bihun.dev
	Spoolman
		Filament management for 3D printers
			spoolman.bihun.dev
	Dashboard
		TBD -- hajimari looks nice, ref: https://github.com/christfriedbalizou/homelab/blob/main/kubernetes/apps/default/hajimari/ks.yaml
			dash.bihun.dev


hetzner runs torrent and autobrr in netherlands $30/month
hetzner seeds only popular things, may churn on the popular stuff just to keep the seed ration high
hetzner box uses tailscale to communicate with sonarr/radarr on the cluster only to communicate with api to get requests
hetzner box uses tailscale (& syncthing) to communicate with the nas to copy desired content to plex
torrentleach -- mmcants has invite


bihun.dev split-brain DNS

internal:
	pihole cluster:
		ns01: 10.10.10.6
		ns02: 10.10.10.7
		vip: 10.10.10.5
		upstream: cloudflare dnssec
	Firewall DNS resolution
		DHCP hosts first
		bihun.dev override to 10.10.10.5

external:
	cloudflare
