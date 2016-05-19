
#ifndef _GARAGE_CONTROL_H_
#define _GARAGE_CONTROL_H_

typedef enum
{
    GARAGE_DOOR_OPEN = 0,
    GARAGE_DOOR_CLOSED = 1,
    GARAGE_DOOR_STATE_UNKNOWN = 0xFFFF,
} GarageDoorState_t;

class GarageControl
{
public:
    static void Init();
    static void SimClick();
    static GarageDoorState_t GetGarageDoorState();
    static void UpdateGarageDoorState(void);
    
private:
    static GarageDoorState_t m_GarageDoorState;
};

#endif // _GARAGE_CONTROL_H_

