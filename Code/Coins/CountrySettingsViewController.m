//
//  CountrySettingsViewController.m
//  Coins
//
//  Created by Panos Kalodimas on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CountrySettingsViewController.h"

@interface CountrySettingsViewController ()

@end

@implementation CountrySettingsViewController

@synthesize option;
@synthesize rows;
@synthesize countryTableView;
@synthesize countryList;
@synthesize caller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];

    self.countryList = [self loadCountryList];
    self.rows = nil;
    if ( self.option == COUNTRY_SETTINGS )  self.countryTableView.allowsSelection = NO;
    if ( self.option == COUNTRY_SELECT ) self.countryTableView.allowsSelection = YES;
}

- (void)viewDidUnload{
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//---------------------------------------------------------------------------
//----------------------------------- IBActions -----------------------------
//---------------------------------------------------------------------------

-(IBAction)addCountry:(id)sender{
    
    UIAlertView *addCountryView = [[UIAlertView alloc] initWithTitle:@"Country Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];    
    UITextField *countryTextField = [[UITextField alloc] init];
    
    addCountryView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addCountryView addSubview:countryTextField];
    [addCountryView dismissWithClickedButtonIndex:1 animated:YES];
    [addCountryView show];
}


//---------------------------------------------------------------------------
//---------------------------- UIAlertViewDelegate --------------------------
//---------------------------------------------------------------------------
             
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
        
    if ( buttonIndex == 1 ) {
                
        if( [self newCountry:self.countryList name:[[alertView textFieldAtIndex:0] text]] ) {
            
            if ( ![self saveCountryList:self.countryList] ) [self errorMessage:@"Internal Error" message:@"Write on disk error!"];
            [self.countryTableView reloadData];
        }
        else [self errorMessage:@"Error" message:@"Illegal Text"];
    }
}
    
//---------------------------------------------------------------------------
//---------------------------- UITableViewDataSource ------------------------
//---------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.countryList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    UITableViewCell *cell = [self.countryTableView dequeueReusableCellWithIdentifier:@"CountryCell"];
    cell.textLabel.text = [self.countryList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *country = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    [self deleteCountry:self.countryList name:country];
    [self saveCountryList:self.countryList];
    
    [self.countryTableView beginUpdates];
    [self.countryTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.countryTableView endUpdates];
}


//---------------------------------------------------------------------------
//---------------------------- UITableViewDelegate --------------------------
//---------------------------------------------------------------------------

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.option == COUNTRY_SETTINGS) return YES;
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( self.option == COUNTRY_SELECT ) {
    
        NSString *selectedCountry= [[[self.countryTableView cellForRowAtIndexPath:indexPath] textLabel] text];
        CoinsAddCoinViewController *vc = (CoinsAddCoinViewController*) self.caller;
        [vc.coinCountry setTitle:selectedCountry forState:UIControlStateNormal];
        [vc.coinCountry setTitle:selectedCountry forState:UIControlStateSelected];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

















