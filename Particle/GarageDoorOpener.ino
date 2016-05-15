#include "PinControl.h"

void setup()
{
    PinControl::Init();
    
    // Setup Particle Function
    Particle.function("ledToggle",ledToggle);
}

void loop()
{

}

int ledToggle(String command)
{
    int state = 0;
    if (command == "on") 
    {
        PinControl::SetLed(0, ON);
        PinControl::SetLed(1, ON);
    }
    else if (command == "off") 
    {
        PinControl::SetLed(0, OFF);
        PinControl::SetLed(1, OFF);
    }
    else {
        state = -1;
    }
    
    return state;
}



