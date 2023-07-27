

.. _utility-script-to-display-certificates:

------------------------------------------
Display Certificates Installed on a System
------------------------------------------

The script **show-certs.sh** can be used to display a list of the specific
certificates present on a |prod| system with details such as expiry
date, residual time, subject, issuer and renewal behaviour (manual or
automatic).

The :command:`show-certs.sh` command has the following options:

**sudo show-certs.sh [-k] [-e <number-of-days>] [-h]**

where:

By default, :command:`show-certs.sh` command displays the platform-managed
system certificates, and (highlighted in red) certificates requiring manual
renewal, and certificates expiring within 90 days.

options:

``-k`` displays certificates found in any Kubernetes SECRETS; this may include
platform certificates and end-users' certificates.

``-e`` <number-of-days>. Changes to highlight (in red) certificates within
<number-of-days> of expiry.

``-h`` displays help

.. note::

    This command can only be run locally on the active controller, in an SSH
    shell.

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

    local-openldap / deployment  /  system-openldap-local-certificate  CERTIFICATE:
    ------------------------------------------
    Renewal        :  Automatic [Managed by Cert-Manager]
    Namespace      :  deployment
    Secret         :  system-openldap-local-certificate
    Subject        :  CN = system-openldap
    Issuer         :  CN = starlingx
    Issue Date     :  Jul 6 16:15:30 2023 GMT
    Expiry Date    :  Oct 4 16:15:30 2023 GMT
    Residual Time  :  89d
    
    … etc


For scalability reasons, in a Distributed cloud system, the Subcloud ICA
certificates that are present on a SystemController are redirected to a file.
The script displays the path to the file with a note at the end of the
displayed output.

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








