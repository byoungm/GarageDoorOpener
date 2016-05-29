
#ifndef _GARAGE_CONTROL_H_
#define _GARAGE_CONTROL_H_

typedef enum
{
    GARAGE_DOOR_OPEN = 0,
    GARAGE_DOOR_CLOSED = 1,
    GARAGE_DOOR_STATE_UNKNOWN = 0xFF,
} GarageDoorState_t;

typedef enum
{
    GARAGE_LIGHT_ON = 0,
    GARAGE_LIGHT_OFF = 1,
    GARAGE_LIGHT_STATE_UNKNOWN = 0xFF,
} GarageLightState_t;

class GarageControl
{
public:
    static void Init();
    static void SimDoorClick();
    static void TurnGarageLightOn();
    static void TurnGarageLightOff();
    static GarageDoorState_t GetGarageDoorState();
    static GarageLightState_t GetGarageLightState();
    static void UpdateGarageDoorState(void);

private:
    static GarageDoorState_t m_GarageDoorState;
};

#endif // _GARAGE_CONTROL_H_
