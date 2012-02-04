//
//  TiltInvestorViewController.m
//  tilt-ios
//
//  Created by Adam Parrish on 1/28/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "TiltLoginViewController.h"
#import "TiltUser.h"
#import "TiltTeamInvestmentsViewController.h"
#import <RestKit/RestKit.h>

@interface TiltLoginViewController()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) TiltUser *user;

@property (strong, nonatomic) NSArray *teams;

@end

@implementation TiltLoginViewController

@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize teams = _teams;
@synthesize user;


- (IBAction)onSigninPressed:(id)sender {
    NSLog(@"Logging in with user %@", self.usernameField.text);
    NSLog(@"Logging in with password %@", self.passwordField.text);
    
    
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[TiltUser class]];
    [objectMapping mapKeyPath:@"_id" toAttribute:@"identifier"];
    [objectMapping mapKeyPath:@"username" toAttribute:@"username"];
    [objectMapping mapKeyPath:@"email" toAttribute:@"email"];
    [objectMapping mapKeyPath:@"funds" toAttribute:@"funds"];
    

    
    RKClient *client = [RKClient sharedClient];
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:client.baseURL];
    [manager.mappingProvider setMapping:objectMapping forKeyPath:@""]; 
    
    user = [[TiltUser alloc] init];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:user.username forKey:@"email"];
    [params setObject:user.password forKey:@"password"];

    [manager loadObjectsAtResourcePath:@"login?json"
                                    delegate:self block:^(RKObjectLoader * loader) { 
                                        loader.method = RKRequestMethodPOST; 
                                        loader.params = params; 
                                        loader.objectMapping = [manager.mappingProvider 
                                                                objectMappingForClass:[TiltUser class]]; 
                                    }]; 
    
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error while loading...%@", error);
    [self performSegueWithIdentifier:@"LoginFailed" sender:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if( [objects count] >= 1 )
    {
        id returnedObject = [objects objectAtIndex:0];
        if( [returnedObject isKindOfClass:[TiltUser class]] )
        {
            user = returnedObject;
        }
    }
    NSLog(@"Identifier: %@", user.identifier);
    NSLog(@"username: %@", user.username);
    NSLog(@"email: %@", user.email);
    NSLog(@"funds: %@", user.funds);
    if( [user.identifier length] != 0  )
    {
        [self performSegueWithIdentifier:@"LoginSuccess" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"LoginFailed" sender:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [segue.destinationViewController isKindOfClass:[TiltTeamInvestmentsViewController class]] )
    {
        TiltTeamInvestmentsViewController *destination = segue.destinationViewController;
        destination.user = user;
    }
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    if ([request isGET]) {  
        // Handling GET /foo.xml  
        
        if ([response isOK]) {  
            // Success! Let's take a look at the data  
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);  
        }  
        
    } else if ([request isPOST]) {  
        
        // Handling POST /other.json  
        if ([response isJSON]) {  
            NSLog(@"Got a JSON response back from our POST! %@ %@", user.identifier, user.email);  
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);  
        }  
        
    } else if ([request isDELETE]) {  
        
        // Handling DELETE /missing_resource.txt  
        if ([response isNotFound]) {  
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);  
        }  
    }  
}  

- (void)viewDidUnload {
    NSLog(@"calling viewDidUnload");
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}

@end
