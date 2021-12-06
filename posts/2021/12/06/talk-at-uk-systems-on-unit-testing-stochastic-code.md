<!--
.. title: Talk at UK Systems on unit testing stochastic code
.. slug: talk-at-uk-systems-on-unit-testing-stochastic-code
.. date: 2021-12-06 16:49:30 UTC
.. tags: news,talk,unit testing,epydemic,python
.. category:
.. link:
.. description:
.. type: text
-->

Last week I went to my first scientific meeting since February 2021 to
talk about unit testing of stochastic code.

<!-- TEASER_END -->

This was to the 6th UK Systems Research Challenges Workshop in Co
Durham. I presented work about an issue we encountered when developing
``epydemic``, and particularly when optimising some of the core data
structures. The issue was that a bias in the random choice -- which we
knew was there -- was only observed by some simulation processes and
not by others, meaning we picked it up later than we should have
done.

Having said that, this does raise some issues about how to go about
testing code that has stochastic elements. Some of the things you'd
normally think of as being unit tests -- for example whether an
epidemic happens under a particular process -- are really only
*elements* of unit tests, as they need to be repeated several times to
account for possible outliers. Similarly some processes should
generate specific final degree distributions that need to be checked
against the know theoretical result, which is also stochastic. This
was the essence of the talk. We'll hopefully refactor some of
``epydemic``'s codebase to make the "aggregate unit test" functions
stand-alone at some point.

{{%bibitem UK-Systems-21 %}}
