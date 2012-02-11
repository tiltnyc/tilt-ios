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
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
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
            NSArray *cookies = response.cookies;
            for ( int i =0; i < cookies.count ; i++ )
            {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[cookies objectAtIndex:i]]; 
            }
        }  
        
    } else if ([request isDELETE]) {  
        
        // Handling DELETE /missing_resource.txt  
        if ([response isNotFound]) {  
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);  
        }  
    }  
}  

#pragma mark -
#pragma mark Private Functions
- (UIView*)inputAccessoryView {
    if(!_keyboardAccessoryView)
    {
        UISegmentedControl *tmpSegControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous",@"Next", nil]];
        [tmpSegControl setFrame:CGRectMake(0, 7, 140, 30)];
        [tmpSegControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [tmpSegControl setTintColor:[UIColor darkGrayColor]];
        [tmpSegControl setMomentary:YES];
        [tmpSegControl addTarget:self action:@selector(doSegmentedControl:) forControlEvents:UIControlEventAllEvents];    
        
        UIBarButtonItem *toolbarSeg = [[UIBarButtonItem alloc] initWithCustomView:tmpSegControl];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doCloseKeyboards:)];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [toolbar setItems:[NSArray arrayWithObjects:toolbarSeg, flexibleSpace, doneButton,nil] animated:YES];
        _keyboardAccessoryView = toolbar;
    }
    return _keyboardAccessoryView;
}

#pragma mark -
#pragma mark Action Methods
- (void)doSegmentedControl:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0){ // Previous
        if(_selectedTextField == _usernameField)
            [_passwordField becomeFirstResponder];
        else if(_selectedTextField == _passwordField)
            [_usernameField becomeFirstResponder];
    }else{ // Next
        if(_selectedTextField == _usernameField)
            [_passwordField becomeFirstResponder];
        else if(_selectedTextField == _passwordField)
            [_usernameField becomeFirstResponder];
    }
}

- (void)doCloseKeyboards:(UIButton *)sender
{
    [_selectedTextField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_usernameField setDelegate:self];
    [_passwordField setDelegate:self];
    
    [_usernameField setInputAccessoryView:[self inputAccessoryView]];
    [_passwordField setInputAccessoryView:[self inputAccessoryView]];
}

#pragma mark - 
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{    
    _selectedTextField = textField;
    
    [_segControl setEnabled:YES forSegmentAtIndex:0];
    [_segControl setEnabled:YES forSegmentAtIndex:1];
    if(_selectedTextField == _usernameField){
        [_segControl setEnabled:NO forSegmentAtIndex:0];
    }
    if(_selectedTextField == _passwordField){
        [_segControl setEnabled:NO forSegmentAtIndex:1];
    }
    NSLog(@"textFieldShouldBeginEditing");    

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidUnload {
    NSLog(@"calling viewDidUnload");
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}

@end
