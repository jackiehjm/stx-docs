==================
Deployment options
==================

StarlingX provides a pre-defined set of standard configurations. You
can use each
of these configurations to deploy a StarlingX Cloud.

Choosing from these options is a key part of planning your Edge
Cloud. In this document we review the available options and provide
guidance as to which option to select.

Choosing the right deployment option for an Cloud architecture
is important, because once you configure a StarlingX Cloud using one
of these options, it can not be changed later.

All-in-one simplex ("simplex" or "AIO-SX")
------------------------------------------
The simplex configuration runs all Cloud functions (i.e. control,
storage, and application workloads) on one node. This configuration
is intended for very small and physically isolated Edge sites
that do not require hardware redundancy. Simplex is a good configuration
to use when evaluating StarlingX.

All-in-one duplex ("duplex" or "AIO-DX")
----------------------------------------
The duplex configuration runs all Cloud functions (i.e. control,
storage, and application workloads) on one node, but
a second node exists for Active / Standby based
hardware redundancy for all platform and
optionally application services. Duplex is a
good configuration to use when evaluating StarlingX's
High Availability capabilities.

All-in-one duplex with up to 4 computes
---------------------------------------
This configuration extends the duplex configuration
by providing a bit more flexibility, In particular,
this options allows
a small number of
compute nodes to be added to the Cloud after it has
been created. This is a good option for small clouds.

Standard with controller storage
--------------------------------
This configuration allows for one or two Controller nodes that
also provide Storage for the Cloud. The configuration
also allows for between one and approximately 100
Compute nodes to run application workloads.
This configuration
works best for Clouds with smaller Storage needs.

Standard with dedicated storage
-------------------------------
This configuration is similar to the "Standard with controller
storage" configuration but has dedicated Storage nodes in addition
to the Controller and Compute nodes. You can use this
configuration for Clouds that require larger amounts of Storage.

.. note:: All Standard configurations can support between one and
          approximately 100 Compute nodes. The upper limit depends on the
          workloads running and how dynamic the Cloud environment is.

Standard with Ironic
--------------------
This configuration extends either of the two Standard configurations
to add the OpenStack Ironic service, which allows application
workloads to run on Bare Metal servers. StarlingX production
deployments that need to manage workloads on Bare Metal should use
this option.

Multi-region
------------
This is an upcoming feature of StarlingX.

Distributed cloud
-----------------
An upcoming feature for StarlingX that allows StarlingX
controllers to manage a number of remote nodes from one UI.
