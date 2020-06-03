==========================================
OpenStack Cinder File System Configuration
==========================================

This guide describes an optional file system that can be used by Cinder to
convert qcow2 images to raw format.

.. contents::
   :local:
   :depth: 1

--------
Overview
--------

By default, qcow2 image conversion is done using the docker_lv file system.
To avoid filling up the docker_lv file system, you can create a new file system
that is dedicated to image conversion using the steps in this guide.

-------------------
Add new file system
-------------------

Use the ``host-fs-add`` CLI command to add a file system dedicated to qcow2
image conversion.

The syntax is:

::

    system host-fs-add <hostname or id> <fs name=size>

Where:

*   ``hostname or id`` is the location where the file system will be added.
*   ``fs name`` is the file system name.
*   ``size`` is an integer indicating the file system size in Gigabytes.

When the command completes, a new partition named ``/opt/conversion`` is
created and mounted.

You must add the file system on both controller nodes. You can do this from
controller-0 using the following example commands:

::

    system host-fs-add controller-0 image-conversion=20
    system host-fs-add controller-1 image-conversion=20


..  Note::

    #.  The requested size of the ``image-conversion`` file system should be
        big enough to accommodate any image that is uploaded to glance. If the
        requested size is too large, the command will fail.

    #.  The recommended size for the file system is at least 2 times as
        large as the largest converted image from qcow2 to raw.

    #.  The conversion file system can be added before or after stx-openstack is
        applied.

    #.  The conversion file system must be added on both controllers. If not,
        stx-openstack will not use the new file system.

    #.  If the conversion file system is added after stx-openstack is applied,
        changes to stx-openstack will only take effect once the application is
        re-applied.

The ``image-conversion`` file system can be added only on controller nodes.

Alarms for ``image-conversion`` will be raised for the following scenarios:

*   If the conversion file system is not added on both controllers.
*   If the size of the file system is not the same on both controllers.

----------------------
Resize the file system
----------------------

Change the size of the ``image-conversion`` file system at runtime using the
following CLI command:

::

    system host-fs-modify <hostname or id> <fs name=size>

For example:

::

    system host-fs-modify controller-0 image-conversion=30

----------------------
Remove the file system
----------------------

Use the ``host-fs-delete`` CLI command to remove an ``image-conversion`` file
system dedicated to qcow2 image conversion.

The syntax is:

::

    system host-fs-delete <hostname or id> <fs name>

When ``image-conversion`` is removed, the ``/opt/conversion`` partition is also
removed.

..  Note::

        You cannot delete an image-conversion file system when
        stx-openstack is in the applying, applied, or removing state.

You cannot add or remove any other file systems using these commands.

