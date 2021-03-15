
.. xss1596546751114
.. _install-portieris:

=================
Install Portieris
=================

You can install Portieris on |prod| from the command line.

.. rubric:: |proc|

#.  Locate the Portieris tarball in /usr/local/share/applications/helm.

    For example:

    /usr/local/share/applications/helm/portieris-<version>.tgz

#.  Upload the application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-upload /usr/local/share/applications/helm/portieris-<version>.tgz

#.  Set caCert helm overrides if applicable.

    In order to specify registries or notary servers signed by a custom |CA|
    certificate, the caCert: CERTIFICATE override must be added to the
    portieris-certs helm chart. This must be passed as the b64enc of the |CA|
    certificate and may contain 1 or more |CA| Certificates.

    For example:


    #.  Create the caCert.yaml override file.

        .. code-block:: none

            ~(keystone_admin)]$ echo 'caCert: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURYVENDQWtXZ0F3SUJBZ0lKQUpjVHBXcTk4SWNSTUEwR0NTcUdTSWIzRFFFQkN3VUFNRVV4Q3pBSkJnTlYKQkFZVEFrRlZNUk13RVFZRFZRUUlEQXBUYjIxbExWTjBZWFJsTVNFd0h3WURWUVFLREJoSmJuUmxjbTVsZENCWAphV1JuYVhSeklGQjBlU0JNZEdRd0hoY05NVGd3T0RFMk1qQXlPREl3V2hjTk1qRXdOakExTWpBeU9ESXdXakJGCk1Rc3dDUVlEVlFRR0V3SkJWVEVUTUJFR0ExVUVDQXdLVTI5dFpTMVRkRYwWlRFaE1COEdBMVVFQ2d3WVNXNTAKWlhKdVpYUWdWMmxrWjJsMGN5QlFkSGtnVEhSa01JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBTUlJQgpDZ0tDQVFFQXV4YXJMaVdwMDVnbG5kTWRsL1o3QmhySDFPTFNTVTcwcm9mV3duTmNQS3hsOURmVVNWVTZMTDJnClppUTFVZnA4TzFlVTJ4NitPYUxxekRuc2xpWjIxdzNXaHRiOGp2NmRFakdPdTg3eGlWWDBuSDBmSjF3cHFBR0UKRkVXekxVR2dJM29aUDBzME1Sbm1xVDA4VWZ6S0hCaFgvekNvNHMyVm9NcWxRNyt0Qjc2dTA3V3NKYQ0RFlQVwprR2tFVmRMSk4rWWcwK0pLaisvVU9kbE5WNDB2OE1ocEhkbWhzY1QyakI3WSszT0QzeUNxZ1RjRzVDSDQvK3J6CmR4Qjk3dEpMM2NWSkRQWTVNQi9XNFdId2NKRkwzN1p1M0dVdmhmVGF3NVE0dS85cTFkczgrVGFYajdLbWUxSzcKQnYyMTZ5dTZiN3M1ckpHU2lEZ0p1TWFNcm5YajFRSURBUUFCbzFBd1RqQWRCZ05WSFE0RUZnUVVyQndhbTAreApydUMvY3Vpbkp1RlM4Y1ZibjBBd0h3WURWUjBqQkJnd0ZvQVVyQndhbTAreHJ1Qy9jdWluSnVGUzhjVmJuMEF3CkRBWURWUjBUQFVd0F3RUIvekFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBZzJ5aEFNazVJUlRvOWZLc1IvMXkKMXJ5NzdSWU5KN1R2dTB0clltRElBMVRaanFtanlncFFiSmlGb0FPa255eHYveURLU0x6TXFNU2JIb0I1K1BhSQpnTERub0F6SnYxbzg3OEpkVllURjIyS2RUTU5wNWtITXVGMnpSTFFxc2lvenJQSUpWMDlVb2VHeHpPQ1pkYzZBCnpUblpCSy9DVTlRcnhVdzhIeDV6SEFVcHdVcGxONUE4MVROUmlMYVFVTXB5dzQ4Y08wNFcyOWY1aFA2aGMwVDMKSDJpU212OWY2K3Q5TjBvTTFuWVh1blgwWNJZll1aERmQy83c3N3eDhWcW5uTlNMN0lkQkhodGxhRHJGRXBzdQpGZzZOODBCbGlDclJiN2FPcUk4TWNjdzlCZW9UUk9uVGxVUU5RQkEzTjAyajJvTlhYL2loVHQvZkhNYlZGUFRQCi9nPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=' > caCert.yaml

    #.  Apply the override file.

        .. code-block:: none

            ~(keystone_admin)]$ system helm-override-update portieris portieris-certs portieris --values caCert.yaml


#.  Apply the application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-apply portieris


