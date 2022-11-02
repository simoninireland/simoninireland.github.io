<!--
.. title: New, faster, release of epydemic
.. slug: new-faster-release-of-epydemic
.. date: 2021-05-14 09:33:17 UTC+01:00
.. tags: news, epydemic, development, python, complex networks, epidemic spreading, simulation
.. has_math: true
.. category:
.. link:
.. description:
.. type: text
-->

I just made a new release of `epydemic`.

<!-- TEASER_END -->

It's a fairly incremental set of changes, but dominated by a roughly
7x speed increase that came from replacing the implementation of event
loci with a dedicated data structure rather than using Python's
built-in `set` implementation -- and replacing one line of code
with about 500 lines. This removed a constraint whose complexity
was linear in the number of edges due to an accident of coding
(*i.e.*, due to my stupidity), and replaced it with something that was
both significantly faster and significantly more scalable.

I also added a discussion of moving from $\mathcal{R}$ values to
the probabilities required for simulation, to make things easier for
those more comfortable with this style of epidemic description.

The new version can be installed using `pip install -U
epydemic`, or from [Github](https://github.com/simoninireland/epydemic).
