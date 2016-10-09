//
//  GDOWCTransferDefines.h
//  GarageDoorOpener
//
//  Created by Benjamin Young on 9/18/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#ifndef GDOWCTransferDefines_h
#define GDOWCTransferDefines_h

typedef enum {
    GDO_WC_ACTION_GARAGE_DOOR_TOGGLE = 1,
    GDO_WC_ACTION_GARAGE_LIGHT_TOGGLE,
} GdoWcActionCode_t;

#define GDO_WC_ACTION_REQUEST_KEY @"Action"
#define GDO_WC_SUCCESS_OCCURED_KEY @"Success"

// Error Defines
#define GDO_WC_ERROR_OCCURED_KEY @"Error"
#define GDO_WC_ERROR_NOT_AUTHENCATED @"Particle Cloud not Authencated. Please use iphone to authenticate"
#define GDO_WC_ERROR_COULD_NOT_CONNECT_TO_PHONE @"Could not connect to iPhone"

#endif /* GDOWCTransferDefines_h */
