//
//  ActiveCoinsViewController.h
//  Coins
//
//  Created by Panos Kalodimas on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+CoinsManaging.h"
#import "CoinsActiveNameSortingCell.h"
#import "CoinsActiveCountrySortingCell.h"

@interface ActiveCoinsViewController : UITableViewController{
    
    UITableView *activeCoinsTable;
    NSMutableArray *coinsList;
    NSMutableArray *rows;
    NSMutableArray *sections;
}

@property (strong, nonatomic) IBOutlet UITableView *activeCoinsTable;
@property (strong, nonatomic) NSMutableArray *coinsList;
@property (strong, nonatomic) NSMutableArray *rows;
@property (strong, nonatomic) NSMutableArray *sections;

- (void)createTableViewSettings;
- (void)activityChanged:(NSString*)coinName state:(BOOL)state;

@end
