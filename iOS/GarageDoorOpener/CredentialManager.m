//
//  CredentialManager.m
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/17/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "CredentialManager.h"
#import <UIKit/UIKit.h>
#import "RNEncryptor.h"
#import "RNDecryptor.h"

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
    NSError *err;
    NSData *encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:self.docPassword error:&err];
    if (err == nil)
    {
        [encryptedData writeToFile:self.credentialsFilePath atomically:YES];
    }
}

- (NSDictionary *)getUsernameAndPassword
{
    NSError *err;
    NSData *encryptedData = [NSData dataWithContentsOfFile:self.credentialsFilePath];
    NSData *decryptedData = [RNDecryptor decryptData:encryptedData withPassword:self.docPassword error:&err];
    NSDictionary *dict = @{@"username":@"__ERROR__", @"password":@"__ERROR__"};
    if (err == nil)
    {
       dict = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
    }
    return dict;
}

@end
