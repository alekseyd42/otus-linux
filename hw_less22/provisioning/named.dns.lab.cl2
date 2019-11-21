$TTL 3600
$ORIGIN dns.lab.
@               IN      SOA     ns01.dns.lab. root.dns.lab. (
                            2711201407 ; serial
                            3600       ; refresh (1 hour)
                            600        ; retry (10 minutes)
                            86400      ; expire (1 day)
                            600        ; minimum (10 minutes)
                        )

                IN      NS      ns01.dns.lab.
                IN      NS      ns02.dns.lab.
client1         IN      A       192.168.50.15
client2         IN      A       192.168.50.16
web1            IN      CNAME   client1.dns.lab.
web2            IN      CNAME   client2.dns.lab.
; DNS Servers
ns01            IN      A       192.168.50.10
ns02            IN      A       192.168.50.11
