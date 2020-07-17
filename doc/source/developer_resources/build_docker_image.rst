=============================
Build StarlingX Docker Images
=============================

Building StarlingX Docker images consists of three components:

*  StarlingX base image, which provides the operating system for the
   Docker image
*  Python wheels, providing an installation source for pip when
   installing python modules via loci
*  Docker image build, using image directives files

The images are currently built using either a Docker file or via loci
(https://github.com/openstack/loci), which is an OpenStack image
builder.

.. contents::
   :local:
   :depth: 1

----------
Base image
----------

The StarlingX base image is the operating system image that provides the
base for the StarlingX Docker images. This is built using the
build-stx-base.sh tool in stx-root/build-tools/build-docker-images.

Currently, we build two base images with CentOS - one for use with
the stable build stream images, and one for the dev build stream
(bleeding edge) images:

*  The stable base image is configured with repo commands to point to
   the StarlingX build output as the source for packages to be installed
   in the images. After setting up the repo configuration, a yum upgrade
   is performed to update installed packages with versions from the
   StarlingX build, to try to align with the host OS as much as
   possible.
*  The dev base image does not point to the StarlingX build, as packages
   will come primarily from upstream sources. It currently installs
   centos-release-openstack-stein in order to add repo configuration to
   point to the Stein release, which is currently the latest available
   release.

The base image is passed into the StarlingX Docker image build command
as an argument.

Example stable build command:

::

    OS=centos
    BUILD_STREAM=stable
    BRANCH=master
    IMAGE_VERSION=${BRANCH}-${BUILD_STREAM}-${USER}
    LATEST=${BRANCH}-${BUILD_STREAM}-latest
    DOCKER_USER=${USER}
    DOCKER_REGISTRY=192.168.0.1:9001 # Some private registry you've setup for your testing, for example

    time $MY_REPO/build-tools/build-docker-images/build-stx-base.sh \
        --os ${OS} \
        --stream ${BUILD_STREAM} \
        --version ${IMAGE_VERSION} \
        --user ${DOCKER_USER} --registry ${DOCKER_REGISTRY} \
        --push \
        --latest-tag ${LATEST} \
        --repo local-stx-build,http://${HOSTNAME}:8088/${MY_WORKSPACE}/std/rpmbuild/RPMS \
        --repo stx-distro,http://${HOSTNAME}:8088/${MY_REPO}/cgcs-${OS}-repo/Binary \
        --clean

Example dev build command:

::

    OS=centos
    BUILD_STREAM=dev
    BRANCH=master
    IMAGE_VERSION=${BRANCH}-${BUILD_STREAM}-${USER}
    LATEST=${BRANCH}-${BUILD_STREAM}-latest
    DOCKER_USER=${USER}
    DOCKER_REGISTRY=192.168.0.1:9001 # Some private registry you've setup for your testing, for example

    time $MY_REPO/build-tools/build-docker-images/build-stx-base.sh \
        --os ${OS} \
        --stream ${BUILD_STREAM} \
        --version ${IMAGE_VERSION} \
        --user ${DOCKER_USER} --registry ${DOCKER_REGISTRY} \
        --push \
        --latest-tag ${LATEST} \
       --clean

If you are not making changes to any source packages (ie. RPMs) that
need to be installed in your designer-built images, you can use the
CENGN-built stx-base image. For example:
https://hub.docker.com/r/starlingx/stx-centos/tags

*  Stable base image: starlingx/stx-centos:master-stable-latest
*  Dev base image: starlingx/stx-centos:master-dev-latest

---------------
Building wheels
---------------

A wheel is a package format that provides a pre-built python module. We
collect or build a set of python modules in wheel format and store them
in a tarball, which can be passed to loci when building the StarlingX
Docker images. We have two groups of wheels in the StarlingX build:

*  Base wheels - wheels that come from upstream source
*  StarlingX wheels - wheels produced by the StarlingX build

The build-wheel-tarball.sh tool in stx-root/build-tools/build-wheels is
used to build and collect wheels and generate the wheels tarball. It
uses two sub-tools (located in the same directory) to build and/or
collect the two groups of wheels.

If you are not modifying any python modules, you can use the CENGN-built
wheels tarball:

*  Stable wheels:
   http://mirror.starlingx.cengn.ca/mirror/starlingx/master/centos/latest_docker_image_build/outputs/wheels/stx-centos-stable-wheels.tar
*  Dev wheels:
   http://mirror.starlingx.cengn.ca/mirror/starlingx/master/centos/latest_docker_image_build/outputs/wheels/stx-centos-dev-wheels.tar

***********
Base wheels
***********

The base wheels are built and/or collected by the build-base-wheels.sh
script, which is called from build-wheel-tarball.sh. It uses a Docker
file in stx-root/build-tools/build-wheels/docker to setup a
wheel-builder container and runs the docker-build-wheel.sh script. This
script uses a wheels.cfg file as input (eg. dev-wheels.cfg), which
provides a list of wheels and build/download directives. The wheels.cfg
file can specify wheel/module sources as:

*  pre-built wheel file to be downloaded
*  source git repo
*  source tarball
*  source zip

In addition, when building the “dev” wheels tarball, the
build-base-wheels.sh script will pull the loci/requirements:master-${OS}
image, extracting the wheels from that image to provide the initial set.
This allows us to keep the dev wheels tarball at the latest upstream
versions, with the exception of wheels that we explicitly build.

Example build command:

::

    OS=centos
    BUILD_STREAM=stable

    ${MY_REPO}//build-tools/build-wheels/build-wheel-tarball.sh \
        --os ${OS} \
        --stream ${BUILD_STREAM}

| This will produce a wheels tarball in your workspace:
| ${MY\_WORKSPACE}/std/build-wheels-${OS}-${BUILD\_STREAM}/stx-${OS}-${BUILD\_STREAM}-wheels.tar

****************
StarlingX wheels
****************

The StarlingX build provides support for producing python wheels during
the build. For CentOs, this means updating the package rpm specfile to
build the wheel and package it in a -wheels package. The names of the
wheels packages to be included in the tarball are listed in the
wheels.inc files in the corresponding repo (ie.
centos\_stable\_wheels.inc).

---------------
Building images
---------------

The StarlingX Docker images are built using a set of image directives
files, with the base image and wheels tarball as input. The images are
built by the build-stx-images.sh tool, in
stx-root/build-tools/build-docker-images. The build-stx-images.sh tool
will search the StarlingX repos for a corresponding docker\_images.inc
file (ie. centos\_dev\_docker\_images.inc) which contains a list of
subdirectories that contain the associated image directives files, which
are processed and built.

The following diff provides an example of changes made to a specfile to
add building a wheel to a package:

::

    diff --git a/openstack/distributedcloud-client/centos/distributedcloud-client.spec b/openstack/distributedcloud-client/centos/distributedcloud-client.spec
    index c6e17f6..7dc83f5 100644
    --- a/openstack/distributedcloud-client/centos/distributedcloud-client.spec
    +++ b/openstack/distributedcloud-client/centos/distributedcloud-client.spec
    @@ -20,6 +20,8 @@ BuildArch:     noarch

     BuildRequires: python2-devel
     BuildRequires: python-setuptools
    +BuildRequires: python2-pip
    +BuildRequires: python2-wheel
     BuildRequires: python-jsonschema >= 2.0.0
     BuildRequires: python-keystonemiddleware
     BuildRequires: python-oslo-concurrency
    @@ -75,10 +77,13 @@ rm -rf {test-,}requirements.txt tools/{pip,test}-requires
     %build
     export PBR_VERSION=%{version}
     %{__python2} setup.py build
    +%py2_build_wheel

     %install
     export PBR_VERSION=%{version}
     %{__python2} setup.py install --skip-build --root %{buildroot}
    +mkdir -p $RPM_BUILD_ROOT/wheels
    +install -m 644 dist/*.whl $RPM_BUILD_ROOT/wheels/

     # prep SDK package
     mkdir -p %{buildroot}/usr/share/remote-clients
    @@ -94,3 +99,11 @@ tar zcf %{buildroot}/usr/share/remote-clients/%{pypi_name}-%{version}.tgz --excl
     %files sdk
     /usr/share/remote-clients/%{pypi_name}-%{version}.tgz

    +%package wheels
    +Summary: %{name} wheels
    +
    +%description wheels
    +Contains python wheels for %{name}
    +
    +%files wheels
    +/wheels/*

The get-stx-wheels.sh script, called by build-wheel-tarball.sh, will
gather the set of -wheels packages, defined by the corresponding
wheels.inc files, and extract the wheel files, making them available to
the build-wheel-tarball.sh tool.

**************
Wheels tarball
**************

The build-wheel-tarball.sh tool, after successfully calling
build-base-wheels.sh and get-stx-wheels.sh, will collect the wheels
built or downloaded and prep the tarball. It will also download the
OpenStack requirements.txt and upper-constraints.txt files, which are
used by loci when installing the python modules. The
upper-constraints.txt file is modified based on the collected/built
wheels, allowing us to override or append module specifications. The
upper-constraints.txt file in the StarlingX wheels tarball then reflects
the content of the tarball, to ensure the desired module versions are
installed.

---------------
Building images
---------------

The StarlingX Docker images are built using the build-stx-images.sh
tool, in stx-root/build-tools/build-docker-images, using the image
directives files for build instructions, with the base image and wheels
as input.

**********************
Image directives files
**********************

The image directives files provide the build arguments necessary for
building a specific image. The first required option is BUILDER, which
can be either “docker” or “loci”.

^^^^^^^^
"docker"
^^^^^^^^

Images with BUILDER set to “docker” are built using a Docker file. The
only other required option in the image directives file for “docker”
builds is the LABEL, or image name (ie. stx-libvirt). The Docker file
can use the StarlingX base image as its “FROM” by including the
following at the top:

::

    ARG BASE
    FROM ${BASE}

The BASE is passed by build-stx-images.sh as a build argument.

Options supported by BUILDER=docker image directives files include:

*  LABEL: the image name
*  PROJECT: main project name
*  DOCKER\_REPO: main project source git repo
*  DOCKER\_REF: git branch or tag for main project source repo (default "master")
*  DOCKER\_PATCHES: list of patch files to apply to DOCKER\_REPO, relative to the local dir
*  DOCKER\_CONTEXT: path to build context source, relative to the local dir (default "docker")
*  DOCKER\_FILE: path to Dockerfile, relative to the local dir (default "docker/Dockerfile")

   .. note::

     DOCKER\_CONTEXT and DOCKER\_FILE are mutually exclusive to DOCKER\_REPO, DOCKER\_REF and DOCKER\_PATCHES.

For an example of a BUILDER=docker image, see
https://opendev.org/starlingx/oidc-auth-armada-app/src/branch/master/dex/centos/dex.stable_docker_image


^^^^^^
"loci"
^^^^^^

The loci project (https://github.com/openstack/loci) provides a
mechanism for building images using a python module as the main project
source. The image directives file for BUILDER=loci images allows you to
specify supporting python modules or packages to be installed, in
addition to specifying the main project source repo and/or branch. In
addition, the build-stx-images.sh supports specifying an additional
customization command that is applied to the loci-built image.

Options supported by BUILDER=loci image directives files that are passed on to
loci include:

*  LABEL: the image name
*  PROJECT: main project name
*  PROJECT\_REPO: main project source git repo
*  PROJECT\_REF: git branch or tag for main project source repo
*  PIP\_PACKAGES: list of python modules to be installed, beyond those
   specified by project dependencies or requirements
*  DIST\_PACKAGES: additional packages to be installed (eg. RPMs from
   repo, configured by base image)
*  PROFILES: bindep profiles supported by project to be installed (eg.
   apache)

In addition, you can specify a bash command in the CUSTOMIZATION option,
in order to do a modification on the loci-built image.

Example:
stx-upstream/openstack/python-nova/centos/stx-nova.dev\_docker\_image

::

    BUILDER=loci
    LABEL=stx-nova
    PROJECT=nova
    PROJECT_REPO=https://github.com/openstack/nova.git
    PIP_PACKAGES="pycrypto httplib2 pylint"
    DIST_PACKAGES="openssh-clients openssh-server libvirt e2fsprogs"
    PROFILES="fluent nova ceph linuxbridge openvswitch configdrive qemu apache"
    CUSTOMIZATION="yum install -y openssh-clients"

In a case where the image is built without a main project source git
repo, where the main project source is just coming from a wheel, you can
set PROJECT to infra, and loci skips the git clone steps. For example,
stx-nova-api-proxy:
stx-nfv/nova-api-proxy/centos/stx-nova-api-proxy.dev\_docker\_image

::

    BUILDER=loci
    LABEL=stx-nova-api-proxy
    # Set PROJECT=infra and PROJECT_REPO=nil because we are not cloning a repo
    PROJECT=infra
    PROJECT_REPO=nil
    PIP_PACKAGES="api_proxy eventlet oslo.config oslo.log \
                  paste PasteDeploy routes webob keystonemiddleware pylint"

^^^^^^^^^^^^^^^^^^^
Image build command
^^^^^^^^^^^^^^^^^^^

Example image build command, using the CENGN base image and wheels:

::

    OS=centos
    BUILD_STREAM=stable
    BRANCH=master
    CENTOS_BASE=starlingx/stx-centos:${BRANCH}-${BUILD_STREAM}-latest
    WHEELS=http://mirror.starlingx.cengn.ca/mirror/starlingx/master/centos/latest_docker_image_build/outputs/wheels//stx-centos-${BUILD_STREAM}-wheels.tar
    DOCKER_USER=${USER}
    DOCKER_REGISTRY=192.168.0.1:9001 # Some private registry you've setup for your testing, for example

    time $MY_REPO/build-tools/build-docker-images/build-stx-images.sh \
        --os centos \
        --stream ${BUILD_STREAM} \
        --base ${CENTOS_BASE} \
        --wheels ${WHEELS} \
        --user ${DOCKER_USER} --registry ${DOCKER_REGISTRY} \
        --push --latest \
        --clean

If I want to build using the wheels tarball from my build, instead:

::

    WHEELS=http://${HOSTNAME}:8088/${MY_WORKSPACE}/std/build-wheels-${OS}-${BUILD_STREAM}/stx-${OS}-${BUILD_STREAM}-wheels.tar

Note: To specify a local wheels tarball, loci needs to be able to access
it via wget from a Docker container. This could mean changes to your
http server and iptables rules to allow “external” access, to allow
access from the Docker containers.

::

    ## Note: Verify that lighttpd is not bound to "localhost"
    vi /etc/lighttpd/lighttpd.conf
    # server.bind = "localhost"
    systemctl restart lighttpd

    ## Note: You may need to add an iptables rule to allow the Docker
    ## containers to access the http server on your host. For example:
    iptables -I INPUT 6 -i docker0 -p tcp --dport ${HOST_PORT} -m state --state NEW,ESTABLISHED -j ACCEPT

If you only want to build specify images, the build-stx-images.sh
provides --only and --skip options (ie. --only stx-nova).

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Testing image on running system
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now that you've built an image, you may be wondering how to test it on
an already running system. First, locate the specific image of interest
you just built

::

    ## Note:  You may need to be root to run Docker commands on your build system.  If so, "sudo -s"
    docker images
    # Locate the image of interest you just built in the output, should be at or near the top of the list, then
    # save the image of interest as a compressed tarball.  It could be rather large. 
    docker save <image id> | gzip -9 >container_filename.tgz
    # scp container_filename.tgz to the active controller, then
    # ssh to active controller, then run the following instructions there:
    # become root:
    sudo -s
    # load the transferred container compressed tarball into the image list
    zcat container_filename.tgz | docker load
    # find the newly loaded container image in the list and make note of it
    docker images

Now that you have the container image loaded, proceed to use it for
test/debug as detailed in the `use container for
debugging <https://wiki.openstack.org/wiki/StarlingX/Containers/FAQ#How_do_I_make_changes_to_the_code_or_configuration_in_a_pod_for_debugging_purposes.3F>`_
FAQ. The next step is to tag the container before pushing it, so scroll
down to the point in the FAQ instructions where you are directed to tag
the container and continue from there.

-------------------------
Incremental image updates
-------------------------

The update-stx-image.sh utility (introduced by
https://review.opendev.org/661641) provides designers with a mechanism
to add minor updates to an existing image without rebuilding the entire
image. This results in a small customization layer appended to the
existing image, which reduces storage requirements over a full rebuild
of the entire image. The tool allows for updates via:

*  installing or updating Python modules, via:

   *  wheel file
   *  Python module source directory
   *  Python module source git repository

*  software packages (currently only supporting RPM packages on CentOS)
*  customization script: a bash script that the updater will run that
   can make necessary modifications in the image that can't be handled
   by updating software

*******************************
Specifying Python module source
*******************************

The --module-src command-line option (or MODULE\_SRC in an update
directives file) allows a designer to specify python module source from
either a directory or git repository. If specifying a git repository,
you can also specify a branch or tag to be fetched, as well as
optionally hardcode a version number. For example:

`` --module-src ``\ “```https://github.com/starlingx-staging/stx-nova|stx/stein.1`` <https://github.com/starlingx-staging/stx-nova%7Cstx/stein.1>`__”

This will clone the stx-nova repo and fetch/checkout the stx/stein.1
branch, installing or updating the python module in the image.

********************
Customization script
********************

You can optionally provide a customization script to make changes to the
image that cannot be handled by updating software, using the --customize
command-line option (or CUSTOMIZATION\_SCRIPT in an update directives
file). You can also provide supporting files with the --extra
command-line option (or EXTRA\_FILES in an update directives file),
which will be accessible to the customization script in the
/image-update/extras directory within the update container.

**********************
Update directives file
**********************

You can optionally specify an updates directives file with the --file
command-line option to provide the various update directives. Options
that can be set from the update directives file include:

::

    FROM= # Specify the base image (equivalent to --from)
    IMAGE_UPDATE_VER= # Specify image update version (equivalent to --version)
    CUSTOMIZATION_SCRIPT= # Specify customization script (equivalent to --customize)
    WHEELS= # Specify one or more wheel files (equivalent to --wheel)
    DIST_PACKAGES= # Specify one or more software packages (equivalent to --pkg)
    MODULE_SRC= # Specify one or more python module source locations (equivalent to --module-src)
    EXTRA_FILES= # Specify one or more extra files to be accessible to customization script (equivalent to --extra)

********
Examples
********

::

    ## Upstream image:
    CENGN_DOCKER_URL="http://mirror.starlingx.cengn.ca/mirror/starlingx/master/centos/latest_docker_image_build/outputs/docker-images"
    DOCKER_USER=mydockerid # My docker ID
    DOCKER_REGISTRY=docker.io # The docker registry to use for pushing. This can be a private registry, like 192.168.2.10:9001

    # For this example, I've setup a directory with files I'm using for updates,
    # under ${MY_WORKSPACE}/updates:
    #
    # updates/pip-packages/modules/aodh - a git clone of upstream aodh, where I've made changes
    # updates/pip-packages/wheels - a directory with multiple wheel files
    # updates/dist-packages - a directory with multiple RPM files
    #
    # Additionally, there's a basic updates/customize.sh bash script that creates
    # a couple of files in /etc:
    #
    # #!/bin/bash
    #
    # # Sample
    # echo example-update > /etc/example-update.txt
    # find /image-update > /etc/example-update-dirlst.txt
    #

    # Get the latest versioned stx-aodh image tag
    STX_AODH=$(curl ${CENGN_DOCKER_URL}/images-centos-stable-versioned.lst 2>/dev/null | grep stx-aodh:)
    echo ${STX_AODH}

    BASE_VERSION=$(echo ${STX_AODH} | sed 's/.*://')


    # For the purposes of the first few examples, each update builds on the previous one.
    # So the --from argument points to the image built in the previous step (or .0 in the first case)

    # Build the first update using the customization script and a couple of random files
    time bash -x ${MY_REPO}/build-tools/build-docker-images/update-stx-image.sh \
        --user ${DOCKER_USER} --registry ${DOCKER_REGISTRY} \
        --from ${STX_AODH} \
        --customize ${MY_WORKSPACE}/updates/customize.sh \
        --extra ${MY_REPO}/build-tools/build-docker-images/build-stx-base.sh \
        --extra ${MY_REPO}/build-tools/build-wheels/build-base-wheels.sh \
        --push \
        --update-id example.1

    # To see the content of one of the files created by the customization script:
    # $ docker run --rm \
    #     ${DOCKER_REGISTRY}/${DOCKER_USER}/stx-aodh:${BASE_VERSION%.0}.1 \
    #     cat /etc/example-update-dirlst.txt
    # /image-update
    # /image-update/internal-update-stx-image.sh
    # /image-update/customize.sh
    # /image-update/extras
    # /image-update/extras/build-base-wheels.sh
    # /image-update/extras/build-stx-base.sh

    # To see the size of the customization layer we just added to the image
    # $ docker history ${DOCKER_REGISTRY}/${DOCKER_USER}/stx-aodh:${BASE_VERSION%.0}.1 | head -2
    # IMAGE                                 CREATED             CREATED BY                                      SIZE                COMMENT
    # 8735dde77f9c                          3 minutes ago       bash -x -c  bash -x /image-update/internal-u…   201B


    # Install/update wheels from the directory we've setup:
    time bash -x ${MY_REPO}/build-tools/build-docker-images/update-stx-image.sh \
        --user ${DOCKER_USER} --registry ${DOCKER_REGISTRY} \
        --from ${DOCKER_REGISTRY}/${DOCKER_USER}/stx-aodh:${BASE_VERSION%.0}.1 \
        --wheel "${MY_WORKSPACE}/updates/pip-packages/wheels/*.whl" \
        --push \
        --update-id example.2

    # We can now do a diff of the piplst files from the updates and verify the change (which can also be seen in output of the tool):
    # $ diff std/update-images/example.1/stx-aodh-${BASE_VERSION%.0}.1.piplst std/update-images/example.2/stx-aodh-${BASE_VERSION%.0}.2.piplst
    # 14a15
    # > cgcs-patch==1.0
    # 130a132
    # > tsconfig==1.0.0


    # Update the aodh module from the dir we cloned and modified:
    time bash -x ${MY_REPO}/build-tools/build-docker-images/update-stx-image.sh \
        --user ${DOCKER_USER} --registry ${DOCKER_REGISTRY} \
        --from ${DOCKER_REGISTRY}/${DOCKER_USER}/stx-aodh:${BASE_VERSION%.0}.2 \
        --module-src ${MY_WORKSPACE}/updates/pip-packages/modules/aodh \
        --push \
        --update-id example.3

    # We can now do a diff of the piplst files from the updates and verify the change (which can also be seen in output of the tool):
    # $ diff std/update-images/example.2/stx-aodh-${BASE_VERSION%.0}.2.piplst std/update-images/example.3/stx-aodh-${BASE_VERSION%.0}.3.piplst
    # 3c3
    # < aodh==8.0.1.dev4
    # ---
    # > aodh==8.1.0.dev28


    # Install/update RPMs from the dir we setup:
    time bash -x ${MY_REPO}/build-tools/build-docker-images/update-stx-image.sh \
        --user ${DOCKER_USER} --registry ${DOCKER_REGISTRY} \
        --from ${DOCKER_REGISTRY}/${DOCKER_USER}/stx-aodh:${BASE_VERSION%.0}.3 \
        --pkg "${MY_WORKSPACE}/updates/dist-packages/*.rpm" \
        --push \
        --update-id example.4

    # We can now do a diff of the piplst files from the updates and verify the change (which can also be seen in output of the tool):
    # $ diff std/update-images/example.3/stx-aodh-${BASE_VERSION%.0}.3.rpmlst std/update-images/example.4/stx-aodh-${BASE_VERSION%.0}.4.rpmlst
    # 156a157
    # > perl-Data-Dumper-2.145-3.el7.x86_64


    # All of the above can also be done in a single command:
    time bash -x ${MY_REPO}/build-tools/build-docker-images/update-stx-image.sh \
        --user ${DOCKER_USER} --registry ${DOCKER_REGISTRY} \
        --from ${STX_AODH} \
        --wheel "${MY_WORKSPACE}/updates/pip-packages/wheels/*.whl" \
        --pkg "${MY_WORKSPACE}/updates/dist-packages/*.rpm" \
        --module-src ${MY_WORKSPACE}/updates/pip-packages/modules/aodh \
        --customize ${MY_WORKSPACE}/updates/customize.sh \
        --extra ${MY_REPO}/build-tools/build-docker-images/build-stx-base.sh \
        --extra ${MY_REPO}/build-tools/build-wheels/build-base-wheels.sh



    # Update stx-nova with the latest update from the stx-nova staging repo

    STX_NOVA=$(curl ${CENGN_DOCKER_URL}/images-centos-stable-versioned.lst 2>/dev/null | grep stx-nova:)
    echo ${STX_NOVA}

    time bash -x ${MY_REPO}/build-tools/build-docker-images/update-stx-image.sh \
        --user ${DOCKER_USER} --registry ${DOCKER_REGISTRY} \
        --from ${STX_NOVA} \
        --module-src "https://github.com/starlingx-staging/stx-nova.git|stx/stein.1" \
        --update-id example.nova
