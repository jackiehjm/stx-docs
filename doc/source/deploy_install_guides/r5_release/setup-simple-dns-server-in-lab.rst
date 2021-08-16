.. _setup-simple-dns-server-in-lab:

=================================
Set up a Simple DNS Server in Lab
=================================

While installing or using |prod|, you may require a |DNS| server that you can add
entries to for name resolution.

If you don't have access to such a DNS server, here is an example procedure for
standing up a simple Bind server on an Ubuntu 20.04 server.

.. rubric:: |proc|

#.  Run the following to install.

    .. code-block:: bash

        $ sudo apt update
        $ sudo apt install bind9

#.  This is the basic setup.

    .. code-block:: bash

        $ sudo ufw allow Bind9

        $ sudo vi /etc/bind/named.conf.options
                …
                dnssec-validation no;

                listen-on {
                10.10.10.0/24;     # this ubuntu server's address is 10.10.10.9/24
                };

                allow-query { any; };

                # If this DNS Server can't find name, forward to …
                forwarders {
                8.8.8.8;
                8.8.4.4;
                };

                …

        $ sudo named-checkconf

        $ sudo systemctl restart bind9

        # Test
        $ nslookup ubuntu.com 10.10.10.9

#.  Add a domain, e.g. mydomain.com.

    .. code-block:: bash

        $ sudo vi /etc/bind/named.conf.local
            …
            zone "mydomain.com" {
                    type master;
                    file "/etc/bind/db.mydomain.com";
            };

        $ sudo systemctl reload bind9

        $ sudo cp /etc/bind/db.local /etc/bind/db.mydomain.com

        # Edit db.mydomain.com … where HOSTNAME is hostname of the dns bind server
        $ sudo vi /etc/bind/db.mydomain.com
            ;
            ;
            ;
            $TTL    604800
            @       IN      SOA     HOSTNAME. admin.HOSTNAME. (
                                     2        ; Serial
                                604800        ; Refresh
                                 86400        ; Retry
                               2419200        ; Expire
                                604800 )      ; Negative Cache TTL
            ;
            @          IN      NS      HOSTNAME.

            @          IN      A       10.10.10.9

            wrcp            IN      A       10.10.10.2
            horizon.wrcp    IN      A       10.10.10.2

            registry        IN      A       10.10.10.10


        $ sudo rndc reload
        $ sudo systemctl reload bind9
        $ sudo systemctl restart bind9
        $ sudo systemctl status bind9

        # test
        $ nslookup mydomain.com 10.10.10.9
        $ nslookup wrcp.mydomain.com 10.10.10.9
        $ nslookup registry.mydomain.com 10.10.10.9
