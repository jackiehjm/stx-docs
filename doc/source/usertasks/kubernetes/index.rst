.. _usertasks-kubernetes-index:

.. include:: /_includes/toc-title-usertasks-kub.rest

.. only:: partner

   .. include:: /usertasks/index.rst
      :start-after: kub-begin
      :end-before: kub-end

-------------
System access
-------------

.. toctree::
   :maxdepth: 1

   kubernetes-user-tutorials-access-overview

-----------------
Remote CLI access
-----------------

.. toctree::
   :maxdepth: 1

   remote-cli-access
   kubernetes-user-tutorials-configuring-container-backed-remote-clis-and-clients
   usertask-using-container-backed-remote-clis-and-clients
   kubernetes-user-tutorials-installing-kubectl-and-helm-clients-directly-on-a-host
   configuring-remote-helm-client
   using-container-based-remote-clis-and-clients

----------
GUI access
----------

.. toctree::
   :maxdepth: 1

   accessing-the-kubernetes-dashboard

----------
API access
----------

.. toctree::
   :maxdepth: 1

   kubernetes-user-tutorials-rest-api-access

----------------------
Application management
----------------------

.. toctree::
   :maxdepth: 1

   kubernetes-user-tutorials-helm-package-manager

---------------------
Local Docker registry
---------------------

.. toctree::
   :maxdepth: 1

   kubernetes-user-tutorials-authentication-and-authorization
   using-an-image-from-the-local-docker-registry-in-a-container-spec

---------------------------
NodePort usage restrictions
---------------------------

.. toctree::
   :maxdepth: 1

   nodeport-usage-restrictions

------------
Cert Manager
------------

.. toctree::
   :maxdepth: 1

   kubernetes-user-tutorials-cert-manager
   letsencrypt-example

--------------------------------
Vault secret and data management
--------------------------------

.. toctree::
   :maxdepth: 1

   kubernetes-user-tutorials-vault-overview
   vault-aware
   vault-unaware

-----------------------------
Using Kata Containers runtime
-----------------------------

.. toctree::
   :maxdepth: 1

   kata-containers-overview
   specifying-kata-container-runtime-in-pod-spec
   known-limitations

-------------------------------
Adding persistent volume claims
-------------------------------

.. toctree::
   :maxdepth: 1

   kubernetes-user-tutorials-about-persistent-volume-support

***************
RBD Provisioner
***************

.. toctree::
   :maxdepth: 1

   kubernetes-user-tutorials-create-readwriteonce-persistent-volume-claims
   kubernetes-user-tutorials-mount-readwriteonce-persistent-volumes-in-containers

****************************
Ceph File System Provisioner
****************************

.. toctree::
   :maxdepth: 1

   kubernetes-user-tutorials-create-readwritemany-persistent-volume-claims
   kubernetes-user-tutorials-mount-readwritemany-persistent-volumes-in-containers

--------------------------------
Optimize application performance
--------------------------------

.. toctree::
   :maxdepth: 1

   using-kubernetes-cpu-manager-static-policy
   use-application-isolated-cores

----------------------------------------
Adding an SRIOV interface to a container
----------------------------------------

.. toctree::
   :maxdepth: 1

   creating-network-attachment-definitions
   using-network-attachment-definitions-in-a-container

--------------
Metrics Server
--------------

.. toctree::
   :maxdepth: 1

   kubernetes-user-tutorials-metrics-server
