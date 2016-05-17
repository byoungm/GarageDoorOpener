#include "PinControl.h"
#include "PinHAL.h"



// Static Members
int PinControl::m_Leds[PIN_CONTROL_NUM_LED_PINS] = {PIN_MAIN_LED};

void PinControl::Init()
{
    for (int i = 0; i < PIN_CONTROL_NUM_LED_PINS; i++)
    {
        pinMode(m_Leds[i], OUTPUT);
        SetLed(i, LED_OFF);
    }
    pinMode(PIN_GARAGE_DOOR_TOGGLE, OUTPUT);
    SetGarageDoorPin(HIGH);
}

void PinControl::SetLed(int num, int value)
{
    if (num < PIN_CONTROL_NUM_LED_PINS)
    {
        digitalWrite(m_Leds[num], value);
    }
}

void PinControl::SetGarageDoorPin(int value)
{
    digitalWrite(PIN_GARAGE_DOOR_TOGGLE, value);
}