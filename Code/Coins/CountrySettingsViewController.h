//
//  CountrySettingsViewController.h
//  Coins
//
//  Created by Panos Kalodimas on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDefinitions.h"
#import "NSObject+CoinsManaging.h"
#import "CoinsAddCoinViewController.h"

@interface CountrySettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    COUNTRY_OPTION option;
    NSMutableArray *rows;
    UITableView *countryTableView;
    NSMutableArray *countryList;
    UIViewController *caller;
}

@property (assign, nonatomic) COUNTRY_OPTION option;
@property (strong, nonatomic) NSMutableArray *rows;
@property (strong, nonatomic) IBOutlet UITableView *countryTableView;
@property (strong, nonatomic) NSMutableArray *countryList;
@property (strong, nonatomic) UIViewController *caller;

-(IBAction)addCountry:(id)sender;

@end
