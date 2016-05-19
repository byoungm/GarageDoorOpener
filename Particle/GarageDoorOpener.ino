#include "GarageControl.h"
#include "PinControl.h"

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
        val = GarageControl::GetGarageDoorState();
    }
    else if (command == "GARAGE_DOOR_CLICK_BUTTON")
    {
        GarageControl::SimClick();
    }
    else 
    {
        val = -255;
    }
    
    return val;
}


