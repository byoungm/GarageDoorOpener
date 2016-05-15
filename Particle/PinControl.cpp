#include "PinControl.h"
#include "PinHAL.h"



// Static Members
int PinControl::m_Leds[PIN_CONTROL_NUM_LED_PINS] = {PIN_LED_1, PIN_LES_2};

void PinControl::Init()
{
    for (int i = 0; i < PIN_CONTROL_NUM_LED_PINS; i++)
    {
        pinMode(m_Leds[i], OUTPUT);
        SetLed(i, OFF);
    }
}

void PinControl::SetLed(int num, bool on)
{
    if (on)
    {
        digitalWrite(m_Leds[num], HIGH);
    }
    else
    {
        digitalWrite(m_Leds[num], LOW);
    }
}