=====================
StarlingX Build Guide
=====================

This section describes the steps for building an ISO image from a StarlingX
R3.0 and earlier release.

.. contents::
   :local:
   :depth: 1

.. _Requirements:

------------
Requirements
------------

*********************
Hardware requirements
*********************

A workstation computer with:

* Processor: x86_64 is the only supported architecture
* Memory: At least 32GB RAM
* Hard Disk: 500GB HDD
* Network: Network adapter with active Internet connection

*********************
Software requirements
*********************

A workstation computer with:

* Operating System: Ubuntu 16.04 LTS 64-bit
* Docker
* Android Repo Tool
* Proxy settings configured, if required (See
  http://lists.starlingx.io/pipermail/starlingx-discuss/2018-July/000136.html for more details)
* Public SSH key

.. _Development-environment-setup:

-----------------------------
Development environment setup
-----------------------------

This section describes how to set up a StarlingX development system on a
workstation computer. After completing these steps, you can build a StarlingX
ISO image on the following Linux distribution:

* Ubuntu 16.04 LTS 64-bit

****************************
Update your operating system
****************************

Before proceeding with the build, ensure your Ubuntu distribution is up to date.
You first need to update the local database list of available packages:

::

  sudo apt-get update

******************************************
Installation requirements and dependencies
******************************************

#. Set up <user>.

   Make sure you are a non-root user with sudo privileges enabled when you build
   the StarlingX ISO.

   Use either your existing user or create a separate *<user>*:

   ::

     sudo useradd -s /bin/bash -d /home/<user> -m -G sudo <user>
     sudo passwd <user>
     sudo su - <user>


#. Set up Git.

   Install the required Git packages on the Ubuntu host system:

   ::

     sudo apt-get install make git curl

   Set up your identity in git using your actual name and email address:

   ::

     git config --global user.name "Name LastName"
     git config --global user.email "Email Address"


#. Install the required Docker CE packages in the Ubuntu host system.

   See
   `Get Docker CE for Ubuntu <https://docs.docker.com/install/linux/docker-ce/ubuntu/#os-requirements>`__ for more information.

   Make sure to log out and log in to add your *<user>* to the Docker group:

   ::

     sudo usermod -aG docker <user>

#. Install the Android Repo Tool in the Ubuntu host system.

   Follow the steps in the
   `Installing Repo <https://source.android.com/setup/build/downloading#installing-repo>`__
   section.

**********************
Install public SSH key
**********************

Follow these instructions on GitHub to
`Generate a Public SSH Key <https://help.github.com/articles/connecting-to-github-with-ssh>`__.
Then upload your public key to your GitHub and Gerrit account profiles:

* `Upload to Github <https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account>`__

* `Upload to Gerrit <https://review.opendev.org/#/settings/ssh-keys>`__

*********************
Install tools project
*********************

#. Under your $HOME directory, clone the <tools> project:

   ::

     cd $HOME
     git clone https://opendev.org/starlingx/tools.git

   The command above fetches the tools project from the latest master. Use the
   commands below to switch to the tools project for STX3.0 and STX2.0 respectively.

   ::

     git checkout remotes/origin/r/stx.3.0
     git checkout remotes/origin/r/stx.2.0

#. Navigate to the *<$HOME/tools>* project
   directory:

   ::

     cd $HOME/tools/

.. _Prepare_the_base_Docker_image:

-----------------------------
Prepare the base Docker image
-----------------------------

StarlingX base Docker image handles all steps related to StarlingX ISO
creation. This section describes how to customize the base Docker image
building process.

********************
Configuration values
********************

You can customize values for the StarlingX base Docker image using a
text-based configuration file named ``localrc``:

* ``HOST_PREFIX`` points to the directory that hosts the 'designer'
  subdirectory for source code, the 'loadbuild' subdirectory for the build
  environment, generated RPMs, and the ISO image. Best practices dictate
  creating the workspace directory in your $HOME directory.
* ``HOST_MIRROR_DIR`` points to the directory that hosts the CentOS mirror
  repository.

^^^^^^^^^^^^^^^^^^^^^^^^^^
localrc configuration file
^^^^^^^^^^^^^^^^^^^^^^^^^^

Create your ``localrc`` configuration file. Make sure to set the project and
the user name. For example:

::

       # tbuilder localrc
       MYUNAME=<your user name>
       PROJECT=<project name>
       HOST_PREFIX=$HOME/starlingx/workspace
       HOST_MIRROR_DIR=$HOME/starlingx/mirror

***************************
Build the base Docker image
***************************

Once the ``localrc`` configuration file has been customized, it is time
to build the base Docker image.

#. If necessary, you might have to set http/https proxy in your
   Dockerfile before building the docker image:

   ::

      ENV http_proxy " http://your.actual_http_proxy.com:your_port "
      ENV https_proxy " https://your.actual_https_proxy.com:your_port "
      ENV ftp_proxy " http://your.actual_ftp_proxy.com:your_port "
      ENV no_proxy "127.0.0.1"
      RUN echo " proxy=http://your-proxy.com:port " >> /etc/yum.conf

#. The ``tb.sh`` script automates the base Docker image build:

   ::

     ./tb.sh create

----------------------------------
Build the CentOS mirror repository
----------------------------------

The creation of the StarlingX ISO relies on a repository of RPM binaries,
RPM sources, and tar compressed files. This section describes how to build
this CentOS mirror repository.

.. _Run_building_Docker_container:

*****************************
Run building Docker container
*****************************

#. Navigate to the *$HOME/tools/* project
   directory:

   ::

     cd $HOME/tools/

#. Verify environment variables:

   ::

     bash tb.sh env

#. Run the building Docker container:

   ::

     bash tb.sh run

#. Execute the building Docker container:

   ::

     bash tb.sh exec

*********************************
Download source code repositories
*********************************

#. Inside the building Docker container, start the internal environment:

   ::

     eval $(ssh-agent)
     ssh-add

#. Use the repo tool to create a local clone of the manifest
   Git repository based on the "master" branch:

   ::

     cd $MY_REPO_ROOT_DIR
     repo init -u https://opendev.org/starlingx/manifest -m default.xml


   Optionally, specify a specific branch to clone, for example the R2.0 release
   branch:

   ::

     cd $MY_REPO_ROOT_DIR
     repo init -u https://opendev.org/starlingx/manifest -m default.xml -b r/stx.2.0

#. Synchronize the repository:

   ::

     repo sync -j`nproc`

*****************
Download packages
*****************

#. Inside the Docker container, enter the following commands to download
   the required packages to populate the CentOS mirror repository:

   ::

     cd  $MY_REPO_ROOT_DIR/stx-tools/centos-mirror-tools && bash download_mirror.sh

#. Monitor the download of packages until it is complete. When the download
   is complete, the following message appears:

   ::

     step #5: done successfully
     sudo rm -rf /tmp/stx_mirror_vyPozw
     IMPORTANT: The following 3 files are just bootstrap versions. Based on them, the workable images
     for StarlingX could be generated by running "update-pxe-network-installer" command after "build-iso"
         - ./output/stx/CentOS/Binary/LiveOS/squashfs.img
         - ./output/stx/CentOS/Binary/images/pxeboot/initrd.img
         - ./output/stx/CentOS/Binary/images/pxeboot/vmlinuz totally 17 files are downloaded!

***************
Verify packages
***************

#. Verify no missing or failed packages exist:

   ::

      cat logs/*_missing_*.log
      cat logs/*_failmoved_*.log

#. In case missing or failed packages do exist, which is usually caused by
   network instability (or timeout), you need to download the packages
   manually.
   Doing so assures you get all RPMs listed in
   *rpms_3rdparties.lst*/*rpms_centos.lst*/*rpms_centos3rdparties.lst*.

******************
Packages structure
******************

The following is a general overview of the packages structure resulting from
downloading the packages:

::

   /localdisk/designer/<user>/<project>/stx-tools/centos-mirror-tools/output
   .
   └── stx
       └── CentOS
           ├── Binary
           │   ├── EFI
           │   │   └── BOOT
           │   │       └── fonts
           │   ├── images
           │   │   └── pxeboot
           │   ├── isolinux
           │   ├── LiveOS
           │   ├── noarch
           │   └── x86_64
           ├── downloads
           │   ├── integrity
           │   │   ├── evm
           │   │   └── ima
           │   └── puppet
           │       └── packstack
           │           └── puppet
           │               └── modules
           └── Source

*******************************
Copy CentOS mirror repository
*******************************

Exit from the building Docker container. Run the following commands:

#. Change the mirror folder owner to the current user and create CentOS folder
   using the commands below:

   ::

     sudo chown $USER: $HOME/starlingx/mirror
     mkdir -p $HOME/starlingx/mirror/CentOS/
     chmod -R ug+w $HOME/starlingx/mirror

#. Copy the built CentOS mirror repository *$HOME/starlingx/mirror/*
   workspace directory:

   ::

      cp -r $HOME/starlingx/workspace/localdisk/designer/<user>/<project>/stx-tools/centos-mirror-tools/output/stx $HOME/starlingx/mirror/CentOS/

.. _create_stx_pkgs:

-------------------------
Create StarlingX packages
-------------------------

#. Login to the container using the command below:

   ::

    cd $HOME/tools/
    ./tb.sh exec

#. Create a tarballs repository:

   ::

     ln -s /import/mirrors/CentOS/stx/CentOS/downloads/ $MY_REPO/stx/

   Alternatively, you can run the "populate_downloads.sh" script to copy
   the tarballs instead of using a symlink:

   ::

     populate_downloads.sh /import/mirrors/CentOS/stx/CentOS/

   Outside the container

#. Exit from the container. On the host machine, create mirror binaries:

   ::

     mkdir -p $HOME/starlingx/mirror/CentOS/stx-installer
     cp $HOME/starlingx/mirror/CentOS/stx/CentOS/Binary/images/pxeboot/initrd.img $HOME/starlingx/mirror/CentOS/stx-installer/initrd.img
     cp $HOME/starlingx/mirror/CentOS/stx/CentOS/Binary/images/pxeboot/vmlinuz $HOME/starlingx/mirror/CentOS/stx-installer/vmlinuz
     cp $HOME/starlingx/mirror/CentOS/stx/CentOS/Binary/LiveOS/squashfs.img $HOME/starlingx/mirror/CentOS/stx-installer/squashfs.img

**************
Build packages
**************

#. Enter the StarlingX container using below command:

   ::

     cd $HOME/tools/
     ./tb.sh exec

#. **Temporal!** Build-Pkgs Errors. Be prepared to have some missing /
   corrupted rpm and tarball packages generated during
   `Build the CentOS Mirror Repository`_, which will cause the next step
   to fail. If that step does fail, manually download those missing /
   corrupted packages.

#. Update the symbolic links:

   ::

     cd $MY_REPO_ROOT_DIR/stx-tools/toCOPY
     bash generate-local-repo.sh /import/mirrors/CentOS/stx/CentOS/

#. Build the packages:

   ::

     build-pkgs

#. **Optional!** Generate local-repo:

   While this step is optional, it improves performance on subsequent
   builds. The local-repo has the dependency information that
   sequences the build order. To generate or update the information, you
   need to execute the following command after building modified or new
   packages.

   ::

     generate-local-repo.sh

-------------------
Build StarlingX ISO
-------------------

Build the image:

::

  build-iso

.. _Build-installer:

---------------
Build installer
---------------

To get your StarlingX ISO ready to use, you must create the initialization
files used to boot the ISO, additional controllers, and worker nodes.

**NOTE:** You only need this procedure during your first build and
every time you upgrade the kernel.

After running "build-iso", run:

::

  build-pkgs --installer

This builds *rpm* and *anaconda* packages. Then run:

::

  update-pxe-network-installer

The *update-pxe-network-installer* covers the steps detailed in
*$MY_REPO/stx/metal/installer/initrd/README*. This script creates three files on
*/localdisk/loadbuild/<user>/<project>/pxe-network-installer/output*.

::

   new-initrd.img
   new-squashfs.img
   new-vmlinuz

Rename the files, as the file system is read only in the container, exit from
the container and follow the commands below to rename the files:


::

   cd $HOME/starlingx/workspace/localdisk/loadbuild/<user>/<project>/pxe-network-installer/output
   sudo mv new-initrd.img initrd.img
   sudo mv new-squashfs.img squashfs.img
   sudo mv new-vmlinuz vmlinuz

Two ways exist for using these files:

#. Store the files in the */import/mirrors/CentOS/stx-installer/* folder for
   future use. Follow the commands below to store files:

   ::

     cp -r $HOME/starlingx/workspace/localdisk/loadbuild/<user>/<project>/pxe-network-installer/output/* $HOME/starlingx/mirror/CentOS/stx-installer/
#. Store the files in an arbitrary location and modify the
   *$MY_REPO/stx/metal/installer/pxe-network-installer/centos/build_srpm.data*
   file to point to these files.

Enter the StarlingX container, recreate the *pxe-network-installer* package, and
rebuild the image using the commands below:

::

  cd $HOME/tools/
  ./tb.sh exec
  build-pkgs --clean pxe-network-installer
  build-pkgs pxe-network-installer
  build-iso

Your ISO image should be able to boot.

****************
Additional notes
****************

* In order to get the first boot working, this complete procedure needs to be
  done. However, once the init files are created, these can be stored in a shared location where different developers can make use of them. Updating these files
  is not a frequent task and should be done whenever the kernel is upgraded.
* StarlingX is in active development.  Consequently, it is possible that a
  future version will change to a more generic solution.

.. _Build-stx-openstack-app:

-------------------------------------
Build StarlingX OpenStack application
-------------------------------------

Use the following command:

::

  $MY_REPO_ROOT_DIR/cgcs-root/build-tools/build-helm-charts.sh

---------------
Build avoidance
---------------

The foundational principle of build avoidance is that it is faster to download
the rpms than it is to build them. This typically true when the host for
reference builds and the consumer are close to each other and share a high speed
link. It is not practical for ``mirror.starlingx.cengn.ca`` to serve as a
provider of reference builds for the world. The real goal is for a corporate
office to have a provider of reference builds to the designers within their
corporate network.

.. contents::
   :local:
   :depth: 1

*******
Purpose
*******

Build avoidance can greatly reduce build times after using ``repo`` to synchronize a local repository
with an upstream source (i.e. ``repo sync``). Build avoidance works well for
designers working within a regional office. Starting from a new workspace,
``build-pkgs`` typically requires three or more hours to complete. Build
avoidance can reduce this step to approximately 20 minutes.

***********
Limitations
***********

* Little or no benefit for designers who refresh a pre-existing workspace at
  least daily (e.g. download_mirror.sh, repo sync, generate-centos-repo.sh, build-pkgs, build-iso). In these cases, an incremental build (i.e. reuse of
  same workspace without a :command:`build-pkgs --clean`) is often just as
  efficient.
* Not likely to be useful to solo designers, or teleworkers that wish to compile
  on using their home computers. Build avoidance downloads build artifacts from a reference build, and WAN speeds are generally too slow.

************************
Reference build overview
************************

* A server in the regional office performs regular (e.g. daily) automated
  builds using existing methods. These builds are called *reference builds*.
* The builds are timestamped and preserved for some time (i.e. a number of weeks).
* A build CONTEXT, which is a file produced by ``build-pkgs`` at location
  ``$MY_WORKSPACE/CONTEXT``, is captured. It is a bash script that can cd to
  each and every Git and check out the SHA that contributed to the build.
* For each package built, a file captures the md5sums of all the source code
  inputs required to build that package. These files are also produced by
  ``build-pkgs`` at location ``$MY_WORKSPACE//rpmbuild/SOURCES//srpm_reference.md5``.
* All these build products are accessible locally (e.g. a regional office)
  using ``rsync``.

  .. Note::

      Other protocols can be added later.

On the reference builds side:

* Build contexts of all builds are collected into a common directory.
* Context files are prefixed by the build time stamp allowing chronological traversal of the files.

On the consumer side:

* The set of available reference build context are downloaded.
* Traverse the set of available build contexts from newest to oldest.

  * If all SHA of all gits in a candidate reference build are also present in the local git context, stop traversal and use this reference build.

  * If selected reference build is newer than the last (if any) reference build that was downloaded, then download the selected build context, else do nothing.


*************
Prerequisites
*************


* Reference build server data file

  * Data file describing your reference build server is required in the location
    ``$MY_REPO/local-build-data/build_avoidance_source``. (This file is not
    supplied by the StarlingX gits.)

  * Required fields and hypothetical values for the data file include:

    ::

       BUILD_AVOIDANCE_DATE_FORMAT="%Y%m%d"
       BUILD_AVOIDANCE_TIME_FORMAT="%H%M%S"
       BUILD_AVOIDANCE_DATE_TIME_DELIM="T"
       BUILD_AVOIDANCE_DATE_TIME_POSTFIX="Z"
       BUILD_AVOIDANCE_DATE_UTC=0

       BUILD_AVOIDANCE_FILE_TRANSFER="rsync"

       BUILD_AVOIDANCE_USR="jenkins"
       BUILD_AVOIDANCE_HOST="my-builder.my-company.com"
       BUILD_AVOIDANCE_DIR="/localdisk/loadbuild/jenkins/master"

* Reference build server requirements

  * The reference build server should build regularly, e.g. daily.
  * The ``MY_WORKSPACE`` variable set prior to a reference build follows the format:

    ::

      TIMESTAMP=$(date +${BUILD_AVOIDANCE_DATE_FORMAT}${BUILD_AVOIDANCE_DATE_TIME_DELIM}${BUILD_AVOIDANCE_TIME_FORMAT}${BUILD_AVOIDANCE_DATE_TIME_POSTFIX})
      export MY_WORKSPACE=${BUILD_AVOIDANCE_DIR}/${TIMESTAMP}

  * Builds should be preserved for a useful period of time.  e.g. at least two weeks.

  * The reference build server is configured to accept rsync requirements. It
    serves files under the ``BUILD_AVOIDANCE_DIR`` directory, which is
    ``/localdisk/loadbuild/jenkins/master`` in this example.

***********************************
Download a selected reference build
***********************************

The list of artifacts to download is captured in the datafile
``$MY_REPO/build-data/build_avoidance_source``.

The following paths are relative to ``$MY_WORKSPACE/$BUILD_TYPE``

::

  BUILD_AVOIDANCE_SRPM_DIRECTORIES="inputs srpm_assemble rpmbuild/SRPMS rpmbuild/SOURCES"
  BUILD_AVOIDANCE_SRPM_FILES=""
  BUILD_AVOIDANCE_RPM_DIRECTORIES="results rpmbuild/RPMS rpmbuild/SPECS repo/local-repo/dependancy-cache"
  BUILD_AVOIDANCE_RPM_FILES=".platform_release"

Details of the files and directories downloaded include:

* ``inputs`` = Working directory used to assemble srpms from git or tarball
* ``srpm_assemble`` = Working directory used to assemble srpms from upstream
  srpms
* ``rpmbuild/SRPMS`` = Assembled stx src.rpms to build
* ``rpmbuild/SOURCES`` = Additional per package metadata data collected to
  support build avoidance
* ``rpmbuild/SOURCES/<package-name>/srpm_reference.md5`` = md5sums of all files
  that go into building the STX src.rpm
* ``results`` = Per package build logs and artifacts generated by mockchain
* ``rpmbuild/RPMS`` = Build RPMs
* ``rpmbuild/SPECS`` = Spec files of build RPMs
* ``repo/local-repo/dependancy-cache`` = build-pkgs data summarizing:

  * The 'Requires' of RPMs
  * The 'BuildRequires' of src.rpms
  * Which RPMs are derived from which src.rpms
*  ``.platform_release`` = Platform release value

On the reference builds side, the only extra step to support build avoidance is
to generate ``rpmbuild/SOURCES/<package-name>/srpm_reference.md5`` files.

On the consumer side, for each build type:

* For each file or subdirectory listed in
  ``$MY_REPO/build-data/build_avoidance_source``, ``rsync`` the file or
  directory with options to preserve the file time stamp.

*********************
Build tool operations
*********************

The build tools automatically perform the tasks described below. There are no
required configuration steps for setting up reference builds and no actions for
consuming reference builds.

For each build type and for each package, build src.rpms:

* Generate a list of input files for the current package.
* Generate a srpm_reference.md5 file for the current inputs.
* Compare srpm_reference.md5 files for current and reference builds. If
  differences are found (list of files, or md5sum of those files), then rebuild
  this src.rpm.

For each build type, for each package, and for the list of RPMs built by
src.rpm:

* If rpm is missing, must rebuild package.
* If rpm is wrong version, must rebuild package.
* If rpm older than src.rpm, must rebuild package.

  .. Note::

      Assumes reference build and consumer are on NTP time, and any drift is
      well below the download time for the reference build.

****************
Designer actions
****************

* Request a build avoidance build. Recommended after you have
  synchronized the repository using ``repo sync`` as shown below:

  ::

    repo sync
    generate-centos-repo.sh
    populate_downloads.sh
    build-pkgs --build-avoidance

* Use combinations of additional arguments, environment variables, and a
  configuration file unique to the regional office to specify an URL
  to the reference builds.

* Using a configuration file to specify the location of your reference build:

  ::

     mkdir -p $MY_REPO/local-build-data

     cat <<- EOF > $MY_REPO/local-build-data/build_avoidance_source
     # Optional, these are already the default values.
     BUILD_AVOIDANCE_DATE_FORMAT="%Y%m%d"
     BUILD_AVOIDANCE_TIME_FORMAT="%H%M%S"
     BUILD_AVOIDANCE_DATE_TIME_DELIM="T"
     BUILD_AVOIDANCE_DATE_TIME_POSTFIX="Z"
     BUILD_AVOIDANCE_DATE_UTC=1
     BUILD_AVOIDANCE_FILE_TRANSFER="rsync"

     # Required, unique values for each regional office
     BUILD_AVOIDANCE_USR="jenkins"
     BUILD_AVOIDANCE_HOST="stx-builder.mycompany.com"
     BUILD_AVOIDANCE_DIR="/localdisk/loadbuild/jenkins/StarlingX_Reference_Build"
     EOF

* Using command-line arguments to specify the location of your reference
  build:

  ::

    build-pkgs --build-avoidance --build-avoidance-dir /localdisk/loadbuild/jenkins/StarlingX_Reference_Build --build-avoidance-host stx-builder.mycompany.com --build-avoidance-user jenkins

* You must accept the host key **before** your build attempt to prevent
  ``rsync`` failures on a ``yes/no`` prompt. You only have to do this once.

  ::

     grep -q $BUILD_AVOIDANCE_HOST $HOME/.ssh/known_hosts
     if [ $? != 0 ]; then
     ssh-keyscan $BUILD_AVOIDANCE_HOST >> $HOME/.ssh/known_hosts
     fi


* ``build-pkgs`` does the following:

  * From newest to oldest, scans the CONTEXTs of the various reference builds.
    Selects the first (i.e. most recent) context that satisfies the following
    requirement: every Git the SHA specifies in the CONTEXT is present.
  * The selected context might be slightly out of date, but not by more than
    a day. This assumes daily reference builds are run.
  * If the context has not been previously downloaded, then download it now.
    This means you need to download select portions of the reference build
    workspace into the designer's workspace. This includes all the SRPMS,
    RPMS, MD5SUMS, and miscellaneous supporting files. Downloading these files
    usually takes about 10 minutes over an office LAN.
  * The designer could have additional commits or uncommitted changes not
    present in the reference builds. Affected packages are identified by the
    differing md5sum values. In these cases, the packages are rebuilt. Rebuilds
    usually take five or more minutes, depending on the packages that have changed.

* What if no valid reference build is found? Then ``build-pkgs`` will fall back
  to a regular build.

****************
Reference builds
****************

* The regional office implements an automated build that pulls the latest
  StarlingX software and builds it on a regular basis (e.g. daily builds).
  Jenkins, cron, or similar tools can trigger these builds.
* Each build is saved to a unique directory, and preserved for a time that is
  reflective of how long a designer might be expected to work on a private branch
  without synchronizing with the master branch. This takes about two weeks.

* We recommend that the ``MY_WORKSPACE`` directory for the build has a common
  root directory, and a leaf directory that is a sortable time stamp. The
  suggested format is ``YYYYMMDDThhmmss``.

  ::

    sudo apt-get update
    BUILD_AVOIDANCE_DIR="/localdisk/loadbuild/jenkins/StarlingX_Reference_Build"
    BUILD_TIMESTAMP=$(date -u '+%Y%m%dT%H%M%SZ')
    MY_WORKSPACE=${BUILD_AVOIDANCE_DIR}/${BUILD_TIMESTAMP}

* Designers can access all build products over the internal network of the
  regional office. The current prototype employs ``rsync``. Other protocols that
  can efficiently share, copy, or transfer large directories of content can be
  added as needed.

**************
Advanced usage
**************

Can the reference build itself use build avoidance? Yes, it can.
Can it reference itself? Yes, it can.
However, in both these cases, caution is advised. To protect against any possible
'divergence from reality', you should limit how many steps you remove
a build avoidance build from a full build.

Suppose we want to implement a self-referencing daily build in an
environment where a full build already occurs every Saturday.
To protect ourselves from a
build failure on Saturday, we also want a limit of seven days since
the last full build. Your build script might look like this:

::

   ...
   BUILD_AVOIDANCE_DIR="/localdisk/loadbuild/jenkins/StarlingX_Reference_Build"
   BUILD_AVOIDANCE_HOST="stx-builder.mycompany.com"
   FULL_BUILD_DAY="Saturday"
   MAX_AGE_DAYS=7

   LAST_FULL_BUILD_LINK="$BUILD_AVOIDANCE_DIR/latest_full_build"
   LAST_FULL_BUILD_DAY=""
   NOW_DAY=$(date -u "+%A")
   BUILD_TIMESTAMP=$(date -u '+%Y%m%dT%H%M%SZ')
   MY_WORKSPACE=${BUILD_AVOIDANCE_DIR}/${BUILD_TIMESTAMP}

   # update software
   repo init -u ${BUILD_REPO_URL} -b ${BUILD_BRANCH}
   repo sync --force-sync
   $MY_REPO_ROOT_DIR/tools/toCOPY/generate-centos-repo.sh
   $MY_REPO_ROOT_DIR/tools/toCOPY/populate_downloads.sh

   # User can optionally define BUILD_METHOD equal to one of 'FULL', 'AVOIDANCE', or 'AUTO'
   # Sanitize BUILD_METHOD
   if [ "$BUILD_METHOD" != "FULL" ] && [ "$BUILD_METHOD" != "AVOIDANCE" ]; then
       BUILD_METHOD="AUTO"
   fi

   # First build test
   if [ "$BUILD_METHOD" != "FULL" ] && [ ! -L $LAST_FULL_BUILD_LINK ]; then
       echo "latest_full_build symlink missing, forcing full build"
       BUILD_METHOD="FULL"
   fi

   # Build day test
   if [ "$BUILD_METHOD" == "AUTO" ] && [ "$NOW_DAY" == "$FULL_BUILD_DAY" ]; then
       echo "Today is $FULL_BUILD_DAY, forcing full build"
       BUILD_METHOD="FULL"
   fi

   # Build age test
   if [ "$BUILD_METHOD" != "FULL" ]; then
       LAST_FULL_BUILD_DATE=$(basename $(readlink $LAST_FULL_BUILD_LINK) | cut -d '_' -f 1)
       LAST_FULL_BUILD_DAY=$(date -d $LAST_FULL_BUILD_DATE "+%A")
       AGE_SECS=$(( $(date "+%s") - $(date -d $LAST_FULL_BUILD_DATE "+%s") ))
       AGE_DAYS=$(( $AGE_SECS/60/60/24 ))
       if [ $AGE_DAYS -ge $MAX_AGE_DAYS ]; then
           echo "Haven't had a full build in $AGE_DAYS days, forcing full build"
           BUILD_METHOD="FULL"
       fi
       BUILD_METHOD="AVOIDANCE"
   fi

   #Build it
   if [ "$BUILD_METHOD" == "FULL" ]; then
       build-pkgs --no-build-avoidance
   else
       build-pkgs --build-avoidance --build-avoidance-dir $BUILD_AVOIDANCE_DIR --build-avoidance-host $BUILD_AVOIDANCE_HOST --build-avoidance-user $USER
   fi
   if [ $? -ne 0 ]; then
       echo "Build failed in build-pkgs"
       exit 1
   fi

   build-iso
   if [ $? -ne 0 ]; then
       echo "Build failed in build-iso"
       exit 1
   fi

   if [ "$BUILD_METHOD" == "FULL" ]; then
       # A successful full build.  Set last full build symlink.
       if [ -L $LAST_FULL_BUILD_LINK ]; then
           rm -rf $LAST_FULL_BUILD_LINK
       fi
       ln -sf $MY_WORKSPACE $LAST_FULL_BUILD_LINK
   fi
   ...

To use the full build day as your avoidance build reference point,
modify the ``build-pkgs`` commands above to use ``--build-avoidance-day``,
as shown in the following two examples:

::

   build-pkgs --build-avoidance --build-avoidance-dir $BUILD_AVOIDANCE_DIR --build-avoidance-host $BUILD_AVOIDANCE_HOST --build-avoidance-user $USER --build-avoidance-day $FULL_BUILD_DAY

   # Here is another example with a bit more shuffling of the above script.

   build-pkgs --build-avoidance --build-avoidance-dir $BUILD_AVOIDANCE_DIR --build-avoidance-host $BUILD_AVOIDANCE_HOST --build-avoidance-user $USER --build-avoidance-day $LAST_FULL_BUILD_DAY

The advantage is that our build is never more than one step removed
from a full build. This assumes the full build was successful.

The disadvantage is that by the end of the week, the reference build is getting
rather old. During active weeks, build times could approach build times for
full builds.
