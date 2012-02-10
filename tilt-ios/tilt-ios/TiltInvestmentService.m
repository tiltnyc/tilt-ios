//
//  TiltInvestmentService.m
//  tilt-ios
//
//  Created by Adam Parrish on 2/8/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "TiltInvestmentService.h"
#import "TiltTeamInvestment.h"

@implementation TiltInvestmentService

-(void) makeInvestment:(TiltInvestment *)investment
{
    RKObjectMapping *tiltInvestmentMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    tiltInvestmentMapping.rootKeyPath = @"investment";
    [tiltInvestmentMapping mapAttributes:@"round", nil];
    
    RKObjectMapping *tiltTeamInvestmentMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [tiltTeamInvestmentMapping mapAttributes:@"team", @"percentage", nil];
    
    [tiltInvestmentMapping mapRelationship:@"investments" withMapping:tiltTeamInvestmentMapping];
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    [manager.mappingProvider setSerializationMapping:tiltInvestmentMapping forClass:[TiltInvestment class]];

    RKObjectRouter *router = manager.router;
    [router routeClass:[TiltInvestment class] toResourcePath:@"/investments.json" forMethod:RKRequestMethodPOST];
     
    [manager postObject:investment delegate:self];
}


- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    NSLog(@"Success");  
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    NSLog(@"Success");
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"Success");
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}

@end
