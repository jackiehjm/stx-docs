
.. ulc1552927930507
.. _adding-hosts-in-bulk-r7:

=================
Add Hosts in Bulk
=================

You can add an arbitrary number of hosts using a single CLI command.

.. rubric:: |proc|

#.  Prepare an XML file that describes the hosts to be added.

    For more information, see :ref:`Bulk Host XML File Format
    <bulk-host-xml-file-format-r7>`.

    You can also create the XML configuration file from an existing, running
    configuration using the :command:`system host-bulk-export` command.

#.  Run the :command:`system host-bulk-add` utility.

    The command syntax is:

    .. code-block:: none

        ~[keystone_admin]$ system host-bulk-add <xml_file>

    where <xml\_file> is the name of the prepared XML file.

#.  Power on the hosts to be added, if required.

    .. note::
        Hosts can be powered on automatically from board management controllers
        using settings in the XML file.

.. rubric:: |result|

The hosts are configured. The utility provides a summary report, as shown in
the following example:

.. code-block:: none

    Success:
    worker-0
    worker-1
    Error:
    controller-1: Host-add Rejected: Host with mgmt_mac 08:00:28:A9:54:19 already exists

.. rubric:: |postreq|

After adding the host, you must provision it according to the requirements of
the personality. 

.. xbooklink For more information, see :ref:`Installing, Configuring, and
   Unlocking Nodes <installing-configuring-and-unlocking-nodes>`, for your system,
   and follow the *Configure* steps for the appropriate node personality.

.. seealso::

   :ref:`Bulk Host XML File Format <bulk-host-xml-file-format-r7>`
