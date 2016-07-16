//
//  CoinsActiveCountrySortingCell.h
//  Coins
//
//  Created by Panos Kalodimas on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDefinitions.h"
#import "ActiveCoinsViewController.h"

@interface CoinsActiveCountrySortingCell : UITableViewCell{
    
    UISwitch *activeSwitch;
    UILabel *coinName;
    UIImageView *imageView;
    id owner;
}

@property (strong, nonatomic) IBOutlet UISwitch *activeSwitch;
@property (strong, nonatomic) IBOutlet UILabel *coinName;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) id owner;

-(id)initWithCoin:(NSDictionary*)coin;
-(IBAction)switchValueChanged:(id)sender;


@end
