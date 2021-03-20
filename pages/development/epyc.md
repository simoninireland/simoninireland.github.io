<!--
.. title: epyc
.. slug: epyc
.. date: 2020-06-17 16:23:09 UTC+01:00
.. updated: 2021-03-17 09:32:08 GMT
.. tags: python, computational science
.. category: development
.. link: https://github.com/simoninireland/epyc
.. description:
.. type: text
-->

[![PyPy project badge](https://badge.fury.io/py/epyc.svg)](https://pypi.org/project/epyc/)
[![API documentation badge](https://readthedocs.org/projects/epyc/badge/?version=latest)](https://epyc.readthedocs.io/en/latest/index.html)
![Test status badge](https://github.com/simoninireland/epyc/actions/workflows/ci.yaml/badge.svg)

`epyc` is a library to manage large sets of computational experiments.

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

`epyc` is being used to manage experiments within my complex networks
blog/book, but it can manage any kind of experiment written in Python,
and can run experiments in parallel using an
[IPython](https://ipython.org) cluster, or locally taking advantage of
a multicore workstation.

[Repository on Github](https://github.com/simoninireland/epyc) <br>
[Install from PyPi](https://pypi.python.org/project/epyc) <br>
[Read the API documentation](https://epyc.readthedocs.io/en/latest/)
