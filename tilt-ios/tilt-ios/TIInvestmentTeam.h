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

@property (nonatomic, weak) NSNumber *identifier;
@property (nonatomic, weak) NSString *name;
@property (nonatomic, weak) NSNumber *percentInvested;

@end
