//
//  TiltInvestment.h
//  tilt-ios
//
//  Created by Adam Parrish on 2/4/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TiltInvestment : NSObject
/**
 * key is the team id
 * value is the percentage invested as a double
 */
@property (strong, nonatomic) NSMutableArray *investments;

@property (strong, nonatomic) NSNumber *round;

@end
