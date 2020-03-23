==========================
Docker Proxy Configuration
==========================

This guide describes how to set the Docker HTTP/HTTPS proxy after installation.

To set the Docker proxy at bootstrap time, refer to
`Ansible Bootstrap Configurations <https://docs.starlingx.io/deploy_install_guides/r3_release/ansible_bootstrap_configs.html#docker-proxy>`_.

To specify the HTTP proxy URL, use the commands:

::

    system service-parameter-modify platform docker http_proxy http://my.proxy.com:1080
    system service-parameter-apply platform

To specify the HTTPS proxy URL, use the commands:

::

    system service-parameter-modify platform docker https_proxy https://my.proxy.com:1443
    system service-parameter-apply platform
