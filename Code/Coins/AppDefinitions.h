//
//  AppDefinitions.h
//  Coins
//
//  Created by Panos Kalodimas on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Coins_AppDefinitions_h
#define Coins_AppDefinitions_h

#define ACTIVE          @"Active"
#define ACCURACY        @"Accuracy"
#define ALL_COINS       @"All Coins"
#define ANGLE           @"Angle"
#define BYTESPERPIXEL   @"BytesPerPixel"
#define COIN            @"Coin"
#define COINS           @"Coins"
#define COINS_LIST      @"CoinsList"
#define COIN_EDIT_TITLE @"Edit Coin"
#define COIN_NEW_TITLE  @"New Coin"
#define COIN_INFO_TITLE @"Coin Info"
#define COUNTRY_LIST    @"CountryList"
#define COUNTRY         @"Country"
#define COUNTRIES       @"Countries"
#define CORRELATION     @"Correlation"
#define CROP            @"Crop"
#define DATA            @"Data"
#define DEVIATION       @"Deviation"
#define DIM_X           @"X"
#define DIM_Y           @"Y"
#define DEPTH           @"Depth"
#define DOCUMENTS_COINS @"~/Documents/Coins"
#define DOCUMENTS       @"~/Documents"
#define EMPTY_CHAR      @""
#define EXPORT_FILE     @"Backup File"
#define HEIGHT          @"Height"
#define IMAGE           @"Image"
#define IMPORT_FILE     @"Backup File"
#define INIT_FILE       @"Init File"
#define MEAN            @"Mean"
#define NAME            @"Name"
#define NO_IMAGE_FILE   @"no_image"
#define N_A             @"N/A"
#define PADDING         @"Padding"
#define PATH            @"Path"
#define PLIST           @"plist"
#define PNG             @"png"
#define SAMPLE_NUM      @"SampleNum"
#define SAMPLE          @"Sample"
#define SAMPLES         @"Samples"
#define SETTINGS        @"Settings"
#define SORTING         @"Sorting"
#define SPACE_CHAR      @" "
#define STEP            @"Step"
#define TEMPLATES       @"Templates"
#define TEMPLATE        @"Template"
#define TOTAL_COR       @"Total Correlation"
#define WIDTH           @"Width"

#define SAMPLE_COORS    @"(0,0)",@"(-1,1)",@"(0,1)",@"(1,1)",@"(-1,0)",@"(1,0)",@"(-1,-1)",@"(0,-1)",@"(1,-1)",@"(-2,2)",@"(-1,2)",@"(0,2)",@"(1,2)",@"(2,2)",@"(-2,1)",@"(2,1)",@"(-2,0)",@"(0,2)",@"(-2,-1)",@"(2,-1)",@"(-2,-2)",@"(-1,-2)",@"(0,-2)",@"(1,-2)",@"(2,-2)"
#define SETTINGS_DEFAULTS  [NSNumber numberWithInt:BY_NAME], SORTING, [NSNumber numberWithInt:CROP_AUTO], CROP, [NSNumber numberWithInt:ANGLE_DEFAULT], ANGLE, [NSNumber numberWithInt:STEP_DEFAULT], STEP, [NSNumber numberWithInt:PADDING_DEFAULT], PADDING, [NSNumber numberWithInt:DEPTH_DEFAULT], DEPTH, [NSNumber numberWithInt:TEMPLATE_DEFAULT], TEMPLATE, [NSNumber numberWithInt:SAMPLE_DEFAULT], SAMPLE, [NSNumber numberWithInt:ACCURACY_DEFAULT], ACCURACY 

#define COINS_IMAGE_SIZE 150
#define COINS_ICON_SIZE 50

typedef enum{
    UNAVAILABLE_COIN = -1,
    INACTIVE_COIN = 0,
    ACTIVE_COIN = 1
} ACTIVE_OPTION;

typedef struct{
    int x;
    int y;
} POINTS;

typedef enum{
    COUNTRY_SELECT = 1,
    COUNTRY_SETTINGS = 2
} COUNTRY_OPTION;

typedef enum{
    COIN_EDIT = 1,
    NEW_COIN = 2,
    COIN_INFO = 3
} COIN_OPTION;

typedef enum{
    SAMPLE_EDIT = 1,
    SAMPLE_INFO = 2
} SAMPLE_OPTION;

typedef enum{
    BY_SETTINGS = 1,
    BY_NAME = 2,
    BY_COUNTRY = 3,
} SORTING_OPTION;

typedef enum{
    CROP_AUTO = 1,
    CROP_MANUAL = 2,
} CROP_OPTION;

typedef enum{
    DEPTH_1 = 1,
    DEPTH_2 = 2,
    DEPTH_3 = 3,
    DEPTH_SIZE_MAX = 3,
    DEPTH_DEFAULT = 2
} DEPTH_SIZE;

typedef enum{
    TEMPLATE_MIN = 100,
    TEMPLATE_DEFAULT = 140,
    TEMPLATE_MAX = 200
} TEMPLATE_SIZE;

typedef enum{
    SAMPLE_MIN = 5,
    SAMPLE_DEFAULT = 20,
    SAMPLE_MAX = 30
} SAMPLE_SIZE;

 typedef enum{
 PADDING_MIN = 0,
 PADDING_DEFAULT = 10,
 PADDING_MAX = 20
} PADDING_SIZE;

typedef enum{
    ANGLE_0 = 0,
    ANGLE_5 = 5,
    ANGLE_10 = 10,
    ANGLE_20 = 20,
    ANGLE_DEFAULT = 10
} ANGLE_SIZE;

typedef enum{
    STEP_5 = 5,
    STEP_10 = 10,
    STEP_DEFAULT = 5
} STEP_SIZE;

typedef enum{
    ACCURACY_MIN = 0,
    ACCURACY_DEFAULT = 80,
    ACCURACY_MAX = 100
} ACCURACY_SIZE;

typedef enum{
    OPTION_COIN = 1,
    OPTION_TEMPLATE = 2
} IMAGE_OPTION;

#endif
