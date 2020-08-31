
.. dxx1582118922443
.. _encrypt-kubernetes-secret-data-at-rest:

======================================
Encrypt Kubernetes Secret Data at Rest
======================================

By default, |prod| configures the kube-apiserver to encrypt or decrypt the
data in the Kubernetes 'Secret' resources in / from the etcd database.

This protects sensitive information in the event of access to the etcd
database being compromised. The encryption and decryption operations are
transparent to the Kubernetes API user.

