==============================
Navigate StarlingX source code
==============================

StarlingX code is kept in multiple Git directories. To simplify the process of
keeping your local copy up to date, the StarlingX project provides Android-type
repo manifests that can be followed by the Android Repo tool.

--------------
Required tools
--------------

In addition to your preferred text editor you will need two tools to download
the StarlingX source code:

* Git (available from your preferred Linux distro)
* Android Repo tool (a simple python script that is installed manually)

To install Git, follow the instructions to install the Git package from your
Linux distro.

To install the required Android Repo tool on the Linux host system, follow
the steps in the `Installing
Repo <https://source.android.com/setup/build/downloading#installing-repo>`

Additional information about the Repo tool is available in the
`Repo Command Reference <https://source.android.com/setup/develop/repo>`.

----------------------------------
Initial download of StarlingX code
----------------------------------

#. Create a *starlingx* workspace directory on your system.
   Best practices dictate creating the workspace in your $HOME directory:

   .. code:: sh

      $ mkdir -p $HOME/starlingx/

#. Use the Repo tool to create a local clone of the manifest Git repository
   based on the `master` branch:

   .. code:: sh

      $ cd $MY_REPO_ROOT_DIR
      $ repo init -u https://opendev.org/starlingx/manifest -m default.xml

#. Synchronize the repository:

   .. code:: sh

      $ repo sync -j`nproc`

---------------------------------------
Keeping in sync with StarlingX upstream
---------------------------------------

.. code:: sh

   $ repo sync -j`nproc`
