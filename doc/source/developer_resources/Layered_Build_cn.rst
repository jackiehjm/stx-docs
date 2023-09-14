==========================
分层构建 "(Layered Build)"
==========================
.. note::
  由于StarlingX没有翻译组，因此可能无法积极的维护本指导文档。如果您对翻译指导文档感兴趣，请联系
  `StarlingX文档团队 <https://wiki.openstack.org/wiki/StarlingX/Docs_and_Infra>`_。

  This guide may not be actively maintained because StarlingX does not have a translation project.
  If you are interested in translating guides, please contact the
  `StarlingX docs team <https://wiki.openstack.org/wiki/StarlingX/Docs_and_Infra>`_.

什么是分层构建？
-----------------------

分层构建是 StarlingX为提高内部研发效率，而设计的一种构建方法。

在此之前，构建一个 StarlingX系统需要耗费几个小时，并生成数百个软件包。Starlingx 90%+ 的工作都在于
对上层的众多package包的维护和开发，剩下的的package包多是发行版(如CentOS)所必须的，而这些package是很少会变化的。
如果这些不经常更改，那么为什么每个人都要编译它？

所以我们把构建分成了几个层级:

1. compiler = 低层的构建工具层。如：编译器工具，脚本语言工具，打包工具等。
2. distro = 一个修改过的 CentOS系统 加上其他第三方软件包，比如 ceph，openstack...
3. flock = StarlingX特有的软件包。这是我们希望大多数人工作的地方。
4. containers = StarlingX特有的容器化软件包。

对于在flock层开发的人员来说，构建过程和旧的编译系统(full build)差别不大。而对于在compiler和distro做开发的人员，
layered build构建过程会稍微复杂一些。

我必须使用分层的构建吗？
---------------------------------

不一定。如果使用default manifest，且不使用命令行或者环境变量去指定编译特定的层，那么执行编译命令后，
仍然会编译所有的层次中的各个package。对于在compiler和distro layer开发，或者需要获取完整的ISO镜像用于测试，
可以采用这种方式构建。

Full build (使用default manifest) 有一些局限性。如对于lst文件，错误的将该层需要的包名填写到了另外一层的lst文件中。
Full build是可以正确编译的，无法发现这个依赖问题。所以对lst文件的修改，是需要使用layer build构建和验证的。

发生了哪些变化？
-----------------

**1) 通过 manifest 下载指定层的软件包**

配置库除了'default.xml'之外还有四个新的配置项。它们是'compiler.xml'，'distro.xml'，'flock.xml'和'containers.xml'。
还有一个'common.xml' 共通配置表，无论您在那个层上进行构建，这共通配置表都会被包含在其构建中。目前还是保留了'default.xml'
作为下载所有 StarlingX 软件包的方式。

在主分支上进行下载flock layer内容，参照以下步骤... ::

   repo init -u https://opendev.org/starlingx/manifest.git -b master -m flock.xml

**2) 环境变量**

新增加了两个环境变量，'LAYER' 和 'STX_CONFIG_DIR'。

强烈建议您配置'LAYER'这个环境变量。否则，您在执行任何类型的下载或构建过程中,许多命令操作会提示您需传递一个layer参数。

第二个环境变量``'STX_CONFIG_DIR'``,在大多数情况下是可以不进行配置的。默认是使用``stx-tools/centos-mirror-tools/config``
这个路径， 这是默认的配置路径信息。什么时候需要定义``STX_CONFIG_DIR``？ 可能在主要处理较低层的更改时，比如切换较新的操作系统版本。
或者重新定义多工作层的集合，或者各工作层的衔接。在这些情况下，由于内容冲突导致repo sync可能会非常痛苦。可能需要复制
``stx-tools/centos-mirror-tools/config`` 路径的内容到git管理之外一段时间然后进行修改。关于config目录以下有一些详述。

例如： ::

   export LAYER=flock

在容器的构建环境下，标准的配置以及环境变量都是通过 localrc 传入到构建环境里的。比如添加 LAYER 值 ::

   cat stc-tools/localrc
      PROJECT=myproject-flock
      HOST_PREFIX=""
      LAYER=flock

**3) 控制依赖文件的下载，即 yum repos 和 lst 文件**

原有的用于管理rpm和tarballs下载的lst文件已经被移动和拆分成多个。

旧的位置是 ``stx-tools/centos-mirror-tools/``，其包含的文件如下: ::

   rpms_centos.lst
   rpms_centos3rdparties.lst
   rpms_3rdparties.lst
   tarball-dl.lst
   other_downloads.lst

新的lst文件位置取决于其要下载的文件类型。

**a) src.rpm**

lst文件被重新定位并重命名。其前缀采用了'操作系统名' + 'srpm'，而不再使用'rpm'。

例如： ::

   rpms_centos.lst -> centos_srpms_centos.lst
   rpms_centos3rdparties.lst -> centos_srpms_centos3rdparties.lst
   rpms_3rdparties.lst -> centos_srpms_3rdparties.lst

Src rpm相关lst文件放在git仓库根目录下。

例如，在'integ' git 中，我们基于 fedora-core src.rpm 重新编译'libvirt-python'。 该libvirt-python不是
CentOS需要的第三方包，所以我们将它记录在'integ'子目录中的 centos_srpms_3rdparties.lst文件中。 ::

   cat cgcs-root/stx/integ/centos_srpms_3rdparties.lst
      libvirt-python-4.7.0-1.fc28.src.rpm#https://libvirt.org/sources/python/libvirt-python-4.7.0-1.fc28.src.rpm
      ...

**b) tarballs**

lst文件同时被重新定位和重命名，并以操作系统名作为前缀。

例如，tarball-dl.lst -> centos_tarball-dl.lst

Tarball相关lst文件放在git仓库根目录下。

例如，在'integ' git 中，我们从tarball中编译'blkin'。 ::

   cat cgcs-root/stx/integ/centos_tarball-dl.lst
      blkin-f24ceec055ea236a093988237a9821d145f5f7c8.tar.gz#blkin#https://api.github.com/repos/ceph/blkin/tarball/f24ceec055ea236a093988237a9821d145f5f7c8#https##
      ...

**c) rpm**

对于记录二进制rpm包的lst文件，将其保留在了 stx-tools git 中，但是基于不同的工作层，将其划分并重新定位到
<os>/<layer>特定的目录中，路径如下: ::

   stx-tools/centos-mirror-tools/config/<os>/<layer>

例如flock层 ::

   ls stx-tools/centos-mirror-tools/config/centos/flock/*lst
      other_downloads.lst
      rpms_3rdparties.lst
      rpms_centos3rdparties.lst
      rpms_centos.lst

有一个称为'mock'的特殊虚拟层，其中放置了构建模拟构建环境所需的 rpm。 这些rpm自动包含在所有工作层中。

什么情况下需要添加一个 rpm 到一个层的包列表中：

- 这个rpm被构建的层所需要。

- 这个rpm被构建的ISO所需要。

什么情况下不要将 rpm 添加到工作层的包列表中：

- 它是由较低的工作层所构建的。

- 它已经在虚拟的'mock'层所列出。

在向工作层的包列表中添加包时，检查是否有其他工作层包含了相同的包。在两个层中，含有相同的软件包是可以的，
但是他们需要具有相同的软件包版本。

**d) 从STX较低的工作层获取 rpm包**

基于``'stx-tools/centos-mirror-tools/config/<os>/<layer>/required_layer_pkgs.cfg'`` 中的配置，
其可以为您自动下载这些包文件。 默认的配置是从最新的官方版本中获取包文件，您无需修改此文件。

**e) yum repositories**

可以继续使用``'stx-tools/centos-mirror/yum.repos.d'`` 目录，作为yum源去下载非Starlingx的rpm包。

您可能也注意到在``'stx-tools/centos-mirror-tools/config/<os>/<layer>/yum.repos.d'`` 中也可以找到一些 yum 目录。
这些只是为了引用 StarlingX官方构建的 rpms。大部分情况下不用修改这些文件，除非你正在构建一个新的分支，工作层或操作系统。

控制构建ISO的包内容
------------------------------------------

只有flock层能够建立一个ISO。

ISO镜像内容完全由文件来定义： ::

   cgcs-root/build-tools/build_iso/image.inc
   cgcs-root/build-tools/build_iso/minimal_rpm_list.txt

构建依赖的包信息不在以上文件中。

构建依赖的包应该列在``'<os>_iso_image.inc'`` 这个文件，其位于你所看到的git库的根目录中。

例如，qemu-kvm-ev 是由'integ' git repo 编译的，所以它可以在 ::

   cat cgcs-root/stx/integ/centos_iso_image.inc

      ...
      # qemu-kvm-ev
      qemu-kvm-ev
      qemu-img-ev
      qemu-kvm-tools-ev
      ...

只需要列出构建依赖的包名，包之间的依赖关系不需要列出，依赖会被自动解决。

当 build-iso 运行时，底层的镜像文件会自动下载，并提供给flock工作层。 这是由
``'stx-tools/centos-mirror-tools/config/<os>/<layer>/required_layer_iso_inc.cfg'``
这个配置文件所控制的，你不应该修改这个配置文件。

如何使用分层构建？
----------------------------

让我们依次解决这些问题。

**工作在flock layer... 一个简单的改变... 没有包的变化。**

当非常小的修改时，因为首次您需要从较低的层次构建中获取rpm，下载步骤可能会稍微慢一点，所以说在第一次尝试构建时是最痛苦的。
一旦本地有了缓存，后续的下载应该很快。构建 pkgs 步骤应该快得多。 ::

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

**工作在distro layer... 一个简单的改变... 没有包的改变。**

假设您可以通过打补丁到新的 rpm (不需要 ISO 构建)来测试您的更改，那么..。 ::

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

**工作在compiler layer... 一个简单的修改... 没有包的修改。**

假设您可以通过打补丁新的 rpm (不需要 ISO 构建)来测试您的更改，那么..。 ::

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

**跨层部署构建。**

例如：内核开发人员在安装时添加新的或更新驱动程序。这就是一个跨层次的构建练习。内核和它的驱动程序是一个发行版层的组件，
但是安装程序和ISO是从 flock layer构建的。

为每个工作层设置一个独立的构建环境。

1) Distro layer环境
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

2) Flock layer环境
::

   repo init -u https://opendev.org/starlingx/manifest.git -b master -m flock.xml
   repo sync
   ...
   export LAYER=flock
   ...
   echo “LAYER=$LAYER” >> stx-tools/localrc
   ...

在这个阶段，需要为flock layer指定你自定义的distro layer的相关内容。这些内容在配置文件中指定，位于
``stx-tools/centos-mirror-tools/config/<os>/<layer-to-build>``下的``required_layer_pkgs.cfg``和
``required_layer_iso_inc.cfg``文件中。在这两个配置文件中列出了所依赖的下层描述信息``<依赖层>,<类型>,<依赖内容的路径>``，
其格式使用逗号分隔为三个字段，参照以下： ::

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

如果需要用到更底层layer所构建的包，需要在当前layer做好配置。使用语法: ``file://`` 将配置文件中的url替换成更底层layer所对应的信息。

例如：需要使用到在'distro layer' 编译生成的包(构建时项目名为:``PROJECT=<my-project>-distro``) ::

    distro,std,file:///localdisk/loadbuild/<my-project>-distro/std/rpmbuild/RPMS/rpm.lst
    distro,rt,file:///localdisk/loadbuild/<my-project>-distro/rt/rpmbuild/RPMS/rpm.lst
    distro,installer,file:///localdisk/loadbuild/<my-project>-distro/installer/rpmbuild/RPMS/rpm.lst

    distro,std,file:///localdisk/loadbuild/<my-project>-distro/std/image.inc
    distro,dev,file:///localdisk/loadbuild/<my-project>-distro/std/image-dev.inc



如何修改这些配置信息？

选项 a)直接修改原始的配置文件。但，请不要提交你的修改! !

'b'方案会更加安全 ::

   vi stx-tools/centos-mirror-tools/config/centos/flock/required_layer_pkgs.cfg \\
      stx-tools/centos-mirror-tools/config/centos/flock/required_layer_iso_inc.cfg
   download_mirror.sh
   ...
   ln -s /import/mirrors/CentOS/stx/CentOS/downloads/ $MY_REPO/stx/
   populate_downloads.sh /import/mirrors/CentOS/stx/CentOS/
   ...
   generate-local-repo.sh /import/mirrors/CentOS/stx/CentOS/

选项 b)使用一个替代的配置文件目录

拷贝default的配置文件到git仓库以外，但仍需要保证构建系统可见。修改拷贝出的配置文件，使用 ``file://`` url格式修改url。 ::

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

选项 c)提供命令行参数来赋值给 downloads.sh 和 generate-local-repo.sh 脚本文件，并直接覆盖 url ::

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

然后继续构建，接下来将导出我们自己的安装程序。 ::

   build-pkgs
   update-pxe-network-installer

该脚本在 ``/localdisk/loadbuild/my-project-flock/pxe-network-installer/output`` 上创建三个文件。 ::

   new-initrd.img
   new-squashfs.img
   new-vmlinuz

请将文件重命名如下： ::

   initrd.img
   squashfs.img
   vmlinuz

最后... ::

   build-pkgs --clean pxe-network-installer
   build-pkgs pxe-network-installer
   build-iso


更换包
------------------------

**我应该把我新编译出的包放在哪一层？**

如果软件包是你原创的内容，是为 StarlingX 项目所编写的，那么它属于flock layer。所有其他内容都被认为是第三方的，
要么进入distro layer，要么进入compiler layer。

用于编译或打包作用的核心组件，属于compiler layer. Compiler layer这一层改动较少，相对稳定。

所有其他的第三方的包都属于distro layer。在distro层其中你可以找到CentOS补丁包，内核包和驱动程序包，ceph，openstack 组件等和更多软件包。

**如何在repo manifest中添加新的项目？**

如果需要一个新的 git repo，需要在default manifest和对应layer相关的manifest文件中修改设置。

**本地yum配置库如何变更？**

希望我们不会经常添加新的 yum repos，如果需要，将它添加到``'stx-tools/centos-mirror/yum.reposit.d'``，而不是
``'stx-tools/centos-mirror-tools/config/<os>/<layer>/repos.yum.d’``。

**需要更新哪个'lst'文件？**

如果要添加的包来自第三方的 tarball 或 src.rpm，那么将这个包添加到git根目录的 lst 文件中，编译指令就会找到它。
你将内容添加在以下lst文件的其中一个，根据包的原则选择最合适的lst文件。 ::

   centos_srpms_3rdparties.lst
   centos_srpms_centos3rdparties.lst
   centos_srpms_centos.lst
   centos_tarball-dl.lst

对于编译时所依赖各个包，以及那些编译过程有传递性要求的包，应该添加到 ``stx-tools/centos-mirror-tools/config/<os>/<layer>``
下的 lst 文件中。将内容添加在以下lst文件的其中一个，根据包的原则选择最合适的lst文件。 ::

   rpms_3rdparties.lst
   rpms_centos3rdparties.lst
   rpms_centos.lst

...as appropriate.

如果软件包需要安装到iso中，那么应该将这些包所依赖的包，以及有传递性要求的包添加到 ``stx-tools/centos-mirror-tools/config/<os>/flock``
下的 lst 文件中。是flock目录下，而不是其它层，因为 ISO 是从flock层建立的。

弄清楚包的传递列表可能是一个挑战。对于centos软件包，我的建议是启动一个单独的centos容器（保持容器版本的正确匹配性），并尝试运行以下命令。 ::

   repoquery --requires --resolve --recursive \\
      --qf='%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}.rpm' <package>

... 否则，您可能不得不实施几次构建迭代，并修复每次中断的问题。

上述方法收集的rpm集合，可能会列出您的lst文件中已经存在的软件包。 如果版本相同，则无需执行任何操作。 如果版本较低，
则您可能需要将lst中版本更新为较新的软件包版本。检查软件包在所依赖的底层lst文件中是否存在，不存在就添加进去。

查看以上方法获得的rpm列表，对比lst文件，对于lst文件中尚不存在的rpm包。如果starlingx中已经构建了该rpm包，
则不需要包含在lst文件中。

lst中如果没有列出，而且我们也没有构建它，那么就需要添加这个rpm包。

**如何在iso中加入一个软件包？**

将需要编译的软件包添加到git根目录下的``<os>_iso_image.inc``文件下，编译系统会自动识别编译。

特定操作系统的(如CentOS)编译时基于的包，以往在 ``'cgcs-root/build-tools/build_iso/image.inc'`` 文件中配置，
可以继续使用这种方式。
1, layer build以后，需要打包到iso中的package，应该都添加到各自git project里的 ``<os>_iso_image.inc`` 里。

2, compile或者distro layer中增加iso中的package，在这两个layer build结束后，执行如下命令生成各自layer的image.inc
::

    source build-tools/image-utils.sh
    image_inc_list iso dev <layer> > my_<layer>_image.inc

cengna上的各自layer的 image.inc也是这样生成的。

在 ``stx-tools/centos-mirror-tools/config/<os>/<layer>/required_layer_iso_inc.cfg`` 文件
$ cat stx-tools/centos-mirror-tools/config/centos/distro/required_layer_iso_inc.cfg
compiler,std,https://mirror.starlingx.windriver.com/mirror/starlingx/master/centos/compiler/latest_build/outputs/image.inc
compiler,dev,https://mirror.starlingx.windriver.com/mirror/starlingx/master/centos/compiler/latest_build/outputs/image-dev.inc

修改成你的distro 或者compile layer的 image.inc
``file:///localdisk/loadbuild/<user>/<project>/my_<layer>_imajge.inc``

在build flock layer的时候会去读这个 ``require_layer_iso_inc.cfg`` 或者下面的命令修改layer的image.inc ::

   generate-local-repo.sh \\
      --layer-pkg-url=distro,std,file:///localdisk/loadbuild/<my-project>-distro/std/rpmbuild/RPMS/rpm.lst \\
      --layer-pkg-url=distro,rt,file:///localdisk/loadbuild/<my-project>-distro/rt/rpmbuild/RPMS/rpm.lst \\
      --layer-pkg-url=distro,installer,file:///localdisk/loadbuild/<my-project>-distro/installer/rpmbuild/RPMS/rpm.lst \\
      --layer-inc-url=distro,std,file:///localdisk/loadbuild/<my-project>-distro/std/image.inc \\
      --layer-inc-url=distro,dev,file:///localdisk/loadbuild/<my-project>-distro/std/image-dev.inc \\
      /import/mirrors/CentOS/stx/CentOS/

编译flock layer时候，会在``cgcs-root/local-repo/layer_image_inc``, 包含distro和compiler layer的image.inc
build-iso的时候会被使用。
