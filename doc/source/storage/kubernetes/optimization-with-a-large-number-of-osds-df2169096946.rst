.. _optimization-with-a-large-number-of-osds-df2169096946:

========================================
Optimization with a Large number of OSDs
========================================

You may need to optimize your Ceph configuration for balanced operation across
deployments with a high number of |OSDs|.

.. rubric:: |context|

As the number of |OSDs| increases, choosing the correct <pg_num> and <pgp_num>
values becomes more important as they have a significant influence on the
behavior of the cluster and the durability of the data should a catastrophic
event occur.

|org| recommends the following values:

* Fewer than 5 |OSDs|: Set <pg_num> and <pgp_num> to 128.

* Between 5 and 10 |OSDs|: Set <pg_num> and <pgp_num> to 512.

* Between 10 and 50 |OSDs|: Set <pg_num> and <pgp_num> to 4096.

* More than 50 |OSDs|: Understanding the memory, CPU and network usage
  tradeoffs, calculate and set the optimal <pg_num> and <pgp_num> values for
  your scenario.

  Use the equation below and round up to a number power of 2.

  *Total PGs = (OSDs * 100) / <pool_size>*

  <pool_size> is either the number of replicas for replicated pools or the K+M
  sum for erasure coded pools as returned by ``ceph osd erasure-code-profile
  get <profile>``, where <profile> is usually default.

  For more information on the tradeoffs involved, consult the Ceph
  documentation at:

  https://docs.ceph.com/en/latest/rados/operations/placement-groups/


.. rubric:: |eg|

*  For a deployment with 7 |OSDs|, use the following commands to set <pg> and
   <pgp_num> to 512.

   .. code-block:: none

       $ ceph osd pool set kube-rbd pg_num 512
       $ ceph osd pool set kube-rbd pgp_num 512
