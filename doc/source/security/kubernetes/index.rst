.. _security-kubernetes-index:

.. include:: /_includes/toc-title-security-kub.rest

.. only:: partner

   .. include:: /security/index.rst
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

*************************
Secure HTTPS Connectivity
*************************

.. toctree::
   :maxdepth: 2

   https-access-overview
   utility-script-to-display-certificates
   starlingx-rest-api-applications-and-the-web-administration-server
   kubernetes-root-ca-certificate
   security-install-update-the-docker-registry-certificate
   add-a-trusted-ca

************
Cert Manager
************

.. toctree::
   :maxdepth: 1

   security-cert-manager
   the-cert-manager-bootstrap-process
   cert-manager-post-installation-setup

******************************
Portieris Admission Controller
******************************

.. toctree::
   :maxdepth: 1

   portieris-overview
   install-portieris
   portieris-clusterimagepolicy-and-imagepolicy-configuration
   remove-portieris

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

*****************************
Security Hardening Guidelines
*****************************

.. toctree::
   :maxdepth: 1

   security-hardening-intro

Recommended Security Features with a Minimal Performance Impact
***************************************************************

.. toctree::
   :maxdepth: 1

   uefi-secure-boot

Secure System Accounts
**********************

.. toctree::
   :maxdepth: 1

   local-linux-account-for-sysadmin
   local-and-ldap-linux-user-accounts
   starlingx-accounts
   web-administration-login-timeout
   ssh-and-console-login-timeout
   system-account-password-rules

Security Features
*****************

.. toctree::
   :maxdepth: 1

   secure-https-external-connectivity
   security-hardening-firewall-options
   isolate-starlingx-internal-cloud-management-network

***************************************
Appendix: Locally creating certificates
***************************************

.. toctree::
   :maxdepth: 1

   create-certificates-locally-using-openssl
   create-certificates-locally-using-cert-manager-on-the-controller