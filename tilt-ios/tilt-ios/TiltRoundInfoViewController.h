//
//  TiltRoundInfoViewController.h
//  tilt-ios
//
//  Created by Adam Parrish on 2/11/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface TiltRoundInfoViewController : UIViewController <RKObjectLoaderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentRoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableCashLabel;
@property (weak, nonatomic) IBOutlet UILabel *openOrClosedLabel;

@end
