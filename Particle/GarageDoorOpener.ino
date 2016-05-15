#include "PinControl.h"


#define PIN_LED_1 D0
#define PIN_LES_2 D7

void setup()
{

   // Here's the pin configuration, same as last time
   pinMode(PIN_LED_1, OUTPUT);
   pinMode(PIN_LES_2, OUTPUT);

   // We are also going to declare a Spark.function so that we can turn the LED on and off from the cloud.
   Spark.function("led",ledToggle);
   // This is saying that when we ask the cloud for the function "led", it will employ the function ledToggle() from this app.

   // For good measure, let's also make sure both LEDs are off when we start:
   digitalWrite(PIN_LED_1, LOW);
   digitalWrite(PIN_LES_2, LOW);

}

void loop()
{
   // Nothing to do here
}

// We're going to have a super cool function now that gets called when a matching API request is sent
// This is the ledToggle function we registered to the "led" Spark.function earlier.


int ledToggle(String command) {

    if (command=="on") {
        digitalWrite(PIN_LED_1,HIGH);
        digitalWrite(PIN_LES_2,HIGH);
        return 1;
    }
    else if (command=="off") {
        digitalWrite(PIN_LED_1,LOW);
        digitalWrite(PIN_LES_2,LOW);
        return 0;
    }
    else {
        return -1;
    }
}
