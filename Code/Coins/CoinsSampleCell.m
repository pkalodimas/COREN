//
//  CoinsSampleCell.m
//  Coins
//
//  Created by Panos Kalodimas on 12/27/12.
//
//

#import "CoinsSampleCell.h"

@implementation CoinsSampleCell

@synthesize imageView;
@synthesize angleLabel;
@synthesize sizeLabel;
@synthesize depthLabel;
@synthesize sampleNumLabel;
@synthesize sampleSizeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
