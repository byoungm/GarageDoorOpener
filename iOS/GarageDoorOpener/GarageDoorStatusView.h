//
//  GarageDoorStatusView.h
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/28/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GarageDoorStatusView : UIView

- (void)setLightStatus:(NSString *)status;
- (void)setDoorStatus:(NSString *)status;
- (void)resetStatus;

@end
