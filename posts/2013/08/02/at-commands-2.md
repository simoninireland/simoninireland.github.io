Controlling the XBee requires issuing AT commands. The XBee library has the low-level machinery to do this.

<!--more-->

AT commands are the basis for controlling almost all modems, and the XBee is no different. In API mode, AT commands are issued in a similar manner to sending data. The Arduino XBee library has the low-level code needed, which can be wrapped into a slightly easier-to-use form.

The basic approach is to send an AT command request packet and then
read a returned packet acknowledging the command. For the moment we'll
stick to "setting" commands, where the AT command takes an integer
parameter: the other are needed less frequently. We construct the
request packet, send it, read the response, and check that all went
well. This isolates the rest of the program from the message exchange,
but also hides the exact nature of any error.

```c
#include <XBee.h>

XBee radio;

int atCommand( char *command, uint8_t param ) {
  // send local AT command
  AtCommandRequest req = AtCommandRequest((uint8_t *) command, (uint8_t *) &amp;param, sizeof(uint8_t));
  radio.send(req);

  // receive response frame
  AtCommandResponse res = AtCommandResponse();
  if(radio.readPacket(500)) {                               // read packet from radio
     if(radio.getResponse().getApiId() == AT_RESPONSE) {    // right type?
       radio.getResponse().getAtCommandResponse(res);
       if(res.isOk()) {                                     // not an error?
         return 0;
       }
     }
  }

  // if we get here, return a failure
  return 1;
}
```

This function can be used to issue the different control codes for the radio. Some parameters can be <a href="/blog/2013/07/02/xctu/">set using X-CTU </a>when the radio firmware is installed, but commands are sometimes needed at run-time too.
