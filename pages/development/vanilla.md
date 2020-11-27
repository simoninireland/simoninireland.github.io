<!--
.. title: Vanilla
.. slug: vanilla
.. date:  2020-06-17 16:43:17 UTC+01:00
.. tags: java, programming, compiler, interpreter
.. category: development
.. link: 
.. description: 
.. type: text
-->

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


Publications
------------

{{% bibliography keywords="Vanilla" %}}
