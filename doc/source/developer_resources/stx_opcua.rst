==========================
Enable OPC UA on StarlingX
==========================

This guide describes how to enable
:abbr:`OPC UA (Open Platform Communications Unified Architecture)` on StarlingX.

.. contents::
   :local:
   :depth: 1

----------
Background
----------

As a cloud infrastructure software stack for the edge, Industrial IoT (IIoT)
is an important use case for StarlingX.

`OPC UA <https://opcfoundation.org/developer-tools/specifications-unified-architecture>`_
(**Open Platform Communications Unified Architecture**)
is a data exchange standard for industrial communication, which
integrates all functionalities from the existing OPC Classic specifications.
It is an indispensable part of Industry 4.0. For StarlingX, it is very
valuable to support OPC UA.

In this article, we'd like to share our practice of enabling OPC UA on
StarlingX.

-------------------------------------------------
Build a container image with OPC UA server/client
-------------------------------------------------

There are quite a few open source OPC UA implementations available. Our work
in this article is based on the project `open62541 <https://open62541.org/>`_,
which is a popular and free OPC UA implementation written in C&C++
language.

The example below shows the dockerfile used to build the container image. The
latest open62541 binary release v1.1 was installed.

::

   From ubuntu:18.04

   RUN apt-get update
   RUN apt-get install -y wget

   WORKDIR /opt

   # install open62541 release package
   RUN mkdir temp
   RUN wget -qO- https://github.com/open62541/open62541/releases/download/v1.1/open62541-linux64.tar.gz | tar -xvz -C temp
   RUN mv ./temp/open62541-linux64/bin/* /usr/bin/
   RUN mv ./temp/open62541-linux64/include/* /usr/local/include/
   RUN mv ./temp/open62541-linux64/lib/* /usr/lib/
   RUN mv ./temp/open62541-linux64/share/open62541/tools .
   RUN rm -r temp

   ENV OPCUA_SERVER_IP "opcua-service.kube-system"
   ENV OPCUA_SERVER_PORT "4840"

   COPY run_ua_client.sh .
   COPY run_ua_server.sh .
   COPY ua_client .

``run_ua_client.sh`` and ``run_ua_server.sh`` are two simple scripts to launch
OPC UA server and OPC UA client. The objective of this work is to enable and
verify OPC UA on StarlingX platform. For simplicity, we chose the sample OPC UA
server provided by the open62541 release instead of developing our own OPC UA
server. The sample client of open62541 hardcoded the server address and port as
``localhost:4840``. We made some changes so it will accept two
arguments: server address and server port.

The content of ``run_ua_server.sh``:

::

   #! /bin/sh
   echo "start opc ua server ..."
   ua_server_ctt.exe

The content of ``run_ua_client.sh``:

::

   #! /bin/sh
   n=1
   while true
   do
       sleep 5
       echo "start opc ua client for the $n time ..."
       ./ua_client $OPCUA_SERVER_IP $OPCUA_SERVER_PORT
       n=$((n+1))
   done

---------------------------
Deploy OPC UA server/client
---------------------------

In this step, we will demonstrate how to deploy OPC UA server and client with
the container image built in the previous step on StarlingX platform.

Here we assume the container image with the name ``stx-opcua-base`` has been
already pulled from a registry which StarlingX can access and uploaded into
StarlingX local registry.

We have two yaml files shown below for OPC UA server and client respectively.

::

   apiVersion: v1
   kind: Pod
   metadata:
     name: opcua-server
     labels:
       app: opcua-server
     namespace: kube-system
   spec:
     hostNetwork: false
     imagePullSecrets:
       - name: registry-local-secret
     containers:
     - name: opcua-server
       image: registry.local:9001/stx-opcua-base
       command: ["/opt/run_ua_server.sh"]

   ---

   apiVersion: v1
   kind: Service
   metadata:
     name: opcua-service
     namespace: kube-system
   spec:
     selector:
       app: opcua-server
     ports:
       - protocol: TCP
         port: 4840
         targetPort: 4840

::

   apiVersion: v1
   kind: Pod
   metadata:
     name: opcua-client
     labels:
       app: opcua-client
     namespace: kube-system
   spec:
     hostNetwork: false
     imagePullSecrets:
       - name: registry-local-secret
     containers:
     - name: opcua-client
       image: registry.local:9001/stx-opcua-base
       command: ["/opt/run_ua_client.sh"]

Once applied the two yaml files by the Kubernetes command
``kubectl apply -f opcua-server.yaml`` and
``kubectl apply -f opcua-client.yaml``,
two pods will be created. Then we can check the status of the two pods.

::

   controller-1:~$ kubectl -n kube-system get po | grep opcua
   opcua-client                     1/1     Running       0          15m
   opcua-server                     1/1     Running       0          15m

We also can use below commands to check the output of OPC UA server and client.
The client was repeatedly reading some information from the server.

::

   kubectl -n kube-system logs opcua-server
   kubectl -n kube-system logs opcua-client

-------
Summary
-------

In this work, we took open62541 as an example to show how to enable OPC UA
server and clients on StarlingX platform. In the future, we may explore how to
operate more efficiently with OPC UA on StarlingX platform.
