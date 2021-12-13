==========
sw-manager
==========

:command:`sw-manager` is the command-line interface for the VIM Orchestration
APIs.

This page documents the :command:`sw-manager` command.

.. contents::
   :local:
   :depth: 2

----------------
sw-manager usage
----------------

::

    sw-manager [-h] [--debug] [--os-auth-url OS_AUTH_URL]
               [--os-project-name OS_PROJECT_NAME]
               [--os-project-domain-name OS_PROJECT_DOMAIN_NAME]
               [--os-username OS_USERNAME] [--os-password OS_PASSWORD]
               [--os-user-domain-name OS_USER_DOMAIN_NAME]
               [--os-region-name OS_REGION_NAME]
               [--os-interface OS_INTERFACE]
               <subcommand> ...

For a list of all :command:`sw-manager` subcommands, enter:

::

    sw-manager -h

-----------
Subcommands
-----------

For a full description of usage and optional arguments for a specific
:command:`sw-manager` command, enter:

::

    sw-manager SUBCOMMAND [ COMMAND ] -h

*******************
Patch orchestration
*******************

The patch-strategy commands create, apply and monitor the orchestration of
software patch application (or updates) across all hosts of a StarlingX cluster.

``patch-strategy create``
    Create a strategy.

``patch-strategy delete``
    Delete a strategy.

``patch-strategy apply``
    Apply a strategy.

``patch-strategy abort``
    Abort a strategy.

``patch-strategy show``
    Show a strategy.

*********************
Upgrade orchestration
*********************

.. note::

   The following commands are not yet supported.

The upgrade-strategy commands create, apply and monitor the orchestration of
software upgrades across all hosts of a StarlingX cluster.

``upgrade-strategy create``
    Create a strategy.

``upgrade-strategy delete``
    Delete a strategy.

``upgrade-strategy apply``
    Apply a strategy.

``upgrade-strategy abort``
    Abort a strategy.

``upgrade-strategy show``
    Show a strategy.

*****************************
Firmware update orchestration
*****************************

The ``fw-update-strategy`` commands create, apply, and monitor the orchestration
of Intel N3000 |FPGA| |PAC| user load image updates across all hosts of a
StarlingX cluster.

``fw-update-strategy create``
    Create a strategy.

``fw-update-strategy delete``
    Delete a strategy.

``fw-update-strategy apply``
    Apply a strategy.

``fw-update-strategy abort``
    Abort a strategy.

``fw-update-strategy show``
    Show a strategy.

********************************
Kubernetes upgrade orchestration
********************************

The kube-upgrade-strategy commands create, apply and monitor the
orchestration of Kubernetes version upgrades across all hosts of a StarlingX
cluster.

``kube-upgrade-strategy create``
    Create a strategy.

``kube-upgrade-strategy delete``
    Delete a strategy.

``kube-upgrade-strategy apply``
    Apply a strategy.

``kube-upgrade-strategy abort``
    Abort a strategy.

``kube-upgrade-strategy show``
    Show a strategy.

***************************************
Kubernetes Root CA update orchestration
***************************************

The :command:`kube-rootca-update-strategy` commands create, apply and monitor
the orchestration of Kubernetes Root |CA| certificate updates across all hosts
of a |prod| cluster.

``kube-rootca-update-strategy create``
    Create a strategy.

``kube-rootca-update-strategy delete``
    Delete a strategy.

``kube-rootca-update-strategy apply``
    Apply a strategy.

``kube-rootca-update-strategy abort``
    Abort a strategy.

``kube-rootca-update-strategy show``
    Show a strategy.
