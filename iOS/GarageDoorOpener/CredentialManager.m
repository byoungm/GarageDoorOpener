//
//  CredentialManager.m
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/17/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "CredentialManager.h"
#import <UIKit/UIKit.h>
@import RNCryptor;

@interface CredentialManager ()
@property (strong, nonatomic)  NSString *credentialsFilePath;
@property (strong, nonatomic)  NSString *docPassword;
@end

@implementation CredentialManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.credentialsFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/EncryptedCredentials.data"];
        self.docPassword = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSLog(@"Doc Pass: %@\n", self.docPassword);
    }
    return self;
}


- (void)saveUsername:(NSString *)username andPassword:(NSString *)password
{
    
    NSDictionary *dict = @{@"username":username, @"password":password};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    NSData *encryptedData = [RNCryptor encryptData:data password:self.docPassword];
    [encryptedData writeToFile:self.credentialsFilePath atomically:YES];
}

- (NSDictionary *)getUsernameAndPassword
{
    NSError *error;
    NSData *encryptedData = [NSData dataWithContentsOfFile:self.credentialsFilePath];
    NSData *decryptedData = [RNCryptor decryptData:encryptedData password:self.docPassword  error:&error];
    NSDictionary *dict = @{@"username":@"__ERROR__", @"password":@"__ERROR__"};
    if (error == nil)
    {
       dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
    }
    return dict;
}

@end
