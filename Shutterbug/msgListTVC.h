//
//  msgListTVC.h
//  Shutterbug
//
//  Created by 樊凡 on 15/8/3.
//  Copyright (c) 2015年 Appress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface msgListTVC : UITableViewController

@property (nonatomic,strong) NSMutableArray *msgList;
@property (nonatomic,strong) NSMutableDictionary *msgInfo;

@property (nonatomic,strong) NSString *typeID;
@property (nonatomic,strong) NSString *objectID;
@end
