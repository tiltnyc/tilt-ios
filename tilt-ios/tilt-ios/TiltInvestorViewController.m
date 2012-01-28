//
//  TiltInvestorViewController.m
//  tilt-ios
//
//  Created by Adam Parrish on 1/28/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "TiltInvestorViewController.h"

@interface TiltInvestorViewController()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation TiltInvestorViewController
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;

- (IBAction)onSigninPressed:(id)sender {
    
    NSLog(@"Logging in with user %g", self.usernameField.text);
    NSLog(@"Logging in with password %g", self.usernameField.text);
    
    if( [self.usernameField.text length] > 0
       && [self.passwordField.text length] > 0 )
    {
        [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"LoginFailed" sender:self];
    }
    
}

- (void)viewDidUnload {
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}

@end
