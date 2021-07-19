
.. nat1580220934509
.. _enabling-snmp-support:

===================
Enable SNMP Support
===================

.. contents::
   :local:
   :depth: 2

|SNMP| support must be enabled and configured before you can begin using it to
monitor |prod|.

.. rubric:: |context|

In order to enable and configure |SNMP|, complete the following steps.

.. rubric:: |proc|

#.  On the active controller, acquire Keystone administrative privileges.

    .. code-block:: none

       $ source /etc/platform/openrc
       ~(keystone_admin)]$

#.  Use the following command to list the system applications and check whether
    SNMP is uploaded or applied. If SNMP is already "uploaded", go to
    Step 5 to configure and enable SNMP. If SNMP is already "applied", SNMP is
    already configured and enabled, see, :ref:`Change Configuration of the SNMP application <change-configuration-of-SNMP>`
    to make configuration changes.

    .. code-block:: none

       ~(keystone)admin)$ system application-list
        +--------------------------+-------------------------+-----------------------------------+----------------------------------------+---------------+-----------+
        | application              | version                 | manifest name                     | manifest file                          | status        | progress  |
        +--------------------------+-------------------------+-----------------------------------+----------------------------------------+---------------+-----------+
        | cert-manager             | 1.0-6                   | cert-manager-manifest             | certmanager-manifest.yaml              | applied       | completed |
        | nginx-ingress-controller | 1.0-0                   | nginx-ingress-controller-manifest | nginx_ingress_controller_manifest.yaml | applied       | completed |
        | oidc-auth-apps           | 1.0-29                  | oidc-auth-manifest                | manifest.yaml                          | uploaded      | completed |
        | platform-integ-apps      | 1.0-9                   | platform-integration-manifest     | manifest.yaml                          | applied       | completed |
        | rook-ceph-apps           | app-version-placeholder | manifest-placeholder              | tarfile-placeholder                    | upload-failed | None      |
        +--------------------------+-------------------------+-----------------------------------+----------------------------------------+---------------+-----------+

#.  In order to load the SNMP application definitions (Armada manifest and Helm
    charts), where **[snmp-<Major>.<Minor>-<Build>.tgz]**, for example,
    **snmp-1.0-2.tgz** is the app filename, with version **1.0-2**,
    available at the following path "/usr/local/share/applications/helm",
    use the following command.

    .. code-block:: none

        ~(keystone)admin)$ system application-upload <path>/snmp-1.0-2.tgz
        +---------------+----------------------------------+
        | Property      | Value                            |
        +---------------+----------------------------------+
        | active        | False                            |
        | app_version   | 1.0-2                            |
        | created_at    | 2020-11-30T14:45:20.442133+00:00 |
        | manifest_file | snmp_manifest.yaml               |
        | manifest_name | snmp-manifest                    |
        | name          | snmp                             |
        | progress      | None                             |
        | status        | uploading                        |
        | updated_at    | None                             |
        +---------------+----------------------------------+

#.  List the SNMP application using the following command to see the status
    of the upload and wait for the upload to complete.

    .. code-block:: none

        ~(keystone)admin)$ system application-list
        +--------------------------+-------------------------+-----------------------------------+----------------------------------------+---------------+-----------+
        | application              | version                 | manifest name                     | manifest file                          | status        | progress  |
        +--------------------------+-------------------------+-----------------------------------+----------------------------------------+---------------+-----------+
        | cert-manager             | 1.0-6                   | cert-manager-manifest             | certmanager-manifest.yaml              | applied       | completed |
        | nginx-ingress-controller | 1.0-0                   | nginx-ingress-controller-manifest | nginx_ingress_controller_manifest.yaml | applied       | completed |
        | oidc-auth-apps           | 1.0-29                  | oidc-auth-manifest                | manifest.yaml                          | uploaded      | completed |
        | platform-integ-apps      | 1.0-9                   | platform-integration-manifest     | manifest.yaml                          | applied       | completed |
        | rook-ceph-apps           | app-version-placeholder | manifest-placeholder              | tarfile-placeholder                    | upload-failed | None      |
        | snmp                     | 1.0-2                   | snmp-manifest                     | snmp_manifest.yaml                     | uploaded      | completed |
        +--------------------------+-------------------------+-----------------------------------+----------------------------------------+---------------+-----------+

#.  Create a Helm chart values file (for example, user_conf.yaml) with the
    definition of the **configmap:user_conf** attribute, defining your SNMP
    configuration of V2 communities, V2 trap sinks, V3 users and/or V3 trap
    sessions, as shown in the example below. The **configmap:user_conf**
    variable in the SNMP Helm chart is a multi-line variable that follows the
    syntax of Net-SNMP's snmpd.conf file for configuring the SNMP agent, see
    `http://www.net-snmp.org/docs/man/snmpd.conf.html <http://www.net-snmp.org/docs/man/snmpd.conf.html>`__,
    for a detailed description of the commands.

    .. warning::

       Since this file may contain sensitive security information, this file
       should be removed from the system after executing the command and
       stored off-box, or regenerated, if required.

    .. code-block:: none

       cat <<EOF > user_conf.yaml
       configmap:
         user_conf: |-
           # Configure V2 Community
           # rocommunity COMMUNITY [SOURCE [OID | -V VIEW [CONTEXT]]]
           rocommunity testcommunity  default    -V all

           # Configure V2 Trap Sink / Destination
           # trap2sink HOST [COMMUNITY [PORT]]
           trap2sink 10.10.10.1:162 testcommunity

           # Configure V3 User
           # createUser [-e ENGINEID] username (MD5|SHA) authpassphrase [DES|AES] [privpassphrase]
           createUser testuser MD5 testpassword DES

           # Configure RW access for V3 User
           # rouser [-s SECMODEL] USER [noauth|auth|priv [OID | -V VIEW [CONTEXT]]]
           rouser testuser priv

           # Configure V3 Trap Session / Destination
           # trapsess -v 3 -u USER -a [MD5|SHA] -A authpassphrase -l [noauth|auth|priv] -x [DES|AES] -X privpassphrase [<transport-specifier>:]<transport-address>
           trapsess -v 3 -u testuser -a MD5 -A testpassword -l authPriv -x DES -X testpassword udp:10.10.10.1:162
       EOF

    **\(Optional\)** You can add your own EngineID value, instead of having it
    auto-created. This keeps the EngineID value the same, even when the SNMP
    application restarts. The EngineID is required if you are using an SNMP
    trap viewer or SNMP monitoring tool. Add the 'engineID [STRING]' value in
    the **configmap:user_conf** variable, as shown below.

    .. code-block:: none

       cat <<EOF > user_conf.yaml
       configmap:
         user_conf: |-
       ...
           engineID [STRING]
       ...
       EOF

#.  Update the values of the **configmap:user_conf** attribute on the Helm
    chart using the following command.

    .. code-block:: none

       ~(keystone_admin)$ system helm-override-update --reuse-values --values user_conf.yaml snmp snmp kube-system
       +----------------+------------------------------------------------------------------------------------------------------------+
       | Property       | Value                                                                                                      |
       +----------------+------------------------------------------------------------------------------------------------------------+
       | name           | snmp                                                                                                       |
       | namespace      | kube-system                                                                                                |
       | user_overrides | configmap:                                                                                                 |
       |                |   user_conf: |-                                                                                            |
       |                |     createUser testuser MD5 testpassword DES                                                               |
       |                |     rouser testuser priv                                                                                   |
       |                |     rocommunity testcommunity  default    -V all                                                           |
       |                |     trapsess -v 3 -u testuser -a MD5 -A testpassword -l authPriv -x DES -X testpassword udp:10.10.10.1:162 |
       |                |     trap2sink 10.10.10.1:162 testcommunity                                                                 |
       +----------------+------------------------------------------------------------------------------------------------------------+

#.  Run the following command to apply the changes and start the SNMP
    application.

    .. code-block:: none

        ~(keystone)admin)$ system application-apply snmp
        +---------------+----------------------------------+
        | Property      | Value                            |
        +---------------+----------------------------------+
        | active        | False                            |
        | app_version   | 1.0-2                            |
        | created_at    | 2020-11-30T14:45:20.442133+00:00 |
        | manifest_file | snmp_manifest.yaml               |
        | manifest_name | snmp-manifest                    |
        | name          | snmp                             |
        | progress      | None                             |
        | status        | applying                         |
        | updated_at    | 2020-11-30T14:45:23.088575+00:00 |
        +---------------+----------------------------------+

#.  List the SNMP application and check the status. Wait for the SNMP
    application to have fully started and is in the "applied" state.

    .. code-block:: none

        ~(keystone)admin)$ system application-list
        +--------------------------+-------------------------+-----------------------------------+----------------------------------------+---------------+-----------+
        | application              | version                 | manifest name                     | manifest file                          | status        | progress  |
        +--------------------------+-------------------------+-----------------------------------+----------------------------------------+---------------+-----------+
        | cert-manager             | 1.0-6                   | cert-manager-manifest             | certmanager-manifest.yaml              | applied       | completed |
        | nginx-ingress-controller | 1.0-0                   | nginx-ingress-controller-manifest | nginx_ingress_controller_manifest.yaml | applied       | completed |
        | oidc-auth-apps           | 1.0-29                  | oidc-auth-manifest                | manifest.yaml                          | uploaded      | completed |
        | platform-integ-apps      | 1.0-9                   | platform-integration-manifest     | manifest.yaml                          | applied       | completed |
        | rook-ceph-apps           | app-version-placeholder | manifest-placeholder              | tarfile-placeholder                    | upload-failed | None      |
        | snmp                     | 1.0-2                   | snmp-manifest                     | snmp_manifest.yaml                     | applied       | completed |
        +--------------------------+-------------------------+-----------------------------------+----------------------------------------+---------------+-----------+

#.  Create a Helm chart values file (for example, snmp_port.yaml) with UDP and
    TCP port mapping rules, for the nginx-ingress-controller application, to
    expose the SNMP services on the required ports. Use external ports 161/UDP
    and 162/TCP.

    **kube-system/snmpd-service:161** is the standard SNMP Agent's UDP port for
    receiving SNMP requests. It should be configured as mapped to external UDP
    port **161**, the default for SNMP Agents. This port can be modified, see,
    :ref:`Modifying 161/UDP port <modifying-161udp-port>` procedure for details
    on modifying this port.

    **kube-system/snmpd-service:162** is used internally by the SNMP
    application to receive trap info from |prod|. It should be configured
    as mapped to external TCP port **162**. This port can be modified, see
    :ref:`Modifying 162/TCP port <modifying-162tcp-port>` procedure below for
    details on modifying this port.

    .. code-block:: none

       cat <<EOF > snmp_port.yaml
       udp:
         161: "kube-system/snmpd-service:161"
       tcp:
         162: "kube-system/snmpd-service:162"
       EOF

#.  Update the values of the SNMP port mappings in the Helm Chart for the
    nginx-ingress-controller application.

    .. code-block:: none

       ~(keystone_admin)$ system helm-override-update --reuse-values --values snmp_port.yaml nginx-ingress-controller ingress-nginx kube-system
       +----------------+------------------------------------------+
       | Property       | Value                                    |
       +----------------+------------------------------------------+
       | name           | nginx-ingress                            |
       | namespace      | kube-system                              |
       | user_overrides | tcp:                                     |
       |                |   "162": kube-system/snmpd-service:162   |
       |                | udp:                                     |
       |                |   "161": kube-system/snmpd-service:161   |
       |                |                                          |
       +----------------+------------------------------------------+

#.  Apply the changes to the nginx-ingress-controller application.

    .. code-block:: none

      ~(keystone_admin)$ system application-apply nginx-ingress-controller
      +---------------+----------------------------------------+
      | Property      | Value                                  |
      +---------------+----------------------------------------+
      | active        | True                                   |
      | app_version   | 1.0-0                                  |
      | created_at    | 2020-10-19T04:59:40.505583+00:00       |
      | manifest_file | nginx_ingress_controller_manifest.yaml |
      | manifest_name | nginx-ingress-controller-manifest      |
      | name          | nginx-ingress-controller               |
      | progress      | None                                   |
      | status        | applying                               |
      | updated_at    | 2020-11-10T17:27:21.509548+00:00       |
      +---------------+----------------------------------------+

#.  Redirect the SNMP UDP traffic to port 161 by creating the next policies.yml
    file and apply it as below.

    Change the ipVersion parameter value from 4 to 6 if you are using IPV6.

    .. code-block:: none

      ~(keystone_admin)$
      cat <<EOF > policies.yml
      apiVersion: crd.projectcalico.org/v1
      kind: GlobalNetworkPolicy
      metadata:
        name: snmp
      spec:
        applyOnForward: false
        ingress:
        - action: Allow
          destination:
            ports:
            - 161
          ipVersion: 4
          protocol: UDP
        order: 200
        selector: has(iftype) && iftype == 'oam'
        types:
        - Ingress
      EOF

    Then, run the following command:

    .. code-block:: none

      ~(keystone_admin)$ kubectl apply -f policies.yml

.. _change-configuration-of-SNMP:

--------------------------------------------
Change configuration of the SNMP application
--------------------------------------------

If the SNMP application is already applied, use the following procedures to
update its configuration.

.. rubric:: |proc|

#.  Create a Helm chart values file (for example, user_conf.yaml) with the
    definition of the **configmap:user_conf** attribute defining your SNMP
    configuration of V2 communities, V2 trap sinks, V3 users and/or V3 trap
    sessions, as shown in the example below. The **configmap:user_conf**
    variable in the SNMP Helm chart is a multi-line variable that follows the
    syntax of Net-SNMP's snmpd.conf file for configuring the SNMP agent, see
    `http://www.net-snmp.org/docs/man/snmpd.conf.html <http://www.net-snmp.org/docs/man/snmpd.conf.html>`__,
    for a detailed description of the commands.

    .. warning::

       Since this file may contain sensitive security information, this file
       should be removed from the system after executing the command and
       stored off-box, or regenerated, if required.

    .. code-block:: none

       cat <<EOF > user_conf.yaml
       configmap:
         user_conf: |-
           # Configure V2 Community
           # rocommunity COMMUNITY [SOURCE [OID | -V VIEW [CONTEXT]]]
           rocommunity testcommunity  default    -V all

           # Configure V2 Trap Sink / Destination
           # trap2sink HOST [COMMUNITY [PORT]]
           trap2sink 10.10.10.1:162 testcommunity

           # Configure V3 User
           # createUser [-e ENGINEID] username (MD5|SHA) authpassphrase [DES|AES] [privpassphrase]
           createUser testuser MD5 testpassword DES

           # Configure RW access for V3 User
           # rouser [-s SECMODEL] USER [noauth|auth|priv [OID | -V VIEW [CONTEXT]]]
           rouser testuser priv

           # Configure V3 Trap Session / Destination
           # trapsess -v 3 -u USER -a [MD5|SHA] -A authpassphrase -l [noauth|auth|priv] -x [DES|AES] -X privpassphrase [<transport-specifier>:]<transport-address>
           trapsess -v 3 -u testuser -a MD5 -A testpassword -l authPriv -x DES -X testpassword udp:10.10.10.1:162
       EOF

    **\(Optional\)** You can add your own EngineID value, instead of having it
    auto-created. This keeps the EngineID value the same, even when the SNMP
    application restarts. The EngineID is required if you are using an SNMP
    trap viewer or SNMP monitoring tool. Add the 'engineID [STRING]' value in
    the **configmap:user_conf** variable, as shown below.

    .. code-block:: none

       cat <<EOF > user_conf.yaml
       configmap:
         user_conf: |-
       ...
           engineID [STRING]
       ...
       EOF

#.  Update the values of the **configmap:user_conf** attribute on the Helm
    chart using the following command.

    .. code-block:: none

       ~(keystone_admin)$ system helm-override-update --reuse-values --values user_conf.yaml snmp snmp kube-system
       +----------------+------------------------------------------------------------------------------------------------------------+
       | Property       | Value                                                                                                      |
       +----------------+------------------------------------------------------------------------------------------------------------+
       | name           | snmp                                                                                                       |
       | namespace      | kube-system                                                                                                |
       | user_overrides | configmap:                                                                                                 |
       |                |   user_conf: |-                                                                                            |
       |                |     createUser testuser MD5 testpassword DES                                                               |
       |                |     rouser testuser priv                                                                                   |
       |                |     rocommunity testcommunity  default    -V all                                                           |
       |                |     trapsess -v 3 -u testuser -a MD5 -A testpassword -l authPriv -x DES -X testpassword udp:10.10.10.1:162 |
       |                |     trap2sink 10.10.10.1:162 testcommunity                                                                 |
       +----------------+------------------------------------------------------------------------------------------------------------+

#.  Apply the changes.

    .. code-block:: none

       ~(keystone_admin)$ system application-apply snmp
       +---------------+----------------------------------+
       | Property      | Value                            |
       +---------------+----------------------------------+
       | active        | True                             |
       | app_version   | 1.0-2                            |
       | created_at    | 2020-11-10T23:25:47.226453+00:00 |
       | manifest_file | snmp_manifest.yaml               |
       | manifest_name | snmp-manifest                    |
       | name          | snmp                             |
       | progress      | None                             |
       | status        | applying                         |
       | updated_at    | 2020-11-10T23:30:59.276031+00:00 |
       +---------------+----------------------------------+

.. _modifying-161udp-port:

**********************
Modifying 161/UDP port
**********************

Modify the external UDP port used for receiving SNMP requests.

.. note::

    After changing this external UDP port, any external SNMP managers being
    used must be updated to send their SNMP requests to |prod| using this
    UDP port, instead of the default UDP port 161.

.. rubric:: |proc|

#.  Create a Helm chart values file (for example, snmp_port.yaml) with
    external ports 161/UDP and 162/TCP port mapping definitions, for the SNMP
    services for the nginx-ingress-controller's Helm chart, as shown in the
    example below.

    Update the external port in the UDP port mapping for internal port
    **kube-system/snmpd-service:161**. The example below shows the external
    port updated to **1061**.

    .. code-block:: none

       cat <<EOF > snmp_port.yaml
       udp:
         1061: "kube-system/snmpd-service:161"
       tcp:
         162: "kube-system/snmpd-service:162"
       EOF

#.  Update the values of the SNMP ports on the Helm chart for the
    nginx-ingress-controller application.

    .. code-block:: none

       ~(keystone_admin)$ system helm-override-update --reuse-values --values snmp_port.yaml nginx-ingress-controller nginx-ingress kube-system
       +----------------+------------------------------------------+
       | Property       | Value                                    |
       +----------------+------------------------------------------+
       | name           | nginx-ingress                            |
       | namespace      | kube-system                              |
       | user_overrides | tcp:                                     |
       |                |   "162": kube-system/snmpd-service:162   |
       |                | udp:                                     |
       |                |   "1061": kube-system/snmpd-service:161  |
       |                |                                          |
       +----------------+------------------------------------------+

#.  Apply the changes in the nginx-ingress-controller application.

    .. code-block:: none

      ~(keystone_admin)$ system application-apply nginx-ingress-controller
      +---------------+----------------------------------------+
      | Property      | Value                                  |
      +---------------+----------------------------------------+
      | active        | True                                   |
      | app_version   | 1.0-0                                  |
      | created_at    | 2020-10-19T04:59:40.505583+00:00       |
      | manifest_file | nginx_ingress_controller_manifest.yaml |
      | manifest_name | nginx-ingress-controller-manifest      |
      | name          | nginx-ingress-controller               |
      | progress      | None                                   |
      | status        | applying                               |
      | updated_at    | 2020-11-10T17:27:21.509548+00:00       |
      +---------------+----------------------------------------+

.. _modifying-162tcp-port:

**********************
Modifying 162/TCP port
**********************

Modify the external port used by the SNMP application to receive trap
information from |prod|.

To change the port 162/TCP, you need to modify both the SNMP application Helm
chart, and the nginx-ingress-controller Helm chart. The new port must be set
to the same port number in the two Helm charts, otherwise SNMP
traps will not be generated.

.. rubric:: |proc|

#.  Modify your SNMP Helm chart values file (for example, user_conf.yaml) by
    adding the line "trap-server-port: [new port]" as shown in the example
    below \("30162" is the new port in this example\).

    .. code-block:: none

       cat <<EOF > user_conf.yaml
       configmap:
         user_conf: |-
           createUser testuser MD5 testpassword DES
           rouser testuser priv
           rocommunity testcommunity  default    -V all
           trapsess -v 3 -u testuser -a MD5 -A testpassword -l authPriv -x DES -X testpassword udp:10.10.10.1:162
           trap2sink 10.10.10.1:162 testcommunity
         trap-server-port: 30162
       EOF

#.  Run the following commands to apply the configuration.

    .. code-block:: none

       ~(keystone_admin)$ system helm-override-update --reuse-values --values user_conf.yaml snmp snmp kube-system
       ~(keystone_admin)$ system application-apply snmp

#.  Modify your nginx ingress controller Helm chart values file
    (for example, snmp_port.yaml). Update the external port in the TCP port
    mapping for internal port **kube-system/snmpd-service:162**. The example
    below shows the external port updated to **30162**.

    - The new port number must match the port number specified in your SNMP
      Helm chart values file (for example, user_conf.yaml).

    - Do not modify port number "162" in **kube-system/snmpd-service:162**.

      .. code-block:: none

         cat <<EOF > snmp_port.yaml
         udp:
           161: "kube-system/snmpd-service:161"
         tcp:
           30162: "kube-system/snmpd-service:162"
         EOF

#.  Run the following commands to apply the configuration.

    .. code-block:: none

       ~(keystone_admin)$ system helm-override-update --reuse-values --values snmp_port.yaml nginx-ingress-controller nginx-ingress kube-system
       ~(keystone_admin)$ system application-apply nginx-ingress-controller
