<!--
.. title: Generating functions for epydemic
.. slug: generating-functions-for-epydemic
.. date: 2021-06-10 18:22:16 UTC+01:00
.. tags: news, development, complex networks, python, epidemic spreading, epydemic, simulation, generating functions
.. category:
.. link:
.. description:
.. type: text
-->

The next version of ``epydemic`` has just been released. It now
includes a generating functions library.

<!-- TEASER_END -->

[Generating
functions](https://en.wikipedia.org/wiki/Generating_function) are
commonly found in network science. They represent entire probability
distributions as a single object that can be manipulated. Implementing
generating functions in a computer is a slightly tricky process,
however, not least because some of the operations need both complex
numbers and high-precision arithmetic.

To make them simpler to use, we've added a small generating functions
library to ``epydemic``. You can then compare simulation results
directly with theoretical calculations, all within the same piece of
code. It encapsulates the tricky code needed to handle the generating
functions of large networks, has the generating functions for the
common degree distributions built-in, and can build the generating
function of an empirical network. There's also a discussion of some of
the implementation issues that had to be solved.

The generating functions library is in version 1.7.1 of the library,
which can be found [at its distribution
page](https://pypi.org/project/epydemic/).
