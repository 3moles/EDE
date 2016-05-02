//
//  FlickrPhotosTVC.h
//  Shutterbug
//
//  Created by 樊凡 on 15/5/23.
//  Copyright (c) 2015年 Appress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotosTVC : UITableViewController
@property (nonatomic,strong) NSArray *photos;

//@property (nonatomic,strong) NSMutableArray *ecoFileName;
@property (nonatomic,strong) NSMutableArray *typeID;
@property (nonatomic,strong) NSMutableArray *objectID;

@property (nonatomic,strong) NSMutableArray *sectionTitle;
@property (nonatomic,strong) NSMutableDictionary *section;
@property (nonatomic,strong) NSMutableDictionary *economyInfo;
@property (nonatomic,strong) NSMutableDictionary *economyList;
@end
