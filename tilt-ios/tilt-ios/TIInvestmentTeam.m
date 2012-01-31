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

-(void) setPercentInvested:(NSNumber *)percentInvested
{
    NSLog(@"incoming set value=%@",percentInvested);
    
    _percentInvested = percentInvested;
}

-(NSNumber *) percentInvested 
{
    
    if( _percentInvested == nil )
    {
        _percentInvested = [NSNumber numberWithInt:0];
    }
    
    NSComparisonResult minCompare = [_percentInvested compare:[NSNumber numberWithInt:0]];
    if( minCompare == NSOrderedAscending  )
    {
        _percentInvested = [NSNumber numberWithInt:0];
    }
    
    NSComparisonResult maxCompare = [_percentInvested compare:[NSNumber numberWithInt:100]];
    if( maxCompare == NSOrderedDescending )
    {
        _percentInvested = [NSNumber numberWithInt:100];
    }
    
    NSLog(@"percentInvested %@", _percentInvested);
    
    return _percentInvested;
}

@end
