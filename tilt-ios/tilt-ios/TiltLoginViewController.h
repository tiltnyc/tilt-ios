//
//  TiltInvestorViewController.h
//  tilt-ios
//
//  Created by Adam Parrish on 1/28/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface TiltLoginViewController : UIViewController  <RKObjectLoaderDelegate, UITextFieldDelegate>
{
    UIView *_keyboardAccessoryView;
    UITextField *_selectedTextField;
    UISegmentedControl *_segControl;
}

@end
