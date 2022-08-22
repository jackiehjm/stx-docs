.. _change-the-default-coredump-configuration-51ff4ce0c9ae:

=========================================
Change the Default Coredump Configuration
=========================================

You  can change the default core dump configuration used to create *core*
files. These are images of the system's working memory used to debug crashes or
abnormal exits.

.. rubric:: |context|

The editable parameters and their defaults are as follows:

``ProcessSizeMax``
   The maximum size of cores that will be processed.

   Default: 2G

   Minimum: 0

``ExternalSizeMax``
   The maximum size of cores to be saved.

   Default: 2G

   Minimum: 0

``MaxUse``
   Sets a maximum diskspace usage by cores.

   Default: *unset*

``KeepFree``
  Sets the minimum amount of disk space to keep free when saving cores.

  Default: 1G

  Minimum: 1G

Maximum values for each configurable coredump parameter depend on system capacity.

The parameters accept integer/float values followed by a letter representing
the unit of measurement.

* ``B`` = Bytes
* ``K`` = Kilobytes
* ``M`` = Megabytes
* ``G`` = Gigabytes
* ``T`` = Terabytes
* ``P`` = Petabytes
* ``E`` = Exabytes

The value 0 (zero) is accepted by parameters ``ProcessSizeMax``,
``ExternalSizeMax`` and ``MaxUse``.

.. Note::
    Other, non-configurable, parameters are:

    * ``Storage`` = external
    * ``Compress`` = yes
    * ``JournalSizeMax`` = 767M


For more information on these values, see
https://man7.org/linux/man-pages/man5/coredump.conf.5.html


.. rubric:: |prereq|

Ensure that you have sufficient storage available on the host's ``log``
filesystem. See :ref:`resizing-filesystems-on-a-host` for more information
about adjusting it's size.


.. rubric:: |eg|

When you configure a parameter, it will be replicated to the ``coredump.conf`` file of all
existing nodes (controllers, workers, storages).

*  To add a coredump service parameter:

   .. code-block:: none

      ~(keystone_admin)]$ system service-parameter-add platform coredump <parameter>=<value>

*  To modify an existing coredump service parameter:

   .. code-block::

      ~(keystone_admin)]$ system service-parameter-modify platform coredump <parameter>=<value>

*  To delete an existing coredump service parameter:

   .. code-block::

      ~(keystone_admin)]$ system service-parameter-delete <uuid>

   .. note::

      When a parameter is deleted, its value will reset to the default.


Where <parameter> can be one of:

*  ``process_size_max``
*  ``external_size_max``
*  ``max_use``
*  ``keep_free``

The following example sets ``ExternalSizeMax`` to 3 gigabytes.

.. code-block:: none

   ~(keystone_admin)]$ system service-parameter-add platform coredump external_size_max=3G

.. note::

   Configuring a parameter raises the 250.001 *controller-0 Configuration
   is out-of-date* alarm. A lock/unlock is required to clear it. For more
   information, see :ref:`locking-a-host-using-the-cli` and
   :ref:`unlocking-a-host-using-the-cli`.
