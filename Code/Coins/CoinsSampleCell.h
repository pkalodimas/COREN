//
//  CoinsSampleCell.h
//  Coins
//
//  Created by Panos Kalodimas on 12/27/12.
//
//

#import <UIKit/UIKit.h>
#import "AppDefinitions.h"

@interface CoinsSampleCell : UITableViewCell{
    
    UILabel *angleLabel;
    UILabel *sizeLabel;
    UILabel *depthLabel;
    UILabel *sampleNumLabel;
    UILabel *sampleSizeLabel;
    UIImageView *imageView;
    id owner;
}

@property (strong, nonatomic) IBOutlet UILabel *angleLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *depthLabel;
@property (strong, nonatomic) IBOutlet UILabel *sampleNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *sampleSizeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) id owner;

-(id)initWithCoin:(NSDictionary*)coin;
-(IBAction)switchValueChanged:(id)sender;


@end
