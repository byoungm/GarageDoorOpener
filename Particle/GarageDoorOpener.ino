#include "GarageControl.h"
#include "PinControl.h"

#define GARAGE_MODULE_STATUS_SIZE 8

void setup()
{
    // Setup Particle Function
    Particle.function("webapi",webapi);

    PinControl::Init();
    GarageControl::Init();
}

void loop()
{

}

int webapi(String command)
{
    int val = 0;
    if (command == "LED_ON" || command == "GARAGE_TURN_LIGHT_ON")
    {
        PinControl::SetLed(0, LED_ON);
        GarageControl::TurnGarageLightOn();
    }
    else if (command == "LED_OFF" || command == "GARAGE_TURN_LIGHT_OFF")
    {
        PinControl::SetLed(0, LED_OFF);
        GarageControl::TurnGarageLightOff();
    }
    else if (command == "GARAGE_DOOR_GET_STATE")
    {
        val |= GarageControl::GetGarageLightState();
        val <<= GARAGE_MODULE_STATUS_SIZE;
        val |= GarageControl::GetGarageDoorState();
    }
    else if (command == "GARAGE_DOOR_CLICK_BUTTON")
    {
        GarageControl::SimDoorClick();
    }
    else
    {
        val = -255;
    }

    return val;
}
