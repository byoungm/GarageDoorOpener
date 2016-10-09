//
//  GDOWCTransferDefines.h
//  GarageDoorOpener
//
//  Created by Benjamin Young on 9/18/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#ifndef GDOWCTransferDefines_h
#define GDOWCTransferDefines_h

// GDO Keys
#define GDO_WC_KEY_ACTION_REQUEST @"Key_Action"
#define GDO_WC_KEY_SUCCESS_OCCURED @"Key_Success"
#define GDO_WC_KEY_ERROR_OCCURED @"Key_Error"
#define GDO_WC_KEY_LIGHT_STATUS @"Key_LightStatus"
#define GDO_WC_KEY_DOOR_STATUS @"Key_DoorStatus"

// GDO Values
#define GDO_WC_ACTION_GARAGE_DOOR_TOGGLE @"Action_ToggleDoor"
#define GDO_WC_ACTION_GARAGE_LIGHT_TOGGLE @"Action_ToggleLight"
#define GDO_WC_ACTION_GARAGE_GET_STATUS @"Action_GetStatus"

#define GDO_WC_NO_ERROR @"No Error"
#define GDO_WC_ERROR_NOT_AUTHENCATED @"Particle Cloud not Authencated. Please use iphone to authenticate"
#define GDO_WC_ERROR_COULD_NOT_CONNECT_TO_PHONE @"Could not connect to iPhone"
#define GDO_WC_ERROR_UNKNOWN_ACTION_CODE @"Unknown Action Code send to iOS App Delegate"

#endif /* GDOWCTransferDefines_h */
