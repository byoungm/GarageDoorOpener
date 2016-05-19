//
//  LoginViewController.m
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/15/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "LoginViewController.h"
#import "Spark-SDK.h"
#import "CredentialManager.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UILabel *loginStatusLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginStatusLabel.text = @""; // Empty string until an error occurs
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(id)sender
{
    NSString *username = [self.userNameTextField text];
    NSString *password = [self.passWordTextField text];
    [[SparkCloud sharedInstance] loginWithUser:username password:password completion:^(NSError *error){
        if (!error)
        {
            NSLog(@"Logged in to cloud\nAccess Token: %@", [SparkCloud sharedInstance].accessToken);
            CredentialManager *cm = [[CredentialManager alloc] init];
            [cm saveUsername:username andPassword:password];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
            self.loginStatusLabel.text = @"Wrong credentials or no internet connectivity, please try again";
    }];
}

@end
