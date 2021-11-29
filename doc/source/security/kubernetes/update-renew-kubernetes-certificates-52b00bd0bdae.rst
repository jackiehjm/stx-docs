.. _update-renew-kubernetes-certificates-52b00bd0bdae:

====================================
Update/Renew Kubernetes Certificates
====================================

Updating Kubernetes Root |CA| certificate is a complex process, because it is
not only the Root |CA| certificate that needs to be updated, but also all the
other Kubernetes certificates signed by it need to be regenerated and updated.

See :ref:`Manual Kubernetes Root CA Certificate Update
<manual-kubernetes-root-ca-certificate-update-8e9df2cd7fb9>` or
:ref:`Kubernetes Root CA Certificate Update Cloud Orchestration
<kubernetes-root-ca-certificate-update-cloud-orchestration-a627f9d02d6d>` for
how to update the Kubernetes Root |CA| certificate.

The other leaf certificates generated from the Kubernetes Root |CA| are
monitored by a cronjob, which runs every day at midnight to check if any of
these certificates’ expiry date is approaching, and renew them if the expiry
date is within 15 days.

If the renewal fails, a **250.003** alarm will be raised:

-   `Kubernetes certificates have been renewed but not all services have been
    updated.`

    For this alarm, controller nodes need to lock/unlock for the services to
    take the new certificates.

-   `Kubernetes certificates renewal failed.`

    For this alarm, the Kubernetes certificates need to be renewed manually,
    during which services need to restart.

If this alarm is raised, the administrator should follow the recommended action
for the specific alarm.