
.. kqa1596551916697
.. _remove-portieris:

================
Remove Portieris
================

You can remove the Portieris admission controller completely from a |prod|
system.

.. rubric:: |proc|

#.  Remove the application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-remove portieris


#.  Delete the application.

    .. code-block:: none

        ~(keystone_admin)]$ system application-delete portieris


