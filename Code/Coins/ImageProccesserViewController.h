//
//  ImageProccesserViewController.h
//  Coins
//
//  Created by Panos Kalodimas on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+CoinsManaging.h"
#import "CoinsAddCoinViewController.h"
#import "CoinsStageViewController.h"
#import "NSObject+ImageProccessing.h"

@interface ImageProccesserViewController : UIViewController{
    
    UILabel *coinName;
    UILabel *coinCountry;
    UILabel *coinCorrelation;
    UILabel *timeLabel;
    UIImageView *userImage;
    UIImageView *coinImage;
    UIImageView *templateImage;
    UIImage *image2proccess;
    Coin *recognizedCoin;
    NSMutableArray *history;
    NSMutableArray *times;
}

@property (strong, nonatomic) IBOutlet UILabel *coinName;
@property (strong, nonatomic) IBOutlet UILabel *coinCountry;
@property (strong, nonatomic) IBOutlet UILabel *coinCorrelation;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coinImage;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UIImageView *templateImage;
@property (strong, nonatomic) UIImage *image2proccess;
@property (strong, nonatomic) Coin *recognizedCoin;
@property (strong, nonatomic) NSMutableArray *history;
@property (strong, nonatomic) NSMutableArray *times;

@end
