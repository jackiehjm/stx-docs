===========================
Access StarlingX Kubernetes
===========================

.. contents::
   :local:
   :depth: 1

----------
Local CLIs
----------

In order to access the StarlingX and Kubernetes commands on controller-O, first
follow these steps:

#. Log in to controller-0 via the console or SSH with a sysadmin/<sysadmin-password>.

#. Acquire Keystone admin and Kubernetes admin credentials:

   ::

	source /etc/platform/openrc

*********************************************
StarlingX system and host management commands
*********************************************

Access StarlingX system and host management commands using the :command:`system`
command. For example:

::

	system host-list

	+----+--------------+-------------+----------------+-------------+--------------+
	| id | hostname     | personality | administrative | operational | availability |
	+----+--------------+-------------+----------------+-------------+--------------+
	| 1  | controller-0 | controller  | unlocked       | enabled     | available    |
	+----+--------------+-------------+----------------+-------------+--------------+

Use the :command:`system help` command for the full list of options.

***********************************
StarlingX fault management commands
***********************************

Access StarlingX fault management commands using the :command:`fm` command, for example:

::

	fm alarm-list

*******************
Kubernetes commands
*******************

Access Kubernetes commands using the :command:`kubectl` command, for example:

::

	kubectl get nodes

	NAME           STATUS   ROLES    AGE     VERSION
	controller-0   Ready    master   5d19h   v1.13.5

See https://kubernetes.io/docs/reference/kubectl/overview/ for details.

-----------
Remote CLIs
-----------

Documentation coming soon.

---
GUI
---

*********************
StarlingX Horizon GUI
*********************

Access the StarlingX Horizon GUI in your browser at the following address:

::

	http://<oam-floating-ip-address>:8080


Log in to Horizon with an admin/<sysadmin-password>.

********************
Kubernetes dashboard
********************

The Kubernetes dashboard is not installed by default.

To install the Kubernetes dashboard, execute the following steps on controller-0:

#. Use the kubernetes-dashboard helm chart from the stable helm repository with
   the override values shown below:

   ::

	cat <<EOF > dashboard-values.yaml
	service:
	  type: NodePort
	  nodePort: 30000

	rbac:
	  create: true
	  clusterAdminRole: true

	serviceAccount:
	  create: true
	  name: kubernetes-dashboard
	EOF

	helm helm repo update

	helm install stable/kubernetes-dashboard --name dashboard -f dashboard-values.yaml

#. Create an ``admin-user`` service account with ``cluster-admin`` privileges, and
   display its token for logging into the Kubernetes dashboard.

   ::

	cat <<EOF > admin-login.yaml
	apiVersion: v1
	kind: ServiceAccount
	metadata:
	  name: admin-user
	  namespace: kube-system
	---
	apiVersion: rbac.authorization.k8s.io/v1
	kind: ClusterRoleBinding
	metadata:
	  name: admin-user
	roleRef:
	  apiGroup: rbac.authorization.k8s.io
	  kind: ClusterRole
	  name: cluster-admin
	subjects:
	- kind: ServiceAccount
	  name: admin-user
	  namespace: kube-system
	EOF

	kubectl apply -f admin-login.yaml

	kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

#. Access the Kubernetes dashboard GUI in your browser at the following address:

   ::

   	https://<oam-floating-ip-address>:30000

#. Log in with the ``admin-user`` TOKEN.

---------
REST APIs
---------

List the StarlingX platform-related public REST API endpoints using the
following command:

::

	openstack endpoint list | grep public

Use these URLs as the prefix for the URL target of StarlingX Platform Services'
REST API messages.
