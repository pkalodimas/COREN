//
//  CoinsSettingsViewController.h
//  Coins
//
//  Created by Panos Kalodimas on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+CoinsManaging.h"
#import "CoinsAddCoinViewController.h"

@interface CoinsSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    NSMutableArray *coinsList;
    NSMutableArray *sections;
    NSMutableArray *rows;
    UITableView *coinsTableView;
}

//@property (strong, nonatomic) CoinsManager *coinsManager;
@property (strong, nonatomic) NSMutableArray *coinsList;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *rows;
@property (strong, nonatomic) IBOutlet UITableView *coinsTableView;

-(void)createTableViewSettings;

@end
