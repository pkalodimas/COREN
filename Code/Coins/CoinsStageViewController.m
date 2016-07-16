//
//  CoinsStageViewController.m
//  Coins
//
//  Created by Panos Kalodimas on 1/14/13.
//
//

#import "CoinsStageViewController.h"

@interface CoinsStageViewController ()

@end

@implementation CoinsStageViewController

@synthesize stagesTable;
@synthesize sections;
@synthesize coors;
@synthesize times;
@synthesize stages;
@synthesize icons;
@synthesize coins;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.sections = [NSMutableArray array];
    self.coors = [NSMutableArray arrayWithObjects:SAMPLE_COORS,@"Finalists Stage",@"Recognize Stage", nil];
    if (!self.stages)  self.stages = [NSMutableArray array];
        
    for (int i=0; i<self.times.count; i++)
        [self.sections addObject:[NSString stringWithFormat:@"Stage %d : %@ at %.3f sec", i+1, [self.coors objectAtIndex:i], [[self.times objectAtIndex:i] doubleValue]]];
    
    if (self.stages.count > self.times.count)  [self.sections insertObject:@"Recognize Stage" atIndex:self.times.count];
    if (self.stages.count > self.times.count+1)  [self.sections insertObject:@"Finalists Stage" atIndex:self.times.count];

    self.coins = [self.stages objectAtIndex:0];
    self.icons = [NSMutableArray array];
    for (int i=0; i<[[self.stages objectAtIndex:0] count]; i++)
        [self.icons addObject:[self getCoinIcon:[[self.coins objectAtIndex:i] valueForKey:NAME]]];
}

-(UIImage*)getCoinIconFromList:(NSString *)name{
    
    int i = [self findCoinInList:self.coins name:name];
    return (i < 0)? nil : [self.icons objectAtIndex:i];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    for (int i=0; i<self.stages.count; i++)  [[self.stages objectAtIndex:i] removeAllObjects];
    [self.stages removeAllObjects];
    self.stages = nil;
    self.icons = nil;
    self.times = nil;
    self.coins = nil;
    self.coors = nil;
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//---------------------------------------------------------------------------
//---------------------------- UITableViewDataSource ------------------------
//---------------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  self.stages.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [self.sections objectAtIndex:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  [[self.stages objectAtIndex:section] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
            
    CoinsStageCell *cell = [self.stagesTable dequeueReusableCellWithIdentifier:@"CoinsStageCell"];
    cell = [cell initWithCoin:[[self.stages objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [cell.number setText:[NSString stringWithFormat:@"%d",((int)indexPath.row+1)]];
    [cell.imageView setImage:[self getCoinIconFromList:cell.coinName.text]];
    return cell;
}


//---------------------------------------------------------------------------
//---------------------------- UITableViewDelegate --------------------------
//---------------------------------------------------------------------------



@end
