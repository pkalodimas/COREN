//
//  CoinsStageCell.m
//  Coins
//
//  Created by Panos Kalodimas on 1/14/13.
//
//

#import "CoinsStageCell.h"

@implementation CoinsStageCell

@synthesize number;
@synthesize coinName;
@synthesize coinCountry;
@synthesize details;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoin:(NSDictionary *)coin{
    
    if (coin) {
        
        [self.coinName setText:[coin valueForKey:NAME]];
        [self.coinCountry setText:[coin valueForKey:COUNTRY]];
        [self.details setText:[NSString stringWithFormat:@"Correlation:%.2f%% at %d angle", [[coin valueForKey:CORRELATION] floatValue], [[coin valueForKey:ANGLE] integerValue]]];
        //[self.imageView setImage:[[self loadCoinDataOnlyInfo:[coin valueForKey:NAME]] image]];
    }
    return self;
}

@end
