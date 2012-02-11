//
//  TiltRound.h
//  tilt-ios
//
//  Created by Adam Parrish on 2/11/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TiltRound : NSObject

/*
{
    "_id":"4f2f0ee57221460100000001",
    "number":1,
    "updated_at":"2012-02-05T23:21:09.851Z",
    "created_at":"2012-02-05T23:21:09.851Z",
    "investor_count":0,
    "total_funds":0,
    "allocated":1000,
    "is_open":true,
    "is_current":true
} 
*/

@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSNumber *allocated;
@property (nonatomic, strong) NSString *isOpen;

@end
