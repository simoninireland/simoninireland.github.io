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

Some caveats: This is very much a work in progress, and is a
collection of my opinions, /not/ a peer-reviewed survey.


Introductions
-------------

.. post-list::
   :type: posts
   :tags: project:lisp-bibliography, tutorial
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:


More advanced treatments
------------------------

.. post-list::
   :type: posts
   :tags: project:lisp-bibliography, advanced-tutorial
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:


Implementation techniques
-------------------------

.. post-list::
   :type: posts
   :tags: project:lisp-bibliography, implementation-techiques
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:


Language definitions
--------------------

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
