//
//  LoginViewController.m
//  GarageDoorOpener
//
//  Created by Benjamin Young on 5/15/16.
//  Copyright © 2016 Benjamin Young. All rights reserved.
//

#import "LoginViewController.h"
#import "Spark-SDK.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
            NSLog(@"Wrong credentials or no internet connectivity, please try again");
    }];
}

@end