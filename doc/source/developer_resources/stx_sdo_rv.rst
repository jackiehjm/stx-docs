==========================================
Enable SDO Rendezvous Service on StarlingX
==========================================

.. contents::
   :local:
   :depth: 2

------------
Introduction
------------

`Secure Device Onboard (SDO) <https://secure-device-onboard.github.io/docs/>`_
is open source software that is in the process of becoming an industry standard
through the FIDO (Fast IDentity Online) alliance. |SDO| automates the "onboard"
process, which occurs when a device establishes the first trusted connection
with a device management service.

|SDO| can be used with x86 and ARM-based devices ranging from small compute IoT
devices to higher compute Intel® Xeon® devices. The key requirement is that the
device must be manufactured with the necessary credentials and |SDO| client
software.

The |SDO| process involves interactions between a number of
different entities including: Manufacturer, Device, Owner, Rendezvous service,
and Device platform service.

This document describes how to enable the |SDO| Rendezvous (RV) service on
|prod|.

-----------------
Integration Steps
-----------------

#. Complete building all the build layers. See the `Layered Build Guide
   <https://docs.starlingx.io/developer_resources/layered_build_guide.html>`_
   for details.

#. Build the application exclusively. Enter the flock layer and refer to the
   `Build flock layer steps
   <https://docs.starlingx.io/developer_resources/layered_build_guide.html#build-flock-layer>`_
   for details.

#. Build the application using the commands:

   ::

     build-pkgs --clean stx-sdo-helm
     build-pkgs --dep-test stx-sdo-helm

   An example of successful logs is shown below:

   ::

     13:49:21 ===== iteration 1 complete =====
     13:49:21
     13:49:21 Results out to: /localdisk/loadbuild/stx/flock/std/results/stx-flock-4.0-std
     13:49:21
     13:49:21 Pkgs built: 2
     13:49:21 Packages successfully built in this order:
     13:49:21 /localdisk/loadbuild/stx/flock/std/rpmbuild/SRPMS/build-info-1.0-4.tis.src.rpm
     13:49:21 /localdisk/loadbuild/stx/flock/std/rpmbuild/SRPMS/stx-sdo-helm-1.0-2.tis.src.rpm
     13:49:22 Recreate repodata

     ######## Tue Feb 23 13:49:23 UTC 2021: build-rpm-parallel --std was successful

     Tue Feb 23 13:49:23 UTC 2021: std complete

     Skipping 'rt' build, no valid targets in list:  stx-sdo-helm
     Skipping 'installer' build
     Skipping 'containers' build
     All builds were successful

#. Create the Armada application using the command:

   ::

     build-helm-charts.sh -a stx-sdo

   Sample console output is as follows:

   ::

     Merging yaml from file: usr/lib/armada/sdo_manifest.yaml
     Writing merged yaml file: stx-sdo.yaml
     Results:
     /localdisk/loadbuild/stx/flock/std/build-helm/stx/stx-sdo-1.0-2.tgz

#. Exit from the container. The SDO-RV Armada application will be found in the
   following location:

   ::

     $HOME/starlingx/workspace/localdisk/loadbuild/stx/flock/std/build-helm/stx/stx-sdo-<version>.tgz

#. Copy the application into the home folder of the controller.

#. Copy the certs folder of the |SDO| version 1.10 release to the home
   folder using the command:

   ::

     curl --progress-bar -LO https://github.com/secure-device-onboard/release/releases/download/v1.10.0/rendezvous-service-v1.10.0.tar.gz
     tar -zxf rendezvous-service-v1.10.0.tar.gz

#. Acquire admin credentials:

   ::

     source /etc/platform/openrc

#. Load the stx-openstack application package into |prod|. The tarball
   package contains the stx-openstack Airship Armada manifest and stx-openstack
   set of Helm charts. For example:

   ::

     system application-upload stx-sdo-<version>.tgz

#. Apply the ``stx-sdo`` application to bring the |SDO| Rendevous application
   into service. If your environment is preconfigured with a proxy server, make
   sure the HTTPS proxy is set before applying ``stx-sdo``.

   ::

     system application-apply stx-sdo

#. Check the application status using the command:

   ::

     system application-show stx-sdo


When the |SDO| Rendezvous application is in service, you will see the RV service
and redis DB pods running. For example:

::

  [sysadmin@controller-0 ~(keystone_admin)]$ kubectl get pods -n kube-system
  NAME                         READY   STATUS    RESTARTS   AGE
  redis-6d76cdd759-wpnv7       1/1     Running   0          11d
  rv.deploy-6b9c4b8b65-chf2v   1/1     Running   0          11d

