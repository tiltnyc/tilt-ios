//
//  TIInvestmentTeam.m
//  tilt-ios
//
//  Created by Adam Parrish on 1/28/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "TIInvestmentTeam.h"

@implementation TIInvestmentTeam

@synthesize identifier;
@synthesize name;
@synthesize percentInvested = _percentInvested;

-(NSNumber *) percentInvested 
{
    if( _percentInvested < [NSNumber numberWithInt:0] )
    {
        _percentInvested = [NSNumber numberWithInt:0];
    }
    if( _percentInvested > [NSNumber numberWithInt:100] )
    {
        _percentInvested = [NSNumber numberWithInt:100];
    }
    
    return _percentInvested;
}

@end
