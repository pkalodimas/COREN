//
//  CoinSamplesViewController.m
//  Coins
//
//  Created by Panos Kalodimas on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoinSamplesViewController.h"

@interface CoinSamplesViewController ()

@end

@implementation CoinSamplesViewController

@synthesize samplesImages;
@synthesize samplesTableView;
@synthesize coin;
@synthesize caller;
@synthesize coors;
@synthesize templateSize;
@synthesize templateView;
@synthesize sampleSize;
@synthesize depthSize;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!self.coin)  self.coin = [[Coin alloc] init];
    
    NSMutableDictionary *settings = [self loadSettings];
    [self.templateView setImage:self.coin.templateImage];
    [self.templateSize setText:[NSString stringWithFormat:@"%dx%d",[[self getSetting:settings name:TEMPLATE] integerValue], [[self getSetting:settings name:TEMPLATE] integerValue]]];
    [self.sampleSize setText:[NSString stringWithFormat:@"%dx%d",[[self getSetting:settings name:SAMPLE] integerValue], [[self getSetting:settings name:SAMPLE] integerValue]]];
    [self.depthSize setText:[NSString stringWithFormat:@"%d",[[self getSetting:settings name:DEPTH] integerValue]]];
    settings = nil;
    
    self.samplesImages = [NSMutableArray arrayWithArray:[self.coin getSamplesImages]];
    self.samplesTableView.allowsSelection = NO;
    self.coors = [NSArray arrayWithObjects:@"(0,0)",@"(-1,1)",@"(0,1)",@"(1,1)",@"(-1,0)",
                                           @"(1,0)",@"(-1,-1)",@"(0,-1)",@"(1,-1)",@"(-2,2)",
                                           @"(-1,2)",@"(0,2)",@"(1,2)",@"(2,2)",@"(-2,1)",
                                           @"(2,1)",@"(-2,0)",@"(0,2)",@"(-2,-1)",@"(2,-1)",
                                           @"(-2,-2)",@"(-1,-2)",@"(0,-2)",@"(1,-2)",@"(2,-2)", nil];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//---------------------------------------------------------------------------
//---------------------------- UITableViewDataSource ------------------------
//---------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"Samples";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  ([self.coin.samples count] > self.coors.count)? self.coors.count : [self.coin.samples count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SampleCell"];
    
    cell.textLabel.text = [@"Sample " stringByAppendingString:[self.coors objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d x %d", [[[self.coin.samples objectAtIndex:indexPath.row] valueForKey:HEIGHT] intValue], [[[self.coin.samples objectAtIndex:indexPath.row] valueForKey:WIDTH] intValue] ];
    [cell.imageView setImage:[self.samplesImages objectAtIndex:indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

//---------------------------------------------------------------------------
//---------------------------- UITableViewDelegate --------------------------
//---------------------------------------------------------------------------

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return NO;
}

@end
