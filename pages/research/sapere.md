<!--
.. title: Sapere
.. slug: sapere
.. date: 2020-06-17 11:34:36 UTC+01:00
.. tags: self-* systems, autonomic computing, spatial computing, project, eu, live semantic annotations, lsa, ecolaws
.. category: research
.. previewimage: /images/sapere-logo.png
.. link:
.. description:
.. type: text
-->

![Sapere logo](/images/sapere-logo.png)

The [Sapere project](https://sites.google.com/site/sapereprojecteu/)
was a project funded by the EU's Future and Emerging Technologies
strand of Framework 7. The goal was to explore how to use
nature-inspired computing techniques to implement scalable services
adapted to their location and context. It was a consortium of five
universities from across Europe:

* Universit&agrave; di Modena &egrave; Reggio Emilia IT (lead)
* Alma Mater Studiorum, Universit&agrave; di Bologna IT
* University of Geneva CH
* Johannes Kepler Universit&auml;t Linz AT
* University of St Andrews UK

The project developed a middleware that exposed the endpoints of
programs running in the system as packets of open data, called *Live
Semantic Annotations* or LSAs, which were
then operated on by a small set of declarative rules. This allowed a
very decentralised approach to distributed systems, both in space and
time: new components could join (or leave), with the system also
responding autonomously to mobility and local failures.

![Sapere middleware architecture](/images/sapere-middleware.jpg)

We ran an instance of the middleware to host a user-facing
application for the 2013 Vienna City Marathon, which tried to manage
crowds of spectators wanting to watch the action and see their
favourite runners.

The St Andrews' work package within the project explored how to do
situation recognition in a distributed and scalable manner on top of
the middleware architecture. We implemented both known and novel
algorithms, driven by a changing pattern of sensors each represented
by an LSA. This was a far more dynamic approach than had been tried
before, and it led us to have to consider the impacts of partial
failures in the sensors, poor and uneven coverage, which informed a
lot of our subsequent work.


Publications
------------

{{% bibliography keywords='Sapere' %}}
