//
//  NSObject+ImageProccessing.m
//  Coins
//
//  Created by Panos Kalodimas on 1/10/13.
//
//

#import "NSObject+ImageProccessing.h"

@implementation NSObject (ImageProccessing)


-(NSMutableArray*)correlateFrame:(UIImage*)mainImage withSamples:(NSMutableArray *)samples point:(POINTS)point{
    
    if (!mainImage || !samples || samples.count == 0)  return [NSMutableArray array];

    int sampleWidth = [[[samples objectAtIndex:0] valueForKey:WIDTH] integerValue];
    int sampleHeight = [[[samples objectAtIndex:0] valueForKey:HEIGHT] integerValue];
    int sampleSize = sampleWidth*sampleHeight;
    int imageWidth = (int)mainImage.size.width;
    int imageHeight = (int)mainImage.size.height;
    
    if (imageWidth < sampleWidth || imageHeight < sampleHeight)  return [NSMutableArray array];
    
    float sampleDeviation = 0.01;
    float *sampleCorrelation = nil;
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(mainImage.CGImage));
    uint8_t *imagePixels = (uint8_t*) CFDataGetBytePtr(data);
    
    float imageMean = 0;
    float imageDeviation = 0;
	float imageCorrelation[sampleSize];
    float correlation = 0;
    NSMutableArray *correlations = [NSMutableArray array];
	
    //Calculate frame mean
	for (int i=point.y*imageWidth; i<(point.y+sampleHeight)*imageWidth; i+=imageWidth) {
        
        for (int j=point.x; j<sampleWidth+point.x; j++)  imageMean += imagePixels[i+j];
    }
    imageMean /= sampleSize;
    
    //Calculate Image Correlation and deviation
    int p = 0;
    for (int i=point.y*imageWidth; i<(point.y+sampleHeight)*imageWidth; i+=imageWidth) {
        
        for (int j=point.x; j<sampleWidth+point.x; j++, p++) {
            
            imageCorrelation[p] = ((float)imagePixels[i+j] - imageMean);
            imageDeviation += (imageCorrelation[p]*imageCorrelation[p]);
        }
    }
    
    if (imageDeviation == 0)  imageDeviation = 0.01;
    
    for (int i = 0; i<samples.count; i++) {
        
        sampleDeviation = [[[samples objectAtIndex:i] valueForKey:DEVIATION] floatValue];
        sampleCorrelation = (float*)[[[samples objectAtIndex:i] valueForKey:CORRELATION] bytes];
        
        for (int j=0; j<sampleSize; j++)  correlation += (imageCorrelation[j]*sampleCorrelation[j]);
        
        if (sampleDeviation == 0)  sampleDeviation = 0.01;
        correlation /= sqrt(imageDeviation*sampleDeviation);
        correlation = (correlation+1)*50;

        [correlations addObject:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithFloat:correlation] forKey:CORRELATION]];
        
        correlation = 0;
        sampleCorrelation = nil;
    }
    CFRelease(data);
    imagePixels = nil;
	
    return correlations;
}


-(NSMutableArray*)correlateTile:(UIImage*)mainImage withSamples:(NSMutableArray*)samples{
    
    if (!mainImage || !samples || samples.count == 0)  return [NSMutableArray array];

    int sampleWidth = [[[samples objectAtIndex:0] valueForKey:WIDTH] integerValue];
    int sampleHeight = [[[samples objectAtIndex:0] valueForKey:HEIGHT] integerValue];
    
    int imageWidth = mainImage.size.width;
    int imageHeight = mainImage.size.height;
    
    NSMutableArray *correlations = [NSMutableArray array];
    NSMutableArray *tempcor = nil;
    
    for (int i=0; i<=imageHeight-sampleHeight; i++) {
        
        for (int j=0; j<=imageWidth-sampleWidth; j++) {
            
            tempcor = [self correlateFrame:mainImage withSamples:samples point:(POINTS){j,i}];
            if ( correlations.count == 0 )  correlations = tempcor;
            for (int c=0; c<correlations.count; c++) {
                
                if ([[[correlations objectAtIndex:c] valueForKey:CORRELATION] floatValue] <= [[[tempcor objectAtIndex:c] valueForKey:CORRELATION] floatValue]) {
                    
                    [[correlations objectAtIndex:c] setValue:[[tempcor objectAtIndex:c] valueForKey:CORRELATION] forKey:CORRELATION];
                    //[[correlations objectAtIndex:c] setValue:[NSNumber numberWithInt:j] forKey:DIM_X];
                    //[[correlations objectAtIndex:c] setValue:[NSNumber numberWithInt:i] forKey:DIM_Y];
                }
            }
        }
    }
    tempcor = nil;
    return  correlations;
}

-(NSMutableArray*)correlateRotate:(UIImage*)mainImage tile:(POINTS)tile withSamples:(NSMutableArray*)samples{
    
    if (!mainImage || [samples count] == 0) return [NSMutableArray array];
    
    NSMutableDictionary *settings = [self loadSettings];
    int depthSize = [[self getSetting:settings name:SAMPLE] integerValue];
    int padding = [[self getSetting:settings name:PADDING] integerValue];
    int angle = [[self getSetting:settings name:ANGLE] integerValue];
    int step = [[self getSetting:settings name:STEP] integerValue];
    
    int imageWidth = 0;
    int imageHeight = 0;
    
    POINTS coordinates = {0,0};
    int tileSize = depthSize + (2*padding);
    UIImage *rotatedImage = nil;
    NSMutableArray *correlations = [NSMutableArray array];
    NSMutableArray *tempcor = nil;
        
    for (int a=360-angle; a<=360+angle; a+=step) {
        
        rotatedImage = [self rgb2bw:[self rotate:mainImage angle:a]];
        imageWidth = (int)rotatedImage.size.width;
        imageHeight = (int)rotatedImage.size.height;
        coordinates.x = (imageWidth/2) + (depthSize*tile.x) - (depthSize/2) - padding;
        coordinates.y = (imageHeight/2) + (depthSize*tile.y) - (depthSize/2) - padding;
        
        if (coordinates.x < 0 || coordinates.y < 0) return [NSMutableArray array];
        
        rotatedImage = [self cropImage:rotatedImage point:CGSizeMake(coordinates.x,coordinates.y) size:CGSizeMake(tileSize, tileSize)];
        correlations = [self correlateTile:rotatedImage withSamples:samples];

        for (int c=0; c<correlations.count; c++) {
            
            if (!tempcor || [[[correlations objectAtIndex:c] valueForKey:CORRELATION] floatValue] >= [[[tempcor objectAtIndex:c] valueForKey:CORRELATION] floatValue]) {
                
                [[correlations objectAtIndex:c] setValue:[NSNumber numberWithInt:a-360] forKey:ANGLE];
            }
            else {
                
                [[correlations objectAtIndex:c] setValue:[[tempcor objectAtIndex:c] valueForKey:CORRELATION] forKey:CORRELATION];
                [[correlations objectAtIndex:c] setValue:[[tempcor objectAtIndex:c] valueForKey:ANGLE] forKey:ANGLE];
            }
        }
        tempcor = correlations;
    }
    rotatedImage = nil;
    tempcor = nil;
    return  correlations;
}

-(NSMutableArray*)correlateImage:(UIImage*)image withCoins:(NSMutableArray *)coinsData {

    if (!image || !coinsData || coinsData.count == 0) return [NSMutableArray array];
    
    NSMutableDictionary *settings = [self loadSettings];
    int depth = [[self getSetting:settings name:DEPTH] integerValue];
    float accurancy = (float) [[self getSetting:settings name:ACCURACY] integerValue] / 100;
    int template = [[self getSetting:settings name:TEMPLATE] integerValue];
    
    NSMutableArray *correlations = [NSMutableArray array];
    float maxCor = 0;
    int sampleNum = -1;
    NSMutableArray *samples = [NSMutableArray array];
    NSMutableArray *history = [NSMutableArray array];
    NSTimeInterval counter = [NSDate timeIntervalSinceReferenceDate];
    NSMutableArray *stageCounter = [NSMutableArray array];
    UIImage* mainImage = [self resize:image size:CGSizeMake(template, template)];
    
    //Arxikopoihsh tou history me total correlation gia ka8e sample = 0
    [history addObject:correlations];
    for (int i=0; i<coinsData.count; i++)  [[history lastObject] addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0], TOTAL_COR, nil]];
    
    //Perihghsh sta samples
    for (int d=0; d<depth && coinsData.count>0; d++) {
        
        for (int i=-d; i<=d && coinsData.count>0; i++) {
            
            for (int j=-d; j<=d && coinsData.count>0; j++) {
                
                //Elegxei wste na pernei ta tiles me thn seira
                if ( d-abs(i) == 0 || d-abs(j) == 0 ) {
                    
                    sampleNum++;
                    maxCor = 0;
                    [samples removeAllObjects];
                    
                    //Eisagwgh twn samples twn coins pou exoun prokri8ei
                    for (int s=0; s<coinsData.count; s++)  [samples addObject:[[[coinsData objectAtIndex:s] samples] objectAtIndex:sampleNum]];
                    
                    //Ypologizei to correlation olwn samples sto sugkekrimeno tile upo oles tis gwnies
                    correlations = [self correlateRotate:mainImage tile:(POINTS){j,i} withSamples:samples];
                                        
                    for (int s=0; s<correlations.count; s++) {

                        //Pros8etei sto dictionary to onoma kai th xwra tou nomismatos
                        [[correlations objectAtIndex:s] setValue:[[coinsData objectAtIndex:s] name] forKey:NAME];
                        [[correlations objectAtIndex:s] setValue:[[coinsData objectAtIndex:s] country] forKey:COUNTRY];

                        //Briskei to megisto correlation
                        if (maxCor < [[[correlations objectAtIndex:s] valueForKey:CORRELATION] floatValue])  maxCor = [[[correlations objectAtIndex:s] valueForKey:CORRELATION] floatValue];
                        
                        //Pros8etei to total correlation se ka8e nomisma
                        [[correlations objectAtIndex:s] setValue:[NSNumber numberWithFloat:([[[[history lastObject] objectAtIndex:s] valueForKey:TOTAL_COR] floatValue] + [[[correlations objectAtIndex:s] valueForKey:CORRELATION] floatValue])]
                                                                                forKey:TOTAL_COR];
                    }
                    //Antikatastash me tis ananewmenes times afou xrhsimopoihse to total correlation
                    [[history lastObject] removeAllObjects];
                    [history removeLastObject];
                    [history addObject:[NSMutableArray arrayWithArray:correlations]];
                    
                    //Afairei ta samples me mikro correlation se sxesh me to megalutero
                    if (accurancy == 0) [history addObject:[NSMutableArray arrayWithArray:correlations]];
                    else {
                    
                        maxCor *= accurancy;
                        for (int s=0; s<correlations.count; s++) {
                        
                            if (maxCor > [[[correlations objectAtIndex:s] valueForKey:CORRELATION] floatValue]) {
                            
                                [coinsData removeObjectAtIndex:s];
                                [correlations removeObjectAtIndex:s];
                                s--;
                            }
                        }
                        [history addObject:[NSMutableArray arrayWithArray:correlations]];
                        if (coinsData.count == 1) [coinsData removeAllObjects];
                    }                    
                    //Counters
                    [stageCounter addObject:[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate] - counter]];
                    counter = [NSDate timeIntervalSinceReferenceDate];
                }//
            }
        }
    }
    correlations = [NSMutableArray array];
    for (int s=0; s<[[history lastObject] count]; s++) {
        [correlations addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [[[history lastObject] objectAtIndex:s] valueForKey:NAME], NAME,
                                     [[[history lastObject] objectAtIndex:s] valueForKey:COUNTRY], COUNTRY,
                                     [[[history lastObject] objectAtIndex:s] valueForKey:ANGLE], ANGLE,
                                     [NSNumber numberWithFloat:([[[[history lastObject] objectAtIndex:s] valueForKey:TOTAL_COR] floatValue]/(sampleNum+1))], CORRELATION,
                                      nil]];
    }
    [history removeLastObject];
    [history addObject:[NSMutableArray arrayWithArray:correlations]];

    if (correlations.count > 1) {
        
        maxCor = [[[correlations objectAtIndex:0] valueForKey:CORRELATION] floatValue];
        [history addObject:[NSMutableArray arrayWithObjects:[correlations objectAtIndex:0], nil]];

        for (int s=1; s<correlations.count; s++) {
            
            if (maxCor < [[[correlations objectAtIndex:s] valueForKey:CORRELATION] floatValue]) {

                maxCor = [[[correlations objectAtIndex:s] valueForKey:CORRELATION] floatValue];
                [[history lastObject] removeLastObject];
                [[history lastObject] addObject:[correlations objectAtIndex:s]];
            }
        }
    }
    [history addObject:stageCounter];

    settings = nil;
    correlations = nil;
    coinsData = nil;
    stageCounter = nil;
    samples = nil;

    return history;
}

/*
-(CGImageRef)createResultMask:(CGImageRef)image points:(NSArray *)points{
    
    int imageWidth = CGImageGetWidth(image);
    int imageHeight = CGImageGetHeight(image);
    int x = 0;
    int y = 0;
    int sampleWidth = 0;
    int sampleHeight = 0;
    
    uint8_t *maskPixels = malloc(imageHeight*imageWidth*sizeof(uint8_t));
    
    for (int i=0; i<imageWidth*imageHeight; i++)  maskPixels[i] = 100;
    
    
    for (int i=0; i<points.count; i++) {
        
        x = [[[points objectAtIndex:i] valueForKey:DIM_X] intValue];
        y = [[[points objectAtIndex:i]  valueForKey:DIM_Y] intValue];
        sampleWidth = [[[[points objectAtIndex:i] valueForKey:SAMPLE] valueForKey:WIDTH] intValue];
        sampleHeight = [[[[points objectAtIndex:i] valueForKey:SAMPLE] valueForKey:HEIGHT] intValue];
        
        for (int h=y; h<y+sampleHeight; h++) {
            
            for (int w=x; w<x+sampleWidth; w++)  maskPixels[h*imageWidth+w] = 254;
        }
    }
    
    CGContextRef canvas = CGBitmapContextCreate(maskPixels, imageWidth, imageHeight, 8, imageWidth, CGColorSpaceCreateDeviceGray(), kCGBitmapByteOrderDefault);
    CGImageRef mask = CGBitmapContextCreateImage(canvas);
    
    return mask;
}
*/

-(UIImage*)rgb2bw:(UIImage*)image{
    
    if (!image) return nil;
    
    int bytesPerPixel = CGImageGetBitsPerPixel(image.CGImage) / 8;
    if (bytesPerPixel == 1)  return image;

    size_t imageWidth = image.size.width;
    size_t imageHeight = image.size.height;
    int imageSize = imageWidth*imageHeight;
    CFDataRef data =  CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    uint8_t *bwpixels = malloc(imageSize);
    uint8_t *pixels = (uint8_t*)CFDataGetBytePtr(data);
    
    imageSize *= bytesPerPixel;
    
    for (int i=0; i<imageSize; i+=bytesPerPixel) {
        
        bwpixels[i/bytesPerPixel] = (uint8_t) ((pixels[i] + pixels[i+1] + pixels[i+2]) / 3);
    }
    
    CGColorSpaceRef color = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate( (void*) bwpixels, imageWidth, imageHeight, 8, imageWidth, color, kCGBitmapByteOrderDefault);
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    UIImage *bwimage = [UIImage imageWithCGImage:cgimage];
    
    CGColorSpaceRelease(color);
    CGContextRelease(context);
    CFRelease(data);
    CGImageRelease(cgimage);
    
    free(bwpixels);
    bwpixels = nil;
    pixels = nil;
    
	return bwimage;
}

-(UIImage*)cropImage:(UIImage*)image point:(CGSize)point size:(CGSize)size{
    
    if (!image) return nil;

    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    int bytesperpixel = CGImageGetBitsPerPixel(image.CGImage)/8;

    if (imageHeight < point.height+size.height || imageWidth < point.width+size.width)  return nil;

    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    uint8_t *imagePixels = (uint8_t*)CFDataGetBytePtr(data);
    
    int newSize = size.width*size.height*bytesperpixel;
    uint8_t *pixels = malloc(newSize);
    
    int k = 0;
    for (int i = (int)(imageWidth*point.height + point.width)*bytesperpixel; i < imageWidth*(point.height+size.height)*bytesperpixel; i+=(imageWidth*bytesperpixel)) {
        
        for (int j = 0; j < size.width*bytesperpixel; j++) {
            
            pixels[k] = imagePixels[i+j];
            k++;
            if (k >= newSize)  break;
        }
    }
    
    CGBitmapInfo info = CGImageGetBitmapInfo(image.CGImage);
    CGColorSpaceRef color = CGImageGetColorSpace(image.CGImage);
    
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 (size_t)size.width,
                                                 (size_t)size.height,
                                                 8,
                                                 (size_t)size.width*bytesperpixel,
                                                 color,
                                                 info);
    
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    UIImage *croppedImage = [UIImage imageWithCGImage:cgimage];
    
    CGContextRelease(context);
    CFRelease(data);
    CGImageRelease(cgimage);
    
    free(pixels);
    pixels = nil;
    imagePixels = nil;
    
    return  croppedImage;
}


-(UIImage*)resize:(UIImage*)image size:(CGSize)size{
    
    if (!image) return nil;
    
    size_t bytesperpixel = CGImageGetBitsPerPixel(image.CGImage) / 8;
    CGBitmapInfo info = CGImageGetBitmapInfo(image.CGImage);
    CGColorSpaceRef color = CGImageGetColorSpace(image.CGImage);
    
    void *pixels = malloc((int)size.width*size.height*bytesperpixel);
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 (size_t)size.width,
                                                 (size_t)size.height,
                                                 8,
                                                 (size_t)size.width*bytesperpixel,
                                                 color,
                                                 info);
    CGRect rect = CGRectMake(0,0,size.width,size.height);
    CGContextDrawImage (context,rect,image.CGImage);
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    UIImage *resizedImage = [UIImage imageWithCGImage:cgimage];
    
    CGContextRelease(context);
    CGImageRelease(cgimage);
    
    free(pixels);
    pixels = nil;
    
    return resizedImage;
}


-(UIImage*)rotate:(UIImage*)image angle:(uint)angle{
    
    if (!image) return nil;
    
    CGBitmapInfo info = CGImageGetBitmapInfo(image.CGImage);
    CGColorSpaceRef color = CGImageGetColorSpace(image.CGImage);
    
    CGFloat angleInRadians = angle * (M_PI / 180);
	CGFloat width = image.size.width;
	CGFloat height = image.size.height;
	
	CGRect imgRect = CGRectMake(0, 0, width, height);
	CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
	CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
	CGContextRef context = CGBitmapContextCreate(NULL,
                                                rotatedRect.size.width,
                                                rotatedRect.size.height,
                                                8,
                                                0,
                                                color,
                                                info);
	CGContextSetAllowsAntialiasing(context, NO);
	CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
	CGContextTranslateCTM(context, +(rotatedRect.size.width/2), +(rotatedRect.size.height/2));
	CGContextRotateCTM(context, angleInRadians);
	CGContextDrawImage(context, CGRectMake(-width/2, -height/2, width, height), image.CGImage);
	
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    UIImage *rotatedImage = [self resize:[UIImage imageWithCGImage:cgimage] size:CGSizeMake(width, height)];    
    
    CGImageRelease(cgimage);
	CFRelease(context);
    
    return rotatedImage;
}

@end
