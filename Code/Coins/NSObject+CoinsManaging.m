//
//  NSObject+CoinsManaging.m
//  Coins
//
//  Created by Panos Kalodimas on 1/10/13.
//
//

#import "NSObject+CoinsManaging.h"

@implementation NSObject (CoinsManaging)

-(BOOL)exportData{
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *dictionary = nil;
    NSString *filepath = nil;
    
    NSMutableArray *coinsList = [self loadCoinsList];
    if (!coinsList) return NO;
        
    for (int i=0; i<coinsList.count; i++) {
        
        filepath = [[[DOCUMENTS_COINS stringByExpandingTildeInPath] stringByAppendingPathComponent:[[coinsList objectAtIndex:i] valueForKey:NAME]] stringByAppendingPathExtension:PLIST];
        dictionary = [NSDictionary dictionaryWithContentsOfFile:filepath];
        [array addObject:dictionary];
    }
    
    NSMutableArray *countryList = [self loadCountryList];
    if (!countryList)  return NO;
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:array, COINS,
                                                            countryList, COUNTRIES, nil];
    
    filepath = [[[DOCUMENTS stringByExpandingTildeInPath] stringByAppendingPathComponent:EXPORT_FILE] stringByAppendingPathExtension:PLIST];
    return [dictionary writeToFile:filepath atomically:NO];
}

-(BOOL)importData{
    
    NSString *path = [[[DOCUMENTS stringByExpandingTildeInPath] stringByAppendingPathComponent:IMPORT_FILE] stringByAppendingPathExtension:PLIST];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *array = nil;
    
    if (!dictionary) return NO;
    
    // Import Countries
    NSMutableArray *countryList = [self loadCountryList];
    array = [dictionary valueForKey:COUNTRIES];
    for (int i=0; i<array.count; i++)  [self newCountry:countryList name:[array objectAtIndex:i]];
    if (![self saveCountryList:countryList]) return NO;
    
    //Import Coins
    NSMutableArray *coinsList = [self loadCoinsList];
    array = [dictionary valueForKey:COINS];
    for (int i=0; i<array.count; i++)  [self newCoin:coinsList coin:[[Coin alloc] initFromDictionary:[array objectAtIndex:i]]];
        
    return YES;
}


//---------------------------------------------------------------------------
//----------------------------- Settings Methods ----------------------------
//---------------------------------------------------------------------------

-(NSMutableDictionary*)loadSettings{
    
    NSString *filepath = [[[DOCUMENTS stringByExpandingTildeInPath] stringByAppendingPathComponent:SETTINGS] stringByAppendingPathExtension:PLIST];
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:filepath];
    if (!settings)  settings = [self defaultSettings];
    
    return  settings;
}

-(NSMutableDictionary*)defaultSettings{
    
    return [NSDictionary dictionaryWithObjectsAndKeys:SETTINGS_DEFAULTS, nil];
}

-(BOOL)saveSettings:(NSMutableDictionary*)settings{
    
    NSString *filepath = [[[DOCUMENTS stringByExpandingTildeInPath] stringByAppendingPathComponent:SETTINGS] stringByAppendingPathExtension:PLIST];

    return [settings writeToFile:filepath atomically:YES];
}

-(id)getSetting:(NSMutableDictionary*)settings name:(NSString *)name{
        
    if (!settings) settings = [self loadSettings];

    return [settings valueForKey:name];
}

-(BOOL)editSetting:(NSMutableDictionary*)settings name:(NSString *)name value:(id)value save:(Boolean)save{
    
    if (!settings) settings = [self loadSettings];
    if (!settings || !name || !value) return NO;
    
    [settings setValue:value forKey:name];
    if (!save)  return YES;
    return [self saveSettings:settings];
}

//---------------------------------------------------------------------------
//---------------------------- CoinsList Methods ----------------------------
//---------------------------------------------------------------------------

-(NSMutableArray*)loadCoinsList{
    
    NSString *filepath = [[[DOCUMENTS stringByExpandingTildeInPath] stringByAppendingPathComponent:COINS_LIST] stringByAppendingPathExtension:PLIST];
    
    NSMutableArray *coinsList = [NSMutableArray arrayWithContentsOfFile:filepath];
    if (!coinsList)  coinsList = [NSMutableArray array];
    
    return  coinsList;
}

-(BOOL)saveCoinsList:(NSArray*)coinsList{
    
    NSString *filepath = [[[DOCUMENTS stringByExpandingTildeInPath] stringByAppendingPathComponent:COINS_LIST] stringByAppendingPathExtension:PLIST];
    
    return [coinsList writeToFile:filepath atomically:YES];
}


-(UIImage*)getCoinIcon:(NSString *)name{
    
    NSString *filepath = [[[DOCUMENTS_COINS stringByExpandingTildeInPath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:PNG];
    UIImage *icon = [[UIImage alloc] initWithContentsOfFile:filepath];
    
    return icon;
}

-(BOOL)saveCoinIcon:(NSString *)name icon:(UIImage *)icon{
    
    NSString *filepath = [[[DOCUMENTS_COINS stringByExpandingTildeInPath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:PNG];
    NSData *iconData = UIImagePNGRepresentation(icon);
    
    return [iconData writeToFile:filepath atomically:YES];
}

-(BOOL)deleteCoinFromList:(NSMutableArray*)coinsList name:(NSString *)name{
        
    if (coinsList) {
        
        int i = [self findCoinInList:coinsList name:name];
        if (i >= 0) {
            
            [coinsList removeObjectAtIndex:i];
            return YES;
        }
    }
    return NO;
}

-(BOOL)addInCoinListSorted:(NSMutableArray*)coinsList coin:(NSDictionary*)coin sortType:(SORTING_OPTION)type{
    
    if (!coinsList || !coin) return NO;
    
    NSString *name = [coin valueForKey:NAME];
    NSString *country = [coin valueForKey:COUNTRY];
    int i=0;
    
    if( type == BY_SETTINGS ) type = (SORTING_OPTION)[[self getSetting:nil name:SORTING] integerValue];
        
    switch (type) {
                        
        case BY_NAME:{
            
            for (i=0; i<coinsList.count && [name localizedCaseInsensitiveCompare:[(NSDictionary*)[coinsList objectAtIndex:i] valueForKey:NAME]] == NSOrderedDescending; i++);
            
            if ( i != coinsList.count && [name localizedCaseInsensitiveCompare:[[coinsList objectAtIndex:i] valueForKey:NAME]] == NSOrderedSame) {
                
                for (i=i; i<coinsList.count && [name localizedCaseInsensitiveCompare:[[coinsList objectAtIndex:i] valueForKey:NAME]] == NSOrderedSame; i++){
                    
                    if ([country localizedCaseInsensitiveCompare:[[coinsList objectAtIndex:i] valueForKey:COUNTRY]] == NSOrderedAscending)  break;
                }
            }
            [coinsList insertObject:coin atIndex:i];
            return YES;
        }
        case BY_COUNTRY:{
            
            for (i=0; i<coinsList.count && [country localizedCaseInsensitiveCompare:[[coinsList objectAtIndex:i] valueForKey:COUNTRY]] == NSOrderedDescending; i++);
            
            if ( i != coinsList.count && [country localizedCaseInsensitiveCompare:[[coinsList objectAtIndex:i] valueForKey:COUNTRY]] == NSOrderedSame) {
                
                for (i=i; i<coinsList.count && [country localizedCaseInsensitiveCompare:[[coinsList objectAtIndex:i] valueForKey:COUNTRY]] == NSOrderedSame; i++){
                    
                    if ([name localizedCaseInsensitiveCompare:[[coinsList objectAtIndex:i] valueForKey:NAME]] != NSOrderedDescending)  break;
                }
            }
            [coinsList insertObject:coin atIndex:i];
            return YES;
        }
        default:{ return NO;}
    }
    return NO;
}

-(BOOL)sortCoinList:(NSMutableArray*)coinsList type:(SORTING_OPTION)type{
    
    if(!coinsList) return NO;
    
    NSMutableArray *sortedList = [NSMutableArray array];
    
    for (int i=0; i<coinsList.count; i++) {
        
        if ( ![self addInCoinListSorted:sortedList coin:[coinsList objectAtIndex:i] sortType:type] ) return NO;
    }
    [coinsList removeAllObjects];
    [coinsList addObjectsFromArray:sortedList];
    return YES;
}

-(BOOL)activateCoin:(NSMutableArray*)coinsList name:(NSString *)name activation:(BOOL)active{

    if (!coinsList || !name)  return NO;
    
    int i = [self findCoinInList:coinsList name:name];
    if (i < 0)  return NO;
    
    [[coinsList objectAtIndex:i] setValue:[NSNumber numberWithInt:ACTIVE_COIN] forKey:ACTIVE];

    return YES;
}

-(int)findCoinInList:(NSArray*)coinsList name:(NSString *)name{
    
    if (!coinsList || !name)  return -1;
    
    int i = 0;
    for (i=0; i<coinsList.count && [name localizedCaseInsensitiveCompare:[[coinsList objectAtIndex:i] valueForKey:NAME]] != NSOrderedSame; i++ );
    
    if (i == coinsList.count)  return -1;
    return i;
}

//---------------------------------------------------------------------------
//---------------------------- CountryList Methods --------------------------
//---------------------------------------------------------------------------

-(NSMutableArray*)loadCountryList{
    
    NSString *filepath = [[[DOCUMENTS stringByExpandingTildeInPath] stringByAppendingPathComponent:COUNTRY_LIST] stringByAppendingPathExtension:PLIST];
    NSMutableArray *countryList = [NSMutableArray arrayWithContentsOfFile:filepath];
    if (!countryList)  countryList = [NSMutableArray array];
    
    return countryList;
}

-(BOOL)saveCountryList:(NSArray*)countryList{
    
    NSString *filepath = [[[DOCUMENTS stringByExpandingTildeInPath] stringByAppendingPathComponent:COUNTRY_LIST] stringByAppendingPathExtension:PLIST];
    
    return [countryList writeToFile:filepath atomically:YES];
}

-(BOOL)newCountry:(NSMutableArray*)countryList name:(NSString *)name{
    
    if (!countryList || !name)  return NO;
    if ([[name stringByReplacingOccurrencesOfString:SPACE_CHAR withString:EMPTY_CHAR] length] < 1)  return NO;
    
    int i = 0;
    for (i=0; i<countryList.count && [name localizedCaseInsensitiveCompare:[countryList objectAtIndex:i]] == NSOrderedDescending ; i++);
    
    if ( countryList.count == i || [name localizedCaseInsensitiveCompare:[countryList objectAtIndex:i]] != NSOrderedSame ) {
        
        [countryList insertObject:name atIndex:i];
        return [self saveCountryList:countryList];
    }
    return NO;
}

-(BOOL)deleteCountry:(NSMutableArray *)countryList name:(NSString *)name{
    
    if (!countryList || !name)  return NO;
    
    int i = [self findCountry:countryList name:name];
    if ( i < 0 )  return NO;
    
    [countryList removeObjectAtIndex:i];
    return YES;
}

-(int)findCountry:(NSArray*)countryList name:(NSString *)name{
    
    if (!countryList || !name)  return -1;
    
    int i = 0;
    for (i=0; i<countryList.count && [name localizedCaseInsensitiveCompare:[countryList objectAtIndex:i]] != NSOrderedSame; i++ );
    
    if (i == countryList.count)  return -1;
    return i;
}

//---------------------------------------------------------------------------
//---------------------------- Coins Methods --------------------------------
//---------------------------------------------------------------------------

-(NSMutableArray*)loadCoinsData:(BOOL)ActiveOnly{
    
    NSMutableArray *coinsList = [self loadCoinsList];
    if (!coinsList)  return nil;
    
    NSMutableArray *coinsData = [NSMutableArray array];
    
    NSString *filepath = nil;
    NSMutableDictionary *coinInfo = nil;
    Coin *coin = nil;
    
    for (int i=0; i<coinsList.count; i++) {
        
        coinInfo = [coinsList objectAtIndex:i];
        
        if ( [[coinInfo valueForKey:ACTIVE] integerValue] > 0 || !ActiveOnly ) {
            
            filepath = [[[DOCUMENTS_COINS stringByExpandingTildeInPath] stringByAppendingPathComponent:[coinInfo valueForKey:NAME]] stringByAppendingPathExtension:PLIST];
            coin = [[Coin alloc] initFromFile:filepath];
            if (coin)  [coinsData addObject:coin];
            else return nil;
        }
    }
    return coinsData;
}

-(NSMutableArray*)loadCoinsDataNoImages:(BOOL)ActiveOnly{
    
    NSMutableArray *coinsList = [self loadCoinsList];
    if (!coinsList)  return nil;
    
    NSMutableArray *coinsData = [NSMutableArray array];
    
    NSString *filepath = nil;
    NSMutableDictionary *coinInfo = nil;
    Coin *coin = nil;
    
    for (int i=0; i<coinsList.count; i++) {
        
        coinInfo = [coinsList objectAtIndex:i];
        
        if ( [[coinInfo valueForKey:ACTIVE] integerValue] > 0 || !ActiveOnly) {
            
            filepath = [[[DOCUMENTS_COINS stringByExpandingTildeInPath] stringByAppendingPathComponent:[coinInfo valueForKey:NAME]] stringByAppendingPathExtension:PLIST];
            coin = [[Coin alloc] initFromFileOnlyData:filepath];
            if (coin)  [coinsData addObject:coin];
            else return nil;
        }
    }
    return coinsData;
}

-(BOOL)newCoin:(NSMutableArray*)coinsList coin:(Coin*)newCoin{
    
    if ( !coinsList || !newCoin )  return NO;
    if ( !newCoin.name || ([newCoin.name length] < 1) )  return NO;
    if ( !newCoin.country ) newCoin.country = N_A;
        
    if ([self findCoinInList:coinsList name:newCoin.name] >= 0)  return NO;
    
    NSMutableDictionary *settings = [self loadSettings];
    
    if (newCoin.templateImage)  [newCoin createTemplateSamples:[[self getSetting:settings name:TEMPLATE] integerValue]
                                                         depth:[[self getSetting:settings name:DEPTH] integerValue]
                                                     depthSize:[[self getSetting:settings name:SAMPLE] integerValue]];
    if( ![self saveCoinData:newCoin] ) return NO;
    
    if (newCoin.image) {
        
        UIImage *icon = [self resize:newCoin.image size:CGSizeMake(COINS_ICON_SIZE, COINS_ICON_SIZE)];
        [self saveCoinIcon:newCoin.name icon:icon];
    }
    
    ACTIVE_OPTION active = (newCoin.templateImage)? ACTIVE_COIN : UNAVAILABLE_COIN;
    NSMutableDictionary *coinInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:newCoin.name, NAME,
                                                                                    newCoin.country,COUNTRY,
                                                                                    [NSNumber numberWithInteger:active], ACTIVE, nil];
    
    if ( [self addInCoinListSorted:coinsList coin:coinInfo sortType:BY_SETTINGS] ) return [self saveCoinsList:coinsList];
    else return NO;
}

-(BOOL)deleteCoin:(NSMutableArray *)coinsList name:(NSString *)name{
    
    if ( !coinsList || !name )  return NO;
    
    if (![self deleteCoinFromList:coinsList name:name])  return NO;
    if (![self saveCoinsList:coinsList])  return NO;
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *filepath = [[[DOCUMENTS_COINS stringByExpandingTildeInPath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:PLIST];
    [filemanager removeItemAtPath:filepath error:nil];
    
    filepath = [[filepath stringByDeletingPathExtension] stringByAppendingPathExtension:PNG];
    [filemanager removeItemAtPath:filepath error:nil];

    return  YES;
}

-(BOOL)editCoin:(NSMutableArray *)coinsList name:(NSString *)name newData:(Coin*)editedCoin{
    
    if (!coinsList || !name || !editedCoin)  return NO;
    
    if ([name localizedCaseInsensitiveCompare:editedCoin.name] != NSOrderedSame) {
        if ( [self findCoinInList:coinsList name:editedCoin.name] >= 0) return NO;
    }
    int i = [self findCoinInList:coinsList name:name];
    if ( i < 0 )  return  NO;
    
    ACTIVE_OPTION active = [[[coinsList objectAtIndex:i] valueForKey:ACTIVE] integerValue];
    [self deleteCoin:coinsList name:name];
    
    [editedCoin.samples removeAllObjects];
    if (![self newCoin:coinsList coin:editedCoin]) return NO;
    
    if (active == 0) {
        
        i = [self findCoinInList:coinsList name:editedCoin.name];
        if (i < 0)  return NO;
        if ( [[[coinsList objectAtIndex:i] valueForKey:ACTIVE] integerValue] == 1 )
            [[coinsList objectAtIndex:i] setValue:[NSNumber numberWithInteger:active] forKey:ACTIVE];
    }
    return YES;
}

-(Coin*)loadCoinData:(NSString *)name{
    
    NSMutableArray *coinsList = [self loadCoinsList];
    if (!coinsList || !name)  return nil;
    
    int i = [self findCoinInList:coinsList name:name];
    if (i < 0)  return nil;
    
    NSString *filepath = [[[DOCUMENTS_COINS stringByExpandingTildeInPath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:PLIST];

    return [[Coin alloc] initFromFile:filepath];
}

-(BOOL)saveCoinData:(Coin *)coinData{
    
    return [coinData saveCoinData];
}

-(Coin*)getCoinData:(NSMutableArray*)coinsData name:(NSString *)name{
    
    if ( !name ) return nil;
    if ( !coinsData ) return [self loadCoinData:name];
    
    int i = 0;
    for (i=0; i<coinsData.count && [name localizedCaseInsensitiveCompare:[[coinsData objectAtIndex:i] valueForKey:NAME]] != NSOrderedSame; i++ );
    
    if (i == coinsData.count)  return nil;
    else  return [coinsData objectAtIndex:i];
}

-(BOOL)recreateCoinSamples{
    
    NSMutableDictionary *settings = [self loadSettings];
    NSMutableArray *coinsData = [self loadCoinsData:NO];
    
    if (!settings || !coinsData) return NO;
    
    int template = (TEMPLATE_SIZE)[[self getSetting:settings name:TEMPLATE] integerValue];
    int depth = (DEPTH_SIZE)[[self getSetting:settings name:DEPTH] integerValue];
    int sample = (SAMPLE_SIZE)[[self getSetting:settings name:SAMPLE] integerValue];
    Coin *coin = nil;
    
    for (int i = 0; i < coinsData.count; i++) {
        
        coin = [coinsData objectAtIndex:i];
        if ( ![coin deleteTemplateSamples] ) return NO;
        else {
            if ( ![coin createTemplateSamples:template depth:depth depthSize:sample] ) return NO;
            else {
                if ( ![coin saveCoinData] ) return NO;
            }
        }
    }
    return YES;
}

//---------------------------------------------------------------------------
//---------------------------- Extra Methods --------------------------------
//---------------------------------------------------------------------------

-(UIAlertView*)errorMessage:(NSString *)title message:(NSString *)message{
    
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [error show];
    return error;
}

@end
