<!--
.. title: SleepySketch
.. slug: sleepysketch
.. date:  2020-06-17 16:43:17 UTC+01:00
.. tags: arduino, programming, c++
.. category: development
.. link: 
.. description: 
.. type: text
-->

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

