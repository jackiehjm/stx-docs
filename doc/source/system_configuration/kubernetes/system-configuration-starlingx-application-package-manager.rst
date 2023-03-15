
.. gsl1568831180133
.. _system-configuration-starlingx-application-package-manager:

=====================================
StarlingX Application Package Manager
=====================================

Use the |prod| system application commands to manage containerized
applications provided as part of |prod|.

StarlingX application management provides a wrapper around FluxCD and
Kubernetes Helm (see `https://github.com/helm/helm
<https://github.com/helm/helm>`__) for managing containerized applications.
FluxCD is a tool for managing multiple Helm charts with dependencies by
centralizing all configurations in a single FluxCD YAML definition and
providing life-cycle hooks for all Helm releases.

A StarlingX application package is a compressed tarball containing a
metadata.yaml file, a manifest.yaml FluxCD manifest file, and a charts
directory containing helm charts and a checksum.md5 file. The metadata.yaml
file contains the application name, version, and optional helm repository
and disabled charts information.

StarlingX application package management provides a set of :command:`system`
CLI commands for managing the lifecycle of an Application, which includes
managing overrides to the helm charts within the application.

.. _system-configuration-starlingx-application-package-manager-d123e61:

.. table:: Table 1. Application Package Manager Commands
    :widths: auto

    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | Command                                | Description                                                                                                                                                                                                                                                 |
    +========================================+=============================================================================================================================================================================================================================================================+
    | :command:`application-list`            | List all applications.                                                                                                                                                                                                                                      |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`application-show`            | Show application details such as name, status, and progress.                                                                                                                                                                                                |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`application-upload`          | Upload a new application package.                                                                                                                                                                                                                           |
    |                                        |                                                                                                                                                                                                                                                             |
    |                                        | This command loads the application's FluxCD manifest and helm charts into an internal database and automatically applies system overrides for well-known helm charts, allowing the helm chart to be applied optimally to the current cluster configuration. |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`helm-override-list`          | List system helm charts and the namespaces with helm chart overrides for each helm chart.                                                                                                                                                                   |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`helm-override-show`          | Show a helm chart's overrides for a particular namespace.                                                                                                                                                                                                   |
    |                                        |                                                                                                                                                                                                                                                             |
    |                                        | This command displays system-overrides, user-overrides and the combined system and user overrides.                                                                                                                                                          |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`helm-override-update`        | Update helm chart user-overrides for a particular namespace.                                                                                                                                                                                                |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`helm-chart-attribute-modify` | Enable or disable the installation of a particular helm chart within an application manifest.                                                                                                                                                               |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`helm-override-delete`        | Delete a helm chart's user-overrides for a particular namespace.                                                                                                                                                                                            |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`application-apply`           | Apply or reapply the application manifest and helm charts.                                                                                                                                                                                                  |
    |                                        |                                                                                                                                                                                                                                                             |
    |                                        | This command will install or update the existing installation of the application based on its FluxCD manifest, helm charts and helm charts' combined system and user overrides.                                                                             |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`application-abort`           | Abort the current application operation.                                                                                                                                                                                                                    |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`application-update`          | Update the deployed application to a different version                                                                                                                                                                                                      |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`application-remove`          | Uninstall an application.                                                                                                                                                                                                                                   |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | :command:`application-delete`          | Remove the uninstalled application's definition, including manifest and helm charts and helm chart overrides, from the system.                                                                                                                              |
    +----------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
