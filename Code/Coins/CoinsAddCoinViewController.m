//
//  CoinsAddCoinViewController.m
//  Coins
//
//  Created by Panos Kalodimas on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoinsAddCoinViewController.h"

@class CoinsSettingsViewController;
@interface CoinsAddCoinViewController ()

@end

@implementation CoinsAddCoinViewController

@synthesize coinName;
@synthesize coinCountry;
@synthesize coinImageView;
@synthesize templateImageView;
@synthesize tapGesture;
@synthesize coinImagePicker;
@synthesize samplesButton;
@synthesize deleteButton;
@synthesize imageButton;
@synthesize templateButton;
@synthesize imageDeleteButton;
@synthesize templateDeleteButton;
@synthesize coin;
@synthesize samplesDetails;
@synthesize option;
@synthesize imageOption;
@synthesize coinImage;
@synthesize templateImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    UIScrollView *scrollView = (UIScrollView*) self.view;
    scrollView.contentSize = CGSizeMake(320, 560);
    
    switch (self.option) {
            
        case COIN_EDIT:{
            
            [self.navigationItem setTitle:COIN_EDIT_TITLE];
            
            if (self.coin) {
                
                [self.coinName setText:self.coin.name];
                [self.coinCountry setTitle:self.coin.country forState:UIControlStateNormal];
                [self.coinCountry setTitle:self.coin.country forState:UIControlStateSelected];
                self.coinImage = self.coin.image;
                [self.coinImageView setImage:self.coinImage];
                self.templateImage = self.coin.templateImage;
                [self.templateImageView setImage:self.templateImage];
            }
            break;
        }
        case COIN_INFO:{
            
            [self.navigationItem setTitle:COIN_INFO_TITLE];
            
            if (self.coin) {
                
                [self.coinName setText:self.coin.name];
                [self.coinCountry setTitle:self.coin.country forState:UIControlStateNormal];
                [self.coinCountry setTitle:self.coin.country forState:UIControlStateSelected];
                self.coinImage = self.coin.image;
                self.templateImage = self.coin.templateImage;
            }
            [self.deleteButton setHidden:YES];
            [self.imageButton setHidden:YES];
            [self.templateButton setHidden:YES];
            [self.imageDeleteButton setHidden:YES];
            [self.templateDeleteButton setHidden:YES];
            self.navigationItem.rightBarButtonItems = [NSArray array];
            [self.coinImageView setImage:self.coinImage];
            [self.templateImageView setImage:self.templateImage];
            
            CGRect frame = [self.view frame];
            frame.size.height -= 100;
            [self.view setFrame:frame];
            
            break;
        }
        case NEW_COIN:{
            
            [self.navigationItem setTitle:COIN_NEW_TITLE];
            
            self.coin = [[Coin alloc] init];
            
            CGRect frame = [self.view frame];
            frame.size.height -= 100;
            [self.view setFrame:frame];
            
            [self.deleteButton setHidden:YES];
            [self.imageDeleteButton setHidden:YES];
            [self.templateDeleteButton setHidden:YES];
            [self.samplesButton setHidden:YES];
            [self.samplesDetails setHidden:YES];
            self.coinImage = nil;
            self.templateImage = nil;
            
            break;
        }
            
        default:
            break;
    }
    
    if (!self.coinImage) {
        
        [self.coinImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NO_IMAGE_FILE ofType:PNG]]];
        [self.imageDeleteButton setHidden:YES];
    }
    if (!self.templateImage) {
        
        [self.templateImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NO_IMAGE_FILE ofType:PNG]]];
        [self.templateDeleteButton setHidden:YES];
        [self.samplesButton setHidden:YES];
        [self.samplesDetails setHidden:YES];
    }
    if (![self.coin samples]) {
        
        [self.samplesButton setHidden:YES];
        [self.samplesDetails setHidden:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (!self.coinImage) {
        
        [self.coinImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NO_IMAGE_FILE ofType:PNG]]];
        [self.imageDeleteButton setHidden:YES];
    }
    
    if (!self.templateImage) {
        
        [self.templateImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NO_IMAGE_FILE ofType:PNG]]];
        [self.templateDeleteButton setHidden:YES];
        [self.samplesButton setHidden:YES];
        [self.samplesDetails setHidden:YES];
    }
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//---------------------------------------------------------------------------
//------------------------------ IBActions & SEGUE---------------------------
//---------------------------------------------------------------------------

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"CountrySelectSegue"] ) {
        
        CountrySettingsViewController *cs = segue.destinationViewController;
        cs.option = COUNTRY_SELECT;
        cs.caller = self;
    }
    else {
        
        CoinSamplesViewController *cs = segue.destinationViewController;
        cs.coin = self.coin;
        cs.caller = self;
    }
}

-(IBAction)gestureTouch:(id)sender{

    [self.coinName resignFirstResponder];
}

-(IBAction)AddImageButton:(id)sender{
    
    self.imageOption = OPTION_COIN;
    [self camera];
}

-(IBAction)AddTemplateButton:(id)sender{

    self.imageOption = OPTION_TEMPLATE;
    [self camera];
}
    
-(void)camera{
    
    self.coinImagePicker = [[UIImagePickerController alloc] init];
    self.coinImagePicker.delegate = self;
    self.coinImagePicker.allowsEditing = YES;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // Gia Kamera
        self.coinImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

        CoinsImagePickerController *imageOverlayPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagePicker"];
        UIButton *photoAlbumButton = [imageOverlayPicker.view.subviews objectAtIndex:0];
        [photoAlbumButton addTarget:self action:@selector(PhotoAlbumButton) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[self getSetting:nil name:CROP] integerValue] == CROP_AUTO) {
            
            self.coinImagePicker.cameraOverlayView = imageOverlayPicker.view;
            imageOverlayPicker.parent = self.coinImagePicker;
        }
        else  [self.coinImagePicker.view addSubview:photoAlbumButton];
    }
    else  self.coinImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:coinImagePicker animated:YES];
}

-(void)PhotoAlbumButton{
    
    self.coinImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

-(IBAction)SaveButton:(id)sender{
        
    if (self.coinName.text && [[self.coinName.text stringByReplacingOccurrencesOfString:SPACE_CHAR withString:EMPTY_CHAR] length] > 0 ) {
         
        NSMutableArray *coinsList = [self loadCoinsList];
            
        self.coin.country = self.coinCountry.titleLabel.text;
        self.coin.image = self.coinImage;
        self.coin.templateImage = self.templateImage;
            
        BOOL error = NO;
            
        switch (self.option) {
            case NEW_COIN:{
                if ([self findCoinInList:coinsList name:self.coinName.text] < 0 ) {
                    
                    self.coin.name = self.coinName.text;
                    error = [self newCoin:coinsList coin:self.coin];
                    if (!error)  [self errorMessage:@"Internal Error" message:@"Error while creating new coin"];
                    else {
                        error = [self saveCoinsList:coinsList];
                        if (!error)  [self errorMessage:@"Internal Error" message:@"Save to disk error"];
                    }
                    break;
                }
                else [self errorMessage:@"Coin Name" message:@"New coin name already exists!"];
            }
            case COIN_EDIT:{
                if ([self.coin.name localizedCaseInsensitiveCompare:self.coinName.text] != NSOrderedSame) {
                    if ( [self findCoinInList:coinsList name:self.coinName.text] >= 0) {
                        
                        [self errorMessage:@"Coin Name" message:@"New name already exists!"];
                        break;
                    }
                }
                NSString *oldName = self.coin.name;
                self.coin.name = self.coinName.text;
                error = [self editCoin:coinsList name:oldName  newData:self.coin];
                if (!error)  [self errorMessage:@"Internal Error" message:@"Error while editing coin"];
                else {
                    error = [self saveCoinsList:coinsList];
                    if (!error)  [self errorMessage:@"Internal Error" message:@"Save to disk error"];
                }
                break;
            }
            default:
                break;
        }
        if (error) [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self errorMessage:@"Coin Name" message:@"No Coin Name Declared!"];
    }
}

-(IBAction)deleteButton:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Coin?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

-(IBAction)countryButton:(id)sender{
    
    switch (self.option) {
            
        case COIN_INFO:
            break;
            
        default:
            [self performSegueWithIdentifier:@"CountrySelectSegue" sender:self];
            break;
    }
}

-(IBAction)DeleteImageButton:(id)sender{
    
    self.coinImage = nil;
    [self.coinImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NO_IMAGE_FILE ofType:PNG]]];
    
    [self.imageDeleteButton setHidden:YES];
    
    [self reloadInputViews];
}


-(IBAction)DeleteTemplateButton:(id)sender{
    
    self.templateImage = nil;
    [self.templateImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NO_IMAGE_FILE ofType:PNG]]];
    
    [self.templateDeleteButton setHidden:YES];
    [self.samplesButton setHidden:YES];
    [self.samplesDetails setHidden:YES];
    
    [self reloadInputViews];
}


//---------------------------------------------------------------------------
//---------------------------- UIAlertViewDelegate --------------------------
//---------------------------------------------------------------------------

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if ( buttonIndex == 1 ) {
        
        NSMutableArray *coinsList = [self loadCoinsList];
        [self deleteCoin:coinsList name:self.coin.name];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//---------------------------------------------------------------------------
//---------------------------- UITextFieldDelegate --------------------------
//---------------------------------------------------------------------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.tapGesture.enabled = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.tapGesture.enabled = NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.option == COIN_INFO)  return NO;
    else  return YES;
}
//---------------------------------------------------------------------------
//---------------------------- UIImagePickerControllerDelegate --------------
//---------------------------------------------------------------------------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *capturedImage = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    
    if (coinImagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImage *image2save = [UIImage imageWithCGImage:capturedImage.CGImage];
        UIImageWriteToSavedPhotosAlbum(image2save, nil, nil, nil);
        
        if ([[self getSetting:nil name:CROP] integerValue] == CROP_AUTO) {

            CGSize size = capturedImage.size;
            capturedImage = [self cropImage:capturedImage point:CGSizeMake(size.width/4, (size.height/2) - (size.width/4)) size:CGSizeMake(size.width/2, size.width/2)];
            
        }
    }
    if (imageOption == OPTION_TEMPLATE)  capturedImage = [self rgb2bw:capturedImage];
    
    if (imageOption == OPTION_COIN) {
        
        capturedImage = [self resize:capturedImage size:CGSizeMake(COINS_IMAGE_SIZE, COINS_IMAGE_SIZE)];
        self.coinImage = capturedImage;
        [self.coinImageView setImage:capturedImage];
        [self.imageDeleteButton setHidden:NO];
    }
    else {
        
        capturedImage = [self resize:capturedImage size:CGSizeMake(TEMPLATE_MAX, TEMPLATE_MAX)];
        self.templateImage = capturedImage;
        [self.templateImageView setImage:capturedImage];
        [self.samplesButton setHidden:YES];
        [self.samplesDetails setHidden:YES];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    self.coinImagePicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
    [self dismissModalViewControllerAnimated:YES];
}


@end
