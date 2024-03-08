The Arduino has several sleep modes that can be used to reduce power consumption. The most useful for sensor networks is probably the one that uses the watchdog timer.

<!--more-->

Powering-down the Arduino makes a lot of sense for a sensor network: it saves battery power allowing the system to survive for longer. Deciding <em>when</em> to power the system down is another story, but in this post we'll concentrate on documenting the mechanics of the process. The details are necessarily messy and low-level. (I've been greatly helped in writing this post by <a href="http://www.atmel.com/devices/atmega328p.aspx?tab=documents" target="_blank">the data sheet for the Atmel ATmega328P microcontroller</a> that's used in the Arduino Uno, as well as by <a href="http://donalmorrissey.blogspot.ie/2010/04/putting-arduino-diecimila-to-sleep-part.html" target="_blank">a series of blog posts by Donal Morrissey</a> that also deal with other sleep modes for the Atmel.)
</p><h2>Header files and general information</h2>
To use the watchdog timer, a sketch needs to include three header files:

```c
#include <avr/power.h>
#include <avr/wdt.h>
```

These provide definitions for various functions and variables needed to control the watchdog timer and manage some of the other power functions.
<h2>Power modes</h2>
A power (or sleep) mode is a setting for the microcontroller that allows it to use less power in exchange of disabling some of its functions. Since a microcontroller is, to all intents and purposes, a small computer on a chip, it has a lot of sub-systems that may not be needed all the time. A power mode lets you shut these unneeded sub-systems down. The result saves power but reduces functionality.

Power modes are pretty coarse control mechanisms, and can shut down more than you intend. If your project is basically software-driven, with the Arduino making all the decisions, then a "deep" power-saving mode is ideal; on the other hand, if you rely on hardware-based signals at all, a "deep" sleep will probably ignore your hardware and the Arduino may never wake up.

The watchdog timer is used to manage the "power-down" mode, the deepest sleep mode with the biggest power savings.
<h2>Watchdog timer</h2>
The Arduino's watchdog timer is a countdown timer that's driven by its own oscillator on the microcontroller. It's designed to run even when all the other circuitry is powered down, meaning that the microcontroller is drawing as little power as possible without actually being turned off completely.

Why "watchdog" timer? The basic function of a watchdog timer is to "bite" after a certain period, where "biting" means raising an interrupt, re-setting the system, or both. A typical use of a watchdog is to make a system more robust to software failures. Since the watchdog is handled by the microcontroller's hardware, independent of any program being run, it will still bite even if the software gets stuck in an infinite loop (for example). Some designers set the watchdog ahead of complex operations, so that if the operation fails, the system will reset in a short amount of time and end up back in a known-good configuration. At the end of a successful operation, the program disables the watchdog (before it bites) and carries on. Of course this assumes that the operation completes before the watchdog bites, which means the programmer needs to have a good idea of how long it will take.
<h2>Setting the time-out period</h2>
It's as well to understand how watchdog timers on microcontrollers work. Typically they have a fairly coarse resolution, counting a fixed number of timer ticks before "biting" and performing some function. In the case of the Arduino, the watchdog timer is driven by the internal oscillator running at 128KHz and counts off some multiple of ticks before biting. This value -- the number of ticks counted -- is referred to as the "prescalar" for the timer.

The prescalar is controlled by the values of four bits in the watchdog timer's control register, <code>WDTCSR</code>. To set them up, you pick the value of prescalar you want and set the appropriate bits. If the bits contain a number \( i \), then the watchdog will bite after \( (2048 &lt;&lt; i) / 128000 \) seconds. So \( i = 0\) means the watchdog bites after 16ms; \( i = 1 \) produces  delay of 32ms; and so on up to \( i = 9 \) (the largest value allowed) means the watchdog bites after about 8s.

The word "about" is important here: the oscillator's exact frequency depends on the supply voltage to the chip and some other factors, meaning that you should be conservative about relying on the delay time.

Writing the appropriate value of \( i \) into the control register
involves representing \( i \) as a four-digit binary number and then
writing these bits into four bits of the register -- and unfortunately
these bits aren't consecutive. if \( i = 7 \) for example, then this
is 0b0111 in binary, so we write 1 into bits <code>WDP0</code>,
<code>WDP1</code> and <code>WDP2</code>, and 0 into bit
<code>WDP3</code>, and 0 into all the other bits:

```c
WDTCSR = (1 << WDP0) | (1 << WDP1) | (1 << WDP2);
```

The phrases of the form <code>(1 &lt;&lt; WDP0)</code> simply takes a binary digit 1 and shifts it left into bit position <code>WDP0</code>. The <code>|</code> symbols logically OR these bits together to generate the final bit mask that is assigned to the control register.

Actually there's a little bit more to it than this, as we can't change the watchdog's configuration arbitrarily. Instead we have to notify the chip that it's configuration is about to be changed, by setting two other bits in the control register and then performing the updates we want:

```c
WDTCSR |= (1 << WDCE) | (1 << WDE);
```

Setting <code>WDCE</code> enables changes in configuration to be made in the next few processor cycles, <em>i.e.</em> immediately. Setting <code>WDE</code> resets the timer.

Finally we enable the watchdog timer interrupts by setting bit
<code>WDIE</code>. When the watchdog timer bites, the microcontroller
executes an interrupt handler, re-starts the main program, and clears
<code>WDIE</code>. Any further interrupts, if the time is re-enabled,
will then cause a system reset.

```c
WDTCSR |= (1 << WDIE);
```

So the complete code the setting up the watchdog timer to bite in 2s is:

```c
set_sleep_mode(SLEEP_MODE_PWR_DOWN);              // select the watchdog timer mode
MCUSR &= ~(1 << WDRF);                            // reset status flag
WDTCSR |= (1 << WDCE) | (1 << WDE);               // enable configuration changes
WDTCSR = (1 << WDP0) | (1 << WDP1) | (1 << WDP2); // set the prescalar = 7
WDTCSR |= (1 << WDIE);                            // enable interrupt mode
sleep_enable();                                   // enable the sleep mode ready for use
sleep_mode();                                     // trigger the sleep

/* ...time passes ... */

sleep_disable();                                  // prevent further sleeps</pre>
```

<h2> Interrupt handler</h2>
What happens when the watchdog bites? It causes an interrupt that has to be handled before the program can continue. The interrupt could be used for all sorts of things, but there's often no point in worrying about it: but it still has to be there, to prevent the microcontroller just resetting. The following code installs a dummy interrupt handler:

```c
ISR( WDT_vect ) {
  /* dummy */
}
```

The <code>WDT_vect</code> identifies the watchdog timer's interrupt vector.

While this might seem like a waste of time, it's important to have an interrupt handler as the default behaviour of the watchdog timer is to reset the microcontroller, which we want to avoid. It's also worth noting that, once enabled, the watchdog timer will keep biting, so the interrupt handler will be called repeatedly. (Put a print statement in the hander to see.) This doesn't cause any problems.
