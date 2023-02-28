
.. rst1450732770531
.. _configuration-using-metadata:

============================
Configuration Using Metadata
============================

Boot configuration user data can be passed to a virtual machine during
startup.

.. contents:: |minitoc|
   :local:
   :depth: 1

For example, an |EMS| may be used in cloud environments for |VM|
configuration, but the |VM| may require some bootstrap information to
successfully communicate with the |EMS|.

|prod-os| provides three mechanisms to accomplish this:

---------
User Data
---------

This is a mechanism for passing a local file to an instance when it is
launched. This method is typically used to pass a shell script or
configuration file.

To send user data when calling nova boot, use the ``--user-data
/path/to/filename`` option, or use the Heat service and set the
``user_data`` property and ``user_data_format`` to RAW.

On initialization, the |VM| queries the metadata service through either
the EC2 compatibility API. For example:

.. code-block:: none

    $ curl http://169.254.169.254/2012-08-10/user_data

or the OpenStack metadata API. For example:

.. code-block:: none

    $ curl http://169.254.169.254/openstack/2009-04-04/user_data

In either case, text is returned to the |VM| and can be used for
bootstrap configuration.

Access to the metadata server at 169.254.169.254 is provided by a
virtual router attached to the project network on which the access
request is made. Virtual routers are automatically configured as
proxies to the metadata service.

----------
cloud-init
----------

This is an open-source package available from
`https://cloudinit.readthedocs.org/en/latest/
<https://cloudinit.readthedocs.org/en/latest/>`__ that supports a
variety of guests. It expects a particular file format for user data,
retrieves the user data from the metadata server, and takes action
based on the contents of the data.

Two commonly used input formats are:

**shell scripts**
    You can configure an instance at boot time by passing a shell
    script as user data. The script file must begin with

    .. code-block:: none

        #!

    for **cloud-init** to recognize it as a shell script.

**Cloud config files**
    A configuration format based on |YAML| that you can use to configure
    a large number of options on a system. For example, to set the
    hostname:

    .. code-block:: none

        #cloud-config
        hostname: mynode
        fqdn: mynode.example.com
        manage_etc_hosts: true

    See `https://cloudinit.readthedocs.org/en/latest
    <https://cloudinit.readthedocs.org/en/latest>`__ for a complete
    list of capabilities.

------------
Config drive
------------

|prod-os| can be configured to use a special-purpose configuration
drive (abbreviated config drive) to store metadata (including
injected files). Metadata is written to the drive, which is attached
to the instance when it boots. The instance can retrieve information
normally available through the metadata service by reading from the
mounted drive.

The config drive can be enabled by using the ``--config-drive=true``
option with nova boot.

The following example enables the config drive and passes user data,
injecting two files and two key/value metadata pairs. These can be read
from the config drive.

.. code-block:: none

    $ openstack server create --config-drive true --image my-image-name --flavor 1 --key-name mykey --user-data ./my-user-data.txt --property role=webservers --property essential=false MYINSTANCE

From within the instance, the config drive volume is labeled
**config-2**. You can mount the config drive as the
/dev/disk/by-label/config-2 device if your guest OS supports accessing
disks by label. For example:

.. code-block:: none

    # mkdir -p /mnt/config
    # mount /dev/disk/by-label/config-2 /mnt/config

The contents of the config drive depend on the options passed to nova
boot. The contents of the config drive for the example above are:

.. code-block:: none

    ec2/2009-04-04/meta-data.json
    ec2/2009-04-04/user-data
    ec2/latest/meta-data.json
    ec2/latest/user-data
    openstack/2012-08-10/meta_data.json
    openstack/2012-08-10/user_data
    openstack/content
    openstack/content/0000
    openstack/content/0001
    openstack/latest/meta_data.json
    openstack/latest/user_data

For file format details and full details on config-drive, refer to the
public OpenStack documentation.

.. caution::
    If a VM uses config-drive for user data or file injection, VM
    evacuations due to a compute node failure and VM live migrations to
    another compute node will cause the config drive to be rebuilt on
    the new compute node and metadata to be populated, but user data
    and injected files are not populated in the evacuated or
    live-migrated config drive of the VM.

    For a VM using **config-file** with file injection, it is
    recommended to copy the injected files to the root disk of the VM
    on initial boot, and to set a flag to prevent the use of injected
    files on subsequent boots.

    File injection is disabled when using a Ceph backend.

