
.. okc1552681506455
.. _authentication-of-software-delivery:

===================================
Authentication of Software Delivery
===================================

|org| signs and authenticates software updates to the |prod| software.

This is done for:


.. _authentication-of-software-delivery-ul-qtp-rbk-vhb:

-   Software patches – incremental updates to system for software fixes or
    security vulnerabilities.

-   Software loads – full software loads to upgrade the system to a new
    major release of software.


Both software patches and loads are cryptographically signed as part of
|org| builds and are authenticated before they are loaded on a system via
|prod| REST APIs, CLIs or GUI.
