
.. vwx1591793382143
.. _starlingx-kubernetes-user-tutorials-overview:

========================
Kata Containers Overview
========================

.. note::

    Kata Containers will not be supported in |prod-long| |prod-ver|.

|prod| uses a **containerd** :abbr:`CRI (Container Runtime Interface)` that supports
both runc and Kata Container runtimes. The default runtime is runc. If you want
to launch a pod that uses the Kata Container runtime, you must declare it
explicitly.

For more information about Kata containers, see `https://katacontainers.io/
<https://katacontainers.io/>`__.
