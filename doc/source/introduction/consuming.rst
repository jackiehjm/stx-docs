===================
Consuming StarlingX
===================

StarlingX is ready for you to use today. However limitations exist regarding
what you can do with the open source software. Features of the software
like secure boot and live software update are not fully enabled by the community.

The community does not provide signed software images, which are needed to enable
features that depend on signed images to implement security features. Providing
signed images is typically the responsibility of commercial vendors or the users
themselves. As such, the following are three ways in which you can consume StarlingX.

---------------------------
Deploy the open source code
---------------------------

You can use the open source software directly. Our community partner CENGN has
an archive containing ready to run ISO images of the current StarlingX releases
and daily builds.

As previously mentioned, these images are not signed and thus do not support
secure boot or live software updates. You can also build your own images.

The StarlingX community recommends that anyone looking to deploy the open source
software use the release images, which have been tested and validated by the
community. Developers looking to work against the tip of the source trees would
typcally use the daily builds.

---------------------------------------
Deploy an internal version of StarlingX
---------------------------------------

If you are part of a company, the company itself can create a team to create
their own version of StarlingX for the company. Such a team could do acceptance
testing of the open source software, customize it as needed, sign their own
internal images, and use the features in StarlingX to enable secure boot and to
develop and deliver live software updates (patches) to their internal users.

-------------------------
Deploy code from a vendor
-------------------------

You can also consume a commercial vendor's StarlingX-based product or solution.
Vendors can provide signed images and signed software updates. They can add
features or content to the open source software. They may provide other services
such as technical support.

The StarlingX community expects several vendors to provide StarlingX-based products
and solutions. We hope to see more as our community grows.
