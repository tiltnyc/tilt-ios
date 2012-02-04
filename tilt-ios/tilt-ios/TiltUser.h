//
//  TiltUser.h
//  tilt-ios
//
//  Created by Adam Parrish on 2/3/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TiltUser : NSObject {
    
}

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *funds;


@end
