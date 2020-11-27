Some initial measurements of power consumption.

<!--more-->

How much power does Arduino sleep mode save? The simplest way to work this out is to power an Arduino from a battery pack and measure the current being drawn in the different modes. A simple program to demonstrate the different modes is:
</p><ul>
	<li>Normal <code>delay()</code> loop</li>
	<li>Deep sleep for a period (deep sleep)</li>
	<li>Flash the LED (awake)</li>
	<li>Flash the LED differently while sending out radio messages (awake and transmitting)</li>
</ul>
We perform these tasks repeatedly, keeping them going for 10s each to let the power draw stabilise.

The results are as follows:

<table style="border: 1">
<tbody>
<tr>
<td>Activity</td>
<td>Power mode</td>
<td>Current</td>
</tr>
<tr>
<td>Nothing</td>
<td><code>delay()</code> loop</td>
<td>43mA</td>
</tr>
<tr>
<td>Nothing</td>
<td>Deep sleep</td>
<td>33mA</td>
</tr>
<tr>
<td>Steady LED</td>
<td>Deep sleep</td>
<td>34mA</td>
</tr>
<tr>
<td>Flashing LED</td>
<td>Awake</td>
<td>45mA</td>
</tr>
<tr>
<td>Xbee (quiet)</td>
<td>Deep sleep</td>
<td>72mA</td>
</tr>
<tr>
<td>Xbee (quiet)</td>
<td>Awake</td>
<td>85mA</td>
</tr>
<tr>
<td>Xbee (transmitting)</td>
<td>Awake</td>
<td>87mA</td>
</tr>
</tbody>
</table>

The good news is that SleepySketch makes it very easy to access the deep sleep mode, and to stay in it by default. This is good, as the normal approach of using <code>delay()</code> is quite power-hungry. The bad news is that the "at rest" power consumption of an Arduino even in deep sleep  -- the quiescent current being drawn by the voltage regulator and other components on the board, regardless of what the microcontroller is doing -- is about 35mA, with an XBee drawing an additional 40mA.There is very little difference in power whether the radio is transmitting or not (although the current being drawn looked more variable when transmitting, suggesting that there's some variation happening faster than the ammeter's sample time).

The radio isn't put to sleep when the Arduino is asleep, which is clearly something that needs to happen: it draws power even when the Arduino is incapable of using it. Something to explore. Potentially more serious is the power being drawn when the Arduino is asleep. A battery pack with 4 x 1500mAH batteries will be drained in about 7 days (6000mAH / 35mA) even with the system asleep all the time.

[UPDATE 1Aug2013: made the table layout a bit clearer.]
