.. _Layered-Build:

=======================
Layered Build Reference
=======================

What is build layering?
-----------------------

Build layering is a feature to accelerate development within StarlingX.

A StarlingX build takes hours and produces hundreds of packages. However
90+% of all work within StarlingX occurs within a much smaller set of
top level packages. The remaining packages are largely small patches
upon an underlying distribution like CentOS, and change only
infrequently. If they change infrequently, why make everyone compile
them?

So we have partitioned the build into layers:

1. compiler = Low level build tools. Compilers, scripting languages, packaging tools.
2. distro = A modified CentOS plus other third party packages, e.g.  ceph, openstack ...
3. flock = Packages unique to StarlingX. This is where we expect most folk to work.

We have tried to keep the changes to the old build system minimal,
particularly for the most common use case of a developer at the flock
layer. Things get slightly more complicated when work on a lower layer
is required.

Do I have to use a layered build?
---------------------------------

A qualified no. If you continue to use the default manifest, and don't
specify a layer via command line option or environment variable, you
will continue to build all packages across all layers in a single step.
This will be a tempting option for folk doing work on lower layers, and
still needing to build an ISO for test.

There is a limitation to this approach. If you are making lst file
changes, you might get away with placing your new required packages in
the wrong layer's lst file. Building all layers in one pass won't catch
this. So when your update includes lst file changes, you should verify
with a layered build or builds.

What has changed?
-----------------

**1) Download the software for a layer via manifest**

The manifest repo now has three new manifests in addition to
'default.xml'. They are 'compiler.xml', 'distro.xml' and 'flock.xml'.
There is also a 'common.xml', a place for content that must always be
included no matter what layer you are working on. the 'default.xml' is
retained as a way to download all StarlingX software.

Downloading the flock layer for the master branch looks like this... ::

   repo init -u https://opendev.org/starlingx/manifest.git -b master -m flock.xml

**2) Environment variables**

Two new environment variables are available, 'LAYER' and
'STX_CONFIG_DIR'.

I strongly encourage you to set the 'LAYER' environment variable.
Otherwise you'll need to pass a layer argument into most commands that
do any sort of downloading or building.

The second environment variable, ``'STX_CONFIG_DIR'``, can safely be left
blank for most use cases. The default is to use
``stx-tools/centos-mirror-tools/config``, which is what you want. When might
you want to define ``STX_CONFIG_DIR``? Possibly when working on a major
change in the lower layer, such as the cutover to a newer OS version. Or
perhaps when redefining the set of layers, or the boundary between layers. In
these cases it might be very painful to repo sync due to conflicts. It
might be desirable to copy ``stx-tools/centos-mirror-tools/config`` outside
of git for a time, and make your changes there. More on the config
directory below.

e.g. ::

   export LAYER=flock

For containerized build, the norm, the environment variables are passed
in via your localrc. Add the LAYER value there.::

   cat stc-tools/localrc
      PROJECT=myproject-flock
      HOST_PREFIX=""
      LAYER=flock

**3) Controlling the download of dependencies. aka yum repos and 'lst' files**

The lst files that used to govern the download of rpms and tarballs have
been moved and split.

The old location was ``stx-tools/centos-mirror-tools/`` with files like: ::

   rpms_centos.lst
   rpms_centos3rdparties.lst
   rpms_3rdparties.lst
   tarball-dl.lst
   other_downloads.lst

The new location depends on the file type to be downloaded.

**a) src.rpm**

The lst files are both relocated and renamed with the os name as a
prefix, and 'srpm' rather than 'rpm'.

e.g. ::

   rpms_centos.lst -> centos_srpms_centos.lst
   rpms_centos3rdparties.lst -> centos_srpms_centos3rdparties.lst
   rpms_3rdparties.lst -> centos_srpms_3rdparties.lst

These files are placed in the root of the git where they are referenced.

e.g. Within the 'integ' git, we recompile 'libvirt-python' based on a
fedora-core src.rpm. Since fedora is not CentOS, nor is it a
3\ :sup:`rd` party package explicitly intended for CentOS, we'll place
it in centos_srpms_3rdparties.lst found in the 'integ' subdirectory. ::

   cat cgcs-root/stx/integ/centos_srpms_3rdparties.lst
      libvirt-python-4.7.0-1.fc28.src.rpm#https://libvirt.org/sources/python/libvirt-python-4.7.0-1.fc28.src.rpm
      ...

**b) tarballs**

The lst file is both relocated and renamed with the os name as a prefix.

e.g. tarball-dl.lst -> centos_tarball-dl.lst

These files are placed in the root of the git where they are referenced.

e.g. Within the 'integ' git, we compile 'blkin' from a tarball. ::

   cat cgcs-root/stx/integ/centos_tarball-dl.lst
      blkin-f24ceec055ea236a093988237a9821d145f5f7c8.tar.gz#blkin#https://api.github.com/repos/ceph/blkin/tarball/f24ceec055ea236a093988237a9821d145f5f7c8#https##
      ...

**c) rpm**

The lst files for binary rpms remain in the stx-tools git, but are
divided based on layer, and are relocated under an os and layer specific
directory. The path will be: ::

   stx-tools/centos-mirror-tools/config/<os>/<layer>

e.g. for the flock layer ::

   ls stx-tools/centos-mirror-tools/config/centos/flock/*lst
      other_downloads.lst
      rpms_3rdparties.lst
      rpms_centos3rdparties.lst
      rpms_centos.lst

There is one special virtual layer called 'mock' where rpms required to
construct a mock build environment are placed. These rpms are
automatically included for all layers.

Add an rpm to a layer package list if:

- It is required to build the layer.

- It is required to build the iso

Do not add the rpm to a layer package list if:

- It is built by a lower layer

- It is already listed in the virtual 'mock' layer.

When adding a package to a layer package list, check if any other layer
is including the same package. It's ok for two layers to require the
same package, but they should require the same version of that package.

**d) rpm from a lower layer of the STX layered build**

These are automatically downloaded for you, based on the configuration
found in
``'stx-tools/centos-mirror-tools/config/<os>/<layer>/required_layer_pkgs.cfg'``.
The default config is to pull content from the most recent official
build. You shouldn't have to touch this file.

**e) yum repositories**

You should continue to use ``'stx-tools/centos-mirror/yum.repos.d'`` as the
place to define new yums repos for downloading non-StarlingX rpms.

You may notice that there are also yum directories found at
``'stx-tools/centos-mirror-tools/config/<os>/<layer>/yum.repos.d'``. These
are only intended to refer to StarlingX official build rpms. You
probably should NOT be touching these unless you are creating a new
branch, layer or os.

Controlling the package content of the ISO
------------------------------------------

Only the flock layer is capable of building an ISO.

ISO image content used to be defined exclusively by the files: ::

   cgcs-root/build-tools/build_iso/image.inc
   cgcs-root/build-tools/build_iso/minimal_rpm_list.txt

These files continue to be used, but should not include packages that we
build.

Packages that we build, and supply a top level command or service.
should be listed in the ``'<os>_iso_image.inc'`` file. The file is located
at the root of the git where the package is found.

e.g. qemu-kvm-ev is compiled from the 'integ' git repo, so it is found
in ... ::

   cat cgcs-root/stx/integ/centos_iso_image.inc

      ...
      # qemu-kvm-ev
      qemu-kvm-ev
      qemu-img-ev
      qemu-kvm-tools-ev
      ...

Only packages supplying top level commands and services need be listed.
Dependencies do NOT need to be listed. They will be resolved
automatically.

The image inc files of lower layer are automatically pulled in and made
available to the flock layer when build-iso is run. This is governed by
the
``'stx-tools/centos-mirror-tools/config/<os>/<layer>/required_layer_iso_inc.cfg'``
config file. You shouldn't have to touch this file.

How do I use build layering?
----------------------------

Lets address this one scenario at a time.

**A flock layer developer ... a simple change ... no packaging
changes.**

Very little has changed. The populate_download step might be a bit
slower as you'll be picking up rpms from lower layer builds, but this is
mostly a pain to be suffered on the first build attempt. Once locally
cached, subsequent downloads should be fast. The build-pkgs step should
be much faster. ::

   repo init -u https://opendev.org/starlingx/manifest.git -b master -m flock.xml
   repo sync
   ...
   export LAYER=flock
   ...
   echo “LAYER=$LAYER” >> stx-tools/localrc
   ...
   cd /stx-tools/centos-mirror-tools
   download_mirror.sh -c ./yum.conf.sample -n -g
   ...
   ln -s /import/mirrors/CentOS/stx/CentOS/downloads/ $MY_REPO/stx/
   populate_downloads.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   generate-local-repo.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   build-pkgs
   build-iso

**A distro layer developer ... a simple change ... no packaging
changes.**

Assuming you can test your changes by patching in new rpms (no ISO build
required), then it's just ... ::

   repo init -u https://opendev.org/starlingx/manifest.git -b master -m distro.xml
   repo sync
   ...
   export LAYER=distro
   ...
   echo “LAYER=$LAYER” >> stx-tools/localrc
   ...
   download_mirror.sh
   ...
   ln -s /import/mirrors/CentOS/stx/CentOS/downloads/ $MY_REPO/stx/
   populate_downloads.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   generate-local-repo.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   build-pkgs
   build-pkgs --installer
   # build-iso can't be run from this layer

**A compiler layer developer ... a simple change ... no packaging
changes.**

Assuming you can test your changes by patching in new rpms (no ISO build
required), then it's just ... ::

   repo init -u https://opendev.org/starlingx/manifest.git -b master -m compiler.xml
   repo sync
   ...
   export LAYER=compiler
   ...
   echo “LAYER=$LAYER” >> stx-tools/localrc
   ...
   download_mirror.sh
   ...
   ln -s /import/mirrors/CentOS/stx/CentOS/downloads/ $MY_REPO/stx/
   populate_downloads.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   generate-local-repo.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   build-pkgs
   build-pkgs --installer
   # build-iso can't be run from this layer

**Cross layer development.**

e.g. A kernel developer adding a new or updated driver required at
install time. This is a cross layer build exercise. The kernel and it's
drivers are a distro layer component, but the installer and ISO are
built from the flock layer.

Set up an independent build environment for each layer.

1) distro environment
::

   repo init -u https://opendev.org/starlingx/manifest.git -b master -m distro.xml
   repo sync
   ...
   export LAYER=distro
   ...
   echo “LAYER=$LAYER” >> stx-tools/localrc
   ...
   download_mirror.sh
   ...
   ln -s /import/mirrors/CentOS/stx/CentOS/downloads/ $MY_REPO/stx/
   populate_downloads.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   generate-local-repo.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   build-pkgs
   build-pkgs --installer

2) flock environment
::

   repo init -u https://opendev.org/starlingx/manifest.git -b master -m flock.xml
   repo sync
   ...
   export LAYER=flock
   ...
   echo “LAYER=$LAYER” >> stx-tools/localrc
   ...

At this stage you must point the flock layer to pick up your custom
distro layer content.  The location of lower layer content is encoded
in config files found under ``stx-tools/centos-mirror-tools/config/<os>/<layer-to-build>``
in files ``required_layer_pkgs.cfg`` and ``required_layer_iso_inc.cfg``.
Both files use a comma seperated three field lines... ``<lower-layer>,<type>,<url>``
e.g. ::

   cat stx-tools/centos-mirror-tools/config/centos/flock/required_layer_pkgs.cfg
      compiler,std,https://mirror.starlingx.windriver.com/mirror/starlingx/master/centos/compiler/latest_build/outputs/RPMS/std/rpm.lst
      distro,std,https://mirror.starlingx.windriver.com/mirror/starlingx/master/centos/distro/latest_build/outputs/RPMS/std/rpm.lst
      distro,rt,https://mirror.starlingx.windriver.com/mirror/starlingx/master/centos/distro/latest_build/outputs/RPMS/rt/rpm.lst
      distro,installer,https://mirror.starlingx.windriver.com/mirror/starlingx/master/centos/distro/latest_build/outputs/RPMS/installer/rpm.lst

   cat stx-tools/centos-mirror-tools/config/centos/flock/required_layer_iso_inc.cfg
      compiler,std,https://mirror.starlingx.windriver.com/mirror/starlingx/master/centos/compiler/latest_build/outputs/image.inc
      compiler,dev,https://mirror.starlingx.windriver.com/mirror/starlingx/master/centos/compiler/latest_build/outputs/image-dev.inc
      distro,std,https://mirror.starlingx.windriver.com/mirror/starlingx/master/centos/distro/latest_build/outputs/image.inc
      distro,dev,https://mirror.starlingx.windriver.com/mirror/starlingx/master/centos/distro/latest_build/outputs/image-dev.inc

To use your lower layer build, you must edit the config in the upper layer build.
You must replace the url field for the relevant lines to point to your own build using the ``fill:///`` syntax.

e.g. To use a 'distro' build compiled under ``PROJECT=<my-project>-distro``
::

    distro,std,file:///localdisk/loadbuild/<my-project>-distro/std/rpmbuild/RPMS/rpm.lst \\
    distro,rt,file:///localdisk/loadbuild/<my-project>-distro/rt/rpmbuild/RPMS/rpm.lst \\
    distro,installer,file:///localdisk/loadbuild/<my-project>-distro/installer/rpmbuild/RPMS/rpm.lst \\

    distro,std,file:///localdisk/loadbuild/<my-project>-distro/std/image.inc \\
    distro,dev,file:///localdisk/loadbuild/<my-project>-distro/std/image-dev.inc



How to make the changes ...

Option a) Edit the config files in place.  Do not submit this change!!!

Using option 'b' (see below) would be safer.
::

   vi stx-tools/centos-mirror-tools/config/centos/flock/required_layer_pkgs.cfg \\
      stx-tools/centos-mirror-tools/config/centos/flock/required_layer_iso_inc.cfg
   download_mirror.sh
   ...
   ln -s /import/mirrors/CentOS/stx/CentOS/downloads/ $MY_REPO/stx/
   populate_downloads.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   generate-local-repo.sh /import/mirrors/CentOS/stx/CentOS/

Option b) Use an alternative config directory.

Copy the default config to an alternative directory outside of git,
but still visible to the build.  In the copied config, edit the config files,
replacing the existing 'distro' url's with ``file:///`` urls.  Finally
instruct the build to use the alternate config.  I'll use the
environment variable method in the example below.  It can also be done
with command line arguments.
::

   cp -r stx-tools/centos-mirror-tools/config config.tmp
   export STX_CONFIG_DIR=$PWD/config.tmp
   ...
   echo “STX_CONFIG_DIR=$STX_CONFIG_DIR” >> stx-tools/localrc
   ...
   vi config.tmp/centos/flock/required_layer_pkgs.cfg \\
      config.tmp/centos/flock/required_layer_iso_inc.cfg
   download_mirror.sh
   ...
   ln -s /import/mirrors/CentOS/stx/CentOS/downloads/ $MY_REPO/stx/
   populate_downloads.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   generate-local-repo.sh /import/mirrors/CentOS/stx/CentOS/

Option c) supply command line arguments to ``populate_downloads.sh`` and
``generate-local-repo.sh`` overriding the urls directly ::

   download_mirror.sh \\
      -L distro,std,file:///localdisk/loadbuild/<my-project>-distro/std/rpmbuild/RPMS/rpm.lst \\
      -L distro,rt,file:///localdisk/loadbuild/<my-project>-distro/rt/rpmbuild/RPMS/rpm.lst \\
      -L distro,installer,file:///localdisk/loadbuild/<my-project>-distro/installer/rpmbuild/RPMS/rpm.lst \\
      -I distro,std,file:///localdisk/loadbuild/<my-project>-distro/std/image.inc \\
      -I distro,dev,file:///localdisk/loadbuild/<my-project>-distro/std/image-dev.inc
   ...
   ln -s /import/mirrors/CentOS/stx/CentOS/downloads/ $MY_REPO/stx/
   populate_downloads.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   generate-local-repo.sh \\
      --layer-pkg-url=distro,std,file:///localdisk/loadbuild/<my-project>-distro/std/rpmbuild/RPMS/rpm.lst \\
      --layer-pkg-url=distro,rt,file:///localdisk/loadbuild/<my-project>-distro/rt/rpmbuild/RPMS/rpm.lst \\
      --layer-pkg-url=distro,installer,file:///localdisk/loadbuild/<my-project>-distro/installer/rpmbuild/RPMS/rpm.lst \\
      --layer-inc-url=distro,std,file:///localdisk/loadbuild/<my-project>-distro/std/image.inc \\
      --layer-inc-url=distro,dev,file:///localdisk/loadbuild/<my-project>-distro/std/image-dev.inc \\
      /import/mirrors/CentOS/stx/CentOS/

Now resume building, but this time we'll roll our own installer ::

   build-pkgs
   update-pxe-network-installer

This script creates three files on
``/localdisk/loadbuild/<my-project>-flock/pxe-network-installer/output``. ::

   new-initrd.img
   new-squashfs.img
   new-vmlinuz

Rename the files as follows: ::

   initrd.img
   squashfs.img
   vmlinuz

Finally ... ::

   build-pkgs --clean pxe-network-installer
   build-pkgs pxe-network-installer
   build-iso


Making packaging changes
------------------------

**In what layer should I place my new compiled package ?**

If the package is original content, written for the StarlingX project, it
belongs in the 'flock' layer. Yes, envision a flock of starling, might
be corny but that is what we named it. All other content is considered
third party and goes in either the 'distro' or 'compiler' layer.

If it's a core component of a programming or packaging language, a build
or packaging tool. It belongs in the the compiler layer. We expect this
layer to change only very rarely.

All other third party content goes in the 'distro' layer. In it you will
find everything from patches CentOS packages, the kernel and drivers,
ceph, openstack components and much more.

**Location of new repo manifest entries?**

If a new git repo is required, add it to BOTH the default and layer
specific manifests.

**Location of yum repo changes ?**

Hopefully we aren't often adding new yum repos. If required, add it to
``'stx-tools/centos-mirror/yum.repos.d'`` and NOT to
``'stx-tools/centos-mirror-tools/config/<os>/<layer>/yum.repos.d'``.

**Location of 'lst' file changes ?**

If the package to be added is derived from a third party tarball or
src.rpm, add it to the lst files at the root of the git where the
compile directives (spec file, build_srpm.data etc) will live. You'll be
adding to one of .... ::

   centos_srpms_3rdparties.lst
   centos_srpms_centos3rdparties.lst
   centos_srpms_centos.lst
   centos_tarball-dl.lst

...as appropriate.

The package's 'BuildRequires' , as well as the transitive Requires of
those BuildRequires, should be added to a lst file under
``stx-tools/centos-mirror-tools/config/<os>/<layer>``. e.g. one of... ::

   rpms_3rdparties.lst
   rpms_centos3rdparties.lst
   rpms_centos.lst

...as appropriate.

If the package will be installed to iso, the package's 'Requires' as
well as the transitive Requires of those Requires, should be added to a
lst file under ``stx-tools/centos-mirror-tools/config/<os>/flock``. Yes I
said 'flock, and not <layer>, because the ISO is build from the flock
layer.

Figuring out the transitive list of a package can be a challenge. For
centos packages, my suggestion is to fire up a separate centos container
of the correct vintage, and try running ... ::

   repoquery --requires --resolve --recursive \\
      --qf='%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}.rpm' <package>

... otherwise you may have to resort to a several build iterations, and
fixing what breaks each time.

The set of rpms suggested by the above method will likely list packages
already in your lst file. If the same version, no action required. If a
lower version, then you probably want to update the version to the newer
package. Check if the package is listed for a lower layer lst file, and
update it there as well.

If the rpm suggested by the above method does not exist, check if we are
building it within StarlingX. If so, don't list it in a lst file.

If not listed, and we don't build it, then add it.

**Including a package in the iso?**

Add you new compile package to the ``<os>_iso_image.inc`` file at the root
of the git where the compile directives for your new package live.

Packages obtained from the host os (e.g. CentOS) have traditionally gone
in ``'cgcs-root/build-tools/build_iso/image.inc'``, and we can continue with
this practice for now, however it will likely become a barrier to an iso
build from the distro layer alone. Considering this, I probably wouldn't
object to a host os service or binary being listed in a git's
``<os>_iso_image.inc``. A better place for it might be
``stx-tools/centos-mirror-tools/config/<os>/<layer>/image.inc``, but this
isn't yet supported.
