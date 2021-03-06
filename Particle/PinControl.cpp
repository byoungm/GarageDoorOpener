#include "PinControl.h"
#include "PinHAL.h"

// Static Members
int PinControl::m_Leds[PIN_CONTROL_NUM_LED_PINS] = {PIN_MAIN_LED};
int PinControl::m_GarageLightPinLastWrite;

void PinControl::Init()
{
    for (int i = 0; i < PIN_CONTROL_NUM_LED_PINS; i++)
    {
        pinMode(m_Leds[i], OUTPUT);
        SetLed(i, LED_OFF);
    }
    pinMode(PIN_GARAGE_DOOR_TOGGLE, OUTPUT);
    pinMode(PIN_GARAGE_LIGHT_TOGGLE, OUTPUT);
    pinMode(PIN_GARAGE_REED_SWITCH, INPUT);

    SetGarageDoorPin(LOW);
    SetGarageLightPin(LOW);
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

int PinControl::GetReedSwitchPinValue(void)
{
    return digitalRead(PIN_GARAGE_REED_SWITCH);
}

void PinControl::SetGarageLightPin(int value)
{
    m_GarageLightPinLastWrite = value;
    digitalWrite(PIN_GARAGE_LIGHT_TOGGLE, value);
}

int PinControl::GetGarageLightPinValue(void)
{
    return m_GarageLightPinLastWrite;
}
