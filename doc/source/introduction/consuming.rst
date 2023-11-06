===================
Consuming StarlingX
===================

While |prod| is a ready-to-use solution, it is important to understand some
limitations to what you can do with the open source software and |prod| 
Community ISO builds. Software features like secure boot, live software
update/patching and live software upgrades are not fully enabled by the
community.

*  The community does not provide signed software images, which are needed to
   implement security features such as |UEFI| Secure Boot. Providing signed images
   is typically the responsibility of commercial vendors or the users
   themselves.
   
*  The commuity does not provide software updates/patches (i.e. for bug fixes or
   new |CVE| vulnerabilities) to |prod| released ISOs.
   
*  The community does not support or test software upgrades from one |prod|
   release to the next |prod| Release. Very often, for software upgrades to
   work from |prod| release N (old/existing) to |prod| release N+1 (new),
   a software-upgrade-enabling 'update/patch' is required for |prod|
   release N. Because the |prod| community does not provide/build software
   update patches, this patch is not available from the |prod| community,
   and therefore software upgrades may not necessarily work and are not tested
   by the |prod| community.

Here are three ways in which you can consume |prod|.

Deploy the open source code
---------------------------
You can use the open source software directly. Our community partner Wind River
provides a |prod| mirror with ready-to-run ISO images of the current |prod|
releases and daily builds. 

View the `StarlingX mirror
<https://mirror.starlingx.windriver.com/mirror/starlingx/>`_.

As previously mentioned, these images are not signed and thus do not support
secure booting. Also, as previously mentioned, live software updates may not
necessarily work without software patches, which are not currently provided by
the |prod| community.

The |prod| community recommends that users planning to deploy the open source
software use the tested and validated release images.

Developers planning to work against the tip of the source trees typically use
the daily builds.

Deploy an internal version of StarlingX
---------------------------------------
Your company can form a team to create their own version of |prod| for internal
use. Such a team can do acceptance testing of the open source software,
customize it as needed, sign their own internal images (to enable features such
as |UEFI| Secure Boot), and build and deliver software updates/patches that will
also enable testing and support of software upgrades.

Deploy code from a vendor
-------------------------
You can consume a commercial vendor's |prod|-based product or solution. Vendors
provide signed images and support for software updates/patches and software
upgrades. They may also add features or content to the open source software and
they may provide other services such as technical support.

The |prod| community expects several vendors to provide |prod|-based products
and solutions. We hope to see more as our community grows.
