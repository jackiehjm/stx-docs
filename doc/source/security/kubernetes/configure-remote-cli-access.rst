
.. amd1581954964169
.. _configure-remote-cli-access:

===========================
Configure Remote CLI Access
===========================

You can access the system from a remote workstation using one of two methods.


.. _configure-remote-cli-access-ul-jt2-lcy-ljb:


-   The first method involves using the remote |CLI| tarball from the
    |prod| CENGEN build servers to install a set of container-backed remote
    CLIs and clients for accessing a remote |prod-long|. This provides
    access to the :command:`system` and :command:`dcmanager` |prod| CLIs,
    the OpenStack CLI for Keystone and Barbican in the platform, and
    Kubernetes-related CLIs (kubectl, helm). This approach is simple to
    install, portable across Linux, macOS, and Windows, and provides access
    to all |prod-long| CLIs. However, commands such as those that reference
    local files or require a shell are awkward to run in this environment.

-   The second method involves installing the :command:`kubectl` and
    :command:`helm` clients directly on the remote host. This method only
    provides the Kubernetes-related CLIs and requires OS-specific installation
    instructions.


The helm client has additional installation requirements applicable to
either of the above two methods.

.. seealso::

    :ref:`Configure Container-backed Remote CLIs and Clients
    <security-configure-container-backed-remote-clis-and-clients>`

    :ref:`Using Container-backed Remote CLIs and Clients
    <using-container-backed-remote-clis-and-clients>`

    :ref:`Install Kubectl and Helm Clients Directly on a Host
    <security-install-kubectl-and-helm-clients-directly-on-a-host>`

    :ref:`Configure Remote Helm v2 Client
    <configure-remote-helm-client-for-non-admin-users>`