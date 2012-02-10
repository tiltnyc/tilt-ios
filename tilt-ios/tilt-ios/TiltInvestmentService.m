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
    RKObjectMapping *tiltTeamInvestmentMapping = [RKObjectMapping mappingForClass:[TiltTeamInvestment class]];
    [tiltTeamInvestmentMapping mapKeyPath:@"team" toAttribute:@"team"];
    [tiltTeamInvestmentMapping mapKeyPath:@"percentage" toAttribute:@"percentage"];
    
    RKObjectMapping *tiltInvestmentMapping = [RKObjectMapping mappingForClass:[TiltInvestment class]];

    [tiltInvestmentMapping mapKeyPath:@"investments" toRelationship:@"investments" withMapping:tiltTeamInvestmentMapping];
    tiltInvestmentMapping.rootKeyPath = @"investment";
    
    RKObjectManager* manager = [RKObjectManager sharedManager];
    [manager.mappingProvider setSerializationMapping:[tiltInvestmentMapping inverseMapping] forClass:[TiltInvestment class]];
    
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
