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

@end

@implementation TIInvestmentViewController

@synthesize teams = _teams;

-(NSArray *) teams 
{
    if(!_teams)
    {
        TIInvestmentTeam *team1 = [[TIInvestmentTeam alloc] init];
        team1.name = @"Team 1";
        team1.percentInvested = 35;
        
        TIInvestmentTeam *team2 = [[TIInvestmentTeam alloc] init];
        team2.name = @"Team 2";
        team2.percentInvested = 20;
        
        TIInvestmentTeam *team3 = [[TIInvestmentTeam alloc] init];
        team3.name = @"Team 3";
        team3.percentInvested = 10;
        
        TIInvestmentTeam *team4 = [[TIInvestmentTeam alloc] init];
        team4.name = @"Team 4";
        team4.percentInvested = 5;
        
        TIInvestmentTeam *team5 = [[TIInvestmentTeam alloc] init];
        team5.name = @"Team 5";
        team5.percentInvested = 0;
        
        TIInvestmentTeam *team6 = [[TIInvestmentTeam alloc] init];
        team6.name = @"Team 6";
        team6.percentInvested = 0;
        
        _teams = [[NSArray alloc]initWithObjects:team1, team2, team3, team4, team5, team6, nil];
    }
    
    return _teams;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.teams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InvestmentTeamDescription"; //Same as the one defined in the prototype cell's identifier
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    TIInvestmentTeam *teamInvestment = [self.teams objectAtIndex:indexPath.row];
    cell.textLabel.text = teamInvestment.name;
    
    return cell;
}


@end
