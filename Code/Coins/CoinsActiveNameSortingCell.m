//
//  CoinsActiveCell.m
//  Coins
//
//  Created by Panos Kalodimas on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoinsActiveNameSortingCell.h"

@implementation CoinsActiveNameSortingCell

@synthesize coinName;
@synthesize coinCountry;
@synthesize activeSwitch;
@synthesize imageView;
@synthesize owner;

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

-(id)initWithCoin:(NSDictionary*)coin{
        
    [self.coinName setText:[coin valueForKey:NAME]];
    [self.coinCountry setText:[coin valueForKey:COUNTRY]];
    [self.imageView setImage:[self getCoinIcon:[coin valueForKey:NAME]]];
    
    ACTIVE_OPTION active = [[coin valueForKey:ACTIVE] integerValue];
    [self.activeSwitch setOn:((active > 0)? YES : NO)];
    if (active < 0) [self.activeSwitch setEnabled:NO];

    return self;
}

-(IBAction)switchValueChanged:(id)sender{
    
    [self.owner activityChanged:self.coinName.text state:self.activeSwitch.on];
}

@end
