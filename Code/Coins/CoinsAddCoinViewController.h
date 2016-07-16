//
//  CoinsAddCoinViewController.h
//  Coins
//
//  Created by Panos Kalodimas on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDefinitions.h"
#import "Coin.h"
#import "CountrySettingsViewController.h"
//#import "CoinsManager.h"
#import "CoinSamplesViewController.h"
#import "CoinsImagePickerController.h"
#import "NSObject+ImageProccessing.h"
#import "NSObject+CoinsManaging.h"


@interface CoinsAddCoinViewController : UIViewController <UITextFieldDelegate, 
                                                            UIImagePickerControllerDelegate,
                                                            UINavigationControllerDelegate> {
    
    UITextField *coinName;
    UIButton *coinCountry;
    UIImageView *coinImageView;
    UIImageView *templateImageView;
    UITapGestureRecognizer *tapGesture;
    UILabel *samplesDetails;
    UIButton *samplesButton;
    UIButton *deleteButton;
    UIButton *imageButton;
    UIButton *imageDeleteButton;
    UIButton *templateButton;
    UIButton *templateDeleteButton;
    COIN_OPTION option;
    IMAGE_OPTION imageOption;
    Coin *coin;
    UIImagePickerController *coinImagePicker;
    UIImage *coinImage;
    UIImage *templateImage;

}

@property(strong, nonatomic) IBOutlet UITextField *coinName;
@property(strong, nonatomic) IBOutlet UIButton *coinCountry;
@property(strong, nonatomic) IBOutlet UIImageView *coinImageView;
@property(strong, nonatomic) IBOutlet UIImageView *templateImageView;
@property(strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property(strong, nonatomic) IBOutlet UIButton *samplesButton;
@property(strong, nonatomic) IBOutlet UIButton *deleteButton;
@property(strong, nonatomic) IBOutlet UIButton *imageButton;
@property(strong, nonatomic) IBOutlet UIButton *imageDeleteButton;
@property(strong, nonatomic) IBOutlet UIButton *templateButton;
@property(strong, nonatomic) IBOutlet UIButton *templateDeleteButton;
@property (strong, nonatomic) IBOutlet UILabel *samplesDetails;
@property(strong, nonatomic) Coin *coin;
@property(assign, nonatomic) COIN_OPTION option;
@property(assign, nonatomic) IMAGE_OPTION imageOption;
@property(strong, nonatomic) UIImagePickerController *coinImagePicker;
@property(strong, nonatomic) UIImage *coinImage;
@property(strong, nonatomic) UIImage *templateImage;

-(IBAction)SaveButton:(id)sender;
-(IBAction)AddImageButton:(id)sender;
-(IBAction)AddTemplateButton:(id)sender;
-(IBAction)DeleteImageButton:(id)sender;
-(IBAction)DeleteTemplateButton:(id)sender;
-(IBAction)gestureTouch:(id)sender;
-(IBAction)deleteButton:(id)sender;
-(IBAction)countryButton:(id)sender;

-(void)camera;

@end
