//
//  CoinsImagePickerController.m
//  Coins
//
//  Created by Panos Kalodimas on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoinsImagePickerController.h"

@interface CoinsImagePickerController ()

@end

@implementation CoinsImagePickerController

@synthesize parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, 320, 640)];
}

- (void)viewDidUnload{
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
 
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear:(BOOL)animated{

}

-(void)viewWillAppear:(BOOL)animated{
}


@end
