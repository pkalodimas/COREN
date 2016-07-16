//
//  SettingsViewController.h
//  Coins
//
//  Created by Panos Kalodimas on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDefinitions.h"
#import "NSObject+CoinsManaging.h"
#import "CountrySettingsViewController.h"

@interface CoinsAppSettingsViewController : UIViewController{
    
    UISegmentedControl *sortButton;
    UISegmentedControl *cropButton;
    UISegmentedControl *angleButton;
    UISegmentedControl *stepButton;
    UISlider *paddingButton;
    UISegmentedControl *depthButton;
    UISlider *templateButton;
    UISlider *sampleButton;
    UISlider *accurancyButton;
    UILabel *paddingSettingLabel;
    UILabel *paddingSettingMaxLabel;
    UILabel *templateSettingLabel;
    UILabel *sampleSettingLabel;
    UILabel *sampleSettingMaxLabel;
    UILabel *accurancySettingLabel;
    NSMutableDictionary *settings;
    SORTING_OPTION sortSetting;
    CROP_OPTION cropSetting;
    ANGLE_SIZE angleSetting;
    STEP_SIZE stepSetting;
    int paddingSetting;
    DEPTH_SIZE depthSetting;
    int templateSetting;
    int sampleSetting;
    int accurancySetting;
    UIActivityIndicatorView *busy;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *sortButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *cropButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *angleButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *stepButton;
@property (strong, nonatomic) IBOutlet UISlider *paddingButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *depthButton;
@property (strong, nonatomic) IBOutlet UISlider *templateButton;
@property (strong, nonatomic) IBOutlet UISlider *sampleButton;
@property (strong, nonatomic) IBOutlet UISlider *accurancyButton;
@property (strong, nonatomic) IBOutlet UILabel *paddingSettingLabel;
@property (strong, nonatomic) IBOutlet UILabel *paddingSettingMaxLabel;
@property (strong, nonatomic) IBOutlet UILabel *templateSettingLabel;
@property (strong, nonatomic) IBOutlet UILabel *sampleSettingLabel;
@property (strong, nonatomic) IBOutlet UILabel *sampleSettingMaxLabel;
@property (strong, nonatomic) IBOutlet UILabel *accurancySettingLabel;
@property (strong, nonatomic) NSMutableDictionary *settings;
@property (assign, nonatomic) SORTING_OPTION sortSetting;
@property (assign, nonatomic) CROP_OPTION cropSetting;
@property (assign, nonatomic) ANGLE_SIZE angleSetting;
@property (assign, nonatomic) STEP_SIZE stepSetting;
@property (assign, nonatomic) int paddingSetting;
@property (assign, nonatomic) DEPTH_SIZE depthSetting;
@property (assign, nonatomic) int templateSetting;
@property (assign, nonatomic) int sampleSetting;
@property (assign, nonatomic) int accurancySetting;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *busy;


-(IBAction)saveSettingsButton:(id)sender;
-(IBAction)sortButton:(id)sender;
-(IBAction)cropButton:(id)sender;
-(IBAction)angleButton:(id)sender;
-(IBAction)stepButton:(id)sender;
-(IBAction)paddingButton:(id)sender;
-(IBAction)depthButton:(id)sender;
-(IBAction)templateButton:(id)sender;
-(IBAction)sampleButton:(id)sender;
-(IBAction)accurancyButton:(id)sender;
-(IBAction)exportDataButton:(id)sender;
-(IBAction)importDataButton:(id)sender;
-(IBAction)defaultSettings:(id)sender;

-(void)settingsInit;
-(void)conflictCheck;

@end
