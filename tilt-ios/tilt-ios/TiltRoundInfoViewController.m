//
//  TiltRoundInfoViewController.m
//  tilt-ios
//
//  Created by Adam Parrish on 2/11/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "TiltRoundInfoViewController.h"
#import "TiltRound.h"

@interface TiltRoundInfoViewController()

@property (nonatomic, strong) TiltRound *round;

@end

@implementation TiltRoundInfoViewController
@synthesize currentRoundLabel = _currentRoundLabel;
@synthesize availableCashLabel = _availableCashLabel;
@synthesize openOrClosedLabel = _openOrClosedLabel;

@synthesize round = _round;

-(TiltRound *) round
{
    if( _round == nil )
    {
        _round = [[TiltRound alloc] init];
    }
    return _round;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    self.round = (TiltRound *)object;
    
    
    NSComparisonResult result = [@"true" compare:self.round.isOpen ];
    if( result == NSOrderedSame )
    {
        self.currentRoundLabel.text = [NSString stringWithFormat:@"you're currently bidding on round: %@", self.round.number];
        self.availableCashLabel.text = [NSString stringWithFormat:@" $%@ of $%@ ", self.round.allocated, self.round.allocated];
        
        self.openOrClosedLabel.text = @"round is open beatches!";
    }
    else
    {
        self.openOrClosedLabel.text = @"pay attention to the preso! round closed";
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    DLog(@"Encountered an error: %@", error);
}

-(void) viewWillAppear:(BOOL)animated
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager getObject:self.round delegate:self];
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [self setCurrentRoundLabel:nil];
    [self setAvailableCashLabel:nil];
    [self setOpenOrClosedLabel:nil];
    [super viewDidUnload];
}
@end
