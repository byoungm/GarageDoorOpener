#include "GarageControl.h"
#include "PinControl.h"

// Static Members
GarageDoorState_t GarageControl::m_GarageDoorState;

void GarageControl::Init()
{
    PinControl::SetGarageDoorPin(LOW);
    GarageControl::m_GarageDoorState = GARAGE_DOOR_STATE_UNKNOWN;
}

void GarageControl::SimClick()
{
    PinControl::SetGarageDoorPin(HIGH);
    delay(5000);
    PinControl::SetGarageDoorPin(LOW);
}

void GarageControl::UpdateGarageDoorState(void)
{
    GarageControl::m_GarageDoorState = GARAGE_DOOR_STATE_UNKNOWN;
    int reedSwitch = PinControl::GetReedSwitchPinValue();
    
    if (reedSwitch == HIGH)
    {
        GarageControl::m_GarageDoorState = GARAGE_DOOR_CLOSED;
    }
    else if (reedSwitch == LOW)
    {
        GarageControl::m_GarageDoorState = GARAGE_DOOR_OPEN;
    }
    
}

GarageDoorState_t GarageControl::GetGarageDoorState()
{
    UpdateGarageDoorState(); // This can be called as an asynchrous update if needed
    return GarageControl::m_GarageDoorState;   
}