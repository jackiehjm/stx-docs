
.. rhb1561120463240
.. _about-persistent-volume-support:

===============================
About Persistent Volume Support
===============================

Persistent Volume Claims \(PVCs\) are requests for storage resources in your
cluster. By default, container images have an ephemeral file system. In order
for containers to persist files beyond the lifetime of the container, a
Persistent Volume Claim can be created to obtain a persistent volume which the
container can mount and read/write files.

Management and customization tasks for Kubernetes Persistent Volume Claims can
be accomplished using the **rbd-provisioner** helm chart. The
**rbd-provisioner** helm chart is included in the **platform-integ-apps**
system application, which is automatically loaded and applied as part of the
|prod| installation.

