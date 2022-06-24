.. _index-security-kub-81153c1254c3:

.. include:: /_includes/toc-title-security-kub.rest

.. only:: partner

   .. include:: /security/index-security-84d0d8aa401b.rst
      :start-after: kub-begin
      :end-before: kub-end

***************
System Accounts
***************

.. toctree::
   :maxdepth: 2

   types-of-system-accounts
   overview-of-system-accounts
   kube-service-account
   keystone-accounts
   remote-windows-active-directory-accounts
   starlingx-system-accounts-system-account-password-rules
   manage-local-ldap-39fe3a85a528

*****************
Access the System
*****************

.. toctree::
   :maxdepth: 2

   configure-local-cli-access
   remote-access-index
   security-access-the-gui
   security-rest-api-access
   connect-to-container-registries-through-a-firewall-or-proxy

***************************
Manage Non-Admin Type Users
***************************

.. toctree::
   :maxdepth: 1

   private-namespace-and-restricted-rbac
   pod-security-policies
   enable-pod-security-policy-checking
   disable-pod-security-policy-checking
   assign-pod-security-policies
   resource-management

.. _user-authentication-using-windows-active-directory-security-index:

**************************************************
User Authentication Using Windows Active Directory
**************************************************

.. toctree::
   :maxdepth: 1

   overview-of-windows-active-directory
   configure-kubernetes-for-oidc-token-validation-while-bootstrapping-the-system
   configure-kubernetes-for-oidc-token-validation-after-bootstrapping-the-system
   configure-oidc-auth-applications
   centralized-oidc-authentication-setup-for-distributed-cloud
   configure-users-groups-and-authorization
   configure-kubectl-with-a-context-for-the-user

Obtain the Authentication Token
*******************************

.. toctree::
   :maxdepth: 1

   obtain-the-authentication-token-using-the-oidc-auth-shell-script
   obtain-the-authentication-token-using-the-browser

Deprovision Windows Active Directory
************************************

.. toctree::
   :maxdepth: 1

   deprovision-windows-active-directory-authentication

****************
Firewall Options
****************

.. toctree::
   :maxdepth: 1

   security-default-firewall-rules
   security-firewall-options

****************************
HTTPS Certificate Management
****************************

.. toctree::
   :maxdepth: 2

   https-access-overview
   utility-script-to-display-certificates
   starlingx-rest-api-applications-and-the-web-admin-server-cert-9196c5794834
   kubernetes-certificates-f4196d7cae9c
   etcd-certificates-c1fc943e4a9c
   kubernetes-root-ca-certificate
   configure-rest-api-applications-and-web-administration-server-certificates-after-installation-6816457ab95f
   configure-docker-registry-certificate-after-installation-c519edbfe90a
   oidc-client-dex-server-certificates-dc174462d51a
   migrate-platform-certificates-to-use-cert-manager-c0b1727e4e5d
   portieris-server-certificate-a0c7054844bd
   vault-server-certificate-8573125eeea6
   dc-admin-endpoint-certificates-8fe7adf3f932
   add-a-trusted-ca
   one-single-root-ca-multiple-server-client-certificates-0692df6ce16d
   alarm-expiring-soon-and-expired-certificates-baf5b8f73009

************
Cert Manager
************

.. toctree::
   :maxdepth: 1

   security-cert-manager
   the-cert-manager-bootstrap-process
   cert-manager-post-installation-setup

.. _portieris-admission-controller-security-index:

******************************
Portieris Admission Controller
******************************

.. toctree::
   :maxdepth: 1

   portieris-overview
   install-portieris
   portieris-clusterimagepolicy-and-imagepolicy-configuration
   remove-portieris

.. _vault-secret-and-data-management-security-index:

********************************
Vault Secret and Data Management
********************************

.. toctree::
   :maxdepth: 1

   security-vault-overview
   install-vault
   configure-vault
   configure-vault-using-the-cli
   remove-vault

**************************************
Encrypt Kubernetes Secret Data at Rest
**************************************

.. toctree::
   :maxdepth: 1

   encrypt-kubernetes-secret-data-at-rest


*********************
Linux Auditing System
*********************

.. toctree::
   :maxdepth: 1

   auditd-support-339a51d8ce16


*************************************
Operator Login/Authentication Logging
*************************************

.. toctree::
   :maxdepth: 1

   operator-login-authentication-logging

************************
Operator Command Logging
************************

.. toctree::
   :maxdepth: 1

   operator-command-logging

****************
UEFI Secure Boot
****************

.. toctree::
   :maxdepth: 1

   overview-of-uefi-secure-boot
   use-uefi-secure-boot

***********************************
Authentication of Software Delivery
***********************************

.. toctree::
   :maxdepth: 1

   authentication-of-software-delivery

*******************************************************
Security Feature Configuration for Spectre and Meltdown
*******************************************************

.. toctree::
   :maxdepth: 1

   security-feature-configuration-for-spectre-and-meltdown

************************
Deprecated Functionality
************************

.. toctree::
   :maxdepth: 1

   starlingx-rest-api-applications-and-the-web-administration-server-deprecated
   security-install-update-the-docker-registry-certificate-deprecated

***************************************
Appendix: Locally creating certificates
***************************************

.. toctree::
   :maxdepth: 1

   create-certificates-locally-using-openssl
   create-certificates-locally-using-cert-manager-on-the-controller

