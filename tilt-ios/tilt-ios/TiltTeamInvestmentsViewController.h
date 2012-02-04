//
//  TIInvestmentViewController.h
//  tilt-ios
//
//  Created by Adam Parrish on 1/28/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "TiltUser.h"

@interface TiltTeamInvestmentsViewController : UITableViewController <RKObjectLoaderDelegate>

@property (nonatomic, strong) TiltUser *user;

@end
