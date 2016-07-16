//
//  MainViewController.m
//  Coins
//
//  Created by Panos Kalodimas on 3/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoinsMainViewController.h"

@interface CoinsMainViewController ()

@end

@implementation CoinsMainViewController

@synthesize imageView;
@synthesize coinImage;
@synthesize recognizeButton;
@synthesize imagePicker;
@synthesize busy;
@synthesize correlationResults;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.imagePicker = nil;
    self.correlationResults = nil;
    self.busy.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (!self.coinImage)  self.recognizeButton.enabled = NO;
    else  self.recognizeButton.enabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.busy stopAnimating];
}

//---------------------------------------------------------------------------
//---------------------------- My Functions ---------------------------------
//---------------------------------------------------------------------------

-(IBAction)CameraButton:(id)sender {

    if (!self.imagePicker) self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
        // Gia Kamera
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        CoinsImagePickerController *imageOverlayPicker = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagePicker"];
        UIButton *photoAlbumButton = [imageOverlayPicker.view.subviews objectAtIndex:0];
        [photoAlbumButton addTarget:self action:@selector(PhotoAlbumButton) forControlEvents:UIControlEventTouchUpInside];

        if ([[self getSetting:nil name:CROP] integerValue] == CROP_AUTO) {
        
            self.imagePicker.cameraOverlayView = imageOverlayPicker.view;
        }
        else  [self.imagePicker.view addSubview:photoAlbumButton];
    }
    else  self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:self.imagePicker animated:YES];
}

-(void)PhotoAlbumButton{

    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

-(IBAction)RecognizeButton:(id)sender{
    
    NSMutableArray *coinsData = [self loadCoinsDataNoImages:YES];
    if (!coinsData) [self errorMessage:@"Internal Error!" message:@"Unable to read coins data!"];
    if (coinsData.count < 1) [self errorMessage:@"Error!" message:@"There are 0 active coins to recognize with!"];
    else {

        [[[NSThread alloc] initWithTarget:self.busy selector:@selector(startAnimating) object:nil] start];

        self.correlationResults = [self correlateImage:self.coinImage withCoins:coinsData];
        if (self.correlationResults && self.correlationResults.count > 0)
            [self performSegueWithIdentifier:@"CorrelationResultsSegue" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ( [segue.identifier isEqualToString:@"CorrelationResultsSegue"] ) {
                
        ImageProccesserViewController *vc = segue.destinationViewController;
        vc.history = self.correlationResults;
        vc.image2proccess = [self rgb2bw:self.coinImage];
        self.correlationResults = nil;
        [self.busy stopAnimating];
    }
}


//---------------------------------------------------------------------------
//---------------------------- UIImagePickerControllerDelegate --------------
//---------------------------------------------------------------------------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.coinImage = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum([UIImage imageWithCGImage:self.coinImage.CGImage], nil, nil, nil);
        
        if ([[self getSetting:nil name:CROP] integerValue] == CROP_AUTO) {

            self.coinImage = [self cropImage:self.coinImage
                                           point:CGSizeMake(self.coinImage.size.width/4, (self.coinImage.size.height/2) - (self.coinImage.size.width/4))
                                            size:CGSizeMake(self.coinImage.size.width/2, self.coinImage.size.width/2)];
        }
    }
    
    [self.imageView setImage:self.coinImage];
    [self dismissModalViewControllerAnimated:YES];
    self.imagePicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
    [self dismissModalViewControllerAnimated:YES];
    self.imagePicker = nil;
}


@end
