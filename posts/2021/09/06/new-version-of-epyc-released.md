<!--
.. title: New version of epyc released
.. slug: new-version-of-epyc-released
.. date: 2021-09-06 13:50:48 UTC+01:00
.. tags: epyc, development, software, python, news, experimental design
.. category:
.. link:
.. description:
.. type: text
-->

I released a new version of my ``epyc`` experimental management
library.

<!-- TEASER_END -->

Nothing too dramatic, but I did start the process of refactoring the
way in which experiments are assigned parameters, which is something
I've been meaning to do for a while.

In previous versions an experiment was performed at every point in the
cross-product of all parameters. This can be quite wasteful, and one
of my MSc students used a different approach where they created
experiments pointwise from the corresponding values of each parameter,
which leads to better control.

This is actually a specific example of a more general concept of an
*experimental design*, which imports into computational science the
ways in which traditional experiments are set up. I refactored how
``epyc`` labs create experiments to use an externally-specified design
class, and implemented the old and alternative versions as standard
designs (called "factorial" and "pointwise" respectively).

There's actually another model that we need, the so-called "block"
designs, which would be great for creating fewer networks under
``epydemic` -- but that needs some more thought as to exactly how to
manage the data flow.
