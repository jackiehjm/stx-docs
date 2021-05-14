
.. yim1593277634652
.. _overview-of-upgrade-abort-procedure:

===================================
Overview of Upgrade Abort Procedure
===================================

You can abort an upgrade procedure if necessary.

There are two cases for aborting an upgrade:


.. _overview-of-upgrade-abort-procedure-ul-q5f-vmz-bx:

-   Before controller-0 has been upgraded \(that is, only controller-1 has been
    upgraded\): In this case the upgrade can be aborted and the system will
    remain in service during the abort.

-   After controller-0 has been upgraded \(that is, both controllers have been
    upgraded\): In this case the upgrade can only be aborted with a complete
    outage and a re-install of all hosts. This would only be done as a last
    resort, if there was absolutely no other way to recover the system.

-   :ref:`Rolling Back a Software Upgrade Before the Second Controller Upgrade
    <rolling-back-a-software-upgrade-before-the-second-controller-upgrade>`  

-   :ref:`Rolling Back a Software Upgrade After the Second Controller Upgrade
    <rolling-back-a-software-upgrade-after-the-second-controller-upgrade>`  
