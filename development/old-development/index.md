<!--
.. title: Older development projects
.. slug: old-development
.. date: 2020-06-17 16:43:17 UTC+01:00
.. tags: python, forth, arduino, java
.. category: 
.. link: 
.. description: 
.. type: text
-->

Some older projects, now either discontinued or long ignored.


## Sleepysketch

Programming sensor networks is a very different experience from
programming modern systems: low memory, restricted computational and
communications capabilities, poor development and debugging
environments, and highly restricted battery power. It’s the latter
that’s a real killer, especially when deploying into the wild: how do
we keep the power consumption down? I did a summer project to explore
these ideas, and SleepySketch was one of the main results.

The [Arduino](http://arduino.cc/) is a hobbyist hardware platform
that’s peculiarly attractive for sensor systems, as it’s so cheap and
surrounded by an ecosystem of extension modules (“shields”) that
simplify development — especially for those of us whose electronics
skills leave something to be desired. As a hobby device, though, the
Arduino software platform (“sketches”) is designed for simplicity, not
for longevity in sensing applications. So I wrote a harness to help
keep the power down.

SleepySketch is a framework within which to deploy Arduino
applications. Its main goal is to keep the microcontroller asleep for
as much of the time as possible, waking up to run tasks and then going
into low-power mode. This lets the programmer supply the things that
*should* happen, and leave SleepySketch to manage the (hopefully
extensive) down time.

[Repository on Github](https://github.com/simoninireland/sleepysketch)


## Attila

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


## Vanilla

The Vanilla project was an experiment in language design, intended to
test two hypotheses:

1. To what extent are programming languages composed of independent
    sub-features that can themselves be independently described and
    composed?, and,
2. If this is so to a large extent, is it possible to build effective
    language tools (specifically interpreters) from such
    independently-compiled features?

The answer to the first question is a qualified “yes”: a programming
language is, to a large extent, composed of features that are either
independent of other features or interact with them in modular
ways. An if statement, for example, depends on there being a `Boolean`
type in the language, but is independent of the types and expressions
that appear in its two arms. This suggests that we should be able to
define the typing and semantic rules of if statements independently of
almost all other language features.

In developing Vanilla we developed a modular, composable type-checking
and interpretation framework within which to define language features
and their associated rules. We then developed a large range of
language features within the framework, including most of the
machinery needed to build imperative, object-oriented and (strict)
functional languages.

The main disadvantage of Vanilla is that it uses Java, both as a
run-time host language and for expressing the rules and
structures. The code that designers have to write is extremely
stylised and repetitive. It would be better to have a more powerful
language for describing languages, and also to allow rule-based
expressions.
