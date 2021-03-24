
.. rnd1590588857064
.. _list-physical-volumes:

=====================
List Physical Volumes
=====================

You can list physical volumes using the :command:`system-host-pv-list` command.

.. rubric:: |context|

The syntax of the command is:

.. code-block:: none

    system host-pv-list <hostname>

<hostname> is the name or ID of the host.

For example, to list physical volumes on compute-1, do the following:

.. code-block:: none

    $ system host-pv-list compute-1


