
#ifndef _PIN_CONTROL_H_
#define _PIN_CONTROL_H_

#include "application.h"

#define PIN_CONTROL_NUM_LED_PINS 1
#define LED_ON  HIGH
#define LED_OFF LOW

class PinControl
{
public:
    static void Init();
    static void SetLed(int num, int value);
    static void SetGarageDoorPin(int value);
    
private:
    static int m_Leds[PIN_CONTROL_NUM_LED_PINS];

};

#endif // _PIN_CONTROL_H_

