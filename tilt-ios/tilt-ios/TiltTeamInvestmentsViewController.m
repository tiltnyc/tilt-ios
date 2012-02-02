//
//  TIInvestmentViewController.m
//  tilt-ios
//
//  Created by Adam Parrish on 1/28/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "TiltTeamInvestmentsViewController.h"
#import "TIInvestmentTeam.h"

@interface TiltTeamInvestmentsViewController()

@property (nonatomic) NSInteger cellTag;
@property (nonatomic) BOOL navSimulator;
@property (nonatomic, strong) NSArray *teams;

@end

@implementation TiltTeamInvestmentsViewController

@synthesize teams;
@synthesize cellTag = _cellTag;
@synthesize navSimulator = _navSimulator;

-(NSInteger) cellTag 
{
    if( _cellTag < 1000 )
    {
        _cellTag = 1000;
    }
    return _cellTag;
}


- (void)finalizeInvestments:(id)sender {
    
    if( self.navSimulator == YES )
    {
        self.navSimulator = NO;
        [self performSegueWithIdentifier:@"InvestmentsFinalized" sender:self];
    }
    else
    {
        self.navSimulator = YES;
        [self performSegueWithIdentifier:@"InvestmentsFailed" sender:self];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.tableView.tableFooterView == nil) {
        //allocate the view if it doesn't exist yet
        UIView *footerView  = [[UIView alloc] init];
        [footerView setFrame:CGRectMake(0, 0, 320, 80)];
        
        //create the button
        UIButton *addNewBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];     
        //the button should be as big as a table view cell
        [addNewBtn setFrame:CGRectMake(10, 0, 300, 50)];
        
        //set title, font size and font color
        [addNewBtn setTitle:@"make investments" forState:UIControlStateNormal];
        [addNewBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [addNewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addNewBtn addTarget:self action:@selector(finalizeInvestments:) forControlEvents:UIControlEventTouchUpInside];
                
        //add the button to the view
        [footerView addSubview:addNewBtn];
        footerView.userInteractionEnabled = YES;
        self.tableView.tableFooterView = footerView;
        self.tableView.tableFooterView.userInteractionEnabled = YES;
        
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.teams count];
}

-(NSNumber *) maxAvailableInvestmentLeft
{
    TIInvestmentTeam *team;
    NSNumber *totalInvestedPercent = [NSNumber numberWithInt:0];
    int total;
    for ( int i = 0; i < teams.count ; i++ )
    {
        team = [teams objectAtIndex:i];
        total = [totalInvestedPercent intValue];
        int teamInvestment = [team.percentInvested intValue];
        total += teamInvestment;
        NSLog(@"total is %d", total);
        NSLog(@"team %@ has %@", team.name, team.percentInvested);
        totalInvestedPercent = [NSNumber numberWithInt:total];
    }
    
    NSLog(@"Returing max available investment of %i",100-total);
    
    return [NSNumber numberWithInt:100-total];
}

-(BOOL)isInvestmentFundsAvailable
{
    TIInvestmentTeam *team;
    NSNumber *totalInvestedPercent = [NSNumber numberWithInt:0];
    for ( int i = 0; i < teams.count ; i++ )
    {
        team = [teams objectAtIndex:i];
        int total = [totalInvestedPercent intValue];
        int teamInvestment = [team.percentInvested intValue];
        total += teamInvestment;
        NSLog(@"total is %d", total);
        NSLog(@"team %@ has %@", team.name, team.percentInvested);
        totalInvestedPercent = [NSNumber numberWithInt:total];
    }
    NSLog(@"totalInvestedPercent is: %@", totalInvestedPercent);

    NSComparisonResult result = [totalInvestedPercent compare:[NSNumber numberWithInt:100]];
    
    if( result == NSOrderedAscending )
    {
        return YES;
    }
    
    return NO;
}


-(void)sliderUpdate:(UISlider *)sender {
    NSLog(@"test moving the slider");
    
    if( [sender isKindOfClass:[UISlider class]] )
    {
        UISlider *callingSlider = sender;
        UITableViewCell *cell = (UITableViewCell *)callingSlider.superview;
        
        /***
         * this is hackery. i bet there is a better way to get a hook
         * back to a cell's ui element aside from using random magic tag math
         */
        int cellTag = cell.tag;
        if( cellTag >= 1000 )
        {
            
            BOOL allowUserAction = false;
            int index = cellTag - 1000;
            TIInvestmentTeam *team = [[self teams] objectAtIndex:index];
            NSNumber *percentToInvest = [NSNumber numberWithInt:[callingSlider value]];
               
            //if user is increasing
            if( [team isIncreasingWith:percentToInvest] )
            {
                //make sure they have fund percentage left
                //if they have funds left - allow
                //else - disallow 
                if( [self isInvestmentFundsAvailable] )
                {
                    allowUserAction = YES;
                }
                else
                {
                    allowUserAction = NO;
                }
            }
            else if( [team isDecreasingWith:percentToInvest] )
            {
                //if user is decreasing - allow always                
                allowUserAction = YES;
            }
            else
            {
                //default allow i guess
                allowUserAction = YES;
            }
            

            if( allowUserAction )
            {
//                NSComparisonResult maxComparedToIntended = [[self maxAvailableInvestmentLeft] compare:percentToInvest];
//                NSNumber *delta;
//                if( maxComparedToIntended == NSOrderedAscending )
//                {
//                    delta = [self maxAvailableInvestmentLeft];
//                }
//                else if( maxComparedToIntended == NSOrderedSame )
//                {
//                    delta = [self maxAvailableInvestmentLeft];
//                }
//                else if( maxComparedToIntended == NSOrderedDescending )
//                {
//                    delta = percentToInvest;
//                }
                
//                if( [team isDecreasingWith:delta] )
//                {
//                    team.percentInvested = [NSNumber numberWithInt:[[team percentInvested] intValue] - [delta intValue]];                    
//                }
//                else if( [team isIncreasingWith:delta] )
//                {
//                    team.percentInvested = [NSNumber numberWithInt:[[team percentInvested] intValue] + [delta intValue]];                    
//                }

                //if decreasing it is safe to just accept percentToInvest - always
                if( [team isDecreasingWith:percentToInvest] )
                {
                    team.percentInvested = percentToInvest;                    
                }
                //if increasing you have to make sure you have room in max available or max available + current is what you get
                else 
                {
                    NSNumber *maxAvailable = [self maxAvailableInvestmentLeft];
                    NSNumber *maxPlusCurrent = [NSNumber numberWithInt:[maxAvailable intValue] + [team.percentInvested intValue]];
                    NSLog(@"MaxPlusCurrent: %@, MaxAvail: %@, vs PercentToInvest: %@",maxPlusCurrent, maxAvailable, percentToInvest);
                    
                    NSComparisonResult maxPlusCurrentComparedToInvested = [maxPlusCurrent compare:percentToInvest];
                    if( maxPlusCurrentComparedToInvested == NSOrderedAscending || maxPlusCurrentComparedToInvested == NSOrderedSame )
                    {
                        team.percentInvested = maxPlusCurrent;
                    }
                    else if( maxPlusCurrentComparedToInvested == NSOrderedDescending )
                    {
                        team.percentInvested = percentToInvest;
                    }
                }
                

                

                UILabel *investmentPercent = (UILabel *)[[cell superview] viewWithTag:2];
                investmentPercent.text = [NSString stringWithFormat:@"%@",team.percentInvested];
                
                NSLog(@"Max Available right now is %@",[self maxAvailableInvestmentLeft]);
                NSLog(@"Value of percentInvested=%@",percentToInvest);
                NSLog(@"Value of team.percentInvested=%@",team.percentInvested);
            }
        }
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"InvestmentTeamDescription"; //Same as the one defined in the prototype cell's identifier
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    if( cell.tag == 0 )
    {
        cell.tag = self.cellTag;
        cell.contentView.tag = self.cellTag;
        self.cellTag++;
        
    }
    
    TIInvestmentTeam *teamInvestment = [self.teams objectAtIndex:indexPath.row];

    UILabel *teamName = (UILabel *)[cell viewWithTag:1];
    UILabel *investmentPercent = (UILabel *)[cell viewWithTag:2];
    UISlider *investmentSlider = (UISlider *)[cell viewWithTag:3];
    
    [investmentSlider addTarget:self action:@selector(sliderUpdate:) forControlEvents:UIControlEventValueChanged];
    
    teamName.text = teamInvestment.name;
    
    NSLog(@"Team %@ has a investment of value %@", teamInvestment.name, teamInvestment.percentInvested);
    
    investmentPercent.text = [NSString stringWithFormat:@"%@",teamInvestment.percentInvested];
    
    //investmentSlider.minimumValue = 0;
    //investmentSlider.maximumValue = 100;
    investmentSlider.value = [teamInvestment.percentInvested floatValue];

    
    return cell;
}


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    
    
    //    self.teams = [NSArray arrayWithArray:objects];
    self.teams = objects;

    [[self tableView] reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"Encountered an error: %@", error);
}

-(void) viewWillAppear:(BOOL)animated
{
    
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[TIInvestmentTeam class]];
    [objectMapping mapKeyPath:@"_id" toAttribute:@"identifier"];
    [objectMapping mapKeyPath:@"name" toAttribute:@"name"];
    
    RKClient *client = [RKClient sharedClient];
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:client.baseURL];
    [manager loadObjectsAtResourcePath:@"/teams.json" objectMapping:objectMapping delegate:self];
    
    
    [super viewWillAppear:animated];
}

@end
