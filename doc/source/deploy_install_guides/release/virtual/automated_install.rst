==============================
Automated Virtual Installation
==============================

This automated installer provides you with an easy way to install StarlingX 
|this-ver| in different configuration options in a virtual environment.

.. contents::
   :local:
   :depth: 1

------------------------------------
Physical host requirements and setup
------------------------------------

This section describes how to prepare the physical host and virtual 
environment for an automated StarlingX |this-ver| virtual deployment in 
VirtualBox.

.. include:: automated_setup.txt

---------------------------
Installation Configurations
---------------------------

The configurations available from this script, via the ``--setup-type`` 
parameter, are:

* **AIO-SX** or "All-In-One Simplex" will set up one single VM that will be
  both a controller and a worker node.

* **AIO-DX** or "All-In-One Duplex" will set up two controller VMs with one of
  them also being a worker.

* **STANDARD** setup is currently under review.

* **STORAGE** setup is currently under review.


------------------
Deployment Example
------------------

.. rubric:: |proc|

The following commands are an example on how to run the script for the 
deployment of an All-In-One Simplex configuration.

#. Set the password for the StarlingX system

   .. code-block:: none

      export STX_INSTALL_PASSWORD=<password>


   The script validates the password as it must contain:

   - Minimum of 7 characters.
   - At least 1 uppercase letter.
   - At least 1 number.
   - At least 1 non-alphanumeric character.


#. Run the script

   .. code-block:: none

      cd $HOME/virtual-deployment/virtualbox/pybox
      source ./venv/bin/activate

      python3 ./install_vbox.py \
      --setup-type <AIO-SX/AIO-DX> \
      --iso-location "$HOME/Downloads/stx-8.iso" \
      --labname StarlingX --install-mode <serial/graphical> \
      --config-files-dir ./myconfig/labSetupFiles/ \
      --ansible-controller-config ./myconfig/ansibleFiles/<simplex/duplex>_localhost.yml \
      --kubernetes-config-files ./myconfig/kubeFiles/ \
      --vboxnet-type nat \
      --vboxnet-name NatNetwork \
      --nat-controller0-local-ssh-port <PORT_CONTROLLER0> \
      --nat-controller1-local-ssh-port <PORT_CONTROLLER1> \
      --password $STX_INSTALL_PASSWORD


.. note::
   All available configuration options can be found using ``--help``.
   Parameters as ``--snapshot`` and ``--headless`` may be benefitial if
   working in a development enviroment. 


.. note::
   The ``localhost.yml`` file can be modified for further configurations 
   during the Ansible bootstrap, refer to :ref:`Ansible Bootstrap 
   Configurations <ansible_bootstrap_configs_r7>` for information on 
   additional configurations for advanced Ansible bootstrap scenarios, such as 
   Docker proxies when deploying behind a firewall, etc. Refer to :ref:`Docker 
   Proxy Configuration <docker_proxy_config>` for details about Docker proxy 
   settings.

.. important::
   In a machine with the physical host requirements described on this page,
   the script will take 60 to 90 minutes to be fully completed (from creating
   a VM and installing an OS to configuring StarlingX). The total amount of
   time will depend on the deployment configurations. Several restarts will
   occur, and a VirtualBox window with a prompt may appear.


.. rubric:: |result|

After the completion of the script your StarlingX cluster is now up and 
running.


----------
Dashboards
----------

*********************
Starlingx Horizon GUI
*********************

The script automatically sets up a port-forwarding rule in VirtualBox for 
accessing the StarlingX Horizon GUI. The default port is ``8080``, if none was 
chosen.

Access the StarlingX Horizon GUI with the following steps:

.. rubric:: |proc|

#. Enter the the following address in your browser:
   ``http://localhost:8080``.

#. Log in to Horizon with an admin/<sysadmin-password>.


********************
Kubernetes Dashboard
********************

The script automatically sets up a port-forwarding rule in VirtualBox for 
accessing the Kubernetes dashboard. The default port is ``32000``, if none was 
chosen.

.. rubric:: |proc|

#. Enter the the following address in your browser:
   ``http://localhost:32000``.

#. Log in to the Kubernetes dashboard using the ``admin-user`` token.

   The token can be found in the token.txt file sent to $HOME in the host 
   machine.