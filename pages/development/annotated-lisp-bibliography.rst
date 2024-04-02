An annotated Lisp bibliography
==============================

Lisp is a "forever" language that's still going reasonably strong
despite also being an ancestor to much of modern programming language
design. It defines both a programming style and a mode of thinking
about programming, best expressed by `Abelson and Sussman
<link:/2024/01/27/structure-and-interpretation-of-computer-programs/>`_
as "stratified" design in which all the levels are programmable -- and
its this focus on having a programming model for each abstraction
layer that's the key to differentiating Lisp programming. It's an idea
that's influenced me profoundly and led me to become, and remain, a
Lisp programmer -- firstly to `extend and adapt my Emacs environment
<link:categories/emacs/>`_, and increasingly as a basis for new
projects (even though most of my academic work needs to stay in
Python).

Such is Lisp's longevity that it's spawned what is perhaps the largest
literature of any single programming language -- too much to collect
in its entirety, but for various reasons I've decided to bring
together an annotated bibliography of the material I find most
interesting. I'm doing this by curating a series of articles reviewing
the key papers and books, adding some structure to hopefully make them
easier to browse and reference.

A lot of the books mentioned are now out of print and unavailable in
electronic form: fortunately `my university
<https://www.st-andrews.ac.uk>`_ has a long history of programming
language research, and correspondingly good library collections. Some
of the papers similarly required some tracking down, and I've included
URLs wherever possible.

Some caveats: This is very much a work in progress, has significant
gaps, and is a collection of my opinions, *not* a peer-reviewed
survey. Having said that, I hope it's useful.

You can subscribe to new posts in this series `here </categories/projectlisp-bibliography.xml>`_.


Introductions
-------------

There are plenty of sources for learning Lisp from scratch, and rather
intriguingly they've continued to be written from the earliest days up
to the present.

.. post-list::
   :type: posts
   :tags: project:lisp-bibliography, tutorial
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:


More advanced treatments
------------------------

Once you've got the basics, a more advanced treatment is in order.
Lisp has what is in many people's opinion (including mine) the best
advanced treatment of programming ever written for *any* language --
and then also has books has push the boundaries of what's possible
within the language and (especially) its macro system. And macros are
what really make Lisp code fly and give it a power that exceeds that
of many more modern languages.

.. post-list::
   :type: posts
   :tags: project:lisp-bibliography, advanced-tutorial
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:


Applications
------------

Contrary to popular belief, there is still new software being written
in Lisp. Admittedly it's a niche speciality and not as supported by
libraries as are other languages. But Lisp's extensibility does make
it attractive for some domains (and some programmers), and there are
several places in which its unique features really give an edge.

.. post-list::
   :type: posts
   :tags: project:lisp-bibliography, applications
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:


Experiences
-----------

A collection of works that speak to the "Lisp experience" in different
ways.

.. post-list::
   :type: posts
   :tags: project:lisp-bibliography, experience
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:


Implementation techniques
-------------------------

All languages benefit from specific implementation techniques: Lisp
perhaps more than others, as its programming model sits so far from
that of most processors. That having been said, Lisp has served as a
test-bed for a range of techniques from compilation to run-time, some
of which have influenced other languages' designs as well.

.. post-list::
   :type: posts
   :tags: project:lisp-bibliography, implementation-techiques
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:


Language definitions
--------------------

Lisp isn't really just *one* language, or even just Common Lisp and
Scheme. It's better thought of as a style or family of languages
that has grown alongside the capabilities of processors and the
imaginations of its users.

.. post-list::
   :type: posts
   :tags: project:lisp-bibliography, language-reference
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:


Lisp machines
-------------

Throughout the 1970s there was a strand of research looking to develop
processors optimised for running Lisp, since the current
implementations rapidly butted-up against the hardware limitations. It
was such a fertile set of ideas that MIT span-out *two* companies
making different Lisp machines: `Lisp Machines International
<https://en.wikipedia.org/wiki/Lisp_Machines>`_ (LMI) and `Symbolics
<https://en.wikipedia.org/wiki/Symbolics>`_.

.. post-list::
   :type: posts
   :tags: project:lisp-bibliography, hardware
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:


Where it all started
--------------------

Some of the very earliest papers and books on Lisp, and the ideas that
predate it.

.. post-list::
   :type: posts
   :tags: project:lisp-bibliography, history
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:


Other resources
---------------

Only when I started pulling this series together did I really
understand the extent of the Lisp literature and the wide range of
historical (and other) resources that already exist. These include:

- The amazingly complete
  `Interlisp bibliography <https://interlisp.org/history/bibliography/>`_,
  unsurprisingly focused mainly on `Medley Interlisp <https://interlisp.org/>`_
  and not annotated, but including pointers to a huge range of
  material. (Thanks to `Paolo Amoroso <https://fosstodon.org/@amoroso>`_
  for pointing me at this.)
- Nelson Beebe's `Common Lisp bibliography
  <http://ftp.math.utah.edu/pub/tex/bib/common-lisp.html>`_, again
  covering a wide range of Lisp and Lisp-adjacent systems. (Thanks to
  Mastodon user `@lispm <https://moth.social/@lispm>`_ for the link.)
