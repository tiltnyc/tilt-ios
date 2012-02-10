//
//  TiltInvestmentService.h
//  tilt-ios
//
//  Created by Adam Parrish on 2/8/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "TiltInvestment.h"

@interface TiltInvestmentService : NSObject <RKObjectLoaderDelegate>

-(void) makeInvestment:(TiltInvestment *) investment;

@end
