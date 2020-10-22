=============================
StarlingX Development Process
=============================

This section describes the StarlingX development process.

.. contents::
   :local:
   :depth: 1

------------
Introduction
------------

The StarlingX development process is designed

* to enable project teams to work according to the
  `Four Opens <https://governance.openstack.org/tc/reference/opens.html>`_

* for work to be managed by the project's community members

* to specify a common software development methodology that enables the
  community to collaborate effectively.

The StarlingX community follows many of the practices
(but not all!) of the
`OpenStack software development process.
<https://docs.openstack.org/project-team-guide>`_
Differences between the StarlingX and OpenStack practices are
highlighted below.

****************
Project personas
****************

The following personas are used to describe the development process. Some
of these same terms are used in
`the project's governance document.
<https://docs.starlingx.io/governance/reference/tsc/stx_charter.html>`_

User
   A user is someone who is building, operating, or maintaining a
   StarlingX cloud.

Developer
   A developer is someone who submits a code, document, or test
   change to the StarlingX git repositories.

Reviewer
   A reviewer is someone who submits review comments to
   StarlingX Gerrit reviews.

Core Reviewer
   A core reviewer is a StarlingX reviewer who can approve code
   to be merged into the StarlingX git repositories.

Technical Lead / Project Lead
   The StarlingX project is divided into a number of sub-projects. Each
   sub-project has a technical lead (TL) and a
   project lead (PL) who serve as leaders of that sub-project.
   Each sub-project has a team which can consist of users, developers
   and (core) reviewers.

Technical Steering Committee
   The StarlingX Technical Steering Committee (TSC) members are the leaders
   of the StarlingX project.

***********************
Notifying the community
***********************

There are several points in the process where as a user or developer
you will be asked to notify the community. You can do so by
sending a message to the
`project's mailing list.
<http://lists.starlingx.io/cgi-bin/mailman/listinfo/starlingx-discuss>`_
Notifying the community both early and often
will help the community engage with you.

Another good way to notify the community is to attend the
`weekly community call
<https://wiki.openstack.org/wiki/Starlingx/
Meetings#7am_Pacific_-_Community_Call>`_
and/or the
`sub-project calls
<https://wiki.openstack.org/wiki/Starlingx/Meetings>`_
for the area you are working
on. Both are good places to ask questions, raise issues, and discuss
technical topics.

Please be patient. StarlingX is a global project and the person with
the knowledge to help you may be twelve timezones away from you.

****************************
Development process overview
****************************

The StarlingX development process includes the following basic steps:

* Decide what change you want to make.
  Many of the changes needed for StarlingX have already been
  documented in the
  `project's bug backlog
  <https://bugs.launchpad.net/starlingx>`_
  and
  `in existing Stories.
  <https://storyboard.openstack.org/#!/
  story/list?status=active&project_group_id=86>`_
  If you are
  reporting a new bug or requesting a new feature, please
  document the change in a bug report (for a defect in the code)
  or in a StoryBoard story (for new functionality) as described
  below in the `Defect submission process`_ or the
  `Feature submission process`_.
* If you are working on a large change (like a new feature), need
  technical guidance,
  or would like to ask other community members to join you
  in the work, please
  `notify the community <Notifying the community_>`_
  that you are starting to work on a change.
* If you are working on a new feature, create a
  `specification <https://docs.starlingx.io/specs/>`_
  and follow `the spec process. <Specification phase_>`_ This step
  will allow you to collaborate with the community on the design of your
  change and helps to identify other teams and services within the
  StarlingX project that could be effected by your change.
* Implement the code change(s) on your local system,
  `posting your changes to Gerrit <Basic git workflow_>`_
  early and often. Respond to the community's feedback and please
  `notify the community <Notifying the community_>`_ if your changes
  do not get reviewed in a timely fashion.
* `Test your changes <Testing phase_>`_
  on your local system. If needed, ask the test
  project members to help you run tests on their systems. It's a good idea
  to check with the sub-project's TL and PL, who can help
  you ensure your testing covers all needed areas. You should be
  testing your changes from the very beginning of your work and should
  include thorough and complete testing in your plan for your changes.
* Update `the project's documentation <Documentation phase_>`_ if needed.
* Your change will be merged once the core reviewers for the repo(s)
  approve your change in Gerrit.

Complete descriptions for these steps are provided
`in the detailed descriptions below. <Development process details>`_

----------------------------------------------
Submitting defect reports and feature requests
----------------------------------------------

Any user or other StarlingX community member can request a change
to the software. The process for requesting a
change depends on whether the
change is a fix to a bug, or a request for a new feature.

*************************
Defect submission process
*************************

The StarlingX project uses `launchpad for tracking bugs. <https://bugs.launchpad.net/starlingx>`_

To report a new bug, go to the launchpad link above and click :guilabel:`Report a bug`.
You will be prompted to search for similar bugs which helps reduce duplicates in
the database. Please use the StarlingX Bug Template (displayed in the bug window)
when filing a new bug to help ensure that the team can quickly triage and fix the bug.

Capturing logs related to a defect is often required in order to root cause and
fix the issue. Please use the `StarlingX log collection tool
<https://files.starlingx.kube.cengn.ca>`_ to post collect log files
and post a link to the logs within your Launchpad.

As the reporter of a bug, once you complete the template and fill
in the information requested, you can submit the bug report.
Please do not change the status of the bug. Leave it as "New". There is
also no need to enter any tags. This will be done as part of the
triage process.

After reporting a bug, please `notify the community <Notifying the community_>`_
if your bug is urgent or impacting your operations.

**************************
Feature submission process
**************************

The StarlingX project uses the OpenDev StoryBoard tool to document
new features for the project. You can use the tool to search for existing
stories or to create new ones. To submit a new feature request for StarlingX
please follow these steps.

#. In your browser navigate to `the StarlingX StoryBoard project group. <https://storyboard.openstack.org/#!/project_group/86>`_
#. Click on the :guilabel:`Create New` button on the top of the page and
   select "Story" from the pull down menu. A dialog box will appear.
#. In the "Title" field in the dialog box, enter in a name for the
   feature or a one sentence description.
#. In the "Description" field of the dialog box, enter in a
   description of what you want the feature to do and why you want it.
#. In the "Project" field in the dialog box, enter in the name of the
   StarlingX sub-project repository that contains the code to
   implement your feature. These names all start with "starlingx/" which
   you can type to have a drop down list shown of all sub-project repositories.
   If you don't know which repository to select, you can use "starlingx/integ".
#. Click :guilabel:`Save Changes` and your feature request is submitted.

After submitting a new feature request, please
`notify the community <Notifying the community_>`_
Your story will be reviewed according to the
`planning <Planning phase_>`_ process described below.
While anyone can submit a feature request to StarlingX, you can
greatly increase the chance of the feature being implemented by
joining the team(s) who are working on the feature and contributing
to the effort.

---------------------------
Development process details
---------------------------

This section describes the StarlingX development process in detail.

******************
Basic git workflow
******************

The
`OpenStack Contributor Guide
<https://docs.openstack.org/contributors/code-and-documentation/index.html>`_
provides a good overview of the standard OpenStack process. The StarlingX
process is very similar.

The steps described in the StarlingX Build Guide in the
`Developer environment setup section
<https://docs.starlingx.io/developer_resources/
build_guide.html#development-environment-setup>`_
must be completed before any of the steps described here.

Clone the desired StarlingX source repos using either:

::

   git clone <a starlingX repo>

Or clone all of the repos using the :command:`repo` tool as described in the
`StarlingX build guide
<https://docs.starlingx.io/developer_resources/build_guide.html>`_:

::

   repo init -u https://opendev.org/starlingx/manifest -m default.xml

The basic developer workflow looks like this:

::

   cd <your local repo>
   git pull # ensure your repo is up to date with the latest changes
   git branch <branch name> # always work on a branch
   # work on the change - edit the code, build it and test it
   git add <the files you changed> # or git add -a
   git commit -s
   # Your commit message should include
      A) A short title
      B) a blank line
      C) a description of the change
      D) A blank line
      E) An optional tag for a story or launchpad issue number
         Closes-Bug: ######
         Partial-Bug: ######
         Related-Bug: ######
         Task: ######
         Story: ######
   git review  # Post your code changes to Gerrit

This will post your change for community review and eventual
approval by the core reviewers. If needed, you can respond to community
feedback by posting an updated version of your change as follows:

::

   git add <the files you changed>
   git commit -a --amend
   git review

***************
Bug fix process
***************

StarlingX follows the
`OpenStack project team guidelines
<https://docs.openstack.org/project-team-guide/bugs.html>`_
for bug management,
but with a few small differences as described below.

^^^^^^^^^^
Bug triage
^^^^^^^^^^

The
`stx-bugs team
<https://launchpad.net/~stx-bugs>`_
is responsible
for triaging, assigning and tagging StarlingX bugs. The team includes
the StarlingX project leads and delegates.
One or more members of the stx-bugs team reviews the new bugs and adds
the applicable sub-project tags. This allows each sub-project
team to see their bug backlog.

The sub-project project lead (or delegate) then triages the bug further and
adds a release tag based on severity and when they believe they can
fix the bug. At this point, they also set the bug importance (if not
already done) and the status is updated to "Triaged".

If an issue is minor and is deemed not gating for the next release, a
release tag is not added. In this case, the bug importance should be
set to "Low" to indicate that it does not gate any release.
It is recommended that the project lead triaging the bug add a comment with
the rationale.

For more information on the use of tags in StarlingX, see
`the Tags & Prefixes page.
<https://wiki.openstack.org/wiki/StarlingX/Tags_and_Prefixes>`_

^^^^^^^^^^^^^^
Bug resolution
^^^^^^^^^^^^^^

It is the responsibility of each sub-project team to manage their bug backlog.

Each project lead has the ability to assign bugs to members of the
team. Team members can also assign bugs to themselves (but not to others).

When working on a bug, it is recommended that the developer sets
the status to "In Progress".

By default, the reporter is subscribed to the bug and will receive
email notifications when comments are added. You can use this to
communicate with the reporter if you have questions or need clarification.

It is expected that the reporter responds by adding another comment
to the bug in launchpad.

Fixing a bug shares some of the same process steps as the feature
development process described below. In particular bug fixes require
thorough testing before the fix is committed, as per the
`testing phase <Testing phase_>`_ below.

All bug fixes must be fixed in master first. The release sub-project
team may request that fixes be merged into older release branches
at their discretion.

When the work to fix a bug is complete, the developer specifies the bug ID in
their commit messages using Closes-Bug: <bug ID> so that
Gerrit automatically marks the bug as "Fix Released" when the
code is merged. See
`the StarlingX code submission guidelines.
<https://wiki.openstack.org/wiki/StarlingX/CodeSubmissionGuidelines>`_

During an active release RC period (prior to the official release),
each sub-project team decides whether a reported bug gates the release
as they are in the best position to articulate the impact. If gating,
the bug must be tagged with the appropriate release tag. The
developer is responsible for cherry picking the fix from the master
branch to the release branch.

Similarly, the sub-project team decides if any bugs need to be
cherry-picked to a released branch. Only critical or high impact issues
will be cherry-picked.

A bug can also be marked as "Invalid" or "Won't Fix" based on further
investigation. Notes must be added to the bug explaining
the rationale. The bug should remain assigned to the developer who
investigated the bug. Do not assign it back to the reporter. This
makes it easier to find bugs you worked on.

^^^^^^^^^^^^^^^^
Bug verification
^^^^^^^^^^^^^^^^

Launchpad does not have a distinction between "Fix Resolved" and "Fix Verified".
Once code merges in master, the bug is automatically updated to "Fix Released"
and considered "Closed". This doesn't provide a way to query bugs that need to
be explicitly retested by the reporter.

An optional tag (stx.retestneeded) will be used to track bugs that
need explicit verification. The tag is added at the
time the bug is triaged (or the reporter at the time the bug is created).

Once the bug is verified by the reporter, a note should be added to
the bug by the reporter and the label will be removed by the stx-bugs team.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Recommended Launchpad display
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It is recommended to customize your display in Launchpad to show the
following information:

* Importance
* Status
* Number
* Assignee
* Tags

***************************
Feature development process
***************************

The feature development process takes place in a number of phases, each
described below. These phases overlap each other in time and are used
here to describe how the work is done and are not meant to be gates
for forward progress.

^^^^^^^^^^^^^
Concept phase
^^^^^^^^^^^^^

The concept phase begins when a user or developer or other community
member has an idea for a new feature for StarlingX. The idea needs to
be documented by following the feature submission process as described
above. Once the new StoryBoard story is submitted, the concept phase is
complete.

^^^^^^^^^^^^^^^^^^^
Specification phase
^^^^^^^^^^^^^^^^^^^

New features for StarlingX require a specification ("spec") to
be written for review and approval by the TSC. The spec is a key
deliverable for the planning phase as the work can not be fully
planned until it is understood and agreed by the community.

The PL for a sub-project
can waive a spec for small changes, but should not do so for any change
that impacts the project's UI, APIs or spans multiple StarlingX
sub-projects. And note that it is possible to cause major changes
to StarlingX by making a one line change in the right place, so the
project team is advised to carefully review a change for its impact
on the project and the need for broader review before approving a waiver
for a spec.

StarlingX specs are stored in a git repo. To start a spec, clone
the StarlingX spec repo:

::

   git clone https://opendev.org/starlingx/specs

Please
`notify the community <Notifying the community_>`_ when you start
working on a specification.
Then read the file specs/instructions.rst which describes the
process of submitting a spec for review.

The spec itself should be submitted for review
by the community early and often. The spec
will be reviewed and approved by the TSC members, who are the core
reviewers for the specs repo. Once the spec is
approved (merged), the spec phase is complete.

^^^^^^^^^^^^^^
Planning phase
^^^^^^^^^^^^^^

The planning phase is largely the responsibility of each StarlingX
sub-project team, who maintain and manage a backlog of stories for the
new features they would like to implement in their part of the project.

Each sub-project PL and TL share the responsibility to review new
story submissions and work with their team members to prioritize and plan
the work. Initial planning should include completing a specification
(see above), breaking down the story into
tasks, assigning the tasks to developers, and making an initial estimate
as to which release the story should be targeted to. All of this planning
should be done and reviewed in the team's
`regularly scheduled calls.
<https://wiki.openstack.org/wiki/Starlingx/Meetings>`_

The Open Infrastructure Foundation holds a `project teams gathering (PTG)
<https://www.openstack.org/ptg/>`_ every 6 months. The PTG is often scheduled
close to the time of other Open Infrastructure events. Review and planning for
new features are discussed as part of the StarlingX PTG meeting. The StarlingX
release cycle is tied to the OpenStack release cycle, so planning features for
the next release at the PTG is a great time for the community to come together
and discuss the technical issues face to face.

Some features may span multiple StarlingX sub-projects. In that case,
the sub-project PLs should consult with the TSC for how the work should
be done early in the planning phase.

The project PL should
`notify the community <Notifying the community_>`_
as features work through
the planning process, separately or in their meeting minutes.

Once the sub-project PL and TL agree that feature planning is complete,
the planning phase is complete.

^^^^^^^^^^^^^^^^^^^^
Implementation phase
^^^^^^^^^^^^^^^^^^^^

The implementation phase can begin at any time in the process and
includes the development of the software changes as well as the
documentation changes and test cases identified in the specification.

Test cases can and should be developed in parallel with the code
changes or ideally before the code changes. You can use test cases
to reproduce the behavior of a defect, for instance, and then
run the test cases with your fix to show that it really is fixed.

As your feature work nears the end your testing should take on
a broader scope. For instance you may need to
work with the test team to run
their test suites. You should also update the release team,
especially near release milestones, to make sure they are aware
of the status of your work.

The `Testing phase`_ section contains additional details on
the testing process to be followed.

See below for guidance on the
testing that developers need to perform prior to code completion.

The implementation phase is complete once all required changes
have been merged by the core reviewers.

^^^^^^^^^^^^^
Release phase
^^^^^^^^^^^^^

The StarlingX `release sub-project <https://wiki.openstack.org/wiki/StarlingX/Releases>`_
has the overall responsibility to manage the delivery of StarlingX releases. The
team tracks new features as they are planned and developed and can move content
into or out of StarlingX releases. All but the smallest features will likely
require close collaboration with the release team. See the `StarlingX Release
Process <https://wiki.openstack.org/wiki/StarlingX/Release_Plan>`_ for more
details on the release process.

Once a software feature is included in a StarlingX release, the release
phase is complete.

*************
Testing phase
*************

Testing a newly developed fix or feature can be as challenging as developing
the fix or feature itself. The effort and work items needed to complete
the testing phase should be considered in the planning phase.

It is possible to cause major changes in the
behavior of the StarlingX software
with very small code changes so thorough testing is important to the stability
of the code. We suggest that feature developers create a test plan
in collaboration with the sub-project's PL and TL, the core reviewers
and subject matter experts within the StarlingX community. Consultation
with members of the project's Test team are also advised.

Test plans can cover one or more StarlingX configurations,
define test
cases focused on the functional changes made, and sometimes include
sanity tests or full regression test runs by the test team, depending
on the impact of the changes made.

Test cases should be automated, and ideally run within Zuul jobs that
are triggered upon code check in. These tests can also be run locally.

It is the responsibility of each project team to ensure that they
have the proper test automation in Zuul jobs for their repos. It is
the responsibility of every developer to submit new automated
tests with their code changes.

Some issues can be configuration specific and for instance only
reproduce on standard configurations on bare metal, or on simplex
configurations in a virtual environment. We don't expect every
developer to have access to multiple hardware setups so collaboration
with the test team is important. Collaboration with the test
team may also be needed
to help create new test cases in their test suites.

Testing should also include unit tests or functional tests. Such
tests should be added to the git repos as part of the code check in.

Once all of the required tests are written, have been checked in
and have been successfully
executed, the test phase is complete. Completion of
developer testing is usually a requirement for acceptance
of the code by the core reviewers, so the implementation and test
phases usually complete at the same time.

*******************
Documentation phase
*******************

Code changes to StarlingX that change the user interface, or
the project's APIs or the behavior of the system should be
documented.

The process to submit a documentation change is described
in the
`Documentation Contributor's Guide.
<https://docs.starlingx.io/contributor/doc_contribute_guide.html>`_

Some changes may require an update to the project's release notes. Please
consult with your sub-project's PL and TL to see if release
notes are needed, and follow the
`Release Note
<https://docs.starlingx.io/contributor/release_note_contribute_guide.html>`_
to contibute your changes to the release notes.

The documentation changes needed for a code change should be
included in the planning phase, working with project's docs team as
for help with the documentation file format or for how to place
your documentation changes into the projects formal documentation.

The documentation phase is complete when all documents impacted
by a change are complete and have been merged by the docs project's
core reviewers.
