//
//  TiltInvestmentService.m
//  tilt-ios
//
//  Created by Adam Parrish on 2/8/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "TiltInvestmentService.h"
#import "TiltTeamInvestment.h"

@interface TiltInvestmentService()

@property (nonatomic) BOOL isClassInitialized;

@end

@implementation TiltInvestmentService

@synthesize isClassInitialized;


-(void) makeInvestment:(TiltInvestment *)investment
{
    RKObjectManager* manager = [RKObjectManager sharedManager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    RKObjectMapping *tiltInvestmentMapping = [RKObjectMapping serializationMapping];    tiltInvestmentMapping.rootKeyPath = @"investment";
    [tiltInvestmentMapping mapAttributes:@"round", nil];
    tiltInvestmentMapping.forceCollectionMapping = YES;

    
    RKObjectMapping *tiltTeamInvestmentMapping = [RKObjectMapping serializationMapping]; 
    [tiltTeamInvestmentMapping mapKeyPath:@"team" toAttribute:@"team"];
    [tiltTeamInvestmentMapping mapKeyPath:@"percentage" toAttribute:@"percentage"];
    
    [tiltInvestmentMapping mapKeyPath:@"investments" toRelationship:@"investments" withMapping:tiltTeamInvestmentMapping serialize:YES];

    [manager.mappingProvider setSerializationMapping:tiltInvestmentMapping forClass:[TiltInvestment class]];
    [manager.mappingProvider setSerializationMapping:tiltTeamInvestmentMapping forClass:[TiltTeamInvestment class]];


    RKObjectRouter *router = manager.router;
    if( isClassInitialized == NO )
    {
        isClassInitialized = YES;
        [router routeClass:[TiltInvestment class] toResourcePath:@"/investments.json" forMethod:RKRequestMethodPOST];
    }
     
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
