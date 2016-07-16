//
//  Coin.m
//  Coins
//
//  Created by IPhone on 3/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Coin.h"


@implementation Coin

@synthesize name;
@synthesize country;
@synthesize samples;
@synthesize image;
@synthesize templateImage;


//---------------------------------------------------------------------------
//----------------------------- Init Methods --------------------------------
//---------------------------------------------------------------------------

-(id)init{
    
    self = [super init];
    //καλεί την υπερκλάσση
	
    self.name = [NSString string];
	//self.name = new class String
    self.country = N_A;
    self.samples = [NSMutableArray array];
	//self.samples = new class Array
    self.image = nil;	//nil == NULL
	//self.image = NULL
    self.templateImage = nil;
    
    return self;
}

-(id)initFromFile:(NSString *)filePath{
    
    self = [self init];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    //Dictionary *data = new class Dictionary;
	//data.dictionaryWithContentsOfFile(filepath);
	//Παίρνει δεδομένα από το αρχείο στην θέση filepath
	
    if( !data ) return nil;
    
    return [self initFromDictionary:data];
	//return self.initFromDictionary(data);
}

-(id)initFromFileOnlyData:(NSString *)filePath{
    
    self = [self init];

    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    //Dictionary *data = new class Dictionary;
	//data.dictionaryWithContentsOfFile(filepath);
	//Παίρνει δεδομένα από το αρχείο στην θέση filepath
	
    if( !data ) return nil;
    
    return [self initFromDictionaryOnlyData:data];
	//return self.initFromDictionary(data);
}

-(id)initFromDictionary:(NSMutableDictionary*)data{
    
    self = [self init];
    
    if( !data ) return nil;

    NSDictionary *theImage = [data valueForKey:IMAGE];
	//dictionary *the image = data.valueForKey("image");
    NSDictionary *theTemplate = [data valueForKey:TEMPLATE];
	//dictionary *theTemplate = data.valueForKey("template");
            
    self.name = [data valueForKey:NAME];
	//self.name = data.valueforkey("name");
    self.country = [data valueForKey:COUNTRY];
    self.samples = [NSMutableArray arrayWithArray:[data valueForKey:SAMPLES]];  
	//self.samples = new class Array;
	//self.samples.copyelementsfromArray(data.vlaueForKey("smaples"));
	//Ο πίνακας samples παίρνει τα αντικείμενα του πίνακα που βρίκσεται μέσα στο dictionaty data με key "samples"
	
    if (!self.name || [self.name length] < 1) return nil;
	//[self.name length] = self.name.length() //getter
    
    const void *pixels = [[theImage valueForKey:DATA] bytes];
	//void *pixels = theImage.valueForKey("data").bytes
	//Το pixels σαν δείκτης δείχνει στα δεδομένα (bytes) της εικόνας
	
    if (pixels) {
    
        size_t width = [[theImage valueForKey:WIDTH] unsignedIntegerValue];
        size_t height = [[theImage valueForKey:HEIGHT] unsignedIntegerValue];
        int bytesPerPixel = (int) [[theImage valueForKey:DATA] length] / (width*height);
        CGColorSpaceRef color = (bytesPerPixel == 1)? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmap = (bytesPerPixel == 1)? kCGBitmapByteOrderDefault : kCGImageAlphaNoneSkipLast;
        
        CGContextRef context = CGBitmapContextCreate( (void*) pixels, width, height, 8, bytesPerPixel*width, color, bitmap );
        
        CGImageRef cgimage = CGBitmapContextCreateImage(context);
        self.image = [[UIImage alloc] initWithCGImage:cgimage];
        
        CGImageRelease(cgimage);
        CGColorSpaceRelease(color);
        CGContextRelease(context);
        pixels = nil;
    }
	//Δημιουργεί αντικείμενο Image από τα pixels για την εικόνα.
        
    pixels = [[theTemplate valueForKey:DATA] bytes];
    if (pixels) {
        
        size_t width = [[theTemplate valueForKey:WIDTH] unsignedIntegerValue];
        size_t height = [[theTemplate valueForKey:HEIGHT] unsignedIntegerValue];
        CGColorSpaceRef color = CGColorSpaceCreateDeviceGray();
        
        CGContextRef context = CGBitmapContextCreate( (void*) pixels, width, height, 8, width,color, kCGBitmapByteOrderDefault );
        CGImageRef cgimage = CGBitmapContextCreateImage(context);
        self.templateImage = [[UIImage  alloc] initWithCGImage:cgimage];
    
        CGImageRelease(cgimage);
        CGColorSpaceRelease(color);
        CGContextRelease(context);
        pixels = nil;
    }
	//Δημιουργεί αντικείμενο Image από τα pixels για το template.
    
    return self;
}

-(id)initFromDictionaryOnlyData:(NSMutableDictionary *)data{
    
    self = [self init];
            
    if( !data ) return nil;
    
    self.name = [data valueForKey:NAME];
    self.country = [data valueForKey:COUNTRY];
    self.samples = [NSMutableArray arrayWithArray:[data valueForKey:SAMPLES]];
    for (int i=0; i<self.samples.count; i++)
        [[self.samples objectAtIndex:i] removeObjectForKey:DATA];
    
    if (!self.name || [self.name length] < 1) return nil;

    return self;
}

-(id)initWithInfo:(NSString*)Name countryName:(NSString*)Country{
	
    self = [self init];

    if (!Name)  return nil;
    if ( ![[Name stringByReplacingOccurrencesOfString:SPACE_CHAR withString:EMPTY_CHAR] length] )  return nil;
    //ελέγχει αν είναι το όνομα μόνο κενά
	
	self.name = Name;
	self.country = (Country)? Country : N_A;
	//if( Country ) self.country = Country; else self.country = "N/A"
	
	return self;
}

//---------------------------------------------------------------------------
//----------------------------- Template Methods ----------------------------
//---------------------------------------------------------------------------

-(NSMutableDictionary*)createSample:(int)Width Height:(int)Height Data:(NSData*)Data{
    
    if ( !Data || !Height || !Width) return nil;
    
    int size = Height*Width;
	float mean = 0;		//Μεσος όρος
	float deviation = 0;	//Διασπορά
    float correlation[size];

    if ( [Data length] >= size) {
	//Data.length()
    
        uint8_t *pixels = (uint8_t*)[Data bytes];
		//To pixels δείχνει στα pixels της εικόνας
	
        for(int i=0; i<size; i++)  mean += pixels[i];
        mean /= size;

        for(int i=0; i<size; i++) {
            
            correlation[i] = ((float)pixels[i] - mean);
            deviation += (correlation[i]*correlation[i]);
        }
    
        NSMutableDictionary *newSample =  [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithUnsignedInt:Width], WIDTH,
                                           [NSNumber numberWithUnsignedInt:Height], HEIGHT,
                                           [NSNumber numberWithFloat:mean], MEAN,
                                           [NSNumber numberWithFloat:deviation], DEVIATION,
                                           [NSData dataWithBytes:correlation length:sizeof(correlation)], CORRELATION,
                                           Data, DATA, nil];
		//Καταχωρεί τιμές στο dictionary newSample. πρώτα πάει η τιμή και μετα (με κεφαλαία) το κλειδί
		
        pixels = nil;
        return newSample;
    }
    return nil;
}

-(void)addSample:(NSMutableDictionary *)sample{
    
    if (sample) [self.samples addObject:sample];
	//self.samples.addObject(sample);
}

-(void)addSampleFromImage:(UIImage*)sampleImage{
    
    switch (CGImageGetBitsPerPixel(sampleImage.CGImage)) {
        case 8: {
            [self addSampleFromBWImage:sampleImage];
            break;
        }
        case 32:{
            [self addSampleFromRGBImage:sampleImage];
            break;
        }
        case 24:{
            [self addSampleFromRGBImage:sampleImage];
        }
        default:
            break;
    }
}

-(void)addSampleFromBWImage:(UIImage*)sampleImage{
	
    if (sampleImage) {
    
        size_t width  = sampleImage.size.width;
        size_t height = sampleImage.size.height;
        CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(sampleImage.CGImage));
		//Παίνρει ένα αντικείμενο τύπου Data από την εικόνα. Το αντικείμενο αυτό έχει πρόσβαση στα pixels της εικόνα, Data.bytes()
    
        NSMutableDictionary *sample = [self createSample:(int)width Height:(int)height Data:(__bridge NSData*)data];
        if (sample) [self addSample:sample];
    
        if (data) CFRelease(data);
		//free(data);
        data = nil;
    }
}

-(void)addSampleFromRGBImage:(UIImage*)sampleImage{
    
    if (sampleImage){
        
        UIImage *bwimage = [self rgb2bw:sampleImage];
        [self addSampleFromBWImage:bwimage];
    }
}

-(void)deleteSample:(NSUInteger)sampleIndex{
    
    if (sampleIndex > -1 && sampleIndex < self.samples.count )
        [self.samples removeObjectAtIndex:sampleIndex];
		//self.samples.removeObjectAtIndex(sampleIndex);
}


-(Boolean)saveCoinData{
	
	NSString *filepath = [[[DOCUMENTS_COINS stringByExpandingTildeInPath] stringByAppendingPathComponent:self.name] stringByAppendingPathExtension:PLIST];
	//Δημιουργεί ένα filepath που δείχνει σε ένα αρχείο .plist μέσα στο φάκελο του application
	
    CFDataRef data = data = CGDataProviderCopyData(CGImageGetDataProvider(self.image.CGImage));
    NSDictionary *imageDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:(uint)self.image.size.width], WIDTH,
                                                                         [NSNumber numberWithUnsignedInt:(uint)self.image.size.height], HEIGHT,
                                                                         (__bridge NSData*)data, DATA, nil];
	//δημιουργεί ένα dictionary με τιμές μήκος, πλάτος και δεδομένα της εικόνας (image)
																		 
    if (data) CFRelease(data);
    
    data = CGDataProviderCopyData(CGImageGetDataProvider(self.templateImage.CGImage));
    NSDictionary *templateDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:(uint)self.templateImage.size.width], WIDTH,
                                                                            [NSNumber numberWithUnsignedInt:(uint)self.templateImage.size.height], HEIGHT,
                                                                            (__bridge NSData*)data, DATA, nil];
    //δημιουργεί ένα dictionary με τιμές μήκος, πλάτος και δεδομένα της εικόνας (templateImage)
	
	if (data) CFRelease(data);
	
    NSDictionary *coin = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.name, NAME, 
                                        self.country, COUNTRY,
                                        self.samples, SAMPLES,
                                        imageDict, IMAGE,
                                        templateDict, TEMPLATE, nil];
    //δημιουργεί ένα dictionary με τις υπόλοιπες τιμές του αντικείμενου coin
    
	return [coin writeToFile:filepath atomically:YES];
	//return coin.writeToFile(filepath);
}

-(UIImage*)getSampleImage:(NSMutableDictionary*)sample{
    
    if (!sample) return nil;
    //Αυτή η συνάρτηση δημιουργεί ένα αντικείμενο Image από τα δεδομένα του dictionary sample
	//που είναι το μήκος, το πλάτος και τα pixels
	
    const void *data = [[sample valueForKey:DATA] bytes];
    size_t width = [[sample valueForKey:WIDTH] unsignedIntegerValue];
    size_t height = [[sample valueForKey:HEIGHT] unsignedIntegerValue];
    CGColorSpaceRef color = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate( (void*) data, width, height, 8, width, color, kCGBitmapByteOrderDefault );
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	   
    UIImage *sampleImage = [[UIImage alloc] initWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(color);
    
    return sampleImage;
}


-(NSMutableArray*)getSamplesImages{
    
	//Η συνάρτηση αυτή κάνει το ίδιο αλλά για όλα τα samples του Coin
	
    NSMutableArray *imageArray = [NSMutableArray array];
    UIImage *sampleImage = nil;
    
    for (int i=0; i<self.samples.count; i++) {
        
        sampleImage = [self getSampleImage:[self.samples objectAtIndex:i]];
        if (sampleImage) [imageArray addObject:sampleImage];
    }
    return imageArray;
}


-(id)copyWithZone:(NSZone *)zone{
	
    Coin *clone = [Coin alloc];
    clone.name = [NSString stringWithString:self.name];
    clone.country = [NSString stringWithString:self.country];
    clone.samples = [NSMutableArray arrayWithArray:self.samples];
    clone.image = [UIImage imageWithCGImage:self.image.CGImage];
    clone.templateImage = [UIImage imageWithCGImage:self.templateImage.CGImage];
    
    for (int i=0; i<self.samples.count; i++) {
        
        [[clone.samples objectAtIndex:i] setValue:[NSMutableArray arrayWithArray:[[self.samples objectAtIndex:i] valueForKey:SAMPLES] ] forKey:SAMPLES];
    }
    return  clone;
}

-(Boolean)createTemplateSamples:(int)templateSize depth:(int)depth depthSize:(int)depthSize{
    
	//Η συνάρτηση αυτή φτιάχνει smaples από το templateImage. Το depthSize ορίζει το μέγεθος του κάθε δείγματος
	//πχ 20χ20 ή 30χ30. Το depth ορίζει το "βάθος". Δηλαδή αν είναι 1 τότε θα έχουμε ένα δείγμα στο κέντρο του κέρματος.
	//Αν είναι 2 τότε θα έχουμε επιπλέον 8 δείγματα γύρω-γύρω από το κέντρο (σύνολο 9). Για 3 πάμε στα 25 δείγματα σύνολο.
	//Το tmplateSize ορίζει το μέγεθος που θα πρέπει να έχει το templateImage.
	
    if (!self.templateImage) return YES;
    
    UIImage *tempImage = [self resize:self.templateImage size:CGSizeMake(templateSize, templateSize)];
	//Αλλάζει το μέγεθος του templateImage σύμφωνα με το templateSize
    tempImage = [self rgb2bw:tempImage];
	//Kάνει το templateImage ασπρόμαυρη εικόνα
    UIImage *tileImage = nil;
    
    int imageWidth = tempImage.size.width;
    int imageHeight = tempImage.size.height;
    POINTS coordinates = {0,0};
    
    coordinates.x = imageWidth - (2*depth-1)*depthSize;
    coordinates.y = imageHeight - (2*depth-1)*depthSize;
    
    if (coordinates.x < 0 || coordinates.y < 0)  return NO;
    
    for (int d=0; d<depth; d++) {
            
        for (int i=-d; i<=d; i++) {
        
            for (int j=-d; j<=d; j++) {
            
                if ( d-abs(i) == 0 || d-abs(j) == 0 ) {
                
                    coordinates.x = (imageWidth/2) + (depthSize*j) - (depthSize/2);
                    coordinates.y = (imageHeight/2) + (depthSize*i) - (depthSize/2);
					//Υπολογίζει που αρχίζει κάθε εικονίδιο για να το κόψει
                    
                    tileImage = [self cropImage:tempImage
                                          point:CGSizeMake(coordinates.x, coordinates.y)
                                           size:CGSizeMake(depthSize, depthSize)];
					//Κόβει ένα κομάτι από την εικόνα από το σημείο point με διαστάσεις size
            
                    if (tileImage) [self addSampleFromImage:tileImage];
                    else return NO;
                }
            }
        }
    }
    if (self.samples.count != (2*depth-1)*(2*depth-1))  return NO;
    return YES;
}

-(Boolean)deleteTemplateSamples{
    
    [self.samples removeAllObjects];
    return  YES;
}


@end

