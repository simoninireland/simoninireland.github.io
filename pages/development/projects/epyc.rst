epyc
====

.. raw:: html

   <a href="https://pypi.org/project/epyc">
   <img src="https://badge.fury.io/py/epyc.svg"/>
   </a>
   <a href="https://zenodo.org/badge/latestdoi/63255319">
   <img src="https://zenodo.org/badge/63255319.svg"/>
   </a>
   <a href="https://www.gnu.org/licenses/gpl-3.0.en.html">
   <img src="https://www.gnu.org/graphics/gplv3-88x31.png"/>
   </a>

``epyc`` is a library to manage large sets of computational experiments.

Computational science often needs us to perform a lot of repetitions
of experiments, for example to reduce variance or to cancel out
strange artefacts. Typically one might also want to perform a set of
experiments across a parameter space, varying one or more parameters
to see their effect. All these tasks generate a lot of repetitions
that need to be managed while they’re on-going, and a lot of result
data that needs to be kept archived.

These activities are so structured, so repetitive, and so common, that
they cry out for automation — but there didn’t seem to be an
automation library for doing this sort of thing in Python. So I wrote
one.

``epyc`` is being used to manage experiments with complex networks,
but it can manage any kind of experiment written in Python, and can
run experiments in parallel using an `IPython compute cluster
<https://ipython.org>`_, or locally taking advantage of a multicore
workstation.


Resources
---------

- `Github repo <https://github.com/simoninireland/epyc>`_
- `Install from PyPi <https://pypi.python.org/project/epyc>`_
- `Read the API documentation <https://epyc.readthedocs.io/en/latest/>`_


Recent articles about ``epyc``
------------------------------

.. post-list::
   :type: posts
   :stop: 5
   :tags: epyc

`All articles <link:/categories/epyc/>`_
