
.. qjd1552681409626
.. _tpm-configuration-considerations:

================================
TPM Configuration Considerations
================================

There are some considerations to account for when configuring or
reconfiguring |TPM|.

This includes certain behavior and warnings that you may encounter when
configuring TPM. The same behavior and warnings are seen when performing
these actions in the Horizon Web interface, also.


.. _tpm-configuration-considerations-ul-fbm-1fy-f1b:

-   The command :command:`certificate-show tpm` will indicate the status of
    the TPM configuration on the hosts, either **tpm-config-failed** or
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


-   If either controller has state **tpm-config-failed**, then a 500.100
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


-   A LOCKED controller node that is not in TPM applied configuration state
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



