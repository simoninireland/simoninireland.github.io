<html><body><div id="heystaks_preview" style="width: 100%;height: 100%"></div>
Smalltalk's influence has declined of late, at least in part because of the  "all or nothing" architecture of the most influential distribution. We've got to the stage that we could change that.

<!--more-->

Some programming languages achieve epic influence without necessarily achieving universal adoption. Lisp was phenomenally influential, but has remained in an AI niche; <a href="https://secure.wikimedia.org/wikipedia/en/wiki/APL_%28programming_language%29" target="_blank">APL</a> gave rise to notions of bulk processing and hidden parallelism without having much uptake outside finance. Smalltalk's influence has been similar: it re-defined what it meant to be an interactive programming environment and laid the ground for many modern interface concepts, as well as giving a boost to object-oriented programming that prepared the way for C++ and Java.

So why does no-one use it any more? Partly it's because of its very interactivity. Smalltalk -- and more especially <a href="http://www.squeak.org" target="_blank">Squeak</a>, its most prominent modern implementation -- are unusual in basing software around  complete interactive images rather than collections of source files. This isn't inherently poor -- images start immediately and encourage direct-manipulation design and interfacing -- but it's radically unfamiliar to programmers used to source code and version control. (Squeak provides version-controlled change sets to collect code outside an image, but that's still an unfamiliar structure.)

But a more important issue is the all-or-nothing nature of Squeak in particular, and in fact of novel languages in general. If you want to use Squeak for a project, all the components really need to be in Squeak (although it can also use web services and other component techniques). If you want to integrate web pages, someone needs to  write an HTML rendering component, HTTP back-end and the like; for the semantic web someone needs to write XML parsers, triple stores, reasoners and the like. You can't just re-use the ones that're already out there, at least not without violating the spirit of the system somewhat. That means it plays well at the periphery with other tools, but at its core need most of the services to be written again. This is a huge buy-in. Similarly Squeak provides a great user interface for direct manipulation -- but only within its own Squeak window, rendered differently and separately from other windows on the screen. These aren't issues inherent to Smalltalk -- it's perfectly possible to imagine a Smalltalk system that used "standard" rendering (and indeed they exist) -- but the "feel" of the language is rather more isolated than is common for modern systems used to integrating C libraries and the like. At bottom it's not necessarily all that different to Java's integration with the host operating system, but the style is very much more towards separation in pursuit of uniformity and expressive power. This is a shame, because Smalltalk is in many ways a perfect development environment for novice programmers (and especially for children, who find it captivating) who are a vast source of programming innovation for small, focused services such as we find on the web ad on smartphones.

So can we make Smalltalk more mainstream? Turn it into an attractive development platform for web services and mobile apps? Looking at some recent developments I think the answer is firmly <em>yes</em> -- and without giving up on the interactivity that gives it its attraction. The key change is (unsurprisingly) the web, or more precisely the current crop of browsers that support Javascript, style sheets, SVG, dynamic HTML and the like. The browser has now arrived at a point at which it can provide a complete GUI -- complete with windows, moving and animated elements and the like -- in a standard, platform-independent and (most importantly) cloud-friendly way.

What I have in mind is essentially implementing a VM for a graphical Smalltalk system, complete with interactive compiler and direct-manipulation editing, in Javascript within a browser. The "image" is then the underlying XML document and its style sheet, which can be downloaded, shared and manipulated directly. The primitives are written in Javascript, together with an engine to run Smalltalk code and objects. Objects are persisted by turning them into document elements and storing them in the DOM tree, which incidentally allows their look and feel to be customised quite simply. Crucially, it can also appeal to any current or emerging features that can appear in style sheets, the semantic web,  Javascript or embedded components: it's mainstream with respect to the other technologies being developed.

Why use Smalltalk, and not Javascript directly? I simply think that the understanding we gained from Smalltalk's simplicity of programming model and embrace of direct manipulation is too valuable to lose. That's not to say that it doesn't need to be re-imagined for the web world, though. In fact, Smalltalk's simplicity and interactivity are ideally suited to the development of front-ends, components and mobile apps -- <em>if</em> they play well with the <em>other</em> technologies those front-ends and apps need to use, and with a suitably low barrier to entry. It's undoubtedly attractive to be able to combine local and remote components together as end-user programs, without the hassle of a traditional compile cycle, and then be able to share those mash-ups directly to the web to be shared (and, if desired, modified) by anyone.

One of the things that's always attracted me about Smalltalk (and Forth, and Scheme -- and Javascript to a lesser extent) is that the code lives completely within  the dominant data structure: indeed, the code <em>is</em> just data in most cases, and can be manipulated using data-structure operations. This is very different from the separation you get between code and data in most other languages, and gives you a huge amount of expressive power. Conversely, one of the thing that always <em>fails</em> to attract me about these <em> </em>same languages is their lack of any static typing and consequent dependence on testing. Perhaps these two aspects necessarily go hand in hand, although I can't think of an obvious reason why that should be.

I know purists will scream at this idea, but to me it seems to go along with ideas that Smalltalk's co-inventor, Alan Kay, has expressed, especially with regard to the need to do away with closely-packaged applications and move towards a more fluid style of software:
<blockquote>The "no applications" idea first surfaced for me at PARC, when we realised that you really wanted to freely construct arbitrary combinations (and could do just that with (mostly media) objects). So, instead of going to a place that has specialised tools for doing  just a few things, the idea was to be in an "open studio" and <em>pull</em> the resources you wanted to combine to you. This doesn't mean to say  that <em>e.g.</em> a text object shouldn't be pretty capable -- so it's a mini app if you will -- but that it and all the other objects that intermingle with each other should have very similar UIs and have their graphics aspect be essentially totally similar as far as the graphics system is concerned -- and this goes also for user constructed objects. The media presentations I do in Squeak for my talks are good examples of the directions this should be taken for the future.</blockquote>
(Anyone who has seen one of Kay's talks -- as I did at the ECOOP conference in 2000 -- can attest to how stunningly engaging they are.) To which I would add that it's equally important today that their <em>data</em> work together seamlessly too, and with the other tools that we'll develop along the way.

The use of the browser as a desktop isn't new, of course: it's central to <a href="http://www.chromium.org/chromium-os" target="_blank">Google Chromium</a> and to <a href="/2011/03/jolicloud/" target="_blank">cloud-friendly Linux variants like Jolicloud</a>. But it hasn't really been used so much as a development environment, or as the host for a language that lives inside the web's main document data structure. I'm not hung-up on it being Smalltalk -- a direct-manipulation front-end to <a href="http://jqueryui.com/" target="_blank">jQuery UI</a> might be even better -- but some form of highly interactive programming-in-the-web might be interesting to try.</body></html>