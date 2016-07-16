//
//  CoinsStageCell.h
//  Coins
//
//  Created by Panos Kalodimas on 1/14/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDefinitions.h"
#import "Coin.h"

@interface CoinsStageCell : UITableViewCell{
    
    UILabel *number;
    UILabel *details;
    UILabel *coinName;
    UILabel *coinCountry;
    UIImageView *imageView;
}

@property (strong, nonatomic) IBOutlet UILabel *number;
@property (strong, nonatomic) IBOutlet UILabel *details;
@property (strong, nonatomic) IBOutlet UILabel *coinName;
@property (strong, nonatomic) IBOutlet UILabel *coinCountry;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

-(id)initWithCoin:(NSDictionary*)coin;

@end
