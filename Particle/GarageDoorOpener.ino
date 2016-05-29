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
    if (command == "LED_ON")
    {
        PinControl::SetLed(0, LED_ON);
    }
    else if (command == "LED_OFF")
    {
        PinControl::SetLed(0, LED_OFF);
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
    else if (command == "GARAGE_TURN_LIGHT_ON")
    {
        GarageControl::TurnGarageLightOn();
    }
    else if (command == "GARAGE_TURN_LIGHT_OFF")
    {
        GarageControl::TurnGarageLightOff();
    }
    else
    {
        val = -255;
    }

    return val;
}
