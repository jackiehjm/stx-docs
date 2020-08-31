========
Contents
========

***************
System Accounts
***************

.. toctree::
   :maxdepth: 1

   overview-of-system-accounts

Linux User Accounts
*******************

.. toctree::
   :maxdepth: 1

   the-sysadmin-account
   local-ldap-linux-user-accounts
   create-ldap-linux-accounts
   remote-access-for-linux-accounts
   password-recovery-for-linux-user-accounts
   establish-keystone-credentials-from-a-linux-account

Kubernetes Service Accounts
***************************

.. toctree::
   :maxdepth: 1

   kubernetes-service-accounts
   create-an-admin-type-service-account

Keystone Accounts
*****************

.. toctree::
   :maxdepth: 1

   about-keystone-accounts
   keystone-account-authentication
   manage-keystone-accounts
   configure-the-keystone-token-expiration-time
   password-recovery

Password Rules
**************

.. toctree::
   :maxdepth: 1

   starlingx-system-accounts-system-account-password-rules

*****************
Access the System
*****************

.. toctree::
   :maxdepth: 2

   configure-local-cli-access
   remote-access-index
   security-access-the-gui
   configure-http-and-https-ports-for-horizon-using-the-cli
   configure-horizon-user-lockout-on-failed-logins
   install-the-kubernetes-dashboard
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

   security-firewall-options
   security-default-firewall-rules

*************************
Secure HTTPS Connectivity
*************************

.. toctree::
   :maxdepth: 1

   https-access-overview
   starlingx-rest-api-applications-and-the-web-administration-server
   enable-https-access-for-starlingx-rest-and-web-server-endpoints
   install-update-the-starlingx-rest-and-web-server-certificate
   secure-starlingx-rest-and-web-certificates-private-key-storage-with-tpm
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

Post Installation Setup
***********************

.. toctree::
   :maxdepth: 1

   firewall-port-overrides
   enable-public-use-of-the-cert-manager-acmesolver-image
   enable-use-of-cert-manager-acmesolver-image-in-a-particular-namespace
   enable-the-use-of-cert-manager-apis-by-an-arbitrary-user

******************************
Portieris Admission Controller
******************************

.. toctree::
   :maxdepth: 1

   portieris-overview
   install-portieris
   remove-portieris
   portieris-clusterimagepolicy-and-imagepolicy-configuration

********************************
Vault Secret and Data Management
********************************

.. toctree::
   :maxdepth: 1

   security-vault-overview
   install-vault
   remove-vault

Configure Vault
***************

.. toctree::
   :maxdepth: 1

   configure-vault
   configure-vault-using-the-cli

**************************************
Encrypt Kubernetes Secret Data at Rest
**************************************

.. toctree::
   :maxdepth: 1

   encrypt-kubernetes-secret-data-at-rest

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
   operator-login-authentication-logging
   operator-command-logging

****************
UEFI Secure Boot
****************

.. toctree::
   :maxdepth: 1

   overview-of-uefi-secure-boot
   use-uefi-secure-boot
   
***********************
Trusted Platform Module
***********************

.. toctree::
   :maxdepth: 1

   tpm-configuration-considerations

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

***************************
Locally Create Certificates
***************************

.. toctree::
   :maxdepth: 1

   create-certificates-locally-using-openssl
   create-certificates-locally-using-cert-manager-on-the-controller

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