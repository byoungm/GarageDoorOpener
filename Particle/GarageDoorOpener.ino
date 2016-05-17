#include "GarageControl.h"
#include "PinControl.h"

void setup()
{
    // Setup Particle Function
    Spark.function("webapi",webapi);

    PinControl::Init();
    GarageControl::Init();
}

void loop()
{

}

int webapi(String command)
{
    int val = 0;
    if (command == "on") 
    {
        PinControl::SetLed(0, LED_ON);
    }
    else if (command == "off") 
    {
        PinControl::SetLed(0, LED_OFF);
    }
    else if (command == "GetGarageDoorState")
    {
        val = GarageControl::GetGarageDoorState();
    }
    else if (command == "GarageDoorButtonClicked")
    {
        GarageControl::SimClick();
    }
    else 
    {
        val = -255;
    }
    
    return val;
}


