//
//  CredentialManager.h
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/17/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CredentialManager : NSObject

- (void)saveUsername:(NSString *)username andPassword:(NSString *)password;
- (NSDictionary *)getUsernameAndPassword;

@end
