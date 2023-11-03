==========================================
Move to new OpenStack version in StarlingX
==========================================

This section describes how to move from OpenStack Stein to OpenStack Train in
StarlingX.

.. contents::
   :local:
   :depth: 1

------------
Introduction
------------

When you apply the OpenStack application in StarlingX, the following OpenStack
services are launched in containers:

* stx-keystone
* stx-nova
* stx-neutron
* stx-horizon
* stx-placement
* stx-cinder
* stx-glance
* stx-aodh
* stx-ironic
* stx-barbican
* stx-heat

.. * stx-panko
.. * stx-ceilometer

Moving to a new OpenStack release in StarlingX applies updates to the already
installed OpenStack services. The examples in this section show the upgrade from
OpenStack Stein to OpenStack Train.

-------------------------------
OpenStack Train upgrade patches
-------------------------------

The following patches are included in the upgrade to OpenStack Train.

*************************
OpenStack service upgrade
*************************

#. https://review.opendev.org/#/q/topic:train_upgrade+(status:open+OR+status:merged)

#. https://review.opendev.org/#/c/683886/

*************************************************
OpenStack-helm & OpenStack-helm-infra RPM upgrade
*************************************************

#. https://review.opendev.org/#/c/687197/

#. https://review.opendev.org/#/c/683886/

#. https://review.opendev.org/#/c/683910/

.. note::

   There is no tag for this 2-project release. You will need to select the
   latest commit.

--------------------------
Upgrade to OpenStack Train
--------------------------

******************************
Update targeted branch/version
******************************

Update the targeted branch/version in the directives files for each project.

#. Update the
   ``cgcs-root/stx/upstream/openstack/python-nova/centos/stx-nova.dev_docker_image``
   file:

   ::

       BUILDER=loci
       LABEL=stx-nova
       PROJECT=nova
       PROJECT_REPO=https://opendev.org/openstack/nova.git
       PIP_PACKAGES="pycrypto httplib2 pylint python-ironicclient"
       DIST_PACKAGES="openssh-clients openssh-server libvirt e2fsprogs"
       PROFILES="fluent nova ceph linuxbridge openvswitch configdrive qemu apache"
       CUSTOMIZATION="yum install -y openssh-clients"

#. Update the
   ``cgcs-root/stx/upstream/openstack/python-nova/centos/stx-nova.stable_docker_image``
   file:

   ::

       BUILDER=loci
       LABEL=stx-nova
       PROJECT=nova
       PROJECT_REPO=https://opendev.org/openstack/nova.git
       PROJECT_REF=stable/train
       PIP_PACKAGES="pycrypto httplib2 pylint python-ironicclient"
       DIST_PACKAGES="openssh-clients openssh-server libvirt e2fsprogs"
       PROFILES="fluent nova ceph linuxbridge openvswitch configdrive qemu apache"
       CUSTOMIZATION="yum install -y openssh-clients"

*******************************************
Build wheels for specific OpenStack version
*******************************************

#. Change the release in ``${MY_REPO}//build-tools/build-wheels/build-wheel-tarball.sh``:

   ::

       CURRENT_STABLE_OPENSTACK=train

#. Use the following script to get specific version information for dependent packages:

   ::

       https://raw.githubusercontent.com/openstack/requirements/stable/train/upper-constraints.txt

#. Update the ``build-tools/build-wheels/docker/stable-wheels.cfg`` file with
   the related entries, as shown below:

   ::

       django_floppyforms-1.7.0-py2.py3-none-any.whl|tar|https://files.pythonhosted.org/packages/8c/18/30a9137c7ae279a27ccdeb10f6fe8be18ee98551d01ec030b6cfe8b2d2e2/django-floppyforms-1.7.0.tar.gz|django-floppyforms-1.7.0
       cmd2-0.8.9-py2.py3-none-any.whl|pypi|https://files.pythonhosted.org/packages/e9/40/a71caa2aaff10c73612a7106e2d35f693e85b8cf6e37ab0774274bca3cf9/cmd2-0.8.9-py2.py3-none-any.whl
       pyngus-2.3.0-py2-none-any.whl|zip|https://files.pythonhosted.org/packages/58/b1/336b8f64e7e4efa9b95027af71e02cd4cfacca8f919345badb852381878a/pyngus-2.3.0.zip|pyngus-2.3.0

#. Build wheels with the following command:

   ::

       export OS=centos
       export BUILD_STREAM=stable
       export MY_REPO=/home/wrsroot/starlingx/workspace/localdisk/designer/wrsroot/starlingx/cgcs-root/
       export MY_WORKSPACE=/home/wrsroot/starlingx/workspace/localdisk/loadbuild/wrsroot/starlingx/
       ${MY_REPO}//build-tools/build-wheels/build-wheel-tarball.sh \
       --os ${OS} \
       --stream ${BUILD_STREAM}

*********************************
Build Docker images for OpenStack
*********************************

#. Build Docker images with the following command:

   ::

       export OS=centos
       export BUILD_STREAM=stable
       export MY_REPO=/home/wrsroot/starlingx/workspace/localdisk/designer/wrsroot/starlingx/cgcs-root/
       export MY_WORKSPACE=/home/wrsroot/starlingx/workspace/localdisk/loadbuild/wrsroot/starlingx/
       export BRANCH=master
       export CENTOS_BASE=starlingx/stx-centos:${BRANCH}-${BUILD_STREAM}-latest
       export WHEELS=https://mirror.starlingx.windriver.com/mirror/starlingx/master/centos/latest_docker_image_build/outputs/wheels/stx-centos-stable-wheels.tar
       time $MY_REPO/build-tools/build-docker-images/build-stx-images.sh \
       --os centos \
       --stream ${BUILD_STREAM} \
       --base ${CENTOS_BASE} \
       --wheels ${WHEELS} \
       --latest \
       --only  $1    //stx-nova,stx-horizon

For additional information on building Docker images, refer to the
`StarlingX wiki entry for Building Images <https://wiki.openstack.org/wiki/StarlingX/Containers/BuildingImages>`_

*************************************
Tag and push image to Docker registry
*************************************

First tag and push your new image to docker.io. Then tag and push to your local
registry for verification. For example:

::

    docker images
    root/stx-horizon         dev-centos-stable-build    ccce6df31a58   30 minutes ago      868MB
    docker tag ccce6df31a58  username/stx-horizon:dev-centos-stable-train
    docker push username/stx-heat:dev-centos-stable-train    // push to docker.io

********************
Update manifest.yaml
********************

You will need to update the ``manifest.yaml`` file for the OpenStack upgrade.

The exact updates needed are determined on a case-by-case basis.

Please refer to this patch: https://review.opendev.org/#/c/684166

**************
Test and debug
**************

Here are some tips for testing and debugging your upgrade:

#. Refer to the
   `StarlingX wiki entry for general container and debugging info <https://wiki.openstack.org/wiki/StarlingX/Containers/FAQ>`_.

#. You will need to create a test patch to perform pre-merge verification of your
   test image. For example: https://review.opendev.org/#/c/688025

#. Use `system application management <sys_app_management>`_ commands to manage
   the application. For example:

   .. parsed-literal::

          system application-upload -n |prefix|-openstack |prefix|-openstack-1.0-16.tgz
          system application-apply |prefix|-openstack
          system application-remove |prefix|-openstack
          system application-delete |prefix|-openstack
          watch -n 5 system application-list

#. Use kubectl commands for log analysis. For example:

   .. parsed-literal::

          tail -f /var/log/sysinv.log
          kubectl -n openstack get po
          kubectl -n openstack logs nova-compute-compute-0-75ea0372-nmtz2
          kubectl -n openstack exec -it nova-compute-compute-0-31b0f4b3-2rqgf -- bash
          kubectl -n openstack describe pod nova-compute-compute-0-31b0f4b3-2rqgf
          kubectl -n openstack get pod nova-compute-compute-0-31b0f4b3-2rqgf -o yaml
          /var/log/container/\*.log  //To see related pod logs for issue debug

