//
//  SettingsViewController.m
//  Coins
//
//  Created by Panos Kalodimas on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoinsAppSettingsViewController.h"

@interface CoinsAppSettingsViewController ()

@end

@implementation CoinsAppSettingsViewController

@synthesize sortButton;
@synthesize cropButton;
@synthesize angleButton;
@synthesize stepButton;
@synthesize depthButton;
@synthesize templateButton;
@synthesize sampleButton;
@synthesize paddingButton;
@synthesize accurancyButton;

@synthesize settings;
@synthesize sortSetting;
@synthesize cropSetting;
@synthesize angleSetting;
@synthesize stepSetting;
@synthesize paddingSetting;
@synthesize depthSetting;
@synthesize templateSetting;
@synthesize sampleSetting;
@synthesize accurancySetting;

@synthesize paddingSettingLabel;
@synthesize paddingSettingMaxLabel;
@synthesize templateSettingLabel;
@synthesize sampleSettingLabel;
@synthesize sampleSettingMaxLabel;
@synthesize accurancySettingLabel;

@synthesize busy;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scrollView = (UIScrollView*) self.view;
    scrollView.contentSize = CGSizeMake(320, 850);
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.settings = [self loadSettings];
    [self settingsInit];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.settings = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)settingsInit{
    
    if (!self.settings) self.settings = [self loadSettings];
    
    self.sortSetting = (SORTING_OPTION) [[self.settings valueForKey:SORTING] intValue];
    self.cropSetting = (CROP_OPTION) [[self.settings valueForKey:CROP] intValue];
    self.angleSetting = (ANGLE_SIZE) [[self.settings valueForKey:ANGLE] intValue];
    self.stepSetting = (STEP_SIZE) [[self.settings valueForKey:STEP] intValue];
    self.paddingSetting = (int) [[self.settings valueForKey:PADDING] intValue];
    self.depthSetting = (DEPTH_SIZE) [[self.settings valueForKey:DEPTH] intValue];
    self.templateSetting = (int) [[self.settings valueForKey:TEMPLATE] intValue];
    self.sampleSetting = (int) [[self.settings valueForKey:SAMPLE] intValue];
    self.accurancySetting = (int) [[self.settings valueForKey:ACCURACY] intValue];
    
    [self.accurancyButton setValue:(int)self.accurancySetting animated:NO];
    [self.accurancySettingLabel setText:[NSString stringWithFormat:@"%d%%", self.accurancySetting]];
    
    [self.paddingButton setValue:(int)(self.paddingSetting - PADDING_MIN)/5 animated:NO];
    [self.paddingSettingLabel setText:[NSString stringWithFormat:@"%dpx", self.paddingSetting]];
    [self.paddingSettingMaxLabel setText:[NSString stringWithFormat:@"%d", PADDING_MAX]];
    self.paddingButton.maximumValue = (int) (PADDING_MAX - PADDING_MIN)/5;
    
    [self.templateButton setValue:(int)(self.templateSetting - TEMPLATE_MIN)/5 animated:NO];
    [self.templateSettingLabel setText:[NSString stringWithFormat:@"%dpx", self.templateSetting]];
    self.templateButton.maximumValue = (int) (TEMPLATE_MAX - TEMPLATE_MIN)/5;
    
    [self.sampleButton setValue:(int)(self.sampleSetting - SAMPLE_MIN)/5 animated:NO];
    [self.sampleSettingLabel setText:[NSString stringWithFormat:@"%dpx", self.sampleSetting]];
    [self.sampleSettingMaxLabel setText:[NSString stringWithFormat:@"%d", SAMPLE_MAX]];
    self.sampleButton.maximumValue = (int) (SAMPLE_MAX - SAMPLE_MIN)/5;
    
    [self conflictCheck];
    
    if (self.sortSetting == BY_COUNTRY)  self.sortButton.selectedSegmentIndex = 1;
    else  self.sortButton.selectedSegmentIndex = 0;
    
    if (self.cropSetting == CROP_MANUAL)  self.cropButton.selectedSegmentIndex = 1;
    else  self.cropButton.selectedSegmentIndex = 0;
    
    if (self.stepSetting == STEP_10)  self.stepButton.selectedSegmentIndex = 1;
    else  self.stepButton.selectedSegmentIndex = 0;
    
    switch (self.angleSetting) {
        case ANGLE_0:
            self.angleButton.selectedSegmentIndex = 0;
            break;
        case ANGLE_5:
            self.angleButton.selectedSegmentIndex = 1;
            break;
        case ANGLE_20:
            self.angleButton.selectedSegmentIndex = 3;
            break;
        default:
            self.angleButton.selectedSegmentIndex = 2;
            break;
    }
    
    switch (self.depthSetting) {
        case DEPTH_1:
            self.depthButton.selectedSegmentIndex = 0;
            break;
        case DEPTH_3:
            self.depthButton.selectedSegmentIndex = 2;
            break;
        default:
            self.depthButton.selectedSegmentIndex = 1;
            break;
    }
}


//---------------------------------------------------------------------------
//---------------------------- IBActions ------------------------------------
//---------------------------------------------------------------------------

-(IBAction)saveSettingsButton:(id)sender{
    
    BOOL samplesRecreate = NO;
    
    if (!self.settings)  self.settings = [self loadSettings];
    
    if ( self.sortSetting != (SORTING_OPTION)[[self.settings valueForKey:SORTING] intValue] ) {
        
        [self editSetting:self.settings name:SORTING value:[NSNumber numberWithInt:self.sortSetting] save:NO];
        NSMutableArray *coinsList = [self loadCoinsList];
        [self sortCoinList:coinsList type:self.sortSetting];
        [self saveCoinsList:coinsList];
    }
    if ( self.cropSetting != (CROP_OPTION)[[self getSetting:settings name:CROP] intValue] ) {
        
        [self editSetting:self.settings name:CROP value:[NSNumber numberWithInt:self.cropSetting] save:NO];
    }
    if ( self.angleSetting != (ANGLE_SIZE)[[self getSetting:settings name:ANGLE] intValue] ) {
        
        [self editSetting:self.settings name:ANGLE value:[NSNumber numberWithInt:self.angleSetting] save:NO];
    }
    if ( self.stepSetting != (STEP_SIZE)[[self getSetting:settings name:STEP] intValue] ) {
        
        [self editSetting:self.settings name:STEP value:[NSNumber numberWithInt:self.stepSetting] save:NO];
    }
    if ( self.paddingSetting != (int)[[self getSetting:settings name:PADDING] intValue] ) {
        
        [self editSetting:self.settings name:PADDING value:[NSNumber numberWithInt:self.paddingSetting] save:NO];
    }
    if ( self.depthSetting != (DEPTH_SIZE)[[self getSetting:settings name:DEPTH] intValue] ) {
        
        [self editSetting:self.settings name:DEPTH value:[NSNumber numberWithInt:self.depthSetting] save:NO];
        samplesRecreate = YES;
    }
    if ( self.templateSetting != (int)[[self getSetting:settings name:TEMPLATE] intValue] ) {
        
        [self editSetting:self.settings name:TEMPLATE value:[NSNumber numberWithInt:self.templateSetting] save:NO];
        samplesRecreate = YES;
    }
    if ( self.sampleSetting != (int)[[self getSetting:settings name:SAMPLE] intValue] ) {
        
        [self editSetting:self.settings name:SAMPLE value:[NSNumber numberWithInt:self.sampleSetting] save:NO];
        samplesRecreate = YES;
    }
    if ( self.accurancySetting != (int)[[self getSetting:settings name:ACCURACY] intValue] ) {
        
        [self editSetting:self.settings name:ACCURACY value:[NSNumber numberWithInt:self.accurancySetting] save:NO];
    }
    if ( ![self saveSettings:self.settings] ) [self errorMessage:@"Internal Error" message:@"Write to disk error"];
    else if (samplesRecreate) {
        
        [[[NSThread alloc] initWithTarget:self.busy selector:@selector(startAnimating) object:nil] start];
        if ( ![self recreateCoinSamples] ) [self errorMessage:@"Internal Error" message:@"Coins Resampling error"];
    }
    [self.busy stopAnimating];
}

-(IBAction)sortButton:(id)sender{
    
    switch (self.sortButton.selectedSegmentIndex) {
        case 0:{
            self.sortSetting = BY_NAME;
            break;
        }
        default:{
            self.sortSetting = BY_COUNTRY;
            break;
        }
    }    
}

-(IBAction)cropButton:(id)sender{
    
    switch (self.cropButton.selectedSegmentIndex) {
        case 0:{
            self.cropSetting = CROP_AUTO;
            break;
        }
        default:{
            self.cropSetting = CROP_MANUAL;
            break;
        }
    }    
}

-(IBAction)angleButton:(id)sender{
    
    switch (self.angleButton.selectedSegmentIndex) {
        case 0:{
            self.angleSetting = ANGLE_0;
            break;
        }
        case 1:{
            self.angleSetting = ANGLE_5;
            break;
        }
        case 2:{
            self.angleSetting = ANGLE_10;
            break;
        }
        default:{
            self.angleSetting = ANGLE_20;
            break;
        }
    }
}

-(IBAction)stepButton:(id)sender{
    
    switch (self.stepButton.selectedSegmentIndex) {
        case 0:{
            self.stepSetting = STEP_5;
            break;
        }
        default:{
            self.stepSetting = STEP_10;
            break;
        }
    }
}

-(IBAction)depthButton:(id)sender{
    
    switch (self.depthButton.selectedSegmentIndex) {
        case 0:{
            self.depthSetting = DEPTH_1;
            break;
        }
        case 1:{
            self.depthSetting = DEPTH_2;
            break;
        }
        default:{
            self.depthSetting = DEPTH_3;
            break;
        }
    }
    [self conflictCheck];
}

-(IBAction)paddingButton:(id)sender{
    
    self.paddingButton.value = (int) self.paddingButton.value;
    self.paddingSetting = (int) 5*self.paddingButton.value + PADDING_MIN;
    [self.paddingSettingLabel setText:[NSString stringWithFormat:@"%dpx", self.paddingSetting]];
    if (sender) [self conflictCheck];
}

-(IBAction)templateButton:(id)sender{
    
    self.templateButton.value = (int) self.templateButton.value;
    self.templateSetting = (int) 5*self.templateButton.value + TEMPLATE_MIN;
    [self.templateSettingLabel setText:[NSString stringWithFormat:@"%dpx", self.templateSetting]];
    [self conflictCheck];
}

-(IBAction)sampleButton:(id)sender{
    
    self.sampleButton.value = (int) self.sampleButton.value;
    self.sampleSetting = (int) 5*((int)self.sampleButton.value) + SAMPLE_MIN;
    [self.sampleSettingLabel setText:[NSString stringWithFormat:@"%dpx", self.sampleSetting]];
    if (sender) [self conflictCheck];
}

-(IBAction)accurancyButton:(id)sender{
    
    self.accurancySetting = (int) self.accurancyButton.value;
    [self.accurancySettingLabel setText:[NSString stringWithFormat:@"%d%%", self.accurancySetting]];
}

-(void)conflictCheck{
    
    int depth = (2*self.depthSetting - 1);
    int sampleMax = ((self.templateSetting/depth) < SAMPLE_MAX)? self.templateSetting/depth : SAMPLE_MAX;
    sampleMax = (sampleMax - SAMPLE_MIN ) / 5;
    
    self.sampleButton.maximumValue = (int) sampleMax;
    [self.sampleSettingMaxLabel setText:[NSString stringWithFormat:@"%d", 5*sampleMax + SAMPLE_MIN]];
    [self sampleButton:nil];
    
    int paddingMax = (int) (self.templateSetting - (self.sampleSetting * depth)) / 2;
    paddingMax = (paddingMax < PADDING_MAX)? paddingMax : PADDING_MAX;
    paddingMax = (paddingMax - PADDING_MIN) / 5;
    
    self.paddingButton.maximumValue = (int) paddingMax;
    [self.paddingSettingMaxLabel setText:[NSString stringWithFormat:@"%d", 5*paddingMax + PADDING_MIN]];
    [self paddingButton:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"CountrySettings"] ) {
        
        CountrySettingsViewController *cs = segue.destinationViewController;
        cs.option = COUNTRY_SETTINGS;
    }
}

-(IBAction)exportDataButton:(id)sender{
    
    [self exportData];
}

-(IBAction)importDataButton:(id)sender{
    
    [self importData];
}

-(IBAction)defaultSettings:(id)sender{
    
    self.settings = [self defaultSettings];
    [self saveSettings:self.settings];
    [self settingsInit];
}


@end
