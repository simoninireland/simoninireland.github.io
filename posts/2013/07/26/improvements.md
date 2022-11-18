It's funny how even early experiences change the way you think about a design. Two minor changes to SleepySketch have been suggested by early testing.

<!--more-->

The first issue is obvious: milliseconds are a really inconvenient way to think about timing, especially when you're planning on staying asleep for long periods. A single method in SleepySketch to convert from more programmer-friendly days/hours/minutes/seconds times makes a lot of difference.

The second issue concerns scheduling -- or rather regular
scheduling. Most sampling and communication tasks occur on predictable
schedules, say every five hours. In an <a href="/2013/06/01/actor-systems/" target="_blank">actor
framework</a>, that means the actor instance (or another one) has to
be re-scheduled after the first has run. We can do this within the
definition of the actor, for example using the <code>post()</code>
action:

```c
class PeriodicActor : public Actor {
   void post();
   void behaviour();
}

...

void PeriodicActor::post() {
   Sleepy.scheduleIn(this, Sleepy.expandTime(0, 5));
}
```

(This also demonstrates the <code>expandTime()</code> function to re-schedule after 0 days and 5 hours, incidentally.) Simple, but bad design: we can't re-use <code>PeriodicActor</code> on a different schedule. If we add a variable to keep track of the repeating period, we'd be mixing up "real" behaviour with scheduling; more importantly, we'd have to do that for <em>every</em> actor that wants to run repeatedly.

A better way is to use an actor combinator that takes an actor and a period and creates an actor that runs first re-schedules the actor to run after the given period, and then runs the underlying actor. (We do it this way so that the period isn't affected by the time the actor actually takes to run.)

```c
Actor *a = new RepeatingActor(new SomeActor(), Sleepy.expandTime(0, 5));
Sleepy.scheduleIn(a, Sleepy.expandTime(0, 5))
```

The <code>RepeatingActor</code> runs the behaviour of
<code>SomeActor</code> every 5 hours, and we initially schedule it to
run in 5 hours. We can actually encapsulate all of this by adding a
method to <code>SleepySketch</code> itself:

```c
Sleepy.scheduleEvery(new SomeActor(), Sleepy.expandTime(0, 5));
```

to perform the wrapping and initial scheduling automatically.

Simple sleepy sketches can now be created at set-up, by scheduling
repeating actors, and we can define the various actors and re-use them
in different scheduling situations without complicating their own
code.
