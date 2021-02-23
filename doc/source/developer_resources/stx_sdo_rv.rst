==================================
Enable SDO RV Service on StarlingX
==================================

.. contents::
   :local:
   :depth: 2

------------
Introduction
------------

`Secure Device Onboard (SDO) <https://secure-device-onboard.github.io/docs/>`_
is an open source software that is in the process of becoming an industry
standard through the FIDO (Fast IDentity Online) alliance, which automates the
process of securely onboarding SDO capable devices. By “onboard” we mean the
process by which device establishes its first trusted connection with the
device management service.

The devices to be onboarded through SDO can be X-86/ARM based platform ranging
from small compute IoT devices to higher compute Xeon devices. The only condition
is that, the device must come with necessary credentials and SDO client software
during the manufacturing stage.

The Secure Device Onboard process involves interactions between a number of
different entities that participate in the process. Those include: Manufacturer,
Device, Owner, Rendezvous service, Device platform service.

This documents talks about enabling Rendezvous service on StarlingX.

-----------------
Integration Steps
-----------------

Following are the steps to build and enable SDO RV service.

#. Complete building all the build layers. See `build guide <https://docs.starlingx.io/developer_resources/layered_build_guide.html>`_ for reference.

#. You can build application exclusively. Enter the flock layer, please refer
   `flock layer <https://docs.starlingx.io/developer_resources/layered_build_guide.html#build-flock-layer>`_
   for same.

#. Build application using below command:

   ::

     $ build-pkgs --clean stx-sdo-helm
     $ build-pkgs --dep-test stx-sdo-helm

   Following is the sample of a successful logs:

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

#. Create the armada application using below command:

   ::

     $ build-helm-charts.sh -a stx-sdo

   Sample console output is as follows:

   ::

     Merging yaml from file: usr/lib/armada/sdo_manifest.yaml
     Writing merged yaml file: stx-sdo.yaml
     Results:
     /localdisk/loadbuild/stx/flock/std/build-helm/stx/stx-sdo-1.0-2.tgz

#. Exit from the container, the SDO-RV armada application will be found in the
   location as follows:

   ::

     $HOME/starlingx/workspace/localdisk/loadbuild/stx/flock/std/build-helm/stx/stx-sdo-<version>.tgz

#. Copy the application into home folder of the controller.

#. Copy the certs folder of the SDO version 1.10 release to the home
   folder using below command.

   ::

     curl --progress-bar -LO https://github.com/secure-device-onboard/release/releases/download/v1.10.0/rendezvous-service-v1.10.0.tar.gz
     tar -zxf rendezvous-service-v1.10.0.tar.gz

#. Acquire admin credentials:

   ::

     source /etc/platform/openrc

#. Load the stx-openstack application’s package into StarlingX. The tarball package contains stx-openstack’s Airship Armada manifest and stx-openstack’s set of helm charts. For example:

   ::

     system application-upload stx-sdo-<version>.tgz

#. Apply the stx-sdo application in order to bring SDO RV application into service. If your environment is preconfigured with a proxy server, then make sure HTTPS proxy is set before applying stx-sdo.

   ::

     system application-apply stx-sdo

#. Check the application status using below command:

   ::

     system application-show stx-sdo


After the application apply is success, you will see the RV service and redis
DB pods running. For example:

::

  [sysadmin@controller-0 ~(keystone_admin)]$ kubectl get pods -n kube-system
  NAME                         READY   STATUS    RESTARTS   AGE
  redis-6d76cdd759-wpnv7       1/1     Running   0          11d
  rv.deploy-6b9c4b8b65-chf2v   1/1     Running   0          11d

