
.. ggs1611608368857
.. _set-up-pods-to-use-sriov:

=============================================================
Set Up Pods to Use SRIOV to Access Mount Bryce HW Accelerator
=============================================================

You can configure pods with |SRIOV| access to a Mount Bryce device by adding the
appropriate 'resources' request in the pod specification.

.. rubric:: |context|

The following procedure shows an example of launching a container image with
'resources' request for a |VF| to the Mount Bryce device.

.. rubric:: |proc|

#.  Source the platform environment.

    .. code-block:: none

        $ source /etc/platform/openrc ~(keystone_admin)$

#.  Create a pod.yml file.

    .. code-block:: none

        ~(keystone_admin)$ cat >> pod0.yml << EOF
          apiVersion: v1
          kind: Pod
          metadata:
            name: pod0
          spec:
          restartPolicy: Never
          containers:
          - name: pod0
            image: "windse/pktgen-testpmd-bbdev:d1911r4p1912" volumeMounts: -
            mountPath: /mnt/huge-1048576kB
              name: hugepage
            - mountPath: /sys/devices
              name: uio
            command: ["/bin/bash", "-ec", "sleep infinity"] securityContext:
              privileged: false capabilities:
                add:
                  ["IPC_LOCK", "SYS_ADMIN"]
            resources:
              requests:
                hugepages-1Gi: 4Gi memory: 4Gi intel.com/intel_acc100_fec: '16'
                windriver.com/isolcpus: '24'
              limits:
                hugepages-1Gi: 4Gi memory: 4Gi intel.com/intel_acc100_fec: '16'
                windriver.com/isolcpus: '24'
          volumes: - name: hugepage
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


