
.. cvf1552672201332
.. _tpm-planning:

============
TPM Planning
============

|TPM| is an industry standard crypto processor that enables secure storage
of HTTPS |SSL| private keys. It is used in support of advanced security
features.

|TPM| is an optional requirement for |UEFI| Secure Boot.

If you plan to use |TPM| for secure protection of REST API and Web Server
HTTPS |SSL| keys, ensure that |TPM| 2.0 compliant hardware devices are
fitted on controller nodes before provisioning them. If properly connected,
the BIOS should detect these new devices and display appropriate
configuration options. |TPM| must be enabled from the BIOS before it can be
used in software.

.. note::
    |prod| allows post installation configuration of HTTPS mode. It is
    possible to transition a live HTTP system to a system that uses |TPM|
    for storage of HTTPS |SSL| keys without reinstalling the system.
