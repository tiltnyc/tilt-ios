//
//  TIInvestmentTeam.h
//  tilt-ios
//
//  Created by Adam Parrish on 1/28/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface TIInvestmentTeam : NSObject {
    
}

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *percentInvested;

/**
 * This value is more or less transient and used to help
 * the UI determine if we are increasing or decreasing 
 * when the user modifies the slider
 */
@property (nonatomic, strong) NSNumber *lastPercentInvested;

-(BOOL) isIncreasing;
-(BOOL) isDecreasing;

-(BOOL) isIncreasingWith :(NSNumber *) newPercentageInvestment;
-(BOOL) isDecreasingWith :(NSNumber *) newPercentageInvestment;

@end
