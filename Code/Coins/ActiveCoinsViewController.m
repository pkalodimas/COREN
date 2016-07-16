//
//  ActiveCoinsViewController.m
//  Coins
//
//  Created by Panos Kalodimas on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActiveCoinsViewController.h"

@interface ActiveCoinsViewController ()

@end

@implementation ActiveCoinsViewController

@synthesize activeCoinsTable;
@synthesize coinsList;
@synthesize rows;
@synthesize sections;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.sections = [NSMutableArray array];
    self.rows = [NSMutableArray array];
    self.coinsList = [self loadCoinsList];
    [self createTableViewSettings];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.coinsList removeAllObjects];
    [self.sections removeAllObjects];
    for (int i=0; i<self.rows.count; i++)  [[self.rows objectAtIndex:i] removeAllObjects];
    [self.rows removeAllObjects];
    self.coinsList = nil;
    self.sections = nil;
    self.rows = nil;
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self saveCoinsList:self.coinsList];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//---------------------------------------------------------------------------
//------------------------------- MyFunctions -------------------------------
//---------------------------------------------------------------------------

- (void)createTableViewSettings{
        
    if ( (SORTING_OPTION)[[self getSetting:nil name:SORTING] intValue] == BY_NAME ) {
        
        [self.sections addObject:ALL_COINS];
        NSMutableArray *row = [NSMutableArray array];
        
        for (int i=0; i<self.coinsList.count; i++)
            [row addObject:[self.coinsList objectAtIndex:i]];

        [self.rows addObject:row];
    }
    else {
        
        NSMutableArray *row = [NSMutableArray array];
        
        for (int i=0; i<self.coinsList.count; i++) {
            
            if ( [[self.sections lastObject] isEqualToString:[[self.coinsList objectAtIndex:i] valueForKey:COUNTRY]] ) {
                
                [row addObject:[self.coinsList objectAtIndex:i]];
            }
            else {
                
                [self.sections addObject:[[self.coinsList objectAtIndex:i] valueForKey:COUNTRY]];
                if (i > 0)  [self.rows addObject:row];
                row = [NSMutableArray array];
                [row addObject:[self.coinsList objectAtIndex:i]];
            }
        }
        [self.rows addObject:row];
    }
}

-(void)activityChanged:(NSString *)coinName state:(BOOL)state{
    
    ACTIVE_OPTION option = (state)? ACTIVE_COIN : INACTIVE_COIN;
    int i = [self findCoinInList:self.coinsList name:coinName];
    [[self.coinsList objectAtIndex:i] setValue:[NSNumber numberWithInteger:option] forKey:ACTIVE];
}

//---------------------------------------------------------------------------
//---------------------------- UITableViewDataSource ------------------------
//---------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [self.sections objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  [[self.rows objectAtIndex:section] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    if ( (SORTING_OPTION)[[self getSetting:nil name:SORTING] intValue] == BY_NAME) {
        
        CoinsActiveNameSortingCell *cell = [self.activeCoinsTable dequeueReusableCellWithIdentifier:@"ActiveNameSortingCell"];
        cell = [cell initWithCoin:[[self.rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        cell.owner = self;
        return cell;
    }
    else {
        
        CoinsActiveCountrySortingCell *cell = [self.activeCoinsTable dequeueReusableCellWithIdentifier:@"ActiveCountrySortingCell"];
        cell = [cell initWithCoin:[[self.rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        cell.owner = self;
        return cell;
    }
}

@end
