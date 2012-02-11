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


-(void) makeInvestment:(TiltInvestment *) investment withSuccess: (SuccessBlock)success withFailure: (FailBlock)failure;
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
    
    if (success) {
        _successBlock = success;
    } else if (failure) {
        _failBlock = failure;
    }
}


- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if (![response isError]) {
        DLog(@"Success"); 
        DLog(@"Response was: %@", response.bodyAsString);
        _successBlock();
    } else {
        DLog(@"Error Descrip: %@, Error: %@", [response failureErrorDescription], [response failureError]);
        _failBlock();
    }
}

@end
