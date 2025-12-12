Install base ubuntu on devices (x2)
SSH into them,
	sudo apt update
	sudo apt upgrade
Install pihole (on all devices)
	git clone --depth 1 https://github.com/pi-hole/pi-hole.git
	cd "pi-hole/automated install/"
	sudo bash basic-install.sh
Set pihole web admin password (on all devices)
	sudo pihole setpassword
Add user to pihole group
	sudo usermod -aG pihole $user

## Setup unbound (slightly better privacy)
See the [pihole documantation](https://docs.pi-hole.net/guides/dns/unbound/) for more information.

On each dns server device
	sudp apt install unbound
Configure unbound
	sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
```
server:
    # If no logfile is specified, syslog is used
    # logfile: "/var/log/unbound/unbound.log"
    verbosity: 0

    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes

    # May be set to no if you don't have IPv6 connectivity
    do-ip6: no

    # You want to leave this to no unless you have *native* IPv6. With 6to4 and
    # Terredo tunnels your web browser should favor IPv4 for the same reasons
    prefer-ip6: no

    # Use this only when you downloaded the list of primary root servers!
    # If you use the default dns-root-data package, unbound will find it automatically
    #root-hints: "/var/lib/unbound/root.hints"

    # Trust glue only if it is within the server's authority
    harden-glue: yes

    # Require DNSSEC data for trust-anchored zones, if such data is absent, the zone becomes BOGUS
    harden-dnssec-stripped: yes

    # Don't use Capitalization randomization as it known to cause DNSSEC issues sometimes
    # see https://discourse.pi-hole.net/t/unbound-stubby-or-dnscrypt-proxy/9378 for further details
    use-caps-for-id: no

    # Reduce EDNS reassembly buffer size.
    # IP fragmentation is unreliable on the Internet today, and can cause
    # transmission failures when large DNS messages are sent via UDP. Even
    # when fragmentation does work, it may not be secure; it is theoretically
    # possible to spoof parts of a fragmented DNS message, without easy
    # detection at the receiving end. Recently, there was an excellent study
    # >>> Defragmenting DNS - Determining the optimal maximum UDP response size for DNS <<<
    # by Axel Koolhaas, and Tjeerd Slokker (https://indico.dns-oarc.net/event/36/contributions/776/)
    # in collaboration with NLnet Labs explored DNS using real world data from the
    # the RIPE Atlas probes and the researchers suggested different values for
    # IPv4 and IPv6 and in different scenarios. They advise that servers should
    # be configured to limit DNS messages sent over UDP to a size that will not
    # trigger fragmentation on typical network links. DNS servers can switch
    # from UDP to TCP when a DNS response is too big to fit in this limited
    # buffer size. This value has also been suggested in DNS Flag Day 2020.
    edns-buffer-size: 1232

    # Perform prefetching of close to expired message cache entries
    # This only applies to domains that have been frequently queried
    prefetch: yes

    # One thread should be sufficient, can be increased on beefy machines. In reality for most users running on small networks or on a single machine, it should be unnecessary to seek performance enhancement by increasing num-threads above 1.
    num-threads: 1

    # Ensure kernel buffer is large enough to not lose messages in traffic spikes
    so-rcvbuf: 1m

    # Ensure privacy of local IP ranges
    private-address: 192.168.0.0/16
    private-address: 169.254.0.0/16
    private-address: 172.16.0.0/12
    private-address: 10.0.0.0/8
    private-address: fd00::/8
    private-address: fe80::/10

    # Ensure no reverse queries to non-public IP ranges (RFC6303 4.2)
    private-address: 192.0.2.0/24
    private-address: 198.51.100.0/24
    private-address: 203.0.113.0/24
    private-address: 255.255.255.255/32
    private-address: 2001:db8::/32
```

## Setup a VRRP (Virtual Router Redundancy Protocol)

SSH into primary pihole device
	ssh $ns01
Install keepalived
	sudo apt install keepalived
Update keepalived config
	sudo nano /etc/keepalived/keepalived.conf

```
vrrp_instance pihole {
        state MASTER
        interface eth0
        virtual_router_id 7
        priority 255
        advert_int 1
        authentication {
                auth_type PASS
                auth_pass STRONG_PASSWORD
        }
        virtual_ipaddress {
                VIP/MASK # e.g. 10.10.10.10/24
        }
}
```

SSH into secondary pihole device
	ssh $ns02
Install keepalived
	sudo apt install keepalived
Update keepalived config
	sudo nano /etc/keepalived/keepalived.conf
```
vrrp_instance pihole {
        state BACKUP
        interface eth0
        virtual_router_id 7
        priority 255
        advert_int 1
        authentication {
                auth_type PASS
                auth_pass STRONG_PASSWORD
        }
        virtual_ipaddress {
                VIP/MASK # e.g. 10.10.10.10/24
        }
}
```
Note: that the priority is 254 which is one lower than the master at 255, additional instances would decrement this priority by 1 each.
Note: The auth_pass value must be the same

dig/nslookup queries should now work on the VIP and each individual instance IP

(ensure that your firewall rules allow dns #53 lookups to all ips including the VIP)

Note: if you have multiple networks dns lookups from a different network will fail until you configure the interface settings (expert mode) in /admin/settings/dns.

Note: Setup [nebula-sync](https://github.com/lovelaze/nebula-sync_) either on the primary node or an external service to do a full config sync