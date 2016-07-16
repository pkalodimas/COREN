//
//  Coin.h
//  Coins
//
//  Created by IPhone on 3/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDefinitions.h"
#import "NSObject+ImageProccessing.h"

@interface Coin : NSObject <NSCopying>{
	
	NSString *name;
	NSString *country;
	NSMutableArray *samples;
    UIImage *image;
    UIImage *templateImage;
}

@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *country;
@property(nonatomic,retain) NSMutableArray *samples;
@property(nonatomic,retain) UIImage *image;
@property(nonatomic,retain) UIImage *templateImage;

//Συναρτήσεις
-(id)initFromFile:(NSString*)filePath;
//(object*)initFromFile(string* filepath);
//Παίρνει το filepath ενός αρχείου, το διαβάζει και επιστρέφει ένα αντικείμενο Coin

-(id)initFromFileOnlyData:(NSString*)filePath;
//(object*)initFromFileOnlyData(string* filepath);
//Το ίδιο αλλά δεν διαβάζει την image και templateImage, κρατάει μόνο τα υπόλοιπα στοιχεία

-(id)initFromDictionary:(NSMutableDictionary*)data;
//(object*)initFromDictionary(Dictionary* data);
//Διαβάζει τα δεδομένα από ένα dictionary και επιστρέφει ένα αντικείμενο coin

-(id)initFromDictionaryOnlyData:(NSMutableDictionary*)data;
//(object*)initFromDictionaryOnlyData(Dictionary* data);
//Διαβάζει τα δεδομένα από ένα dictionary και επιστρέφει ένα αντικείμενο coin χωρίς εικόνες (image, templateImage)

-(id)initWithInfo:(NSString*)Name countryName:(NSString*)Country;
//(object*)initWithInfo(string name, string country);
//Δημιουργεί ένα αντικείμενο coin με στοιχεία name και country

-(id)init;
//αρχικοποιεί ένα αντικείμενο coin

-(void)addSampleFromImage:(UIImage*)sampleImage;
//void addsampleFromImage(Image *smapleImage)
//Παίρνει μια εικόνα και δημιουργεί τα δείγματα (μικρά εικονίδια)

-(void)addSampleFromBWImage:(UIImage*)sampleImage;
//void addSampleFromBWImage(Image *smapleImage)
//Παίρνει μια ασπρόμαυρη εικόνα και δημιουργεί τα δείγματα (μικρά εικονίδια)

-(void)addSampleFromRGBImage:(UIImage*)sampleImage;
//void addSampleFromRGBImage(Image *smapleImage)
//Παίρνει μια έγχρωμη εικόνα και δημιουργεί τα δείγματα (μικρά εικονίδια)

-(void)addSample:(NSMutableDictionary*)sample;
//void addSample(Dictionary *smaple)
//Προσθέτει ένα δείγμα στον πίνακα samples

-(Boolean)saveCoinData;
//Αποθηκεύει το Coin σε αρχείο στο δίσκο

-(UIImage*)getSampleImage:(NSMutableDictionary*)sample;
//Παίρνει ένα αντικείμενο Image μέσα από τα δεδομένα που είναι αποθηκευμένα στο dictionary sample

-(NSMutableArray*)getSamplesImages;
//Το ίδιο για όλα τα samples του Coin

-(void)deleteSample:(NSUInteger)sampleIndex;
//Σβήνει ένα smaple

-(NSMutableDictionary*)createSample:(int)Width Height:(int)Height Data:(NSData*)Data;
//NSMutableDictionary* createSample(int Width, int Height, NSData* Data);
//Παίρνει ένα dictionary με τα δεδομένα του smaple

-(Boolean)createTemplateSamples:(int)templateSize depth:(int)depth depthSize:(int)depthSize;
//Δημιουργεί όλα τα samples από την εικόνα templateImage

-(Boolean)deleteTemplateSamples;
//Διαγράφει όλα τα samples

@end
