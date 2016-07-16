//
//  CoinsSettingsViewController.m
//  Coins
//
//  Created by Panos Kalodimas on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoinsSettingsViewController.h"

@interface CoinsSettingsViewController ()

@end

@implementation CoinsSettingsViewController

@synthesize coinsList;
@synthesize sections;
@synthesize rows;
@synthesize coinsTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.sections = nil;
    self.rows = nil;
    self.coinsList = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.coinsList = [self loadCoinsList];
    [self createTableViewSettings];
    [self.coinsTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.coinsList removeAllObjects];
    [self.sections removeAllObjects];
    for (int i=0; i<self.rows.count; i++)  [[self.rows objectAtIndex:i] removeAllObjects];
    [self.rows removeAllObjects];
    self.coinsList = nil;
    self.rows = nil;
    self.sections = nil;
}

- (void)createTableViewSettings{
    
    if (!self.coinsList)  self.coinsList = [self loadCoinsList];
    self.rows = [NSMutableArray array];
    self.sections = [NSMutableArray array];
    
    if ( (SORTING_OPTION)[[self getSetting:nil name:SORTING] intValue] == BY_NAME ) {
        
        [self.sections addObject:ALL_COINS];
        NSMutableArray *row = [NSMutableArray array];
        
        for (int i=0; i<self.coinsList.count; i++) {
            
            [row addObject:[self.coinsList objectAtIndex:i]];
        }
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


//---------------------------------------------------------------------------
//------------------------------- My Functions ------------------------------
//---------------------------------------------------------------------------

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    CoinsAddCoinViewController *dvc = [segue destinationViewController];

    if ([segue.identifier isEqualToString:@"AddNewCoinSegue"])  dvc.option = NEW_COIN;
    else {
        
        UITableViewCell *selected = [self.coinsTableView cellForRowAtIndexPath: [self.coinsTableView indexPathForSelectedRow]];
        Coin *selectedCoin = [self loadCoinData:selected.textLabel.text];
        dvc.coin = selectedCoin;
        dvc.option = COIN_EDIT;
    }
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
    
    return  ((NSMutableArray*)[self.rows objectAtIndex:section]).count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *name = [[[self.rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:NAME];
    UIImage *image = [self getCoinIcon:name];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CountrySortingCell"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if ( (SORTING_OPTION)[[self getSetting:nil name:SORTING] intValue] == BY_NAME ) {
        
        cell = [cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NameSortingCell"];
        [cell.detailTextLabel setText:[[[self.rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:COUNTRY]];
    }
    [cell.textLabel setText:name];
    [cell.imageView setImage:image];
    
    return cell;
}


//---------------------------------------------------------------------------
//---------------------------- UITableViewDelegate --------------------------
//---------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
 
    [self.coinsTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self performSegueWithIdentifier:@"EditCoinSegue" sender:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"EditCoinSegue" sender:self];
}
    
@end

