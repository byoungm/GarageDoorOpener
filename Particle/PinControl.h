
#ifndef _PINCONTROL_H_
#define _PINCONTROL_H_

#define PIN_CONTROL_NUM_LED_PINS 2
#define ON 1
#define OFF 0

class PinControl
{
public:
    static void Init();
    static void SetLed(int num, bool on);
    
private:
    static int m_Leds[PIN_CONTROL_NUM_LED_PINS];

};

#endif _PINCONTROL_H_

