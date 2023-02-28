
.. qzw1552672165570
.. _infrastructure_security:

=======================
Infrastructure Security
=======================

A key aspect of planning your installation and configuration is addressing
infrastructure security. By planning your configuration to include industry
standard best practices prior to deployment, you can reduce the risk of
security and compliance issues.

---------------------------------------
|prod| Infrastructure Security Features
---------------------------------------

The security features listed below are available with |prod| and should be
included in your infrastructure security planning.

-   Regular CVE scanning and fixing of |prod| Platform’s DEB Kernel and RPM
    Packages
         
-   UEFI Secure Boot on |prod| Hosts

    -    Signed boot loaders, initramfs, kernel and kernel modules

    -    Signed in formal builds with |prod| private key on |prod| secure
         signing server

    -    Validated by board-specific UEFI Secure Boot Firmware

    For more information, see :ref:`Kubernetes_UEFI_Secure_Boot_Planning`
    
-   Signed ISOs and Patches/Updates

    -    Signed in formal builds with |prod| private key on |prod| secure
         signing server

    -    Public key built into ISO and patch signature validation code

    -    Signatures checked on load import and update import commands

-   Authentication and Authorization on all interfaces of:

    -    SSH / Local Console (local LDAP)
    
         -    Linux User/Group Permissions
 
         -    Linux sudo
 
    -    |prod| REST APIs/CLIs (Keystone - local DB)
    
         -    Keystone Roles - admin, member
 
    -    Kubernetes APIs/CLIs (Service Accounts and Remote LDAP / Windows
         Active Directory via OIDC/DEX)

         -    K8S RBAC Policies

    -    |prod| Dashboard Webserver (Keystone - Local DB)

         -    Keystone Roles - admin, member

    -    Local Docker Registry (Keystone - Local DB)

         - Keystone - admin, non-admin user

-   HTTPS Support for all external Platform endpoints including:

    -    System, Kubernetes, local docker registry REST APIs

    -    Platform Dashboard Webserver

    -   Certificate Management for K8S Certificates
        
        -    Bootstrap configured K8S Root CA Certificates (auto-generated or
             user-specified)

        -    Cron Jobs for renewing K8S server & client Certificates
            
        -    Procedure for updating K8S Root CA Certificate

    -   Certificate Management for HTTPS Platform endpoints  (StarlingX APIs,
        Registry, OIDC, …) including use of Cert-Manager for install and
        auto-renewal of Certificates


    -   Trusted CA Management for local client-side certificate validation

    -   Alarming of soon-to-expired and expired Certificates

    -   ‘show-certs.sh’ for displaying status and residual time for all
        certificates.

-   Secure (HTTPS) Platform management network communication in Distributed
    Cloud providing secure management network connectivity between the system
    controller and subclouds with auto-renewal of certificates

-   OAM / API Firewall includes default firewall rules automatically applied
    and customer modifiable through Calico network policies

-   Helm v3 support including the removal of the default use of Helmv2/Tiller
    (insecure)
     
-   Secure User Management including:

    -    User Password Complexity enforcement

    -    User forced log out on idle activity

    -    User temporary lock out on N consecutive authentication failures

-   Audit logs for operator commands and authentication events

    -    Shell commands (on SSH / Local Console)

    -    StarlingX REST APIs / CLIs

    .. include:: /_includes/infrastructure-security.rest
       :start-after: begin-wra-note
       :end-before: end-wra-note

-   Linux Auditd support for running on all hosts with configurable rules

-   OpenScap Modules included in Host ISO

-   Security Services for Hosted Applications including:

    -    Cert Manager support including integration of the cert-manager project
         to automate the management and issuance of TLS certificates from
         various issuing sources (e.g. interface with external CA for
         certificate signing, auto-renewal of certificates)

    -   Secure secret management and storage  (Hashicorp Vault) with the
        integration of upstream Hashicorp Vault project and Support Vault
        general secret management for hosted applications

.. _Kubernetes_UEFI_Secure_Boot_Planning:

------------------------------------
Kubernetes UEFI Secure Boot Planning
------------------------------------

|UEFI| Secure Boot Planning allows you to authenticate modules before they are
allowed to execute.

The initial installation of |prod| should be done in |UEFI| mode if you plan on
using the secure boot feature in the future.

The |prod| secure boot certificate can be found in the |prod| ISO, on the EFI
bootable FAT filesystem. The file is in the directory /CERTS. You must add this
certificate database to the motherboard's |UEFI| certificate database. How to
add this certificate to the database is determined by the |UEFI| implementation
provided by the motherboard manufacturer.

You may need to work with your hardware vendor to have the certificate
installed.

There is an option in the |UEFI| setup utility that allows a user to browse to
a file containing a certificate to be loaded in the authorized database. This
option may be hidden in the |UEFI| setup utility unless |UEFI| mode is enabled,
and secure boot is enabled.

Many motherboards ship with Microsoft secure boot certificates pre-programmed
in the |UEFI| certificate database. These certificates may be required to boot
|UEFI| drivers for video cards, |RAID| controllers, or |NICs| (for example,
the |PXE| boot software for a |NIC| may have been signed by a Microsoft
certificate). While certificates can be removed from the certificate database
\(this is |UEFI| implementation specific) it may be required that you keep the
Microsoft certificates to allow for complete system operation.

Mixed combinations of secure boot and non-secure boot nodes are supported. For
example, a controller node may secure boot, while a worker node may not. Secure
boot must be enabled in the |UEFI| firmware of each node for that node to be
protected by secure boot.

.. _security-planning-uefi-secure-boot-planning-ul-h4z-lzg-bjb:

-   Secure Boot is supported in |UEFI| installations only. It is not used when
    booting |prod| as a legacy boot target.

-   |prod| does not currently support switching from legacy to |UEFI| mode
    after a system has been installed. Doing so requires a reinstall of the
    system. This means that upgrading from a legacy install to a secure boot
    install (|UEFI|) is not supported.

-   When upgrading a |prod| system from a version that did not support secure
    boot to a version that does, do not enable secure boot in |UEFI| firmware
    until the upgrade is complete.
