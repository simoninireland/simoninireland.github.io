<!--
.. title: Attila
.. slug: attila
.. date:  2020-06-17 16:43:17 UTC+01:00
.. tags: forth, c, programming
.. category: development
.. link: 
.. description: 
.. type: text
-->

Attila is an abstract, re-targetable threaded interpreter, developed
as a personal project and an experiment in language design and
cross-compilation.

Threaded interpreted languages (TILs) provide a different view of
language implementation to that traditionally used. I’ve written in
the past about using such systems (typically known as Forth systems
because Forth is the most widespread TIL) for use with sensor networks
and as a possible platform for extensible virtual machines. Exploring
either of these ideas requires access to the TIL that’s easily
modified and easily targeted at a range of platforms. Existing
open-source systems like [GForth](http://www.gnu.org/software/gforth/),
while extremely powerful, are also rather too large and complex for
the task.

Attila is an *ab initio* implementation of a TIL that’s intended form
the start to be simple to port and cross-compile. It includes all the
usual Forth features and words, the ability to define new primitives
in C, and a cross-compiler able to build the system from a bootstrap
and cross-compile it onto other target platforms.

[Repository on Github](https://github.com/simoninireland/attila)
