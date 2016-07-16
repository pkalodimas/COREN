//
//  CoinsStageViewController.h
//  Coins
//
//  Created by Panos Kalodimas on 1/14/13.
//
//

#import <UIKit/UIKit.h>
#import "NSObject+ImageProccessing.h"
#import "CoinsStageCell.h"

@interface CoinsStageViewController : UITableViewController{
    
    UITableView *stagesTable;
    NSMutableArray *sections;
    NSMutableArray *stages;
    NSMutableArray *times;
    NSMutableArray *coors;
    NSMutableArray *icons;
    NSMutableArray *coins;
}

@property (strong, nonatomic) IBOutlet UITableView *stagesTable;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSMutableArray *stages;
@property (strong, nonatomic) NSMutableArray *times;
@property (strong, nonatomic) NSMutableArray *coors;
@property (strong, nonatomic) NSMutableArray *icons;
@property (strong, nonatomic) NSMutableArray *coins;

-(UIImage*)getCoinIconFromList:(NSString*)name;

@end
