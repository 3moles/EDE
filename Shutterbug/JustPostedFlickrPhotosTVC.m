//
//  JustPostedFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by 樊凡 on 15/5/23.
//  Copyright (c) 2015年 Appress. All rights reserved.
//

#import "JustPostedFlickrPhotosTVC.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>

@interface JustPostedFlickrPhotosTVC ()

@end

@implementation JustPostedFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在更新..."];

    [self fetchInformation];
    // Do any additional setup after loading the view.
}

- (IBAction)fetchInformation
{
    NSLog(@"-------Start query data base");
    
    [self.refreshControl beginRefreshing];
    /*dispatch_queue_t fetchQ = dispatch_queue_create("file list fetch", NULL);
    dispatch_async(fetchQ, ^{*/
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"dailyInfo"];
        //[bquery selectKeys:@[@"typeID",@"content",@"nameID",@"infoFile",@"nameID"]];
        [bquery setLimit:30];
        [bquery orderByDescending:@"typeId"];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if(!error){
                NSMutableArray *tmpTypeId = [[NSMutableArray alloc] init];
                NSMutableArray *tmpObjectId = [[NSMutableArray alloc] init];
                for (BmobObject *obj in array) {
                    NSString *typeId = [obj objectForKey:@"typeId"];
                    [tmpTypeId addObject:typeId];
                    [tmpObjectId addObject:[obj objectId]];
                }
                
                if ([tmpTypeId isEqualToArray:self.typeID] && [tmpObjectId isEqualToArray:self.objectID])  {
                    NSLog(@"Arrary is the same");
                    [self.refreshControl endRefreshing];
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"友情提示"
                                              message:@"没有新的数据"
                                              delegate:self cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil, nil];
                    [alertView show];
                } else {
                    [self.typeID removeAllObjects];
                    [self.objectID removeAllObjects];
                    [self.sectionTitle removeAllObjects];
                    [self.section removeAllObjects];
                    
                    for (BmobObject *obj in array) {
                        NSString *typeId = [obj objectForKey:@"typeId"];
                        NSLog(@"obj.typeId = %@", typeId);
                        NSLog(@"boj.objeceId = %@",[obj objectId]);
                        NSUInteger hasStore = 0;
                        if ([typeId length] && [self.typeID count]) {
                            NSArray *typeIdArray = [NSArray arrayWithArray:self.typeID];
                            for (NSString *str in typeIdArray) {
                                if ([str isEqualToString:typeId]) {
                                    hasStore = 1;
                                }
                            }
                            
                            if (!hasStore) {
                                [self.typeID addObject:typeId];
                                [self.objectID addObject:[obj objectId]];
                            }
                            
                        } else {
                            [self.typeID addObject:typeId];
                            [self.objectID addObject:[obj objectId]];
                        }
                    }
                    
                    if ([self.typeID count]) {
                        [self getSection:self.typeID];
                        [self.tableView reloadData];
                        [self.refreshControl endRefreshing];
                    }
                }
            }else{
                [self.refreshControl endRefreshing];
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"友情提示"
                                          message:@"无法获取数据，请检查网络"
                                          delegate:self cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    
    }

- (void)getSection:(NSMutableArray *)typeId
{
    if ([typeId count]) {
        for (NSUInteger i = 0; i < [typeId count]; i++) {
            NSRange range;
            range.location = 0;
            range.length   = [typeId[i] length] - 2;
            NSString *fileName = [typeId[i] substringWithRange:range];
            
            NSUInteger fileExitFlag = 0;
            if ([self.sectionTitle count]){
                for (int k = 0; k < [self.sectionTitle count]; k++){
                    if ([self.sectionTitle[k] isEqualToString:fileName]){
                        fileExitFlag = 1;
                        break;
                    }
                }
            }
            if (fileExitFlag) continue;
            [self.sectionTitle addObject:fileName];
            
            NSMutableArray *cellTitle = [[NSMutableArray alloc] init];
            for (NSUInteger j = 0; j < [typeId count]; j++) {
                NSRange isExist = [typeId[j] rangeOfString:fileName];
                if (isExist.length) {
                    [cellTitle addObject:typeId[j]];
                }
            }
            [self.section setValue:cellTitle forKeyPath:fileName];
        }
    }
    
}



@end
