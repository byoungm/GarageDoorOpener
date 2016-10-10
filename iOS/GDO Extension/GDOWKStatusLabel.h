//
//  GDOWKStatusLabels.h
//  GarageDoorOpener
//
//  Created by Benjamin Young on 10/9/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import <WatchKit/WatchKit.h>


@interface GDOWKStatusLabel : WKInterfaceLabel

- (void)setStatus:(NSString *)status;
- (void)resetStatus;

@end

@interface GDOWKDoorStatusLabel : GDOWKStatusLabel

@end


@interface GDOWKLightStatusLabel : GDOWKStatusLabel

@end
