//
//  MainViewController.h
//  Coins
//
//  Created by Panos Kalodimas on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoinsImagePickerController.h"
#import "NSObject+CoinsManaging.h"
#import "NSObject+ImageProccessing.h"
#import "ImageProccesserViewController.h"

@interface CoinsMainViewController : UIViewController <UINavigationControllerDelegate,
                                                        UIImagePickerControllerDelegate> {
    UIImageView *imageView;
    UIImage *coinImage;
    UIBarButtonItem *recognizeButton;
    UIImagePickerController *ImagePicker;
    UIActivityIndicatorView *busy;
    NSMutableArray *correlationResults;
}

@property(strong,nonatomic) IBOutlet UIImageView *imageView;
@property(strong,nonatomic) IBOutlet UIImage *coinImage;
@property(strong,nonatomic) IBOutlet UIBarButtonItem *recognizeButton;
@property(strong,nonatomic) UIImagePickerController *imagePicker;
@property(strong,nonatomic) IBOutlet UIActivityIndicatorView *busy;
@property(strong,nonatomic) NSMutableArray *correlationResults;

-(IBAction)CameraButton:(id)sender;
-(IBAction)RecognizeButton:(id)sender;
-(void)PhotoAlbumButton;

@end
