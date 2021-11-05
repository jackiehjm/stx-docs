.. _blog_contribute_guide:

===========================
Blog Post Contributor Guide
===========================

This section describes the guidelines for contributing new blog posts to the
StarlingX website.

.. contents::
   :local:
   :depth: 1

-------------------------------------------
Share your stories on the StarlingX Website
-------------------------------------------

Are you experimenting with StarlingX or have it deployed in production and
would like to share your story as a case study? Do you have an edge use case
that StarlingX fits into, but the world doesn't know it yet? Do you have
features in the platform that you like and would like to highlight? Do you have
a StarlingX demo that you would like to draw attention to?

Share your StarlingX story on the `StarlingX blog
<https://www.starlingx.io/blog/>`_! You are only a few steps away...

************************
StarlingX website source
************************

Unlike the rest of the StarlingX artifacts, the StarlingX website code and
content is stored in a `GitHub repository
<https://github.com/StarlingXWeb/starlingx-website>`_.

The blog posts are written using markdown language that is mainly plain text with a few
easy formatting conventions to create lists, add images or code blocks, or
format the text.

You can find many `cheat sheets <https://www.markdownguide.org/cheat-sheet/>`_
floating on the web to get in terms of the basic syntax. You can also check the
`source files of the already existing blog posts
<https://github.com/StarlingXWeb/starlingx-website/tree/master/src/pages/blog>`_
, where you will find examples of all the basic items that you will
need for your new entry.

**********************
Create a new blog post
**********************

When you create a new blog post, you need to create a new file in the
`'src/pages/blog/' folder
<https://github.com/StarlingXWeb/starlingx-website/tree/master/src/pages/blog>`_
with a '.md' extension.

Files are usually named 'starlingx-<the-title-of-your-blog-post>.md'.

The markdown file has a few formatting conventions in its header to capture the
title, author, publishing date and category of your blog post.

The header looks like the following:

::

  ---
  templateKey: blog-post
  title: The Title of Your Amazing Blog Post
  author: Your Name
  date: 2021-01-28T16:23:52.741Z
  category:
    - label: News & Announcements
      id: category-A7fnZYrE1
  ---

The categories give the possibility to filter on the web page and see only the
blog posts that fall under one of the options. You can choose from the
following options:

* News & Announcements
* Features & Updates

The 'Annual Report' category is reserved for the StarlingX chapter in the
Open Infrastructure Annual report that we are also re-posting on the StarlingX
website.

Blog posts usually start with a one-sentence overview and teaser that is
formatted by using the '<!-- more -->' tag at the end of that line.

Once you filled out the above fields in the header and got your one-liner all
set, you can go ahead and type up the contents of your blog post using the
conventional markdown formatting.

If you have an image file to add, you need to place the file in the
'static/img' folder.

You can then insert the image into your blog post by using the following line:

::

  ![alt text](/img/the-file-name-of-your-image.jpg)

Once you are done with formatting your blog post and happy with the content, you
need to upload it to GitHub and create a pull request. You can do that by using
git commands on your laptop or you can also use the GitHub web interface to add
files to the repository and create a pull request when you are ready.

If you have an idea for a blog post and would like to get feedback from the
community about it, please send an email to the `starlingx-discuss mailing list
<http://lists.starlingx.io/cgi-bin/mailman/listinfo/starlingx-discuss>`_.

If you need help with either writing and formatting the content or uploading
the final product to GitHub, please reach out to Ildiko Vancsa
(ildiko@openinfra.dev) for help.
