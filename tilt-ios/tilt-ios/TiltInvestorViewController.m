//
//  TiltInvestorViewController.m
//  tilt-ios
//
//  Created by Adam Parrish on 1/28/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "TiltInvestorViewController.h"
#import "TIInvestmentTeam.h"
#import "TiltLoginViewController.h"
#import <RestKit/RestKit.h>

@interface TiltInvestorViewController()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) NSArray *teams;

@end

@implementation TiltInvestorViewController

@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize teams = _teams;


- (IBAction)onSigninPressed:(id)sender {
    
    NSLog(@"Logging in with user %g", self.usernameField.text);
    NSLog(@"Logging in with password %g", self.usernameField.text);
    
    if( [self.usernameField.text length] > 0
       && [self.passwordField.text length] > 0 )
    {
        RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[TIInvestmentTeam class]];
        [objectMapping mapKeyPath:@"_id" toAttribute:@"identifier"];
        [objectMapping mapKeyPath:@"name" toAttribute:@"name"];
        
        RKClient *client = [RKClient sharedClient];
        RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:client.baseURL];
        [manager loadObjectsAtResourcePath:@"/teams.json" objectMapping:objectMapping delegate:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"LoginFailed" sender:self];
    }
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {

    TIInvestmentTeam *team;
    for (int i; i < [objects count]; i++)
    {
        team = [objects objectAtIndex:i];
        NSLog(@"Loaded team id #%@ -> Name: %@", team.identifier, team.name);
    }
    
    self.teams = [NSArray arrayWithArray:objects];
    
    [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Prepare happening...");
    if( [[segue identifier] isEqualToString:@"LoginSuccess"] )
    {
        TIInvestmentTeam *team;
        for (int i = 0; i < [self.teams count]; i++)
        {
            team = [self.teams objectAtIndex:i];
            NSLog(@"Loaded team id #%@ -> Name: %@", team.identifier, team.name);
        }
    
        id destination = segue.destinationViewController;
        if( [destination isKindOfClass:[TiltLoginViewController class]] )
        {
            TiltLoginViewController *tiltInvestorViewController = destination;
            [tiltInvestorViewController setTeams:[[NSArray alloc] initWithArray:self.teams]];
        }
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}

- (void)viewDidUnload {
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}

@end
