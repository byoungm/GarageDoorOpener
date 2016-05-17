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
    delay(500);
    PinControl::SetGarageDoorPin(LOW);
}

GarageDoorState_t GarageControl::GetGarageDoorState()
{
    return GarageControl::m_GarageDoorState;   
}