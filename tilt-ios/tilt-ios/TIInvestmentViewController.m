//
//  TIInvestmentViewController.m
//  tilt-ios
//
//  Created by Adam Parrish on 1/28/12.
//  Copyright (c) 2012 Neosavvy. All rights reserved.
//

#import "TIInvestmentViewController.h"
#import "TIInvestmentTeam.h"

@interface TIInvestmentViewController()

@property (nonatomic, strong) NSArray *teams;
@property (nonatomic) NSInteger cellTag;
@property (nonatomic) BOOL navSimulator;

@end

@implementation TIInvestmentViewController

@synthesize teams = _teams;
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

-(NSArray *) teams 
{
    if(!_teams)
    {
        TIInvestmentTeam *team1 = [[TIInvestmentTeam alloc] init];
        team1.name = @"Team 1";
        team1.percentInvested = [NSNumber numberWithInt:35];
        
        TIInvestmentTeam *team2 = [[TIInvestmentTeam alloc] init];
        team2.name = @"Team 2";
        team2.percentInvested = [NSNumber numberWithInt:20];
        
        TIInvestmentTeam *team3 = [[TIInvestmentTeam alloc] init];
        team3.name = @"Team 3";
        team3.percentInvested = [NSNumber numberWithInt:10];
        
        TIInvestmentTeam *team4 = [[TIInvestmentTeam alloc] init];
        team4.name = @"Team 4";
        team4.percentInvested = [NSNumber numberWithInt:5];
        
        TIInvestmentTeam *team5 = [[TIInvestmentTeam alloc] init];
        team5.name = @"Team 5";
        team5.percentInvested = [NSNumber numberWithInt:0];
        
        TIInvestmentTeam *team6 = [[TIInvestmentTeam alloc] init];
        team6.name = @"Team 6";
        team6.percentInvested = [NSNumber numberWithInt:0];
        
        _teams = [[NSArray alloc]initWithObjects:team1, team2, team3, team4, team5, team6, nil];
    }
    
    return _teams;
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

-(void)sliderUpdate:(UISlider *)sender {
    NSLog(@"test moving the slider");
    
    if( [sender isKindOfClass:[UISlider class]] )
    {
        
        //get the cell from the slider somehow
        //use that to lookup the index of the item to update
        
        UISlider *callingSlider = sender;
        UITableViewCell *cell = (UITableViewCell *)callingSlider.superview;
        int cellTag = cell.tag;
        NSLog(@"cellTag: %i", cellTag);
        if( cellTag >= 1000 )
        {
            int index = cellTag - 1000;
            TIInvestmentTeam *team = [[self teams] objectAtIndex:index];
            team.percentInvested = [NSNumber numberWithInt:[callingSlider value]];
            NSLog(@"Value of percentInvested=%@",[NSNumber numberWithInt:[callingSlider value]]);
            
            UILabel *investmentPercent = (UILabel *)[[cell superview] viewWithTag:2];
            investmentPercent.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[callingSlider value]]];
        }
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil; //enables the header view
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

    NSLog(@"Value of investment: %@", teamInvestment.percentInvested);
    
    UILabel *teamName = (UILabel *)[cell viewWithTag:1];
    UILabel *investmentPercent = (UILabel *)[cell viewWithTag:2];
    UISlider *investmentSlider = (UISlider *)[cell viewWithTag:3];
    
    [investmentSlider addTarget:self action:@selector(sliderUpdate:) forControlEvents:UIControlEventValueChanged];
    
    teamName.text = teamInvestment.name;
    investmentPercent.text = [NSString stringWithFormat:@"%@",teamInvestment.percentInvested];
    investmentSlider.value = [teamInvestment.percentInvested floatValue];
    
    return cell;
}




@end
