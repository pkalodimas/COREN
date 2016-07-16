//
//  ImageProccesserViewController.m
//  Coins
//
//  Created by Panos Kalodimas on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageProccesserViewController.h"

@interface ImageProccesserViewController ()

@end

@implementation ImageProccesserViewController

@synthesize coinName;
@synthesize coinCountry;
@synthesize coinCorrelation;
@synthesize timeLabel;
@synthesize userImage;
@synthesize coinImage;
@synthesize templateImage;
@synthesize image2proccess;
@synthesize recognizedCoin;
@synthesize history;
@synthesize times;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.image2proccess)  [self.userImage setImage:self.image2proccess];
    
    if (self.history) {
        
        self.times = [self.history lastObject];
        [self.history removeLastObject];
        double totalTime = 0;
        for (int i=0; i<self.times.count; i++)  totalTime += [[self.times objectAtIndex:i] doubleValue];
        [self.timeLabel setText:[NSString stringWithFormat:@"%.3f sec",totalTime]];
        
        self.recognizedCoin = [self loadCoinData:[[[history lastObject] lastObject] valueForKey:NAME]];
        [self.coinImage setImage:self.recognizedCoin.image];
        [self.templateImage setImage:self.recognizedCoin.templateImage];
        [self.coinName setText:self.recognizedCoin.name];
        [self.coinCountry setText:self.recognizedCoin.country];
        
        [self.coinCorrelation setText:[NSString stringWithFormat:@"%.2f%%", ([[[[self.history lastObject] lastObject] valueForKey:CORRELATION] floatValue])]];
    }
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    for (int i=0; i<self.history.count; i++)  [[self.history objectAtIndex:i] removeAllObjects];
    [self.history removeAllObjects];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"CoinInfoSegue"] ) {

        CoinsAddCoinViewController *dvc = segue.destinationViewController;
        dvc.coin = self.recognizedCoin;
        dvc.option = COIN_INFO;
    }
    else {
        
        CoinsStageViewController *dvc = segue.destinationViewController;
        dvc.stages = self.history;
        dvc.times = self.times;
    }
}



@end
