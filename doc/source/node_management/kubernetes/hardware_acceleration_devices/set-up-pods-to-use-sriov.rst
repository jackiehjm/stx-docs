
.. ggs1611608368857
.. _set-up-pods-to-use-sriov:

================================================================
Set Up Pods to Use SRIOV to Access ACC100/ACC200 HW Accelerators
================================================================

You can configure pods with |SRIOV| access to a ACC100/ACC200 devices by adding the
appropriate 'resources' request in the pod specification.

.. rubric:: |context|

The following procedure shows an example of launching a container image with
'resources' request for a |VF| to the ACC100/ACC200 devices.

.. rubric:: |proc|

#.  Source the platform environment.

    .. code-block:: none

        $ source /etc/platform/openrc ~(keystone_admin)$

#.  Create a pod.yml file that requests 16 ACC100/ACC200 VFs
    \(i.e. intel.com/intel_acc100_fec: '16'\)

    .. code-block:: none

        ~(keystone_admin)$ cat >> pod0.yml << EOF
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: pod0
          annotations:
          labels:
            app: pod0
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: pod0
          template:
            metadata:
              name: pod0
              labels:
                app: pod0
            spec:
              restartPolicy: Always
              containers:
              - name: pod0
                image: "windse/pktgen-testpmd-bbdev:d1911r4p1912"
                volumeMounts:
                - mountPath: /mnt/huge-1048576kB
                  name: hugepage
                - mountPath: /sys/devices
                  name: uio
                command: ["/bin/bash", "-ec", "sleep infinity"]
                securityContext:
                  privileged: false
                  capabilities:
                    add:
                      ["IPC_LOCK", "SYS_ADMIN"]
                resources:
                  requests:
                    memory: 4Gi
                    intel.com/intel_acc100_fec: '16'
                    windriver.com/isolcpus: 24
                  limits:
                    hugepages-1Gi: 2Gi
                    memory: 4Gi
                    intel.com/intel_acc100_fec: '16'
                    windriver.com/isolcpus: 24
              volumes:
              - name: hugepage
                emptyDir:
                  medium: HugePages
              - name: uio
                hostPath:
                  path: /sys/devices
        EOF

#.  Start the pod.

    .. code-block:: none

        ~(keystone_admin)$ kubectl create -f pod0.yml

#.  Wait for the pod to start and execute the following command:

    .. code-block:: none

        ~(keystone_admin)$ kubectl exec -it pod0 -- bash echo
        $PCIDEVICE_INTEL_COM_INTEL_ACC100_FEC

    The following PCI addresses corresponding to the |SRIOVs| are displayed:

    .. code-block:: none

        0000:86:01.1,0000:86:01.0,0000:86:01.7,0000:86:01.4,0000:86:00.3,0000:86:00.1,0000:86:00.5,0000:86:00.7,0000:86:00.2,0000:86:00.4,0000:86:01.5,0000:86:01.6,0000:86:01.2,0000:86:00.0,0000:86:00.6,0000:86:01.3


