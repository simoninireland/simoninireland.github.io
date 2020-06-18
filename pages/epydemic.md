<!--
.. title: epydemic
.. slug: epydemic
.. date: 2020-06-17 16:31:46 UTC+01:00
.. tags: python, computation science, network science, epidemic spreading, simulation
.. category: development
.. link: https://github.com/simoninireland/epydemic
.. description: 
.. type: text
-->

`epydemic` is a library for simulating epidemic processes over
networks.

Network science uses epidemic spreading processes a lot, both for the
obvious application of modelling diseases, but also for things that
are mathematically similar such as computer viruses and
rumour-spreading. Some simulations use discrete-time approaches where
lots of events happen in a single timestep; others — and this is more
common for research-grade software — use continuous-time stochastic or
Gillespie simulation, which can be significantly faster and is
statistically exact, but is also a lot harder to code up. There didn’t
seem to be a reusable simulation library that would play well with
[`networkx`](https://networkx.github.io/), so I wrote one in the
course of writing my complex networks blog/book. `epydemic` releases
this code from the book and allows it to be used stand-alone. For good
measure I integrated it with [`epyc`](/pages/epyc/) to allow for reproducible
simulations at scale.

[Repository on Github](https://github.com/simoninireland/epydemic) <br>
[Install from PyPi](https://pypi.python.org/project/epydemic) <br>
[Read the API documentation](https://pyepydemic.readthedocs.io/en/latest/)
