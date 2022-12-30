.. _deploy-flexran-2107-on-starlingx-c4efa00b1b98:

=================================
Deploy FlexRAN 21.07 on StarlingX
=================================

.. contents::
   :local:
   :depth: 1

-----
Scope
-----

`FlexRAN <https://www.intel.com/content/www/us/en/developer/topic-technology/edge-5g/tools/flexran.html>`__
is a vRAN reference implementation for virtualized cloud-enabled radio access
networks. FlexRAN is not an open-source project. It is provided here as an
example of a 5G application running on |prod|.

This document provides details on how to build FlexRAN software for |prod|,
generate a containerized version of the prebuilt FlexRAN binaries, and deploy
on |prod| solution.

.. note::

    The steps in this guide are based on FlexRAN 21.07. The instructions are
    subject to change in future releases of FlexRAN.

-----------------
Intended Audience
-----------------

The intended audience for this document are software engineers and
system architects who want to design and develop 5G systems using the
O-RAN Specifications based on FlexRAN and |prod| OpenSource Edge
computing platform.

------------------------
AIO Simplex Installation
------------------------

*************************************************
Prepare USB stick with StarlingX Installation ISO
*************************************************

#. Get StarlingX Installation ISO from following location:

   http://mirror.starlingx.cengn.ca/mirror/starlingx/master/centos/latest_build/outputs/iso/bootimage.iso

#. Burn the image to a USB stick:

   .. note::

      Be sure to use the correct USB device name when copying the image.

   .. code::

       dd if=bootimage.iso of=/dev/sdc bs=1M

*****************************
Follow the installation guide
*****************************


In addition to the :ref:`aio_simplex_hardware_r7` for |prod|, you will need the
following hardware for FlexRAN applications.

+---------------------------+--------------------------------------------------------------------------------+
| Minimum Requirement       | All-in-one Controller Node                                                     |
+===========================+================================================================================+
| Minimum processor class   | Single-CPU Intel Xeon Cascade Lake (14 nm) or IceLake (10 nm)                  |
+---------------------------+--------------------------------------------------------------------------------+
| Minimum memory            | 64 GB single socket                                                            |
+---------------------------+--------------------------------------------------------------------------------+
| Minimum network ports     | OAM: 1x1GE, If only test timer mode, no other NIC required.                    |
+---------------------------+--------------------------------------------------------------------------------+
| BIOS settings             | - Hyper-Threading technology : Enabled                                         |
|                           | - Virtualization technology : Enabled                                          |
|                           | - VT for directed I/O : Enabled                                                |
|                           | - CPU Power and Performance Policy : Performance                               |
|                           | - CPU C state control : Enabled                                                |
|                           | - Plug & play BMC detection : Disabled                                         |
|                           | - Uncore Frequency Scaling : Disabled                                          |
|                           | - Performance P-limit : Disabled                                               |
|                           | - Enhanced Intel SpeedStep (R) Tech : Enabled                                  |
|                           | - Intel(R) Turbo Boost Technology : Enabled                                    |
+---------------------------+--------------------------------------------------------------------------------+
| Accelerator Card          | Mt. Bryce ACC100 (Intel eASIC chip which can be mounted on third party card)   |
+---------------------------+--------------------------------------------------------------------------------+

The FlexRAN application on |prod| has been tested on Intel Reference Hardware
platform: **Wilson City** (housing ICX-SP).

.. note::

    Some third-party platforms like SuperMicro / HPE / Dell / Quanta /
    and others can also be used depending on customer platform requirements,
    certain optimizations for low-latency and power savings mode by the
    platform vendors.

:ref:`aio_simplex_install_kubernetes_r7`:

#. In addition to required |prod| configuration, you must set up the Ceph
   backend for Kubernetes |PVC|, isolcpus and hugepages:

   .. code:: bash

       source /etc/platform/openrc

       NODE=controller-0
       OAM_IF=<OAM-PORT>

       # if you use flat oam network
       system host-if-modify ${NODE} $OAM_IF -c platform
       system interface-network-assign ${NODE} $OAM_IF oam

       # if you use vlan oam network
       VLANID=<VLAN-ID>
       system host-if-modify -n pltif -c platform $NODE $OAM_IF
       system host-if-add ${NODE} -V $VLANID -c platform oam0 vlan pltif
       system interface-network-assign ${NODE} oam0 oam

       system host-label-assign $NODE sriovdp=enabled
       system host-label-assign $NODE kube-topology-mgr-policy=restricted

       # Ceph backend for k8s pvc
       system storage-backend-add ceph --confirmed
       system host-disk-list ${NODE} | awk '/\/dev\/sdb/{print $2}' | xargs -i system host-stor-add ${NODE} {}

       # isolate cpus depends on number of the physical core
       system host-cpu-modify -f application-isolated -p0 28 controller-0

       # allocate/enable hugepages for DPDK usage
       system host-memory-modify $NODE -1G 10 0

       system host-unlock $NODE

#. After the system has been unlocked and available for the first time,
   configure ACC100/ACC200:

   .. code:: bash

       source /etc/platform/openrc

       system host-lock $NODE

       # get the device name of the Mount Bryce, we assume it is
       # pci_0000_85_00_0 here.
       system host-device-list controller-0

       # Modify the Mount Bryce device to enable it, specify the base driver
       # and vf driver, and configure it for 1 VFs

       # NOTE: If this is the initial install and have not unlocked, you will
       # get following error message.
       # Cannot configure device 73b13ddf-99be-44c8-8fbe-db85eb8d99ba until host
       # controller-0 is unlocked for the first time.
       system host-device-modify controller-0 pci_0000_85_00_0 --driver igb_uio --vf-driver vfio -N 1

       system host-unlock $NODE

------------------------------
FlexRAN Software Prerequisites
------------------------------

* FlexRAN 21.07 Release Package

  FlexRAN Software Wireless Access Solutions is available from the following page:
  https://www.intel.com/content/www/us/en/developer/topic-technology/edge-5g/tools/flexran.html

* FlexRAN |DPDK| BBDEV v21.07 Patch

  This patch file is also available in FlexRAN Software Wireless Access
  Solutions mentioned above.

* |DPDK| version 20.11.1

  |DPDK| version 20.11.1 is available in http://static.dpdk.org/rel/dpdk-20.11.1.tar.xz

* Intel C++ Compiler

  The Intel C++ Compiler is used to compile Intel |DPDK| and L1 software. The
  Intel C++ Compiler can be obtained using the following link:
  https://software.intel.com/en-us/system-studio/choose-download with community
  license.

  Recommended version of Compiler: **icc (ICC) 19.0.3.206 20190206**

-----------------------------
Build, Deploy and Run FlexRAN
-----------------------------

Generally speaking, the build and execution environments should not be the same.
To facilitate building, deploying, and running the process on |prod|, a
custom containerized build environment has been prepared and verified. Developers
can use the instructions to build the customized Docker image themselves or use
the prebuilt Docker image directly.

Using this method, developers can:

#. Start the build soon after |prod| is ready.
#. Use the scripts provided to generate a Docker image with pre-built
   FlexRAN binaries.
#. Launch the FlexRAN Pod using the image just generated.
#. Execute L1 test cases.

The following procedures provide detailed instructions for completing the stages
described above.

*************************
FlexRAN build preparation
*************************

For details, see:

https://www.intel.com/content/www/us/en/developer/topic-technology/edge-5g/tools/flexran.html

You can find build instructions in the Compilation Chapter of :title:`FlexRAN 5GNR Reference Solution 21.07`.

The following steps provide a quick-start procedure for developers.

#. Create a |PVC| for FlexRAN build storage:

   .. note::

       The |PVC| size should be larger than 70G.

   .. code:: bash

       cat >  volume-ceph.yaml << 'EOF'
       kind: PersistentVolumeClaim
       apiVersion: v1
       metadata:
         name: flexran-storage
       spec:
         accessModes:
           - ReadWriteOnce
         resources:
           requests:
             storage: 80Gi
         storageClassName: general
       EOF

       kubectl create -f volume-ceph.yaml

       kubectl create -f volume-ceph.yaml
       persistentvolumeclaim/flexran-storage created
       controller-0:~$ kubectl get pvc
       NAME              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
       flexran-storage   Bound    pvc-43e50806-785f-440b-8ed2-85bb3c9e8f79   80Gi       RWO            general        9s

#. Launch the `quick start building Pod <https://hub.docker.com/r/wrsnfv/flexran-builder>`__
   attaching to the |PVC|:

   .. note::

       This pod is assumed to be assigned enough resources to launch quickly
       after FlexRAN is built. If you don't have isolated CPU, hugepage and
       accelerator resources configured as part of the system used for
       building, feel free to remove related content from the yaml spec
       file. Hugepages-1Gi and intel.com/intel_acc100_fec are not required to
       perform the build.

   .. code:: bash

       cat >  flexran-buildpod.yml << 'EOF'
       apiVersion: v1
       kind: Pod
       metadata:
         name: buildpod
         annotations:
       spec:
         restartPolicy: Never
         containers:
         - name: buildpod
           image: wrsnfv/flexran-builder:21.07
           imagePullPolicy: IfNotPresent
           volumeMounts:
           - name: usrsrc
             mountPath: /usr/src
           - mountPath: /hugepages
             name: hugepage
           - name: lib-modules
             mountPath: /lib/modules
           - name: pvc1
             mountPath: /opt
           - name: docker-sock-volume
             mountPath: /var/run/docker.sock
           command: ["/bin/bash", "-ec", "sleep infinity"]
           securityContext:
             privileged: true
             capabilities:
               add:
                 ["IPC_LOCK", "SYS_ADMIN"]
           resources:
             requests:
               memory: 32Gi
               hugepages-1Gi: 10Gi
               intel.com/intel_acc100_fec: '1'
             limits:
               memory: 32Gi
               intel.com/intel_acc100_fec: '1'
               hugepages-1Gi: 10Gi
         volumes:
         - name: usrsrc
           hostPath:
             path: /usr/src
         - name: lib-modules
           hostPath:
             path: /lib/modules
         - name: hugepage
           emptyDir:
               medium: HugePages
         - name: docker-sock-volume
           hostPath:
             path: /var/run/docker.sock
             type: Socket
         - name: pvc1
           persistentVolumeClaim:
             claimName: flexran-storage
       EOF

       kubectl create -f flexran-buildpod.yml

#. (Optional) Instructions for FlexRAN building image creation:

   .. note::

       You can use the following instructions to build the default image or a
       customized version to meet your needs.

   .. code:: bash

       mkdir dockerbuilder && cd dockerbuilder

       # prepare the artifacts used for FlexRAN prebuilt binary Docker image
       mkdir docker-image-building
       cat >  docker-image-building/readme << 'EOF'
       # Instructions of Docker image generation

       # Following steps are supposed to be executed inside building Pod,
       # after building FlexRAN from source code

       flxr_install_dir=/opt/flexran/

       # populate flexran related env var
       cd ${flxr_install_dir}
       source set_env_var.sh -d

       # prepare the FlexRAN binaries
       ./transport.sh

       # build the Docker image
       docker build -t flr-run -f Dockerfile .

       # tag and push
       orgname=somename
       docker tag flr-run ${orgname}/flr-run

       EOF

       cat >  docker-image-building/transport.sh << 'EOF'
       #!/bin/bash

       # ICCPATH=/opt/intel/system_studio_2019/compilers_and_libraries_2019.5.281/linux

       echo "Make sure source set_env_var.sh -d first.(located in FlexRAN installation directory)"

       [[ -z "$MKLROOT" ]] && { echo "MKLROOT not set, exit..."; exit 1; }
       [[ -z "$DIR_WIRELESS_SDK_ROOT" ]] && { echo "DIR_WIRELESS_SDK_ROOT not set, exit..."; exit 1; }

       ICCPATH=`echo $MKLROOT | awk -F '/mkl' '{print $1}'`
       FLXPATH=`echo $DIR_WIRELESS_SDK_ROOT| awk -F '/sdk' '{print $1}'`

       [[ -d stuff ]] && { echo "Directory stuff exists, move it to old."; mv -f stuff stuff.old; }

       mkdir stuff; cd stuff

       mkdir libs
       cp $ICCPATH/mkl/lib/intel64_lin/libmkl_intel_lp64.so libs
       cp $ICCPATH/mkl/lib/intel64_lin/libmkl_core.so libs
       cp $ICCPATH/mkl/lib/intel64_lin/libmkl_intel_thread.so libs
       cp $ICCPATH/mkl/lib/intel64_lin/libmkl_avx512.so libs
       cp $ICCPATH/mkl/lib/intel64_lin/libmkl_avx2.so libs
       cp $ICCPATH/mkl/lib/intel64_lin/libmkl_avx.so libs
       cp $ICCPATH/ipp/lib/intel64/libipps.so libs
       cp $ICCPATH/ipp/lib/intel64/libippe.so libs
       cp $ICCPATH/ipp/lib/intel64/libippcore.so libs
       cp $ICCPATH/ipp/lib/intel64_lin/libippee9.so libs
       cp $ICCPATH/ipp/lib/intel64_lin/libippse9.so libs
       cp $ICCPATH/compiler/lib/intel64_lin/libiomp5.so libs
       cp $ICCPATH/compiler/lib/intel64_lin/libirc.so libs
       cp $ICCPATH/compiler/lib/intel64_lin/libimf.so libs
       cp $ICCPATH/compiler/lib/intel64_lin/libsvml.so libs
       cp $ICCPATH/compiler/lib/intel64_lin/libintlc.so.5 libs
       cp $ICCPATH/compiler/lib/intel64_lin/libirng.so libs

       cp $FLXPATH/libs/cpa/bin/libmmwcpadrv.so libs
       cp $FLXPATH/wls_mod/libwls.so libs

       mkdir -p flexran/sdk/build-avx512-icc/
       cp -rf $FLXPATH/sdk/build-avx512-icc/source flexran/sdk/build-avx512-icc/
       cp -rf $FLXPATH/sdk/build-avx512-icc/install flexran/sdk/build-avx512-icc/
       cp -rf $FLXPATH/bin flexran/
       cp -rf $FLXPATH/set_env_var.sh flexran/

       # testcase files
       mkdir -p tests/nr5g/
       cd tests/nr5g/
       for cfg in $FLXPATH/bin/nr5g/gnb/testmac/icelake-sp/*.cfg
       do
         cat $cfg | grep TEST_FD > /tmp/$$.testfile
         while IFS= read line
         do
           array=($(echo "$line" | sed 's/5GNR,/ /g'))
           for i in "${array[@]}"; do
             if [[ "$i" =* \.cfg ]]; then
               casedir=`echo "$i"| cut -d / -f 1-3 | xargs`
               caseabsdir=$FLXPATH/tests/nr5g/$casedir
               [[ ! -d $casedir ]] && { mkdir -p $casedir; cp -rf $caseabsdir/* $casedir; }
             fi
           done
         done < /tmp/$$.testfile
       done

       echo "Transportation Completed."
       EOF

       chmod a+x docker-image-building/transport.sh

       cat >  docker-image-building/set-l1-env.sh << 'EOF'
       # source this script to l1 binary location

       export WORKSPACE=/root/flexran
       export isa=avx512

       cd $WORKSPACE
       source ./set_env_var.sh -i ${isa}

       MODE=$1
       [[ -z "$MODE" ]] && read -p "Enter the MODE(LTE or 5G): " MODE

       if [ $MODE = LTE ]; then
         cd $WORKSPACE/bin/lte/l1/
       fi
       if [ $MODE = 5G ]; then
         cd $WORKSPACE/bin/nr5g/gnb/l1
       fi
       EOF

       cat >  docker-image-building/set-l2-env.sh << 'EOF'
       # source this script to l2 binary location

       export WORKSPACE=/root/flexran
       export isa=avx512

       cd $WORKSPACE
       source ./set_env_var.sh -i ${isa}

       MODE=$1
       [[ -z "$MODE" ]] && read -p "Enter the MODE(LTE or 5G): " MODE

       if [ $MODE = LTE ]; then
         cd $WORKSPACE/bin/lte/testmac/
       fi
       if [ $MODE = 5G ]; then
         cd $WORKSPACE/bin/nr5g/gnb/testmac
       fi
       EOF

       cat >  docker-image-building/res-setup.sh << 'EOF'
       #!/bin/bash

       [[ -z "$PCIDEVICE_INTEL_COM_INTEL_ACC100_FEC" ]] && { echo "ACC100 not used, sleep..."; sleep infinity; }

       sed -i 's#.*dpdkBasebandFecMode.*#        <dpdkBasebandFecMode\>1</dpdkBasebandFecMode>#' /root/flexran/bin/nr5g/gnb/l1/phycfg_timer.xml
       sed -i 's#.*dpdkBasebandDevice.*#        <dpdkBasebandDevice\>'"$PCIDEVICE_INTEL_COM_INTEL_ACC100_FEC"'</dpdkBasebandDevice>#' /root/flexran/bin/nr5g/gnb/l1/phycfg_timer.xml

       echo "Resource setup Completed, sleep..."
       sleep infinity
       EOF

       chmod a+x docker-image-building/res-setup.sh

       cat >  docker-image-building/Dockerfile << 'EOF'
       FROM centos:7.9.2009

       RUN [ -e /etc/yum.conf ] && sed -i '/tsflags=nodocs/d' /etc/yum.conf || true

       RUN yum install -y libhugetlbfs* libstdc++* numa* gcc g++ iproute \
                  module-init-tools kmod pciutils python libaio libaio-devel \
                  numactl-devel nettools ethtool
       RUN yum clean all

       COPY stuff/libs/* /usr/lib64/

       WORKDIR /root/
       COPY stuff/flexran ./flexran
       COPY stuff/tests ./flexran/tests
       COPY set-l1-env.sh ./
       COPY set-l2-env.sh ./
       COPY res-setup.sh ./

       CMD ["/root/res-setup.sh"]
       EOF

       cat >  Dockerfile << 'EOF'
       FROM centos:7.9.2009

       RUN [ -e /etc/yum.conf ] && sed -i '/tsflags=nodocs/d' /etc/yum.conf || true

       RUN yum groupinstall -y 'Development Tools'

       RUN yum install -y vim gcc-c++ libhugetlbfs* libstdc++* kernel-devel numa* gcc git mlocate \
                  cmake wget ncurses-devel hmaccalc zlib-devel binutils-devel elfutils-libelf-devel \
                  numactl-devel libhugetlbfs-devel bc patch git patch tar zip unzip python3 sudo docker
       RUN yum clean all

       RUN pip3 install meson && \
           pip3 install ninja pyelftools

       # ENV HTTP_PROXY=""
       # ENV HTTPS_PROXY=""

       WORKDIR /usr/src/
       RUN git clone https://github.com/pkgconf/pkgconf.git
       WORKDIR /usr/src/pkgconf
       RUN ./autogen.sh && ./configure && make && make install

       WORKDIR /usr/src/
       RUN git clone git://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git
       WORKDIR /usr/src/rt-tests
       RUN git checkout stable/v1.0
       RUN make all && make install

       COPY docker-image-building /root/docker-image-building

       WORKDIR /opt

       # Set default command
       CMD ["/usr/bin/bash"]
       EOF

       # build the Docker image for FlexRAN building environment
       orgname=somename
       docker build -t flexran-builder .
       docker tag flexran-builder ${orgname}/flexran-builder:21.07
       docker login
       docker push ${orgname}/flexran-builder:21.07

********************
Build FlexRAN in Pod
********************

#. Use a shell inside Pod to build FlexRAN:

   .. code:: bash

       kubectl exec -it buildpod -- bash

#. Use ``scp`` to copy the FlexRAN related files into the pod's |PVC|:

   .. code:: bash

       mkdir -p /opt/scrach && cd /opt/scrach
       scp <options> FlexRAN-21.07.tar.gz.part00 .
       scp <options> FlexRAN-21.07.tar.gz.part01 .
       scp <options> dpdk_21.07.patch .
       scp <options> system_studio_2019_update_5_ultimate_edition.tar.gz .

       cat FlexRAN-21.07.tar.gz.part00 FlexRAN-21.07.tar.gz.part01 > FlexRAN-21.07.tar.gz
       rm FlexRAN-21.07.tar.gz.part00
       rm FlexRAN-21.07.tar.gz.part01

#. Copy |DPDK| source code into the pod's |PVC|:

   .. code:: bash

       cd /opt && wget http://static.dpdk.org/rel/dpdk-20.11.1.tar.xz
       tar xf dpdk-20.11.1.tar.xz
       mv dpdk-stable-20.11.1 dpdk-flxr-21.07
       cd /opt/dpdk-flxr-21.07 && patch -p1 < /opt/scrach/dpdk_21.07.patch

#. Install Intel System Studio 2019 Update 5:

   .. code:: bash

       cd /opt/scrach

       tar zxvf system_studio_2019_update_5_ultimate_edition.tar.gz
       cd /opt/scrach/system_studio_2019_update_5_ultimate_edition

       # replace xxxx-xxxxxxxx with yours for ACTIVATION_SERIAL_NUMBER
       sed -i -r -e 's/^ACCEPT_EULA=.*/ACCEPT_EULA=accept/' -e 's/^ACTIVATION_TYPE=.*/ACTIVATION_TYPE=serial_number/' -e 's%^#?ACTIVATION_SERIAL_NUMBER=.*%ACTIVATION_SERIAL_NUMBER=xxxx-xxxxxxxx%' silent.cfg

       cd /opt/scrach/system_studio_2019_update_5_ultimate_edition && ./install.sh -s silent.cfg

#. Extract FlexRAN and populate the environment variables:

   .. code:: bash

       cd /opt/scrach/ && tar zxvf flexran-21.07.tar.gz && ./extract.sh
       # input '/opt/flexran' for Extract destination directory

       cd /opt/flexran && source ./set_env_var.sh -d
       # When following promote message shows:
       #     Enter Intel SystemStudio / ParallelStudio Install Directory for icc
       # input: /opt/intel/system_studio_2019/
       # When following promote message shows:
       #     Enter DPDK Install Directory, or just enter to set default
       # input: /opt/dpdk-flxr-21.07

#. Switch to devtoolset-8 environment:

   .. code:: bash

       yum install centos-release-scl
       yum install devtoolset-8
       scl enable devtoolset-8 bash

#. Build FlexRAN SDK:

   .. code:: bash

       cd /opt/flexran && ./flexran_build.sh -e -r 5gnr_sub6 -b -m sdk && ./flexran_build.sh -e -r 5gnr_mmw -b -m sdk

#. Build |DPDK| with the FlexRAN patch:

   .. code:: bash

       cd /opt/dpdk-flxr-21.07 && meson build
       cd /opt/dpdk-flxr-21.07/build && meson configure -Dflexran_sdk=/opt/flexran/sdk/build-avx512-icc/install && ninja

#. Build the FlexRAN applications:

   .. code:: bash

       cd /opt/flexran
       # Linux 5.6 deprecated ioremap_nocache, need to change to use ioremap_cache instead
       sed -i 's#ioremap_nocache#ioremap_cache#g' ./libs/cpa/mmw/rec/drv/src/nr_dev.c
       ./flexran_build.sh -e -r 5gnr_sub6 -b -n && ./flexran_build.sh -e -r 5gnr_mmw -b -n

#. (Optional) Build the test applications:

   .. code:: bash

       cd /opt/flexran && ./flexran_build.sh -e -r 5gnr_sub6 -b -m 5gnr_testmac

*******************************************
Generate Docker image with FlexRAN binaries
*******************************************

.. note::

    Since host path ``/var/run/docker.sock`` has been mounted into the building
    pod, you can build the Docker image using the FlexRAN binaries from the
    previous step inside the building pod. The artifacts used
    by :command:`docker build` have been integrated into the build image and
    are ready to use.

#. Prepare the env var for the script in ``/root/docker-image-building/transport.sh``:

   .. code:: bash

       cd /opt/flexran && source ./set_env_var.sh -d

#. Prepare binaries and scripts for Docker build:

   .. code:: bash

       cd /root/docker-image-building
       ./transport.sh

#. Build Docker image which will be saved in local host:

   .. code:: bash

       docker build -t flr-run -f Dockerfile .


*********************************
Run the FlexRAN Test cases in Pod
*********************************

After the build and Docker image generation steps above, you can launch the
FlexRAN execution pod from the host.

#. Push the Docker image to a registry, for example, `dockerhub.io <https://hub.docker.com/>`__:

   .. code:: bash

      docker login
      orgname=somename
      docker tag flr-run ${orgname}/flr-run:v1
      docker push ${orgname}/flr-run:v1

#. Launch the FlexRAN Pod.

   Adjust the CPU and memory for your configuration.
   Memory should be more than 32Gi for the test case pass rate.

   .. note::

       ``command`` should not be used in the spec, otherwise it will overwrite
       the default container command which does accelerator |PCI| address
       filling for L1.

   .. code:: bash

      cat > runpod-flxr.yml << 'EOF'
      apiVersion: v1
      kind: Pod
      metadata:
        name: runpod
        annotations:
      spec:
        restartPolicy: Never
        containers:
        - name: runpod
          image: somename/flr-run:v1
          imagePullPolicy: IfNotPresent
          volumeMounts:
          - name: usrsrc
            mountPath: /usr/src
          - mountPath: /hugepages
            name: hugepage
          - name: lib-modules
            mountPath: /lib/modules
          securityContext:
            privileged: true
            capabilities:
              add:
                ["IPC_LOCK", "SYS_ADMIN"]
          resources:
            requests:
              memory: 32Gi
              hugepages-1Gi: 8Gi
              intel.com/intel_acc100_fec: '1'
            limits:
              memory: 32Gi
              intel.com/intel_acc100_fec: '1'
              hugepages-1Gi: 8Gi
        volumes:
        - name: usrsrc
          hostPath:
            path: /usr/src
        - name: lib-modules
          hostPath:
            path: /lib/modules
        - name: hugepage
          emptyDir:
              medium: HugePages
      EOF

      kubectl create -f runpod-flxr.yml

#. Execute L1.

   #. Enter the L1 directory inside Pod:

      .. code:: bash

          kubectl exec -it runpod -- bash
          source set-l1-env.sh 5G


   #. Edit L1 configuration file:

      .. note::

          ``phycfg_timer.xml`` has been modified by entry script to use the FEC
          accelerator: ``<dpdkBasebandFecMode>1</dpdkBasebandFecMode>``
          ``<dpdkBasebandDevice>0000:8b:00.0</dpdkBasebandDevice>``

          This configuration is scripted and runs automatically, no manual
          configuration is needed. You can use :command:`printenv
          PCIDEVICE_INTEL_COM_INTEL_ACC100_FEC` to check dpdkBasebandDevice.

      .. code:: console

          # change default CPU binding in section of <Threads> in phycfg_timer.xml
          # use the first 3 assigned CPUs for the Applications threads

          <!-- CPU Binding to Application Threads -->
              <Threads>
                  <!-- System Threads (Single core id value): Core, priority, Policy [0: SCHED_FIFO 1: SCHED_RR] -->
                  <systemThread>2, 0, 0</systemThread>

                  <!-- Timer Thread (Single core id value): Core, priority, Policy [0: SCHED_FIFO 1: SCHED_RR] -->
                  <timerThread>3, 96, 0</timerThread>

                  <!-- FPGA for LDPC Thread (Single core id value): Core, priority, Policy [0: SCHED_FIFO 1: SCHED_RR] -->
                  <FpgaDriverCpuInfo>4, 96, 0</FpgaDriverCpuInfo>

                  <!-- FPGA for Front Haul (FFT / IFFT) Thread (Single core id value): Core, priority, Policy [0: SCHED_FIFO 1: SCHED_RR] -->
                  <!-- This thread should be created for timer mode and hence can be same core as LDPC polling core -->
                  <FrontHaulCpuInfo>4, 96, 0</FrontHaulCpuInfo>

                  <!-- DPDK Radio Master Thread (Single core id value): Core, priority, Policy [0: SCHED_FIFO 1: SCHED_RR] -->
                  <radioDpdkMaster>2, 99, 0</radioDpdkMaster>
              </Threads>


   #. Run L1 application:

      .. code:: bash

          # launch L1app
          ./l1.sh -e

#. Execute testmac after L1 is up and running in another terminal.

   #. Enter the testmac directory inside Pod:

      .. code:: bash

         kubectl exec -it runpod -- bash
         source set-l2-env.sh 5G

   #. Edit testmac configuration file:

      .. code:: console

         # Modify default CPU binding in section of <Threads> in testmac_cfg.xml
         # Make sure to use the CPU from the CPU whose ID is bigger than 13,
         # this way, the Application Threads will not overlap with the BBUPool CPUs.
         <!-- CPU Binding to Application Threads -->
             <Threads>
                 <!-- Wireless Subsystem Thread: Core, priority, Policy [0: SCHED_FIFO 1: SCHED_RR] -->
                 <wlsRxThread>16, 90, 0</wlsRxThread>

                 <!-- System Threads: Core, priority, Policy [0: SCHED_FIFO 1: SCHED_RR] -->
                 <systemThread>14, 0, 0</systemThread>

                 <!-- TestMac Run Thread: Core, priority, Policy [0: SCHED_FIFO 1: SCHED_RR] -->
                 <runThread>14, 89, 0</runThread>

                 <!-- Thread to send / receive URLLC APIS to / from testmac to Phy. It will be created only when the phy_config has URLLC Support added to it: Core, priority, Policy [0: SCHED_FIFO 1: SCHED_RR] -->
                 <urllcThread>15, 90, 0</urllcThread>
             </Threads>

         # workaround the known issue of parsing zero value in the config file
         sed -i '/>0</d' testmac_cfg.xml

   #. Run testmac application:

      .. code:: bash

         # launch testmac
         ./l2.sh --testfile=icelake-sp/icxsp_mu1_100mhz_mmimo_64x64_16stream_hton.cfg

         # Note, case of 3389 is the most stringent case, we can comment out
         # other cases in the file and run this case directly:
         # TEST_FD, 3389, 3, 5GNR, fd/mu1_100mhz/383/fd_testconfig_tst383.cfg,
         #                   5GNR, fd/mu1_100mhz/386/fd_testconfig_tst386.cfg,
         #                   5GNR, fd/mu1_100mhz/386/fd_testconfig_tst386.cfg

.. note::

    For detailed explanation of the XML configuration used by L1, refer to the
    FlexRAN documentation available at:
    https://www.intel.com/content/www/us/en/developer/topic-technology/edge-5g/tools/flexran.html
