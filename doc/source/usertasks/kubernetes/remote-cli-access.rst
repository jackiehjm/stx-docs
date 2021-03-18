
.. hqk1581948275511
.. _remote-cli-access:

=================
Remote CLI Access
=================

You can access the system :abbr:`CLIs (Command Line Interfaces)` from a
remote workstation using one of the two methods.

.. xreflink .. note::
    To use the remote Windows Active Directory server for authentication of
    local :command:`kubectl` commands, see, |sec-doc|: :ref:`Overview of
    Windows Active Directory <overview-of-windows-active-directory>`.

.. _remote-cli-access-ul-jt2-lcy-ljb:

#.  The first method involves using the remote :abbr:`CLI (Command Line
    Interface)` tarball from |dnload-loc| to install a set of container-backed
    remote CLIs for accessing a remote |prod-long|. This provides
    access to the kubernetes-related CLIs \(kubectl, helm\). This approach is
    simple to install, portable across Linux, OSX and Windows, and provides
    access to all |prod-long| CLIs. However, commands such as those that
    reference local files or require a shell are awkward to run in this
    environment.

#.  The second method involves installing the :command:`kubectl` and
    :command:`helm` clients directly on the remote host. This method only
    provides the kubernetes-related CLIs and requires OS-specific installation
    instructions.
