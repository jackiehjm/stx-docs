
.. qbz1552920585263
.. _software-update-space-reclamation:

=================================
Software Update Space Reclamation
=================================

|prod-long| provides functionality for reclaiming disk space used by older
versions of software updates once newer versions have been committed.

The :command:`sw-patch commit` command allows you to “commit” a set of software
updates, which effectively locks down those updates and makes them unremovable.
In doing so, |prod-long| is then able to delete package files with lower
versions from the storage and repo, keeping only the highest version of each
package in the committed software update set.

.. caution::
    This action is irreversible.
