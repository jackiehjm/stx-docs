
.. agv1552920520258
.. _update-orchestration-cli:

========================
Update Orchestration CLI
========================

The update orchestration CLI is :command:`sw-manager`. Use this to create your
update strategy.

The commands and options map directly to the parameter descriptions in the web
interface dialog, described in :ref:`Configuring Update Orchestration
<configuring-update-orchestration>`.

.. note::
    To use update orchestration commands, you need administrator privileges.
    You must log in to the active controller as user **sysadmin** and source
    the ``/etc/platform/openrc`` script to obtain administrator privileges. Do not
    use :command:`sudo`.

.. note::
    Management-affecting alarms cannot be ignored at the indicated severity
    level or higher by using relaxed alarm rules during an orchestrated update
    operation. For a list of management-affecting alarms, see |fault-doc|:
    :ref:`Alarm Messages <100-series-alarm-messages>`. To display
    management-affecting active alarms, use the following command:

    .. code-block:: none

        ~(keystone_admin)$ fm alarm-list --mgmt_affecting

    During an orchestrated update operation, the following alarms are ignored
    even when strict restrictions are selected:

    -   200.001, Maintenance host lock alarm

    -   900.001, Patch in progress

    -   900.005, Upgrade in progress

    -   900.101, Software patch auto apply in progress

.. _update-orchestration-cli-ul-qhy-q1p-v1b:

Help is available for the overall command and also for each sub-command. For
example:

.. code-block:: none

    ~(keystone_admin)]$  sw-manager patch-strategy --help
    usage: sw-manager patch-strategy [-h]  ...
    
    optional arguments:
      -h, --help  show this help message and exit

Update orchestration commands include:

.. _update-orchestration-cli-ul-cvv-gdd-nx:

-   :command:`create` - Create a strategy

-   :command:`delete` - Delete a strategy

-   :command:`apply` - Apply a strategy

-   :command:`abort` - Abort a strategy

-   :command:`show` - Show a strategy
