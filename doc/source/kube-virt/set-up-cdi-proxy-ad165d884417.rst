.. _set-up-cdi-proxy-ad165d884417:

================
Set up CDI Proxy
================

.. rubric:: |context|

The Containerized Data Importer (|CDI|) project provides facilities for enabling
|PVCs| to be used as disks for KubeVirt |VMs| by way of DataVolumes.

The |CDI| service is installed as part of uploading and applying the KubeVirt
system application. The most common use case for |CDI| is 'uploading a disk
image to a DataVolume'. To use the |CDI| service, your Kubernetes cluster-admin
should make the ``cdi-uploadproxy`` service accessible from outside the cluster.
This can be done via NodePort service or Ingress service.

Configuring the NodePort service option is shown below:


.. rubric:: |proc|

#. Create the |CDI| proxy yaml configuration.

   .. code-block:: yaml

      $ cat <<EOF > cdi-uploadproxy-nodeport-service.yaml apiVersion: v1
      kind: Service
      metadata:
        name: cdi-uploadproxy-nodeport
        namespace: cdi
        labels:
          cdi.kubevirt.io: "cdi-uploadproxy"
      spec:
        type: NodePort
        ports:
          - port: 443
          targetPort: 8443
          nodePort: 32111 # Use unused nodeport in 31,500 to 32,767 range 
          protocol: TCP
      selector:
        cdi.kubevirt.io: cdi-uploadproxy
      EOF


#. Apply the configuration.

   .. code-block:: none

      $ kubectl apply -f cdi-uploadproxy-nodeport-service.yaml

.. rubric:: |result|

Now the ``virtctl`` command can be used to upload a |VM| image file into an
existing or new DataVolume (|PVC|). 

See the example (:ref:`create-an-ubuntu-vm-fafb82ec424b`) that uploads an ubuntu
cloud image (``jammy-server-cloudimg-amd64.img`` from
https://cloud-images.ubuntu.com/jammy/current/) into a new 500G DataVolume
named stx-lab-jenkins-disk:

.. code-block::

   $ virtctl image-upload dv stx-lab-jenkins-disk -n jenkins-ns --insecure \
     --access-mode ReadWriteOnce --size 500Gi --image-path \
     /home/sysadmin/admin/kubevirt/images/jammy-server-cloudimg-amd64.img     \
     --uploadproxy-url https://admin.starlingx.abc.com:32111

See sections on :ref:`create-an-ubuntu-vm-fafb82ec424b` and
:ref:`create-a-windows-vm-82957181df02` on how to then use this DataVolume to
create/launch a |VM|.

See https://kubevirt.io/user-guide/operations/containerized_data_importer/ for
more details and other use cases.

