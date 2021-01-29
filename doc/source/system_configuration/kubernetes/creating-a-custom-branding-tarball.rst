
.. ngt1557520137257
.. _creating-a-custom-branding-tarball:

================================
Create a Custom Branding Tarball
================================

This section contains instructions and examples for creating and applying a
tarball containing a custom Horizon Web interface theme, and associated
branding files, for the |prod|.

You can modify the existing style sheet, font, and image files to develop
your own branding, package it, and then apply the branding by installing the
tarball that includes the modified files along with a manifest. To create a
custom branding tarball, with a new custom theme, and package it, follow the
steps below:

.. rubric:: |proc|

#.  You can use the existing default Horizon theme as a starting point for the
    creation of your custom theme or for the directory structure.

#.  Customize the styles and color scheme using the **\_styles.scss**,
    and **\_variables.scss** files. Image overrides can be placed in the
    **static/img/** folder, and template overrides can be placed in the
    **templates** folder. This theme can be found in the Horizon repository,
    at `GitHub <https://github.com/openstack/horizon/tree/master/openstack_dashboard/themes/default>`__
    or on a controller host, at /usr/share/openstack-dashboard/openstack\_dashboard/themes/default/.

#.  Copy the theme and modify it to fit your requirements.

    For more information on customizing your theme, see the OpenStack
    documentation at, `https://docs.openstack.org/horizon/latest/configuration/branding.html <https://docs.openstack.org/horizon/latest/configuration/branding.html>`__

    .. note::

        -   You can use the **example** theme as a guide to where
            customized templates and javascript must be located in a custom
            theme, and can be found next to the default theme.

        -   The name of the custom theme is **custom** and must be used in the
            source paths of new images or javascript, for example,
            **/static/themes/custom/img/extra\_img.png**.

        -   If a static folder is used, the **\_styles.scss**, and
            **\_variables.scss** files must be located in the static folder
            and not in the root of the theme.

#.  You must add a **manifest.py** file to your theme directory that is used
    to overwrite Horizon's branding-related settings. This file should
    specify the following information:

    .. code-block:: none

        # SITE_BRANDING = "Sample System Name"

    where
        **Sample System Name** is the name that will be used in the site title

    .. code-block:: none

        # HORIZON_CONFIG["help_url"] = "https://www.openstack.org/"

    where
        the **help\_url** is the help link for users.

    The theme directory should have the following files, depending on how
    extensive the theme is. Use the following command to find the files:

    .. code-block:: none

        # find .
        ./manifest.py
        ./static
        ./static/img
        ./static/img/logo-splash.svg
        ./static/img/logo.svg
        ./static/_styles.scss
        ./static/_variables.scss
        ./templates
        ./templates/auth
        ./templates/auth/login.html
        ./templates/auth/_login_form.html
        ./templates/base.html

#.  Compress this directory into a tarball that can then be deployed in
    running systems.

    .. note::
        This tarball must have the extension **.tgz**. There are no
        limitations on the name of this file.

    .. code-block:: none

        # ls manifest.py static templates

    .. code-block:: none

        # tar czfv new_branding.tgz *
        manifest.py
        static/
        static/img/
        static/img/favicon.png
        static/img/logo-splash.svg
        static/img/logo.png
        static/img/logo.svg
        static/_styles.scss
        static/_variables.scss
        templates/
        templates/auth/
        templates/auth/login.html
        templates/auth/_login_form.html
        templates/base.html

.. rubric:: |postreq|

After creating your custom branding tarball containing a customized Horizon Web
interface theme and associated branding files, you cqn apply it to both newly
installed and running systems. You can apply it to different stages in your
installation.

For more information on applying the tarball to newly installed systems prior
to running the bootstrap playbook,
see :ref:`Apply a Custom Branding Tarball to Newly Installed Systems
<applying-a-custom-branding-tarball-to-newly-installed-systems>`.

For more information on applying the tarball to running systems,
see :ref:`Apply a Custom Branding Tarball to Running Systems
<applying-a-custom-branding-tarball-to-running-systems>`.