.. _overview-234a36ffe9fb:

========
Overview
========

With support for the CentOS Distribution being discontinued, |deb-prev-prods|
will move to the Debian OS Distribution. Debian is a well-established Linux
Distribution supported by a large and mature open-source community and used by
hundreds of commercial organizations, including Google. When fully transitioned
to Debian, |deb-prev-prods| will have full functional equivalence to the
current CentOS-based versions of |deb-prev-prods|.

The planned rollout for the transition to Debian is as follows:


.. rubric:: |prod| |deb-510-kernel-release| (RELEASED)

*   General Availability (GA) Release of CentOS7 |prod| (for production
    deployments)

*   Moved to 5.10 kernel, which will be used by the upcoming Debian-based
    release.

.. rubric:: |prod| |deb-eval-release|


|prod| |deb-eval-release| is a general Availability (GA) Release of CentOS7
|prod| for production deployments. It will be the last release of a CentOS7
–based |prod|.

|prod| |deb-eval-release| inherits the 5.10 version of the Linux kernel
introduced in |prod| |deb-510-kernel-release|.

|prod| |deb-eval-release| is also a technology Preview Release of Debian |prod|
for evaluation purposes.

|prod| |deb-eval-release| release runs Debian Bullseye (11.3). It is limited in
scope to the |AIO-SX| configuration. |deb-dup-std-na|

See :ref:`technology-preview-reduced-scope-0008a139a4b9` for details.


.. rubric:: Debian |prod| General Availability


An upcoming release will make Debian |prod| genrally available for
production deployments.

This upcoming release  will run Debian Bullseye 11.3 or later with
full functional equivalence to the CentOS-based |prod|.

.. only:: partner

    .. include:: /_includes/deb-tech-preview.rest
        :start-after: begin-prod-an-1
        :end-before: end-prod-an-1


.. rubric:: Planned in-service upgrade paths for |prod|

* |prod| |deb-510-kernel-release| running CentOS  ==>  |prod| |deb-eval-release| running CentOS  ==>  |prod| Debian general availability release

or

* |prod| |deb-510-kernel-release| running CentOS  ==>  |prod| Debian general availability release


.. note::

    There will be no upgrade paths related to the |prod| |deb-eval-release|
    Debian Technology Preview release.

The |prod-long| |deb-eval-release| Debian Technology Preview allows you to
evaluate and prepare for the upcoming Debian-based General Availability release
while continuing to run your production deployment
on CentOS-based |prod-long|. It is strongly recommended that you perform a
complete assessment of |prod| and your application running on |prod| in a lab
setting to fully understand and plan for any changes that may be required to
your application when you migrate to Debian-based |prod|
the |prod| Debian General Availability release in a production
environment.

