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
		login.bihun.dev
		
Code Management:
	Using gitea
		code.bihun.dev (:443, web ui)
		git.bihun.dev (:22, ssh)

Generic Tools and Utilities:
	PDF Tools
		Using Stirling PDF, may switch to better more private software tooling
			pdf.bihun.dev
	Spoolman
		Filament management for 3D printers
			spoolman.bihun.dev
	Dashboard
		TBD
			dash.bihun.dev