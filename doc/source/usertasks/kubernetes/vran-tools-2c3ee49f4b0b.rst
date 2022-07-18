.. _vran-tools-2c3ee49f4b0b:

==========
vRAN Tools
==========

The following open-source |vRAN| tools are delivered in the following container
image, ``docker.io/starlingx/stx-centos-tools-dev:stx.7.0-v1.0.1``:

-   ``dmidecode``

-   ``net-tools``

-   ``iproute``

-   ``ethtool``

-   ``tcpdump``

-   ``turbostat``

-   OPAE Tools (`Open Programmable Acceleration Engine
    <https://opae.github.io/latest/>`__, ``fpgainfo``, ``fpgabist``, etc.)

-   ACPICA Tools (``acpidump``, ``acpixtract``, etc.)

-   PCM Tools (`https://github.com/opcm/pcm <https://github.com/opcm/pcm>`__,
    pcm, pcm-core, etc.)

To use them on the |prod| Platform, you must launch this container image in
a Kubernetes pod and ``exec`` into a shell in the container in order to execute
the commands. The Kubernetes pod must run in a privileged and host context,
such that the above tools provide information on resources in the host context.

The suggested yaml manifest to launch the ``stx-centos-tools-dev`` container is
as follows:

.. code-block:: none

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: stx-centos-tools
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: stx-centos-tools
      template:
        metadata:
          labels:
            app: stx-centos-tools
        spec:
          containers:
          - name: stx-centos-tools
            image: docker.io/starlingx/stx-centos-tools-dev:stx.7.0-v1.0.1
            imagePullPolicy: Always
            stdin: true
            tty: true
            securityContext:
              privileged: true  # processes in privileged containers are essentially equivalent to root on the host
              capabilities:
                add: ["NET_ADMIN", "SYS_ADMIN"] # add the capabilities you need https://man7.org/linux/man-pages/man7/capabilities.7.html
              runAsUser: 0  # run as root
            volumeMounts:
            - mountPath: /tmp
              name: tmp-volume
          volumes:
          - name: tmp-volume
            hostPath:
              path: /tmp
              type: Directory
          hostIPC: true  # Use the host's network namespace https://www.man7.org/linux/man-pages/man7/network_namespaces.7.html
          hostNetwork: true  # Use the host's network namespace https://www.man7.org/linux/man-pages/man7/network_namespaces.7.html
          hostPID: true  # Use the host's pid namespace https://man7.org/linux/man-pages/man7/pid_namespaces.7.html

For example:

.. code-block:: none

    # Create pod
    ~(keystone_admin)] $ kubectl apply -f stx-centos-tools.yaml

    # Get the running pods
    ~(keystone_admin)] $ kubectl get pods
    NAME                               READY   STATUS    RESTARTS   AGE
    stx-centos-tools                   1/1     Running   0          6s

Then ``exec`` into shell in container:

.. code-block:: none

    # Attach to pod
    ~(keystone_admin)] $ kubectl exec -it stx-centos-tools -- bash
    [root@controller-0 /]#
    [root@controller-0 /]#

-------------------------------------------
Build, deploy and run non-open-source tools
-------------------------------------------

The ``docker.io/starlingx/stx-centos-tools-dev:stx.7.0-v1.0.1`` container image
also contains the |prod| development tools.

Using this container as your base image, this enables the |prod| user to build
a custom container for building and installing of custom or non-opensource
tools (specifically ones requiring |prod| load-specific kernel headers) on a
|prod| target, and then using those tools on |prod|.

For example this can be used for running the non-opensource Intel tool,
Quartzville.

Quartzville is available at
`https://designintools.intel.com/product_p/stlgrn108.htm
<https://designintools.intel.com/product_p/stlgrn108.htm>`__, contact an Intel
representative for access.

You can create and build a Docker image with Quartzville tools as follows:

Running on Kubernetes:

.. code-block:: none

    # Creating the Dockerfile
    cat << EOF > Dockerfile
    FROM docker.io/starlingx/stx-centos-tools-dev:stx.7.0-v1.0.1

    USER root
    WORKDIR /root
    ADD ./348742_Quartzville_Tools_637987.zip /root
    RUN yum install -y centos-release-scl
    RUN yum install -y devtoolset-9
    RUN yum install -y kernel-devel
    RUN unzip /root/348742_Quartzville_Tools_637987.zip
    RUN rm /root/348742_Quartzville_Tools_637987.zip
    RUN chmod +x TOOLS/Linux_x64/OEM_Mfg/install
    RUN chmod +x TOOLS/Linux_x64/SVTools/lanconf64e
    CMD /bin/bash -c "cd TOOLS/Linux_x64/OEM_Mfg/ && scl enable devtoolset-9 ./install && sleep infinity"
    EOF

    # Building the image with Quartzville
    sudo docker build -t stx-centos-tools-quartzville .

    # Create the yml for Kubernetes; note the additional mounting of the host kernel headers from the host
    cat << EOF > stx-centos-tools-quartzville.yml
    apiVersion: v1
    kind: Pod
    metadata:
      name: stx-centos-tools-quartzville
    spec:
      hostNetwork: true
      hostPID: true
      containers:
      - name: stx-centos-tools-quartzville
        image: registry.local:9001/public/stx-centos-tools-quartzville
        imagePullPolicy: Always
        stdin: true
        tty: true
        securityContext:
          privileged: true
          runAsUser: 0
          capabilities:
            add: ["NET_ADMIN", "SYS_ADMIN"]
        volumeMounts: # Mount host kernel headers in container
        - name: usrsrc
          mountPath: /usr/src/
        - name: libmodules
          mountPath: /lib/modules/
      imagePullSecrets:
        - name: regcred
      volumes:
      - name: usrsrc
        hostPath:
          path: /usr/src
      - name: libmodules
        hostPath:
          path: /lib/modules
    EOF

    # Create secret for local registry
    kubectl create secret docker-registry regcred --docker-server=registry.local:9001 --docker-username=admin --docker-password=<admin-keystone-user-password>

    # Log in local registry
    sudo docker login -u admin -p <admin-keystone-user-password> registry.local:9001

    # Tagging for local registry
    sudo docker tag stx-centos-tools-quartzville:latest registry.local:9001/public/stx-centos-tools-quartzville:latest

    # Push image to local registry
    sudo docker push registry.local:9001/public/stx-centos-tools-quartzville:latest

    # Create pod
    kubectl apply -f stx-centos-tools-quartzville.yml

    # Attach to pod
    kubectl exec -it stx-centos-tools-quartzville -- scl enable devtoolset-9 /bin/bash
    # < execute testing with quartzville tool >

-------
Cleanup
-------

After finishing executing commands on the container just run the following
commands to uninstall Quartzville driver:

.. code-block:: none

    # Inside the container
    cd TOOLS/Linux_x64/OEM_Mfg/
    ./install uninstall
    exit

    # Delete the quartzville pod
    kubectl delete pods stx-centos-tools-quartzville
