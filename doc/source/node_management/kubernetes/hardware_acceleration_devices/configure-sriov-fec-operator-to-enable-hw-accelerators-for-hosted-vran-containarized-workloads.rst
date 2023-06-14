.. _configure-sriov-fec-operator-to-enable-hw-accelerators-for-hosted-vran-containarized-workloads:

===================================================================
Configure Intel Wireless FEC Accelerators using SR-IOV FEC operator
===================================================================

This section provides the instructions for installing the |SRIOV| |FEC|
operator that provides detailed configurability of Wireless |FEC| Accelerators
on |prod-long| (|AIO-SX|).

.. rubric:: |context|

The |SRIOV| |FEC| Operator for Intel Wireless |FEC| Accelerators supports the
following |vRAN| |FEC| accelerators:

-   Intel® vRAN Dedicated Accelerator ACC100.

-   Intel® |FPGA| Programmable Acceleration Card N3000.

-   Intel® vRAN Dedicated Accelerator ACC200.

.. rubric:: |prereq|

-   The system has been provisioned and unlocked.

.. rubric:: |proc|

#.  Source the platform environment.

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)$

#.  Upload and Apply the |SRIOV| |FEC| Operator.

    .. code-block:: none

        ~(keystone_admin)$ system application-upload /usr/local/share/applications/helm/sriov-fec-operator-<version>.tgz
        +---------------+-------------------------------------+
        | Property      | Value                               |
        +---------------+-------------------------------------+
        | active        | False                               |
        | app_version   | 1.0-1                               |
        | created_at    | 2022-09-29T19:47:29.427225+00:00    |
        | manifest_file | fluxcd-manifests                    |
        | manifest_name | sriov-fec-operator-fluxcd-manifests |
        | name          | sriov-fec-operator                  |
        | progress      | None                                |
        | status        | uploading                           |
        | updated_at    | None                                |
        +---------------+-------------------------------------+

    .. code-block:: none

        ~(keystone_admin)$ system application-apply sriov-fec-operator
        +---------------+-------------------------------------+
        | Property      | Value                               |
        +---------------+-------------------------------------+
        | active        | False                               |
        | app_version   | 1.0-1                               |
        | created_at    | 2022-09-29T19:47:29.427225+00:00    |
        | manifest_file | fluxcd-manifests                    |
        | manifest_name | sriov-fec-operator-fluxcd-manifests |
        | name          | sriov-fec-operator                  |
        | progress      | None                                |
        | status        | applying                            |
        | updated_at    | 2022-09-29T19:47:33.599867+00:00    |
        +---------------+-------------------------------------+

    .. code-block:: none

        ~(keystone_admin)$ system application-show sriov-fec-operator
        +---------------+-------------------------------------+
        | Property      | Value                               |
        +---------------+-------------------------------------+
        | active        | True                                |
        | app_version   | 1.0-1                               |
        | created_at    | 2022-09-29T19:47:29.427225+00:00    |
        | manifest_file | fluxcd-manifests                    |
        | manifest_name | sriov-fec-operator-fluxcd-manifests |
        | name          | sriov-fec-operator                  |
        | progress      | completed                           |
        | status        | applied                             |
        | updated_at    | 2022-09-29T19:50:27.543655+00:00    |
        +---------------+-------------------------------------+

#.  Verify that all the operator pods are up and running.

    .. code-block:: none

        $ kubectl get pods -n sriov-fec-system
        NAME                                            READY   STATUS    RESTARTS        AGE
        accelerator-discovery-svh87                     1/1     Running   0               3m26s
        sriov-device-plugin-j54hh                       1/1     Running   0               3m26s
        sriov-fec-controller-manager-77bb5b778b-bjmr8   2/2     Running   0               3m28s
        sriov-fec-controller-manager-77bb5b778b-wpfld   2/2     Running   1 (3m26s ago)   3m28s
        sriov-fec-daemonset-stnjh                       1/1     Running   0               3m26s

#.  List all the nodes in the cluster with |FEC| accelerators installed.

    .. code-block:: none

        $ kubectl get sriovfecnodeconfigs.sriovfec.intel.com -n sriov-fec-system
        NAME           CONFIGURED
        controller-0   NotRequested

#.  Find the |PCI| address of the |PF| of |SRIOV| |FEC| accelerator device to
    be configured.

    -   ACC100

        .. code-block:: none

            $ kubectl get sriovfecnodeconfigs.sriovfec.intel.com -n sriov-fec-system controller-0 -o yaml
            apiVersion: sriovfec.intel.com/v2
            kind: SriovFecNodeConfig
            metadata:
              creationTimestamp: "2022-08-25T01:33:35Z"
              generation: 1
              name: controller-0
              namespace: sriov-fec-system
              resourceVersion: "8298897"
              selfLink: /apis/sriovfec.intel.com/v2/namespaces/sriov-fec-system/sriovfecnodeconfigs/controller-0
              uid: dcab90d9-2fe2-4769-81b0-fdd54e96e287
            spec:
              physicalFunctions: []
            status:
              conditions:
              - lastTransitionTime: "2022-08-25T01:33:35Z"
                  message: ""
                  observedGeneration: 1
                  reason: NotRequested
                  status: "False"
                  type: Configured
              inventory:
                sriovAccelerators:
                - deviceID: 0d5c
                  driver: ""
                  maxVirtualFunctions: 16
                  pciAddress: "0000:17:00.0"
                  vendorID: "8086"
                  virtualFunctions: []

    -   N3000

        .. code-block:: none

            $ kubectl get sriovfecnodeconfigs.sriovfec.intel.com -n sriov-fec-system controller-0 -o yaml
            apiVersion: sriovfec.intel.com/v2
            kind: SriovFecNodeConfig
            metadata:
              creationTimestamp: "2022-10-21T18:17:55Z"
              generation: 1
              name: controller-0
              namespace: sriov-fec-system
              resourceVersion: "1996828"
              selfLink: /apis/sriovfec.intel.com/v2/namespaces/sriov-fec-system/sriovfecnodeconfigs/controller-0
              uid: 05db8606-8236-4efd-99bb-7b5ca20cd02e
            spec:
              physicalFunctions: []
            status:
              conditions:
              - lastTransitionTime: "2022-10-21T18:17:55Z"
                message: ""
                observedGeneration: 1
                reason: NotRequested
                status: "False"
                type: Configured
              inventory:
                sriovAccelerators:
                - deviceID: 0d8f
                  driver: ""
                  maxVirtualFunctions: 8
                  pciAddress: 0000:1c:00.0
                  vendorID: "8086"
                  virtualFunctions: []

    -   ACC200

        .. code-block:: none

            $ kubectl get sriovfecnodeconfigs.sriovfec.intel.com -n sriov-fec-system controller-0 -o yaml
            apiVersion: sriovfec.intel.com/v2
            kind: SriovFecNodeConfig
            metadata:
              creationTimestamp: "2022-10-21T18:31:41Z"
              generation: 1
              name: controller-0
              namespace: sriov-fec-system
              resourceVersion: "2144487"
              selfLink: /apis/sriovfec.intel.com/v2/namespaces/sriov-fec-system/sriovfecnodeconfigs/controller-0
              uid: e4e536fc-a777-4e26-974d-71226d43c4ed
            spec:
              physicalFunctions: []
            status:
              conditions:
              - lastTransitionTime: "2022-10-21T18:31:41Z"
                message: ""
                observedGeneration: 1
                reason: NotRequested
                status: "False"
                type: Configured
              inventory:
                sriovAccelerators:
                - deviceID: 57c0
                  driver: ""
                  maxVirtualFunctions: 16
                  pciAddress: 0000:f7:00.0
                  vendorID: "8086"
                  virtualFunctions: []

#.  Apply the |FEC| device configuration.

    #.  ACC100 device configuration.

        - The maximum number of |VFs| that can be configured for ACC100 is
          16 |VFs|.

        - There are 8 queue groups available which can be allocated to any
          available operation (4GUL/4GDL/5GUL/5GDL) based on the
          ``numQueueGroups`` parameter.

        - The product of ``numQueueGroups`` x ``numAqsPerGroups`` x
          ``aqDepthLog2`` x ``numVfBundles`` must be less than 32K.

        - The following example creates 1 |VF|, configures ACC100's 8 queue
          groups; allocating 4 queue groups for 5G Uplink and another 4
          queue groups for 5G Downlink.

          .. code-block:: none

              apiVersion: sriovfec.intel.com/v2
              kind: SriovFecClusterConfig
              metadata:
                name: config
                namespace: sriov-fec-system
              spec:
                priority: 1
                nodeSelector:
                  kubernetes.io/hostname: controller-0
                acceleratorSelector:
                  pciAddress: 0000:17:00.0
                physicalFunction:
                  pfDriver: "pci-pf-stub"
                  vfDriver: "vfio-pci"
                  vfAmount: 1
                  bbDevConfig:
                    acc100:
                      # pfMode: false = VF Programming, true = PF Programming
                      pfMode: false
                      numVfBundles: 1
                      maxQueueSize: 1024
                      uplink4G:
                        numQueueGroups: 0
                        numAqsPerGroups: 16
                        aqDepthLog2: 4
                      downlink4G:
                        numQueueGroups: 0
                        numAqsPerGroups: 16
                        aqDepthLog2: 4
                      uplink5G:
                        numQueueGroups: 4
                        numAqsPerGroups: 16
                        aqDepthLog2: 4
                      downlink5G:
                        numQueueGroups: 4
                        numAqsPerGroups: 16
                        aqDepthLog2: 4
                drainSkip: true

        - The following example creates 2 |VFs|, configures ACC100's 8 queue
          groups; allocating 2 queue groups each for 4G Uplink, 4G downlink,
          5G Uplink and 5G downlink.

          .. code-block:: none

              apiVersion: sriovfec.intel.com/v2
              kind: SriovFecClusterConfig
              metadata:
                name: config
                namespace: sriov-fec-system
              spec:
                priority: 1
                nodeSelector:
                  kubernetes.io/hostname: controller-0
                acceleratorSelector:
                  pciAddress: 0000:17:00.0
                physicalFunction:
                  pfDriver: "pci-pf-stub"
                  vfDriver: "vfio-pci"
                  vfAmount: 2
                  bbDevConfig:
                    acc100:
                      # pfMode: false = VF Programming, true = PF Programming
                      pfMode: false
                      numVfBundles: 2
                      maxQueueSize: 1024
                      uplink4G:
                        numQueueGroups: 2
                        numAqsPerGroups: 16
                        aqDepthLog2: 4
                      downlink4G:
                        numQueueGroups: 2
                        numAqsPerGroups: 16
                        aqDepthLog2: 4
                      uplink5G:
                        numQueueGroups: 2
                        numAqsPerGroups: 16
                        aqDepthLog2: 4
                      downlink5G:
                        numQueueGroups: 2
                        numAqsPerGroups: 16
                        aqDepthLog2: 4
                drainSkip: true

    #.  N3000 device configuration.

        - The maximum number of |VFs| that can be configured for N3000 is 8
          |VFs|.

        - The maximum number of queues that can be mapped to each VF for uplink
          or downlink is 32.

        - The following configuration for N3000 creates 1 |VF| with 32
          queues each for 5G uplink and 5G downlink.

          .. code-block:: none

              apiVersion: sriovfec.intel.com/v2
              kind: SriovFecClusterConfig
              metadata:
                name: config
                namespace: sriov-fec-system
              spec:
                priority: 1
                nodeSelector:
                  kubernetes.io/hostname: controller-0
                acceleratorSelector:
                  pciAddress: 0000:1c:00.0
                physicalFunction:
                  pfDriver: pci-pf-stub
                  vfDriver: vfio-pci
                  vfAmount: 1
                  bbDevConfig:
                    n3000:
                      # Network Type: either "FPGA_5GNR" or "FPGA_LTE"
                      networkType: "FPGA_5GNR"
                      # Pf mode: false = VF Programming, true = PF Programming
                      pfMode: false
                      flrTimeout: 610
                      downlink:
                        bandwidth: 3
                        loadBalance: 128
                        queues:
                          vf0: 32
                          vf1: 0
                          vf2: 0
                          vf3: 0
                          vf4: 0
                          vf5: 0
                          vf6: 0
                          vf7: 0
                      uplink:
                        bandwidth: 3
                        loadBalance: 128
                        queues:
                          vf0: 32
                          vf1: 0
                          vf2: 0
                          vf3: 0
                          vf4: 0
                          vf5: 0
                          vf6: 0
                          vf7: 0
                drainSkip: true

        - The following configuration for N3000 creates 2 |VFs| with 16
          queues each, mapping 32 queues with 2 |VFs| for 5G uplink and
          another 32 queues with 2 |VFs| for 5G downlink.

          .. code-block:: none

              apiVersion: sriovfec.intel.com/v2
              kind: SriovFecClusterConfig
              metadata:
                name: config
                namespace: sriov-fec-system
              spec:
                priority: 1
                nodeSelector:
                  kubernetes.io/hostname: controller-0
                acceleratorSelector:
                  pciAddress: 0000:1c:00.0
                physicalFunction:
                  pfDriver: pci-pf-stub
                  vfDriver: vfio-pci
                  vfAmount: 2
                  bbDevConfig:
                    n3000:
                      # Network Type: either "FPGA_5GNR" or "FPGA_LTE"
                      networkType: "FPGA_5GNR"
                      # Pf mode: false = VF Programming, true = PF Programming
                      pfMode: false
                      flrTimeout: 610
                      downlink:
                        bandwidth: 3
                        loadBalance: 128
                        queues:
                          vf0: 16
                          vf1: 16
                          vf2: 0
                          vf3: 0
                          vf4: 0
                          vf5: 0
                          vf6: 0
                          vf7: 0
                      uplink:
                        bandwidth: 3
                        loadBalance: 128
                        queues:
                          vf0: 16
                          vf1: 16
                          vf2: 0
                          vf3: 0
                          vf4: 0
                          vf5: 0
                          vf6: 0
                          vf7: 0
                drainSkip: true

    #.  ACC200 device configuration.

        -   The maximum number of |VFs| that can be configured for ACC200
            is 16 |VFs|.

        -   There are 16 queue groups available which can be allocated to any
            available operation (4GUL/4GDL/5GUL/5GDL) based on the
            ``numQueueGroups`` parameter.

        -   The product of ``numQueueGroups`` x ``numAqsPerGroups`` x
            ``aqDepthLog2`` x ``numVfBundles`` must be less than 64K.

        -   The following configuration creates 1 |VF|, configures ACC200's 12
            queue groups; allocating 16 queues per |VF| for 5G processing
            engine functions(5GUL/5GDL/FFT).

            .. code-block:: none

                apiVersion: sriovfec.intel.com/v2
                kind: SriovFecClusterConfig
                metadata:
                  name: config
                  namespace: sriov-fec-system
                spec:
                  priority: 1
                  nodeSelector:
                    kubernetes.io/hostname: controller-0
                  acceleratorSelector:
                    pciAddress: 0000:f7:00.0
                  physicalFunction:
                    pfDriver: pci-pf-stub
                    vfDriver: vfio-pci
                    vfAmount: 1
                    bbDevConfig:
                      acc200:
                        # Pf mode: false = VF Programming, true = PF Programming
                        pfMode: false
                        numVfBundles: 1
                        maxQueueSize: 1024
                        uplink4G:
                          numQueueGroups: 0
                          numAqsPerGroups: 16
                          aqDepthLog2: 4
                        downlink4G:
                          numQueueGroups: 0
                          numAqsPerGroups: 16
                          aqDepthLog2: 4
                        uplink5G:
                          numQueueGroups: 4
                          numAqsPerGroups: 16
                          aqDepthLog2: 4
                        downlink5G:
                          numQueueGroups: 4
                          numAqsPerGroups: 16
                          aqDepthLog2: 4
                        qfft:
                          numQueueGroups: 4
                          numAqsPerGroups: 16
                          aqDepthLog2: 4
                  drainSkip: true

        -   The following configuration creates 2 |VF|, configures ACC200's 16
            queue groups; allocating 16 queues per |VF| for 4G and 5G
            processing engine functions(4GUL/4GDL/5GUL/5GDL/FFT).

            .. code-block:: none

                apiVersion: sriovfec.intel.com/v2
                kind: SriovFecClusterConfig
                metadata:
                  name: config
                  namespace: sriov-fec-system
                spec:
                  priority: 1
                  nodeSelector:
                    kubernetes.io/hostname: controller-0
                  acceleratorSelector:
                    pciAddress: 0000:f7:00.0
                  physicalFunction:
                    pfDriver: pci-pf-stub
                    vfDriver: vfio-pci
                    vfAmount: 2
                    bbDevConfig:
                      acc200:
                        # Pf mode: false = VF Programming, true = PF Programming
                        pfMode: false
                        numVfBundles: 2
                        maxQueueSize: 1024
                        uplink4G:
                          numQueueGroups: 2
                          numAqsPerGroups: 16
                          aqDepthLog2: 4
                        downlink4G:
                          numQueueGroups: 2
                          numAqsPerGroups: 16
                          aqDepthLog2: 4
                        uplink5G:
                          numQueueGroups: 4
                          numAqsPerGroups: 16
                          aqDepthLog2: 4
                        downlink5G:
                          numQueueGroups: 4
                          numAqsPerGroups: 16
                          aqDepthLog2: 4
                        qfft:
                          numQueueGroups: 4
                          numAqsPerGroups: 16
                          aqDepthLog2: 4
                  drainSkip: true



    #.  If you need to run the operator on a |prod-long| (|AIO-SX|), then you
        should provide ``SriovFecClusterConfig`` with ``spec.drainSkip: True``
        to avoid node draining, because it is impossible to drain a node if
        there is only one node.

    #.  Create and apply a ``SriovFecClusterConfig`` custom resource using
        the above examples as templates, setting the parameters
        ``nodeSelector:kubernetes.io/hostname`` and
        ``acceleratorSelector:pciAddress`` to select the desired device and
        configuring ``vfAmount`` and ``numVfBundles`` as desired.

        .. code-block:: none

            $ kubectl apply -f <sriov-fec-config-file-name>.yaml
            sriovfecclusterconfig.sriovfec.intel.com/config created

        .. note::

            The ``vfAmount`` and ``numVfBundles`` in ``SriovFecClusterConfig``
            must be always equal for ACC100/ACC200.

#.  Verify that the |FEC| configuration is applied.

    -   An example of ACC100 status after applying 1 |VF| configuration.

        .. code-block:: none

            $ kubectl get sriovfecnodeconfigs.sriovfec.intel.com -n sriov-fec-system controller-0 -o yaml
            apiVersion: sriovfec.intel.com/v2
            kind: SriovFecNodeConfig
            metadata:
              creationTimestamp: "2022-09-29T19:49:59Z"
              generation: 2
              name: controller-0
              namespace: sriov-fec-system
              resourceVersion: "2935834"
              selfLink: /apis/sriovfec.intel.com/v2/namespaces/sriov-fec-system/sriovfecnodeconfigs/controller-0
              uid: 1a39b2a6-7512-4f44-8a64-083df7e480f3
            spec:
              physicalFunctions:
              - bbDevConfig:
                  acc100:
                    downlink4G:
                      aqDepthLog2: 4
                      numAqsPerGroups: 16
                      numQueueGroups: 0
                    downlink5G:
                      aqDepthLog2: 4
                      numAqsPerGroups: 16
                      numQueueGroups: 4
                    maxQueueSize: 1024
                    numVfBundles: 1
                    pfMode: false
                    uplink4G:
                      aqDepthLog2: 4
                      numAqsPerGroups: 16
                      numQueueGroups: 0
                    uplink5G:
                      aqDepthLog2: 4
                      numAqsPerGroups: 16
                      numQueueGroups: 4
                pciAddress: "0000:17:00.0"
                pfDriver: pci-pf-stub
                vfAmount: 1
                vfDriver: vfio-pci
            status:
              conditions:
              - lastTransitionTime: "2022-09-29T20:33:13Z"
                message: Configured successfully
                observedGeneration: 2
                reason: Succeeded
                status: "True"
                type: Configured
              inventory:
                sriovAccelerators:
                - deviceID: 0d5c
                  driver: pci-pf-stub
                  maxVirtualFunctions: 16
                  pciAddress: "0000:17:00.0"
                  vendorID: "8086"
                  virtualFunctions:
                  - deviceID: 0d5d
                    driver: vfio-pci
                    pciAddress: "0000:18:00.0"

    -   An example of N3000 status after applying 2 |VFs| configuration.

        .. code-block:: none

            $ kubectl get sriovfecnodeconfigs.sriovfec.intel.com -n sriov-fec-system controller-0 -o yaml
            apiVersion: sriovfec.intel.com/v2
            kind: SriovFecNodeConfig
            metadata:
              creationTimestamp: "2022-10-21T18:17:55Z"
              generation: 2
              name: controller-0
              namespace: sriov-fec-system
              resourceVersion: "2011601"
              selfLink: /apis/sriovfec.intel.com/v2/namespaces/sriov-fec-system/sriovfecnodeconfigs/controller-0
              uid: 05db8606-8236-4efd-99bb-7b5ca20cd02e
            spec:
              drainSkip: true
              physicalFunctions:
              - bbDevConfig:
                  n3000:
                    downlink:
                      bandwidth: 3
                      loadBalance: 128
                      queues:
                        vf0: 16
                        vf1: 16
                        vf2: 0
                        vf3: 0
                        vf4: 0
                        vf5: 0
                        vf6: 0
                        vf7: 0
                    flrTimeout: 610
                    networkType: FPGA_5GNR
                    uplink:
                      bandwidth: 3
                      loadBalance: 128
                      queues:
                        vf0: 16
                        vf1: 16
                        vf2: 0
                        vf3: 0
                        vf4: 0
                        vf5: 0
                        vf6: 0
                        vf7: 0
                pciAddress: 0000:1c:00.0
                pfDriver: pci-pf-stub
                vfAmount: 2
                vfDriver: vfio-pci
            status:
              conditions:
              - lastTransitionTime: "2022-10-21T19:35:18Z"
                message: Configured successfully
                observedGeneration: 2
                reason: Succeeded
                status: "True"
                type: Configured
              inventory:
                sriovAccelerators:
                - deviceID: 0d8f
                  driver: pci-pf-stub
                  maxVirtualFunctions: 8
                  pciAddress: 0000:1c:00.0
                  vendorID: "8086"
                  virtualFunctions:
                  - deviceID: 0d90
                    driver: vfio-pci
                    pciAddress: 0000:1c:00.1
                  - deviceID: 0d90
                    driver: vfio-pci
                    pciAddress: 0000:1c:00.2

    -   An example of ACC200 status after applying 1 |VF| configuration.

        .. code-block:: none

            $ kubectl get sriovfecnodeconfigs.sriovfec.intel.com -n sriov-fec-system controller-0 -o yaml
            apiVersion: sriovfec.intel.com/v2
            kind: SriovFecNodeConfig
            metadata:
              creationTimestamp: "2022-10-21T18:31:41Z"
              generation: 3
              name: controller-0
              namespace: sriov-fec-system
              resourceVersion: "2159562"
              selfLink: /apis/sriovfec.intel.com/v2/namespaces/sriov-fec-system/sriovfecnodeconfigs/controller-0
              uid: e4e536fc-a777-4e26-974d-71226d43c4ed
            spec:
              drainSkip: true
              physicalFunctions:
              - bbDevConfig:
                  acc200:
                    downlink4G:
                      aqDepthLog2: 4
                      numAqsPerGroups: 16
                      numQueueGroups: 2
                    downlink5G:
                      aqDepthLog2: 4
                      numAqsPerGroups: 16
                      numQueueGroups: 4
                    maxQueueSize: 1024
                    numVfBundles: 1
                    qfft:
                      aqDepthLog2: 4
                      numAqsPerGroups: 16
                      numQueueGroups: 4
                    uplink4G:
                      aqDepthLog2: 4
                      numAqsPerGroups: 16
                      numQueueGroups: 2
                    uplink5G:
                      aqDepthLog2: 4
                      numAqsPerGroups: 16
                      numQueueGroups: 4
                pciAddress: 0000:f7:00.0
                pfDriver: pci-pf-stub
                vfAmount: 1
                vfDriver: vfio-pci
            status:
              conditions:
              - lastTransitionTime: "2022-10-21T19:48:26Z"
                message: Configured successfully
                observedGeneration: 3
                reason: Succeeded
                status: "True"
                type: Configured
              inventory:
                sriovAccelerators:
                - deviceID: 57c0
                  driver: pci-pf-stub
                  maxVirtualFunctions: 16
                  pciAddress: 0000:f7:00.0
                  vendorID: "8086"
                  virtualFunctions:
                  - deviceID: 57c1
                    driver: vfio-pci
                    pciAddress: 0000:f7:00.1

#.  Modify |FEC| Cluster config.

    #.  To further modify |FEC| device configuration, make desired
        modifications to the sriov-fec custom resource file and re-apply.

        .. code-block:: none

            $ kubectl apply -f <sriov-fec-config-file-name>.yaml
            sriovfecclusterconfig.sriovfec.intel.com/config configured

#.  Delete ``SriovFecClusterConfig``.

    .. code-block:: none

        $ kubectl delete -f <sriov-fec-config-file-name>.yaml
        sriovfecclusterconfig.sriovfec.intel.com "config" deleted

#.  Configure |VFIO| for |PF| interface.

    |SRIOV| |FEC| operator also supports ``vfio-pci`` driver for |PF|
    interface. The |VFIO| mode requires that the ``vfio-pci`` driver be loaded
    with the arguments ``enable_sriov=1`` and ``disable_idle_d3=1``.

    If the ``vfio-pci`` driver is used to bind the |PF| interface, then a UUID
    token must be configured as a ``VFIO_TOKEN`` to both |PF| and |VF|
    interfaces.

    -   For the |PF| interface, the ``VFIO_TOKEN`` is configured by |SRIOV|
        |FEC| operator and has the default value of
        ``02bddbbf-bbb0-4d79-886b-91bad3fbb510``

    -   The ``VFIO_TOKEN`` could be changed by setting
        ``SRIOV_FEC_VFIO_TOKEN`` before application Apply with
        :command: `system helm-override-update`.

    -   This example sets the ``SRIOV_FEC_VFIO_TOKEN`` using ``uuidgen``.

        .. code-block:: none

            ~(keystone_admin)$ system helm-override-update sriov-fec-operator sriov-fec-operator sriov-fec-system --set env.SRIOV_FEC_VFIO_TOKEN=`uuidgen`

    -   For the |VF| interface, the same ``VFIO_TOKEN`` must be configured by
        the application.

    -   To configure ACC100, N3000 and ACC200 in vfio mode, you should provide
        ``sriovFecClusterConfig`` with
        ``spec.physicalFunction.pfDriver: vfio-pci``.

#.  Switch between Static method configuration and Operator method.

    #.  Delete ``SriovFecClusterConfig``.

    #.  Remove ``sriov-fec-operator`` using the command
        :command:`system application-remove`.

    #.  Apply the configuration using :command:`system host-device-modify`,
        see :ref:`Enable ACC100/ACC200 Hardware Accelerators for Hosted vRAN Containerized Workloads <enabling-mount-bryce-hw-accelerator-for-hosted-vram-containerized-workloads>`.

.. rubric:: |postreq|

-   See :ref:`Set Up Pods to Use SRIOV to Access ACC100/ACC200 HW Accelerators
    <set-up-pods-to-use-sriov>`.

-   The resource name for |FEC| |VFs| configured with |SRIOV| |FEC| operator
    must be ``intel.com/intel_fec_acc100`` for ACC100,
    ``intel.com/intel_fec_5g`` for N3000 and ``intel.com/intel_fec_acc200``
    for ACC200 when requested in a pod spec.

    -   ACC100

        .. code-block:: none

            resources:
              requests:
                intel.com/intel_fec_acc100: '16'
              limits:
                intel.com/intel_fec_acc100: '16'

    -   N3000.

        .. code-block:: none

            resources:
              requests:
                intel.com/intel_fec_5g: '2'
              limits:
                intel.com/intel_fec_5g: '2'

    -   ACC200.

        .. code-block:: none

            resources:
              requests:
                intel.com/intel_fec_acc200: '16'
              limits:
                intel.com/intel_fec_acc200: '16'

-   Applications that are using |FEC| |VFs| when the |PF| interface is bound
    with the ``vfio-pci`` driver, should provide the ``vfio-token`` to |VF|
    interface.

    For example, a sample |DPDK| application can provide ``vfio-vf-token`` via
    Environment Abstraction Layer (EAL) parameters.
    :command:`./test-bbdev.py -e="--vfio-vf-token=02bddbbf-bbb0-4d79-886b-91bad3fbb510 -a0000:f7:00.1"`

-   An application pod can get the |VFIO| token through a pod environment
    variable.

    For example, reference the pod spec section for vfio token injection.

    .. code-block:: none

        env:
        - name: SRIOV_FEC_VFIO_TOKEN
          value: "02bddbbf-bbb0-4d79-886b-91bad3fbb510"

    :command:`./test-bbdev.py -e="--vfio-vf-token=$SRIOV_FEC_VFIO_TOKEN -a0000:f7:00.1"`
