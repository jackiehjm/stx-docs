

.. _utility-script-to-display-certificates:

------------------------------------------
Display Certificates Installed on a System
------------------------------------------

The utility script **show-certs.sh** can be used to display an overview of the
various certificates that exist in the system along with their expiry date.

The :command:`show-certs.sh` command has the following options:

**sudo show-certs.sh [-k] [-e <number-of-days>] [-h]**

where:

By default, :command:`show-certs.sh` command displays the platform-managed
system certificates, and (highlighted in red) certificates requiring manual
renewal, and certificates expiring within 90 days.

options:

-k  displays certificates found in any Kubernetes SECRETS;
    this may include platform certificates and end-users' certificates

-e  <number-of-days> changes to highlight (in red) certificates within
    <number-of-days> of expiry

-h  displays help

For example:

.. code-block:: none

    ~(keystone_admin)]$ sudo show-certs.sh

    registry.local  CERTIFICATE:
    -----------------------------------------------------
    Renewal 	    :  Manual
    Filename	    :  /etc/ssl/private/registry-cert.crt
    Subject         :  /CN=registry.local
    Issuer          :  /CN=registry.local
    Issue Date	    :  Aug 31 01:43:09 2021 GMT
    Expiry Date	    :  Aug 31 01:43:09 2022 GMT
    Residual Time   :  341d
    -----------------------------------------------------

For scalability in a Distributed cloud system, the Subcloud ICA certificates
are redirected to a file. The script displays the path to the file with a note
at the end of the output file.

.. code-block:: none

    Subcloud ICA certificates (*-adminep-ca-certificate) are saved to
    /tmp/subcloud-icas-tls-secrets.HqZSBQoUUJ.txt in order to limit the
    size of the output.

For example,

.. code-block:: none

    ~(keystone_admin)]$ cat /tmp/subcloud-icas-tls-secrets.HqZSBQoUUJ.txt

    Renewal                              Namespace  Secret		             Residual Time
    ---------------------------------------------------------------------------------------
    Automatic [Managed by Cert-Manager]   dc-cert   subcloud1-adminep-ca-certificate   364d
    Automatic [Managed by Cert-Manager]   dc-cert   subcloud10-adminep-ca-certificate  364d
    Automatic [Managed by Cert-Manager]   dc-cert   subcloud100-adminep-ca-certificate 364d
    ---------------------------------------------------------------------------------------








