.. _code-submission-guide:

==========================
Code Submission Guidelines
==========================

------------
Code reviews
------------

* Use Gerrit for StarlingX code reviews
* Follow the OpenStack Git Commit Good Practice for
  `Git Commit Messages <https://wiki.openstack.org/wiki/GitCommitMessages>`_
* Add the core reviewers for the affected sub-project to the review, as well as
  any other interested reviewers

  * The core reviewers are listed in each sub-project repository. Refer to the
    list of
    `sub-project repos <https://review.opendev.org/#/admin/groups/?filter=starlingx>`_
  * In order for code to get merged, two core reviewers must give the review +2.
    A final Workflow +1 from one core reviewer will allow the code to merge.
    Typically, the final W+1 is done by the second core reviewer.
  * If a core reviewer sets a -2, the code cannot be merged until that reviewer
    removes their -2.
  * Authors should not review their own code and, therefore, should not +2 or W+
    their code submissions

    * If an exception is needed (ex: emergency fix for a broken build), the
      author should send an email to the mailing list to let the community know
      or contact the core reviewers on IRC.

-------------------
Code review process
-------------------

* Any contributor can review commits by any other contributor, optionally adding
  comments and/or setting approvals of -1/0/+1. For regular contributors, these
  are considered opinion only, though the core reviewers
  will generally take them into account.
* Reviewers should set "-1" to indicate there are things which must be fixed
  before the review should be approved. If a reviewer sets -1, they must leave
  one or more comments indicating specific issues.
* If line-specific issues are raised by a reviewer, it is expected that the
  committer leaves line-specific comments indicating that it has been addressed
  (this could be a simple as replying with "Done"), or if not, why not. General
  comments applying to the whole review should be replied to in the general
  comments.
* Reviewers may prefix comments with "nit:". This indicates a fix that would be
  nice but would not block merging the commit. If a new revision is needed to
  fix any non-nit issues, it is expected that any nits should be fixed at that
  time.
* For more details, refer the OpenStack code review process, documented in the
  `OpenStack Developer Guide <https://docs.openstack.org/infra/manual/developers.html#code-review>`_

.. _link-review-to-story:

----------------------------
Link reviews to story or bug
----------------------------

* For traceability, always link your code change to a story or bug. The
  story/bug will give reviewers context for the code changes. This will also be
  used to help determine the relative priority of the code changes.
* Gerrit will update the status of the story/bug automatically once the code is
  merged.
* Linking to StoryBoard Stories: Specify the story and task ID in the commit
  message as follows:

  * Story: $story_id
  * Task: $task_id
  * Example: https://review.openstack.org/#/c/590083/
* Linking to Launchpad Bugs: Specify the Bug ID in the commit message as
  follows:

  * Closes-Bug: $bug_id -- use 'Closes-Bug' if the commit is intended to fully
    fix and close the bug being referenced.
  * Partial-Bug: $bug_id -- use 'Partial-Bug' if the commit is only a partial
    fix and more work is needed.
  * Related-Bug: $bug_id -- use 'Related-Bug' if the commit is merely related
    to the referenced bug.
  * If a fix requires multiple commits, use "Partial-Bug" with only the final
    commit using "Closes-Bug"
  * Example: https://review.openstack.org/596305

-------------------------------------
Pre-review and pre-submission testing
-------------------------------------

* For the majority of cases, it is expected that the author completes their
  testing before posting a review.
* Make sure the new code compiles and builds successfully.
* For each package being modified, update the ``TIS_PATCH_VER`` variable in
  the centos/build_srpm.data. This ensures that packages are versioned
  correctly and the latest version will be used. If up-versioning a
  package then reset ``TIS_PATCH_VER`` to 0.
* Run tox tests (flake8, py27, etc) successfully. These can all be run manually
  prior to launching a review.
* Update existing automated unit tests and add new ones when applicable.
* Verify basic functional testing on a live system to ensure the new code gets
  executed and functions correctly.
* If needed, consult with the core reviewers or send questions to the mailing
  list regarding required/recommended testing.
* Add the details of the testing performed as a comment in the review so that
  the core reviewers are aware of it. It will save time if they don't have to
  ask for this information and wait for it to be added.

-------------------------
Early review and feedback
-------------------------

* In specific cases, changes can be posted for early review prior to testing
  (ex: need early feedback on detailed design/coding approach)
* Such changes should be marked as WIP in the commit message and given a
  Workflow -1 immediately by the author
* The author should also include a comment in the review explaining the purpose
  of the review and why the testing is deferred.
* Reviewing code early and often helps catch design and coding errors sooner
  and shows us following the Four Opens.

--------------
Cherry-picking
--------------

* All code changes must be pushed to master first and then cherry-picked to the
  appropriate release branch as needed
* Exception: Feature branches used during development

------------
Patch rebase
------------

* During patch re-base, there is a chance that patches can be applied by
  treating the patch line numbers as approximate, rather than a strict
  requirement, just so long as the before/after context seems to be correct.
  They require fuzzing during the patch apply, and an .orig file will be
  created as the consequence of applying patches that are not clean.

* In StarlingX, we will not accept fuzzing patches. All patches are required to
  be re-based cleanly so that no fuzzing and no .orig files are generated.
