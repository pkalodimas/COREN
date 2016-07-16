//
//  NSObject+CoinsManaging.h
//  Coins
//
//  Created by Panos Kalodimas on 1/10/13.
//
//

#import <Foundation/Foundation.h>
#import "AppDefinitions.h"
#import "Coin.h"
@class Coin;

@interface NSObject (CoinsManaging)

-(BOOL)importData;
-(BOOL)exportData;

//Settings method
-(NSMutableDictionary*)loadSettings;
-(BOOL)saveSettings:(NSMutableDictionary*)settings;
-(id)getSetting:(NSMutableDictionary*)settings name:(NSString*)name;
-(BOOL)editSetting:(NSMutableDictionary*)settings name:(NSString*)name value:(id)value save:(Boolean)save;
-(NSMutableDictionary*)defaultSettings;

//coinsList methods
-(NSMutableArray*)loadCoinsList;
-(UIImage*)getCoinIcon:(NSString*)name;
-(BOOL)saveCoinIcon:(NSString*)name icon:(UIImage*)icon;
-(BOOL)saveCoinsList:(NSArray*)coinsList;
-(BOOL)addInCoinListSorted:(NSMutableArray*)coinsList coin:(NSDictionary*)coin sortType:(SORTING_OPTION)type;
-(BOOL)deleteCoinFromList:(NSMutableArray*)coinsList name:(NSString*)name;
-(BOOL)sortCoinList:(NSMutableArray*)coinsList type:(SORTING_OPTION)type;
-(int)findCoinInList:(NSArray*)coinsList name:(NSString*)name;

//CountryList methods
-(NSMutableArray*)loadCountryList;
-(BOOL)saveCountryList:(NSArray*)countryList;
-(BOOL)newCountry:(NSMutableArray*)countryList name:(NSString*)name;
-(BOOL)deleteCountry:(NSMutableArray*)countryList name:(NSString*)name;
-(int)findCountry:(NSArray*)countryList name:(NSString*)name;

//Coin methods
-(NSMutableArray*)loadCoinsData:(BOOL)ActiveOnly;
-(NSMutableArray*)loadCoinsDataNoImages:(BOOL)ActiveOnly;
-(BOOL)newCoin:(NSMutableArray*)coinsList coin:(Coin*)newCoin;
-(BOOL)deleteCoin:(NSMutableArray*)coinsList name:(NSString*)name;
-(BOOL)editCoin:(NSMutableArray*)coinsList name:(NSString*)name newData:(Coin*)editedCoin;
-(BOOL)activateCoin:(NSMutableArray*)coinsList name:(NSString*)name activation:(BOOL)active;
-(Coin*)loadCoinData:(NSString*)name;
-(Coin*)getCoinData:(NSMutableArray*)coinsData name:(NSString*)name;
-(BOOL)saveCoinData:(Coin*)coinData;
-(BOOL)recreateCoinSamples;

//Extra methods
-(UIAlertView*)errorMessage:(NSString*)title message:(NSString*)message;

@end
