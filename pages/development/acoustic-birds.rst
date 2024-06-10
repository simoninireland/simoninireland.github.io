Bird counting with acoustic sensing
===================================

Everybody likes birds, which makes them a great target for sensing.
There are already a lot of platforms available for recording,
detecting, identifying, and counting birds, and I decided to deploy
some of them, largely for practice but also to feed-into some work
we've been doing on target counting and estimation.

The starting point was `BirdNet-Pi
<https://github.com/mcguirepr89/BirdNET-Pi/wiki/Installation-Guide>`_,
an acoustic bird-identification platform running on a Raspberry Pi and
making use of the `BirdNET <https://birdnet.cornell.edu/>`_ platform
developed at Cornell Lab of Ornithology. The great part is that all
the recognition runs locally, making use a pre-trained machine
learning model.

The more traditional approach separates these two functions
(collection and classification), with the former in the field and the
latter offline. This is cheaper and easier to power, but more
labour-intensive in terms of collection and analysis -- as well as
being a lot less engaging for a user (like me).

.. post-list::
   :type: posts
   :tags: project:acoustic-birds
   :template: series_post_list.tmpl
   :require_all_tags:
   :reverse:
