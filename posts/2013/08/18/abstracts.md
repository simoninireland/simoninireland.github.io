<html><body><p>An abstract is an advertisement, not an introduction.

<!--more-->

I've spent much of this week working with MSc students writing their dissertations, and this has inevitably led to the part of a dissertation that often causes the most pain to write (and read, for that matter): the abstract.

What is the abstract of a report or paper? What it <em>isn't</em> is an introduction or guide to the rest of the document: that, unsurprisingly, is what the introduction is for. The goal of an abstract is much simpler: it's intended to persuade the reader to read some or all of the rest of the document. It may be surprising that this is an issue, but in a world in the grip of an information explosion it's clear that readers' attention is a limiting quantity in information processing. As a reader, should you bother to read a paper? Or not? And how do you make this decision?

Many new researchers, when confronted with a paper, start at the front and work forward. More experienced researchers know this is a mistake that leads to reading whole tracts of irrelevance or nonsense. (The former is worse: nonsense at least has occasional entertainment value.) This leads many people (myself included) to adopt a non-linear reading style:
</p><ol>
	<li>Read the abstract</li>
	<li>If still interested, read the conclusion</li>
	<li>If <em>still</em> interested, read the introduction</li>
	<li>If it's <em>really</em> interesting, read the rest of the paper</li>
</ol>
(There are several variants, a couple of which are described <a href="http://www.sciencebuddies.org/science-fair-projects/top_science-fair_how_to_read_a_scientific_paper.shtml" target="_blank">here</a> and <a href="http://www.wikihow.com/Read-a-Scientific-Paper" target="_blank">here</a>.) The point here is that we can filter out papers of lesser interest to reserve time and head space for the most interesting. Only if the results grab your attention do you need to spend time discovering the detail of how they were obtained -- rather than doing that work only discover that you don't care about the results being reported.

The abstract is the key: without a decent description of what the paper is about, the discerning reader will not proceed even to the introduction, and therefore any work contained in the paper will remain unread -- and therefore be largely worthless.

So how does one write a decent abstract? Most experienced scientists have their own technique, and the approach does need to vary from field to field and for different paper styles: a review paper is different to a piece of primary research. The approach I've come to rely on for research in computer science and mathematics can be described succinctly as <strong>the five-sentence abstract</strong>. I've found five sentences seems to be about optimal, structured as follows:
<ul>
	<li><span style="color: red">The area of the paper (1 sentence).</span> The problem area to which this paper makes a contribution.</li>
	<li><span style="color: orange">The issue the paper addresses (1 sentence).</span> Presumably the area is not yet fully explored, and you've found a problem that needs tackling -- otherwise what's in your paper?</li>
	<li><span style="color: green">What you've done, the results you've obtained (2 sentences).</span> The key contribution of the paper, what you've added to practice and/or knowledge</li>
	<li><span style="color: blue">What this means (1 sentence).</span> Why should anyone care?</li>
</ul>
Let's do an example, from a paper I've always wanted to write about finding unicorns:
<blockquote><span style="color: red">There are lots of interesting animals out there, many of which have horns.</span> <span style="color: orange">No-one has yet reported observing any one-horned horses, however.</span> <span style="color: green">We describe our research survey of the horses of the West of Ireland. While we found many horses, and many other horned animals, we failed to locate any horned horses.</span> <span style="color: blue">We conclude that further research is required to find unicorns, preferably in an equally pleasant holiday destination.</span></blockquote>
OK, perhaps not a great example. Let's try another, from a real paper:
<blockquote><span style="color: red">In the domain of ubiquitous computing, the ability to identify the occurrence of situations is a core function of being context-aware.</span> <span style="color: orange">Given the uncertain nature of sensor information and inference rules, reasoning techniques that cater for uncertainty hold promise for enhancing the reasoning process.</span> <span style="color: green">In our work, we apply the Dempster Shafer theory of evidence to infer situation occurrence with the minimal use of training data. We describe a set of evidential operations for sensor mass functions using context quality and evidence accumulation for continuous situation detection.</span> <span style="color: blue">We demonstrate how our approach enables situation inference with uncertain information using a case study based on a published smart home data set.</span></blockquote>
(Taken from McKeever, Ye, Coyle and Dobson. <a href="http://www.simondobson.org/softcopy/ds-situation-inference-eurossc-09.pdf">Using Dempster-Shafer theory of evidence for situation inference</a>. In Proceedings of the 4th European Conference on Smart Sensing and Context (EuroSSC). Volume 5741 of LNCS. Springer-Verlag. Guildford, UK. 2009.) The abstract goes from domain to challenge to approach to significance: having read it, the reader hopefully has a fairly good idea of what the paper contributes to which domain, and why this contribution is significant (in the authors' minds, at least).

Shorter is often better, of course:
<div title="Page 1">
<div>
<div>
<blockquote><span style="color: red">Wireless sensor networks are attracting increasing interest</span> <span style="color: orange">but suffer from severe challenges such as power constraints and low data reliability. Sensors are often energy-hungry and cannot operate over the long term, and the data they gather are frequently erroneous in complex ways. The two problems are linked, but existing work typically treats them independently:</span> <span style="color: green">in this paper we consider both side-by-side,</span> <span style="color: blue">and propose a self-organising solution for model-based data collection that reduces errors and communications in a unified fashion.</span></blockquote>
</div>
</div>
</div>
(From Fang and Dobson. <a href="http://www.simondobson.org/softcopy/iwsos-faults-energy.pdf">Unifying sensor fault detection with energy conservation</a>. In Proceedings of the 7th International Workshop on Self-Organising Systems (IWSOS'13). Palma de Mallorca, ES. May 2013.) In this case my student Lei messed with the sentence structure because we wanted to get across the idea that the main problem was the totality of the existing approach to the problem, which we wanted to address as a whole. The abstract still follows the basic structure, and I think is stronger for being shorter.

No rule of writing is hard-and-fast, of course, and so you'll often find great abstracts that adopt a completely different approach. I don't think this matters so much as ensuring that the abstract is fit for purpose: an enticement to read further.

 </body></html>