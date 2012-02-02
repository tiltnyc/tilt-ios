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
@synthesize lastPercentInvested;

-(BOOL) isIncreasingWith :(NSNumber *) newPercentageInvestment
{
    
    NSLog(@"lastPercentInvested for %@ = %@, and newinvestment is %@", self.name, self.percentInvested, newPercentageInvestment);
    
    NSComparisonResult result = [lastPercentInvested compare:newPercentageInvestment];
    
    if( result == NSOrderedAscending )
    {
        return YES;
    }
    
    return NO;

}

-(BOOL) isDecreasingWith :(NSNumber *) newPercentageInvestment
{
    NSComparisonResult result = [lastPercentInvested compare:newPercentageInvestment];
    
    if( result == NSOrderedDescending || result == NSOrderedSame )
    {
        return YES;
    }
    
    return NO;  
}

-(BOOL) isIncreasing
{
    return [self isIncreasingWith:[self percentInvested]];
}

-(BOOL) isDecreasing
{
    return [self isDecreasingWith:[self percentInvested]];
}

-(void) setPercentInvested:(NSNumber *)percentInvested
{
    //save the old value
    lastPercentInvested = _percentInvested;
    
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
