
.. lzf1570032232833
.. _secure-starlingx-rest-and-web-certificates-private-key-storage-with-tpm:

========================================================================
Secure StarlingX REST and Web Certificate's Private Key Storage with TPM
========================================================================

For increased security, the |prod| REST and Web Server's certificate can
be installed such that the private key is stored in a |TPM| 2.0 device on
the controller.

.. rubric:: |context|

|TPM| is an industry standard cryptographic processor that enables secure
storage of secrets. |prod| can use a |TPM| device, if present, to securely
store the private key of the |prod| REST and Web Server's certificate.

The |TPM| is used to wrap the private key within the |TPM| device. Each
wrapping is unique to that |TPM| device and cannot be synchronized between
controllers using different |TPM| devices. Therefore, the same private key
is always secured to both the active and standby controllers' |TPM| devices
at the same time. Given this operational constraint, |prod| has measures in
place to detect when the standby controller is reinstalled or replaced, and
raise appropriate alarms to prevent an Unlock or Swact of a new standby
controller until the |prod| REST and Web Server's certificate is
re-installed, in order to update the new standby controller's |TPM| device.

.. rubric:: |prereq|


.. _secure-starlingx-rest-and-web-certificates-private-key-storage-with-tpm-ul-xj3-mqc-d1b:

-   Obtain an Intermediate or Root |CA|-signed certificate and key from a
    trusted Intermediate or Root |CA|. Refer to the documentation for the
    external Intermediate or Root |CA| that you are using, on how to create
    public certificate and private key pairs, signed by an Intermediate or
    Root-signed |CA|, for HTTPS.

    For lab purposes, see :ref:`Create Certificates Locally using openssl
    <create-certificates-locally-using-openssl>` for details on how to create
    a test Intermediate or Root |CA| certificate and key, and use it to sign
    test certificates.

    Put the |PEM| encoded versions of the certificate and key in a
    single file, and copy the file to the controller host.

-   Both controllers must be provisioned and unlocked before you can install
    the certificate using |TPM| to store the private key.

-   A |TPM| 2.0 device must be available on both controller nodes.

-   |TPM| must be enabled in the |UEFI| on both controllers.

-   HTTPS must be enabled on the system.

.. note::

    If you plan to use the container-based remote CLIs, due to a limitation in
    the Python2 SSL certificate validation, the certificate used for the |prod|
    REST API application endpoints and |prod| Web Administration Server ('ssl')
    certificate must either have:

    #.  CN=IPADDRESS and SANs=IPADDRESS

        or

    #.  CN=FQDN and SANs=FQDN

        where IPADDRESS and |FQDN| are for the |OAM| Floating IP Address.

.. caution::

    Do not install the certificate using |TPM| on controller-0 before the
    standby controller-1 has been provisioned and unlocked. If this happens,
    you cannot unlock controller-1. To recover, do the following:

.. _secure-starlingx-rest-and-web-certificates-private-key-storage-with-tpm-ol-jpm-2kq-qcb:

#.  Install the certificate without |TPM| on controller-0. For more
    information, see :ref:`Install/Update the StarlingX Rest and Web
    Server Certificate
    <install-update-the-starlingx-rest-and-web-server-certificate>`.

#.  Unlock controller-1.

#.  Reinstall the certificate using |TPM| on controller-0.


.. rubric:: |proc|

.. _secure-starlingx-rest-and-web-certificates-private-key-storage-with-tpm-steps-hnx-qf5-x1b:

#.  Install the |prod| REST and Web Server's certificate using |TPM| to
    securely store the private key:

    .. code-block:: none

        ~(keystone_admin)]$ system certificate-install –m tpm_mode <pathTocertificateAndKey>

    where:

    **<pathTocertificateAndKey>**

    is the path to the file containing both the intermediate or Root
    |CA|-signed certificate and private key to install.

    .. warning::

        For security purposes, the utility deletes the provided SSL private
        key from the file system and asks for confirmation during the
        installation. You should store a copy of the SSL private key off-site.

    .. note::

        Only X.509 based RSA key certificates are supported \(PKCS12 format
        and ECDSA keys are not supported\). Additionally, 4096 bit RSA key
        lengths are not supported.

#.  Check the certificate's |TPM| configuration state for each provisioned
    controller node.

    .. code-block:: none

        [sysadmin@controller-0 tmp(keystone_admin)]$ system certificate-show tpm
        +-------------+-----------------------------------------------------+
        | Property    | Value                                               |
        +-------------+-----------------------------------------------------+
        | uuid        | ed3d6a22-996d-421b-b4a5-64ab42ebe8be                |
        | certtype    | tpm_mode                                            |
        | signature   | tpm_mode_13214262027721489760                       |
        | start_date  | 2018-03-21T14:53:03+00:00                           |
        | expiry_date | 2019-03-21T14:53:03+00:00                           |
        | details     | {u'state': {u'controller-1': u'tpm-config-applied', |
        |             |  u'controller-0': u'tpm-config-applied'}}           |
        +-------------+-----------------------------------------------------+


    Subsequent certificate installs using |TPM| populate the updated\_at field
    to indicate when the certificate was refreshed.

    .. code-block:: none

        [sysadmin@controller-0 tmp(keystone_admin)]$ system certificate-show tpm
        +-------------+-----------------------------------------------------+
        | Property    | Value                                               |
        +-------------+-----------------------------------------------------+
        | uuid        | d6a47714-2b99-4470-b2c8-422857749c98                |
        | certtype    | tpm_mode                                            |
        | signature   | tpm_mode_13214262027721489760                       |
        | start_date  | 2018-03-21T14:53:03+00:00                           |
        | expiry_date | 2019-03-21T14:53:03+00:00                           |
        | details     | {u'state': {u'controller-1': u'tpm-config-applied', |
        |             |  u'controller-0': u'tpm-config-applied'},           |
        |             |  u'updated_at':u'2018-03-21T16:18:15.879639+00:00'} |
        +-------------+-----------------------------------------------------+


If either controller has state **tpm-config-failed**, then a 500.100
alarm is raised for the host.

-   A LOCKED controller node that is not in the |TPM| applied configuration
    state \(**tpm-config-applied**\), is prevented from being UNLOCKED

-   An UNLOCKED controller node that is not in the |TPM| applied
    configuration state \(**tpm-config-applied**\), is prevented from being
    Swacted To or upgraded.



.. rubric:: |postreq|

When reinstalling either of the controllers or during a hardware replacement
scenario, you must reinstall the certificate:

.. code-block:: none

    ~(keystone_admin)]$ system certificate-install -m tpm_mode
    <pathTocertificateAndKey>

To disable the use of |TPM| to store the private key of the |prod| REST
and Web Server's certificate, install the certificate without the |TPM|
option:

.. code-block:: none

    ~(keystone_admin)]$ system certificate-install <pathTocertificateAndKey>

.. warning::

    The REST and Web Server certificate are not automatically renewed, user
    MUST renew the certificate prior to expiry, otherwise a variety of system
    operations will fail.

.. _tpm-configuration-considerations:

--------------------------------
TPM configuration considerations
--------------------------------

There are some considerations to account for when configuring or
reconfiguring |TPM|.

This includes certain behavior and warnings that you may encounter when
configuring |TPM|. The same behavior and warnings are seen when performing
these actions in the Horizon Web interface, also.


.. _tpm-configuration-considerations-ul-fbm-1fy-f1b:

-   The :command:`certificate-show tpm` command will indicate the status of
    the |TPM| configuration on the hosts, either **tpm-config-failed** or
    **tpm-config-applied**.

    .. code-block:: none

        ~(keystone_admin)]$ system certificate-show tpm
        +-------------+-----------------------------------------------------+
        | Property    | Value                                               |
        +-------------+-----------------------------------------------------+
        | uuid        | ed3d6a22-996d-421b-b4a5-64ab42ebe8be                |
        | certtype    | tpm_mode                                            |
        | signature   | tpm_mode_13214262027721489760                       |
        | start_date  | 2018-03-21T14:53:03+00:00                           |
        | expiry_date | 2019-03-21T14:53:03+00:00                           |
        | details     | {u'state': {u'controller-1': u'tpm-config-applied', |
        |             |  u'controller-0': u'tpm-config-applied'}}           |
        +-------------+-----------------------------------------------------+


-   If either controller has state **tpm-config-failed**, then a **500.100**
    alarm will be raised for the host.

    .. code-block:: none

        ~(keystone_admin)]$ fm alarm-list

        +----------+------------------+------------------+----------+------------+
        | Alarm ID | Reason Text      | Entity ID        | Severity | Time Stamp |
        +----------+------------------+------------------+----------+------------+
        | 500.100  | TPM configuration| host=controller-1| major    | 2017-06-1..|
        |          | failed or device.|                  |          |.586010     |
        +----------+------------------+------------------+----------+------------+


-   An UNLOCKED controller node that is not in TPM applied configuration
    state \(**tpm-config-applied**\) will be prevented from being Swacted To or
    upgraded.

    The following warning is generated when you attempt to swact:

    .. code-block:: none

        ~(keystone_admin)]$ system host-swact controller-0
        TPM configuration not fully applied on host controller-1; Please
        run https-certificate-install before re-attempting.


-   A LOCKED controller node that is not in |TPM| applied configuration state
    \(**tpm-config-applied**\) will be prevented from being UNLOCKED.

    The :command:`host-list` command below shows controller-1 as locked and
    disabled.

    .. code-block:: none

        ~(keystone_admin)]$ system host-list

        +----+--------------+-------------+----------------+-------------+--------------+
        | id | hostname     | personality | administrative | operational | availability |
        +----+--------------+-------------+----------------+-------------+--------------+
        | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
        | 2  | controller-1 | controller  | locked         | disabled    | online       |
        +----+--------------+-------------+----------------+-------------+--------------+

    The following warning is generated when you attempt to UNLOCK a
    controller not in a **tpm-config-applied** state:

    .. code-block:: none

        ~[keystone_admin)]$ system host-unlock controller-1

        TPM configuration not fully applied on host controller-1; Please
        run https-certificate-install before re-attempting

