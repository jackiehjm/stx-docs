===================
Consuming StarlingX
===================

StarlingX is ready for you to use today. However limitations exist
regarding what you can do with the
open source software. Features of the software
like Secure Boot and live Software Update are not fully enabled by
the community.

The community does not provide signed software images, which are needed
to enable features that depend
on signed images to implement Security features.
Providing signed images typically are the responsibility of
commercial vendors or the users themselves.
As such, the following are
three ways in which you can consume StarlingX.

Deploy the open source code
---------------------------

You can use the open source software directly. Our community partner
CENGN has an archive containing ready to run
ISO images of the current StarlingX releases and daily builds.

As previously mentioned, these images are not signed
and thus do not support Secure Boot or live Software Updates. You can also
build your own images of course.

The StarlingX community recommends that anyone looking to deploy
the open source software use the release images, which have been
tested and validated by the community. Developers
looking to work against the tip of the source trees would
typcally use the daily builds.

Deploy an internal version of StarlingX
---------------------------------------

If you are part of a company, the company itself can create
a team to create their own version of
StarlingX for the company. Such a team could do
acceptance testing of the open source software, customize it as
needed, sign their own internal images, and use the features
in StarlingX to enable Secure Boot and to develop and deliver live
Software Updates (patches) to their internal users.

Deploy code from a vendor
-------------------------

You can also consume a commercial vendor's StarlingX-based
product or solution. Vendors can provide signed images and
signed Software Updates. They can add features or content to
the open source software. They may provide other services such
as technical support.

The StarlingX community
expects several vendors to provide StarlingX-based products
and solutions. We hope to see more as our community grows.
