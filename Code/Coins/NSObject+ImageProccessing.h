//
//  NSObject+ImageProccessing.h
//  Coins
//
//  Created by Panos Kalodimas on 1/10/13.
//
//

#import <Foundation/Foundation.h>
#import "AppDefinitions.h"
#import "NSObject+CoinsManaging.h"

@interface NSObject (ImageProccessing)

-(NSMutableArray*)correlateFrame:(UIImage*)mainImage withSamples:(NSMutableArray*)samples point:(POINTS)point;
-(NSMutableArray*)correlateTile:(UIImage*)mainImage withSamples:(NSMutableArray*)samples;
-(NSMutableArray*)correlateRotate:(UIImage*)mainImage tile:(POINTS)tile withSamples:(NSMutableArray*)samples;
-(NSMutableArray*)correlateImage:(UIImage*)image withCoins:(NSMutableArray*)coinsData;
//-(CGImageRef)createResultMask:(CGImageRef)image points:(NSArray*)points;

-(UIImage*)rgb2bw:(UIImage*)cgimage;
-(UIImage*)cropImage:(UIImage*)cgimage point:(CGSize)point size:(CGSize)size;
-(UIImage*)resize:(UIImage*)cgimage size:(CGSize)size;
-(UIImage*)rotate:(UIImage*)cgimage angle:(uint)angle;

@end
