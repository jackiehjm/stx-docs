.. _configure-silicom-sts-ptp-application-1bc4a8d07aad:

======================================================
Configure PTP on Silicom TimeSync (STS) Server Adapter
======================================================


The Silicom TimeSync Server Adapter (STS) provides local time sync support via
a local GNSS module which is based on Intel E810 chipset.

For additional information, see
https://www.silicom-usa.com/pr/server-adapters/networking-adapters/10-gigabit-ethernet-networking-adapters/p410g8ts81-timesync-server-adapter/

The Silicom STS card operates in two modes: regular NIC mode and timing mode.

Packaged as a system application, the sts-silicom application provides
the ability to configure the STS cards in timing mode and specify time sync
parameters using helm-overrides.

.. rubric:: |context|

On multi-node systems, a homogenous deployment of the Silicom TimeSync (STS)
cards is necessary since it's not possible to specify different configurations
for different nodes.


.. rubric:: **Limitations**

.. include:: configuring-ptp-service-using-the-cli.rst
   :start-after: begin-silicom-ptp-limitations
   :end-before: end-silicom-ptp-limitations

.. rubric:: |proc|

The following example uses a Grand Master deployment on port ``enp81s0f3`` with
``twoStep`` mode enabled:

#. Install the application.

   ~(keystone_admin)]$ system application-upload /usr/local/share/applications/helm/sts-silicom-<n.n-nn>.tgz


#. Create the configuration file and apply it.

   .. code-block::

      $ cat << EOF > sts_override.yaml
      Spec:
        profileID: 2
        ports:
        - ethName: enp81s0f3
          ql: 4
          ethPort: 4
        masterPortMask_GM: 0x8
        syncePortMask_GM: 0x8
        twoStep: 1
      EOF

      ~(keystone_admin)]$ system helm-override-update sts-silicom sts-silicom sts-silicom --values sts_override.yaml

      ~(keystone_admin)]$ system application-apply sts-silicom

#. Check if the application is applied.

   .. code-block::

      ~(keystone_admin)]$ system application-show sts-silicom

.. rubric:: |postreq|

To update the application, remove and re-apply it with the new configuration.

#. Remove the application.

.. code-block:: none

   ~(keystone_admin)]$ system application-remove sts-silicom

#. Edit ``sts_override.yaml``.

#. Apply the new configuration.

   .. code-block:: none
   
      ~(keystone_admin)]$ system helm-override-update sts-silicom sts-silicom sts-silicom --values sts_override.yaml
      ~(keystone_admin)]$ system application-apply sts-silicom


For more details on the configuration parameters, please consult the following
Silicom documentation:

https://github.com/silicom-ltd/STS_HelmCharts

From https://silicom.ftptoday.com, under /STS/STS_Docs/  (credentials
required):

* STS_Products_Line_Quick_Start_Guide_v1.60.pdf
* Linux_TSync_Prog_Guide_V2.4.pdf
