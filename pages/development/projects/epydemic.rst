epydemic
========

.. raw:: html

   <a href="https://pypi.org/project/epydemic">
   <img src="https://badge.fury.io/py/epydemic.svg"/>
   </a>
   <a href="https://pepy.tech/project/epydemic">
   <img src="https://pepy.tech/badge/epydemic"/>
   </a>
   <a href="https://doi.org/10.5281/zenodo.6875267">
   <img src="https://zenodo.org/badge/DOI/10.5281/zenodo.6875267.svg"/>
   </a>
   <a href="https://www.gnu.org/licenses/gpl-3.0.en.html">
   <img src="https://www.gnu.org/graphics/gplv3-88x31.png"/>
   </a>

``epydemic`` is a library for simulating epidemic (and other)
processes over complex networks (and other combinatorial
structures).

Network science uses epidemic spreading processes a lot, both for the
obvious application of modelling diseases, but also for things that
are mathematically similar such as computer viruses and
rumour-spreading. Some simulations use discrete-time approaches where
lots of events happen in a single timestep; others — and this is more
common for research-grade software — use continuous-time stochastic or
Gillespie simulation, which can be significantly faster and is
statistically exact, but is also a lot harder to code up. There didn’t
seem to be a reusable simulation library that would play well with
`NetworkX <https://networkx.github.io/>`_, so I wrote one in the
course of writing my complex networks blog/book. ``epydemic`` releases
this code from the book and allows it to be used stand-alone. For good
measure I integrated it with `epyc </development/projects/epyc/>`_
to allow for reproducible simulations at scale.


Resources
---------

- `Github repo <https://github.com/simoninireland/epydemic>`_
- `Install from PyPi <https://pypi.python.org/project/epydemic>`_
- `Read the API documentation <https://pyepydemic.readthedocs.io/en/latest/>`_


Recent articles about ``epydemic``
----------------------------------

.. post-list::
   :type: posts
   :stop: 5
   :tags: epydemic

`All articles <link:/categories/epydemic/>`_
