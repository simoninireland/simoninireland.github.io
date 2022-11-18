<html><body><p>A library for using XBee radios with Arduinos.

<!--more-->

The XBee radio operates in <a href="/2013/07/01/xbee/" target="_blank">two modes</a>: transparent or text-based, and API or binary-based. The latter (API mode) is generally considered more suitable for computer-to-computer interactions, as it's faster and simpler for computers to manipulate. However, using an XBee in this mode requires additional software.

The <a href="https://code.google.com/p/xbee-arduino/" target="_blank">xbee-arduino library</a> provides Arduino functions to access the API mode functionality of the various XBee radio modules. The library is quite low-level, but does provide access to all the necessary functions like issuing AT commands to control the modem and sensing and receiving packets of data to other radios in the mesh network.

To use the library you download the latest version from the web page and unpack it into the <tt>libraries/</tt> directory of your Arduino IDE. You also need to make sure that the radios you use have the <a href="/2013/07/02/xctu/" target="_blank">API function set installed using X-CTU</a>, as the library only makes sense for radios in API mode. You also have to set the "AP" parameter to 2 when writing the firmware.</p></body></html>
