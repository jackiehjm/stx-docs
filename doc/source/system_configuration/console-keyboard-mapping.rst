
.. rws1552674043508
.. _console-keyboard-mapping:

========================
Console Keyboard Mapping
========================

You can change the keyboard layout settings used on the text console for
a |prod| node.

You can log in to the console using the US keyboard layout and then change
the keyboard settings, if required. Use the following CLI commands to change
the keyboard layout settings on your keyboard:

To display the current console keyboard settings that are configured for the
virtual console:

.. code-block:: none

    $ localectl status

For example,

.. code-block:: none

    System Locale:LANG=en_US.UTF-8
    VC Keymap:us
    X11 Layout:n/a

To check if a keyboard layout can be configured on your system, for example:

.. code-block:: none

    $ localectl list-keymaps|fgrep 106
    jp 106

To set the console keyboard layout, use the following syntax:

.. code-block:: none

    $ sudo localectl set-keymap <mapping-name>

For example, to use jp106:

.. code-block:: none

    $ sudo localectl set-keycap jp106

.. code-block:: none

    $ localectl status
      System Locale:LANG=en_US.UTF-8
      VC Keymap:jp106
      X11 Layout:jp
      X11 Model:jp106
      X11 Options:terminate:ctrl_alt_bksp