//
//  CoinSamplesViewController.h
//  Coins
//
//  Created by Panos Kalodimas on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDefinitions.h"
#import "Coin.h"
#import "NSObject+CoinsManaging.h"

@interface CoinSamplesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, 
                                                        UINavigationControllerDelegate> {
    NSMutableArray *samplesImages;
    Coin *coin;
    UITableView *samplesTableView;
    UIViewController *caller;
    NSArray *coors;
    UIImageView *templateView;
    UILabel *templateSize;
    UILabel *sampleSize;
    UILabel *depthSize;
}

@property (strong, nonatomic) NSMutableArray *samplesImages;
@property (strong, nonatomic) Coin *coin;
@property (strong, nonatomic) IBOutlet UITableView *samplesTableView;
@property (strong, nonatomic) UIViewController *caller;
@property (strong, nonatomic) NSArray *coors;
@property (strong, nonatomic) IBOutlet UIImageView *templateView;
@property (strong, nonatomic) IBOutlet UILabel *templateSize;
@property (strong, nonatomic) IBOutlet UILabel *sampleSize;
@property (strong, nonatomic) IBOutlet UILabel *depthSize;

@end
