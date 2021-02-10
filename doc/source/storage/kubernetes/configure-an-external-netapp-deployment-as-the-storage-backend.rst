
.. rzp1584539804482
.. _configure-an-external-netapp-deployment-as-the-storage-backend:

================================================================
Configure an External Netapp Deployment as the Storage Backend
================================================================

Configure an external Netapp Trident deployment as the storage backend,
after system installation using with the help of a |prod|-provided ansible
playbook.

..
  .. rubric:: |prereq|

.. xbooklink

   |prod-long| must be installed and fully deployed before performing this
   procedure. See the :ref:`Installation Overview <installation-overview>`
   for more information.

.. rubric:: |proc|

#.  Configure the storage network.


    If you have not created the storage network during system deployment,
    you must create it manually.


    #.  If you have not done so already, create an address pool for the
        storage network. This can be done at any time.

        .. code-block:: none

            system addrpool-add --ranges <start_address>-<end_address> <name_of_address_pool> <network_address> <network_prefix>

        For example:

        .. code-block:: none

            (keystone_admin)$ system addrpool-add --ranges 10.10.20.1-10.10.20.100 storage-pool 10.10.20.0 24

    #.  If you have not done so already, create the storage network using
        the address pool.

        For example:

        .. code-block:: none

            (keystone_admin)$ system addrpool-list | grep storage-pool | awk '{print$2}' | xargs system network-add storage-net storage true

    #.  For each host in the system, do the following:

        1.  Lock the host.

            .. code-block:: none

                (keystone_admin)$ system host-lock <hostname>

        2.  Create an interface using the address pool.

            For example:

            .. code-block:: none

                (keystone_admin)$ system host-if-modify -n storage0 -c platform --ipv4-mode static --ipv4-pool storage-pool controller-0 enp0s9

        3.  Assign the interface to the network.

            For example:

            .. code-block:: none

                (keystone_admin)$ system interface-network-assign controller-0 storage0 storage-net

        4.  Unlock the system.

            .. code-block:: none

                (keystone_admin)$ system host-unlock <hostname>

.. _configuring-an-external-netapp-deployment-as-the-storage-backend-mod-localhost:

#.  Configure Netapps configurable parameters and run the provided
    install\_netapp\_backend.yml ansible playbook to enable connectivity to
    Netapp as a storage backend for |prod|.

    #.  Provide Netapp backend configurable parameters in an overrides yaml
        file.

        You can make changes-in-place to your existing localhost.yml file
        or create another in an alternative location. In either case, you
        also have the option of using an ansible vault named secrets.yml
        for sensitive data. The alternative must be named localhost.yaml.

        The following parameters are mandatory:

        **ansible\_become\_pass**
            Provide the admin password.

        **netapp\_backends**
            **name**
                A name for the storage class.

            **provisioner**
                This value must be **netapp.io/trident**.

            **backendType**
                This value can be anything but must be the same as
                StorageDriverName below.

            **version**
                This value must be 1.

            **storageDriverName**
                This value can be anything but must be the same as
                backendType below.

            **managementLIF**
                The management IP address for the backend logical interface.

            **dataLIF**
                The data IP address for the backend logical interface.

            **svm**
                The storage virtual machine type to use.

            **username**
                The username for authentication against the netapp backend.

            **password**
                The password for authentication against the netapp backend.

        The following parameters are optional:

        **trident\_setup\_dir**
            Set a staging directory for generated configuration files. The
            default is /tmp/trident.

        **trident\_namespace**
            Set this option to use an alternate Kubernetes namespace.

        **trident\_rest\_api\_port**
            Use an alternate port for the Trident REST API. The default is
            8000.

        **trident\_install\_extra\_params**
            Add extra space-separated parameters when installing trident.

        For complete listings of available parameters, see

        `https://opendev.org/starlingx/ansible-playbooks/src/commit/d05785ffd9add6553662fcab43f30bf8d9f6d2e3/playbookconfig/src/playbooks/host_vars/netapp/default.yml
        <https://opendev.org/starlingx/ansible-playbooks/src/commit/d05785ffd9add6553662fcab43f30bf8d9f6d2e3/playbookconfig/src/playbooks/host_vars/netapp/default.yml>`__

        and

        `https://opendev.org/starlingx/ansible-playbooks/src/commit/d05785ffd9add6553662fcab43f30bf8d9f6d2e3/playbookconfig/src/playbooks/roles/k8s-storage-backends/netapp/vars/main.yml
        <https://opendev.org/starlingx/ansible-playbooks/src/commit/d05785ffd9add6553662fcab43f30bf8d9f6d2e3/playbookconfig/src/playbooks/roles/k8s-storage-backends/netapp/vars/main.yml>`__

        The following example shows a minimal configuration in
        localhost.yaml:

        .. code-block:: none

            ansible_become_pass: xx43U~a96DN*m.?
            trident_setup_dir: /tmp/trident
            netapp_k8s_storageclasses:
              - metadata:
                  name: netapp-nas-backend
                provisioner: netapp.io/trident
                parameters:
                  backendType: "ontap-nas"

            netapp_k8s_snapshotstorageclasses:
              - metadata:
                  name: csi-snapclass
                driver: csi.trident.netapp.io
                deletionPolicy: Delete

            netapp_backends:
              - version: 1
                storageDriverName: "ontap-nas"
                backendName: "nas-backend"
                managementLIF: "10.0.0.1"
                dataLIF: "10.0.0.2"
                svm: "svm_nfs"
                username: "admin"
                password: "secret"

        This file is sectioned into **netapp\_k8s\_storageclass**,
        **netapp\_k8s\_snapshotstorageclasses**, and **netapp\_backends**
        You can add multiple backends and/or storage classes.

        .. note::
            To use IPv6 addressing, you must add the following to your configuration:

            .. code-block:: none

                trident_install_extra_params: "--use-ipv6"

        For more information about configuration options, see
        `https://netapp-trident.readthedocs.io/en/stable-v20.04/kubernetes/operations/tasks/backends/ontap.html
        <https://netapp-trident.readthedocs.io/en/stable-v20.04/kubernetes/operations/tasks/backends/ontap.html>`__.

    #.  Run the playbook.

        The following example uses the ``-e`` option to specify a customized
        location for the localhost.yml file.

        .. code-block:: none

            # ansible-playbook /usr/share/ansible/stx-ansible/playbooks/install_netapp_backend.yml -e "override_files_dir=</home/sysadmin/mynetappconfig>"

        Upon successful launch, there will be one Trident pod running on
        each node, plus an extra pod for the REST API running on one of the
        controller nodes.

#.  Confirm that the pods launched successfully.

    In an all-in-one simplex environment you will see pods similar to the
    following:

    .. code-block:: none

        (keystone_admin)$ kubectl -n <tridentNamespace> get pods
        NAME                          READY   STATUS    RESTARTS   AGE
        trident-csi-c4575c987-ww49n   5/5     Running   0          0h5m
        trident-csi-hv5l7             2/2     Running   0          0h5m

.. rubric:: |postreq|

To configure a persistent volume claim for the Netapp backend, add the
appropriate storage-class name you set up in step :ref:`2
<configure-an-external-netapp-deployment-as-the-storage-backend>`
\(**netapp-nas-backend** in this example\) to the persistent volume
claim's yaml configuration file. For more information about this file, see
|usertasks-doc|: :ref:`Create Persistent Volume Claims
<kubernetes-user-tutorials-creating-persistent-volume-claims>`.

.. seealso::

    -   :ref:`Configure Netapps Using a Private Docker Registry
        <configure-netapps-using-a-private-docker-registry>`