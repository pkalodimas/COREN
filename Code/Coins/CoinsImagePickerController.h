//
//  CoinsImagePickerController.h
//  Coins
//
//  Created by Panos Kalodimas on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinsImagePickerController : UIViewController{
    
    UIImagePickerController *parent;
}
@property(strong, nonatomic) UIImagePickerController *parent;

@end
