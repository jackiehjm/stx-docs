.. _vran-tools-2c3ee49f4b0b:

==========
vRAN Tools
==========

The |vRAN| tools consist of the following open-source packages that are delivered
in the container image starlingx/stx-debian-tools-dev:|v_starlingx-stx-debian-tools-dev|. For more
detailed information on the tools packages, click the hyperlink on the
package names, which will lead you to the Debian Bullseye package information
web page https://packages.debian.org/bullseye/<package name>.

-   `dmidecode
    <https://packages.debian.org/bullseye/dmidecode>`__

-   `net-tools
    <https://packages.debian.org/bullseye/net-tools>`__:
    includes ``arp``, ``ifconfig``, ``netstat``, ``nameif``, ``route``, ``mii-tool``, ``iptunnel``, ``ipmaddr``, etc.

-   `iproute2
    <https://packages.debian.org/bullseye/iproute2>`__:
    includes the network tools ``arpd``, ``ip``, ``nstat``, ``ss``, and others.

-   `ethtool
    <https://packages.debian.org/bullseye/ethtool>`__

-   `tcpdump
    <https://packages.debian.org/bullseye/tcpdump>`__

-   `linux-cpupower
    <https://packages.debian.org/bullseye/linux-cpupower>`__

-   `trace-cmd
    <https://packages.debian.org/bullseye/trace-cmd>`__

-   `OPAE Tools
    <https://opae.github.io/1.3.0/>`__:
    includes ``fpgainfo``, ``fpgabist``, among other ``Field Programmable Gate Array`` tools.

-   `ACPICA Tools
    <https://packages.debian.org/bullseye/acpica-tools>`__:
    includes ``acpidump``, ``acpixtract``, and other ``ACPI Component Architecture`` tools.

-   `PCM Tools
    <https://github.com/opcm/pcm>`__: includes ``pcm``, and other ``Processor Counter Monitor`` tools.

You can launch this container image in a Kubernetes pod and ``exec`` into a shell
in the container in order to execute the commands. The Kubernetes pod must run
in a privileged and host context, such that the above tools provide information
on resources in the host context.

The suggested yaml manifest to launch the ``stx-debian-tools-dev`` container is
as follows:

.. parsed-literal::

    # Creating the Kubernetes Deployment
    cat << EOF > stx-debian-tools-dev.yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: stx-debian-tools-dev
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: stx-debian-tools-dev
      template:
        metadata:
          labels:
            app: stx-debian-tools-dev
        spec:
          containers:
          - name: stx-debian-tools-dev
            image: docker.io/starlingx/stx-debian-tools-dev:|v_starlingx-stx-debian-tools-dev|
            imagePullPolicy: Always
            stdin: true
            tty: true
            securityContext:
              # processes in privileged containers are essentially equivalent to root on the host
              privileged: true
              capabilities:
                # add capabilities https://man7.org/linux/man-pages/man7/capabilities.7.html
                add: ["NET_ADMIN", "SYS_ADMIN"]
              runAsUser: 0  # run as root
            volumeMounts:
            - mountPath: /tmp
              name: tmp-volume
          volumes:
          - name: tmp-volume
            hostPath:
              path: /tmp
              type: Directory
          # Use host ipc ns [https://man7.org/linux/man-pages/man7/ipc_namespaces.7.html]
          hostIPC: true
          # Use host network ns [https://www.man7.org/linux/man-pages/man7/network_namespaces.7.html]
          hostNetwork: true
          # Use host pid ns [https://man7.org/linux/man-pages/man7/pid_namespaces.7.html]
          hostPID: true
    EOF

For example:

.. code-block:: none

    # Create pod
    $ kubectl apply -f stx-debian-tools-dev.yaml

    # Get the running pods
    $ kubectl get pods
    NAME                               READY   STATUS    RESTARTS   AGE
    stx-debian-tools-dev-xxxx-xxxx     1/1     Running   0          6s

Then ``exec`` into shell in container:

.. code-block:: none

    $ STX_DEBIAN_TOOLS_DEV=$(kubectl get pods | grep '^stx-debian-tools-dev' | awk '/Running/ {print $1}')

    $ echo $STX_DEBIAN_TOOLS_DEV
    stx-debian-tools-dev-xxxx-xxxx

    $ kubectl exec -it $STX_DEBIAN_TOOLS_DEV -- bash

-------------------------------------------
Build, deploy and run non-open-source tools
-------------------------------------------

The starlingx/stx-debian-tools-dev:|v_starlingx-stx-debian-tools-dev| container image also
contains development tools.

Using this container image as a Dockerfile base image enables |prod| users to
build a custom container image for building and installing custom or non-opensource
tools on |prod| target.

For example, this can be used for running the non-opensource Intel Quartzville
tools. The necessary (open-source) Intel iqvlinux driver is already pre-installed
in |prod| for Debian. Quartzville is available at:
`https://designintools.intel.com/product_p/stlgrn108.htm
<https://designintools.intel.com/product_p/stlgrn108.htm>`__. Contact Intel if
you need access.

You can create and build a container to run Quartzville tools on Kubernetes as
follows:

.. parsed-literal::

    # Creating the Dockerfile
    cat << EOF > Dockerfile
    FROM docker.io/starlingx/stx-debian-tools-dev:|v_starlingx-stx-debian-tools-dev|

    USER root
    WORKDIR /root
    COPY 348742_Quartzville_Tools_637987.zip /root/quartzville.zip

    # Install Quartzville Tools
    # ATTENTION: There is a known issue in celo64e that crashes the host.
    # The issue might affect nvmupdate64e as well.
    # Only eeupdate64e and lanconf64e are supported in this release.
    RUN set -ex && \
        unzip quartzville.zip \
          "TOOLS/Linux_x64/*" \
          "TOOLS/DOCS/*" \
          "TOOLS/*.txt" \
          "TOOLS/*.pdf" \
          -d quartzville && \
        cd quartzville/TOOLS/Linux_x64/OEM_Mfg && \
        rm -f celo64e nvmupdate64e && \
        install -t /usr/local/bin/ \
          eeupdate64e \
          ../SVTools/lanconf64e && \
        cd - && \
        rm quartzville.zip

    # Enable the ll alias for convenience (optional)
    RUN set -ex && \
        sed -i 's/# alias ll=/alias ll=/' ~/.bashrc

    CMD echo 'Press Ctrl-C to exit'; \
        sleep infinity
    EOF

    # Building the container image with Quartzville
    sudo docker build -t stx-debian-tools-quartzville .

    # Test container (optional)
    sudo docker run -it --rm --privileged \
      -v /usr/src/:/usr/src \
      -v /lib/modules:/lib/modules \
      --name stx-debian-tools-quartzville stx-debian-tools-quartzville

    # Create kubernetes POD
    cat << EOF > stx-debian-tools-quartzville.yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: stx-debian-tools-quartzville
    spec:
      hostNetwork: true
      hostPID: true
      containers:
      - name: stx-debian-tools-quartzville
        image: registry.local:9001/public/stx-debian-tools-quartzville
        imagePullPolicy: Always
        stdin: true
        tty: true
        securityContext:
          privileged: true
          runAsUser: 0
          capabilities:
            add: ["NET_ADMIN", "SYS_ADMIN"]
        volumeMounts: # Mount the host linux headers directory as a volume in the container
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
    kubectl create secret docker-registry regcred --docker-server=registry.local:9001 \
      --docker-username=admin --docker-password=<admin-keystone-user-password>

    # Log in local registry
    sudo docker login registry.local:9001 -u admin -p <admin-keystone-user-password>

    # Tagging for local registry
    sudo docker tag stx-debian-tools-quartzville:latest \
      registry.local:9001/public/stx-debian-tools-quartzville:latest

    # Push image to local registry
    sudo docker push registry.local:9001/public/stx-debian-tools-quartzville:latest

    # Create pod
    kubectl apply -f stx-debian-tools-quartzville.yaml

    # Check POD status
    kubectl -n default get pods

    # Attach to pod
    kubectl exec -it stx-debian-tools-quartzville -- /bin/bash
