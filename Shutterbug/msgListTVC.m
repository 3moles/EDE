//
//  msgListTVC.m
//  Shutterbug
//
//  Created by 樊凡 on 15/8/3.
//  Copyright (c) 2015年 Appress. All rights reserved.
//

#import "msgListTVC.h"
#import "TextViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "MBProgressHUD.h"

@interface msgListTVC ()

@end

@implementation msgListTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)msgList
{
    if (!_msgList) _msgList = [[NSMutableArray alloc] init];
    return _msgList;
}

- (NSMutableDictionary *)msgInfo
{
    if (!_msgInfo) _msgInfo = [[NSMutableDictionary alloc] init];
    return _msgInfo;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchMsgWithMbp];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@""
                                                             style:UIBarButtonItemStylePlain
                                                            target:nil
                                                            action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

- (void)fetchMsgWithMbp
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    //HUD.delegate = self;
    HUD.labelText = @"正在更新";
    
    [HUD showWhileExecuting:@selector(fetchMsgFile) onTarget:self withObject:nil animated:YES];
}
- (void)fetchMsgFile
{
    BmobQuery *bquery = [[BmobQuery alloc] initWithClassName:@"dailyInfo"];
    [bquery getObjectInBackgroundWithId:self.objectID block:^(BmobObject *object, NSError *error) {
        if (error) {
            [self.refreshControl endRefreshing];
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"友情提示"
                                      message:@"无法连接服务器，请检查网络"
                                      delegate:self cancelButtonTitle:@"关闭"
                                      otherButtonTitles:nil, nil];
            [alertView show];
            NSLog(@"fectchMsgFile background fail! %@",error);
        } else {
            BmobFile *file = (BmobFile*)[object objectForKey:@"file"];
            
            if ([file.url length]) {
                NSURL *url = [NSURL URLWithString:file.url];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                [request setTimeoutInterval:5.0];
                
                NSError *ferror = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:nil
                                                                 error:&ferror];
                if (ferror) {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"友情提示"
                                              message:@"无法获取文件，请检查网络"
                                              delegate:self cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil, nil];
                    [alertView show];
                    NSLog(@"fectchMsgFile fail! %@",ferror);
                }
                else {
                    NSMutableString *filecontent = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [self parseInfomationFile:file.name Content:filecontent];
                }
            }
        }
    }];


}

- (void)parseInfomationFile:(NSString *)fileName Content:(NSMutableString *)content
{
    if (!content)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"友情提示"
                                  message:@"未能正确获取文件"
                                  delegate:self cancelButtonTitle:@"关闭"
                                  otherButtonTitles:nil, nil];
        [alertView show];

        return;
    }
    NSMutableString *filecontent = [[NSMutableString alloc] initWithString:content];
    NSUInteger msgNumber = [self calcMsgNumber:content];
    
    NSLog(@"file name %@",fileName);
    
    for (int i = 0; i < msgNumber; i++) {
        NSRange rangeLeft = [filecontent rangeOfString:@"【"];
        NSRange rangeRight = [filecontent rangeOfString:@"】"];
        
        if (rangeRight.length) {
            
            NSRange titleRange;
            titleRange.location = rangeLeft.location + 1;
            titleRange.length = rangeRight.location - 1;
            
            NSString *msgTitle = [filecontent substringWithRange:titleRange];
            [self.msgList addObject:msgTitle];
            
            NSRange deleRange;
            deleRange.location = 0;
            deleRange.length = rangeRight.location + 1;
            [filecontent deleteCharactersInRange:deleRange];
            
            if (i == msgNumber - 1) {
                [self.msgInfo setValue:filecontent forKey:msgTitle];
                break;
            }
            rangeLeft = [filecontent rangeOfString:@"【"];
            NSRange bodyRange;
            bodyRange.location = 0;
            bodyRange.length = rangeLeft.location;
            
            NSString *msgBody = [filecontent substringWithRange:bodyRange];
            
            [self.msgInfo setValue:msgBody forKey:msgTitle];
            
            deleRange.location = 0;
            deleRange.length   = bodyRange.length;
            [filecontent deleteCharactersInRange:deleRange];
            
        }
    }
    //NSLog(@"msgNum = %lu",[self.msgList count]);
    [self.tableView reloadData];
}


- (NSUInteger)calcMsgNumber:(NSMutableString *)content
{
    NSUInteger msgNumber = 0;
    NSMutableString *fileContent = [[NSMutableString alloc] initWithString:content];
    NSRange charRange  = [fileContent rangeOfString:@"【"];
    NSRange otherRange = [fileContent rangeOfString:@"】"];
    
    while (charRange.length) {
        msgNumber += 1;
        NSRange deleRange;
        deleRange.location = 0;
        deleRange.length = otherRange.location + 1;
        [fileContent deleteCharactersInRange:deleRange];
        charRange  = [fileContent rangeOfString:@"【"];
        otherRange = [fileContent rangeOfString:@"】"];
    }
    
    return msgNumber;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.msgList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Msg List Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    if ([self.msgList count]) {
        UIFont *newFont = [UIFont fontWithName:@"Arial" size:17.0];
        cell.textLabel.font = newFont;
        NSRange range;
        range = [self.msgList[indexPath.row] rangeOfString:@"："];
        if ((range.length > 0) && (range.length < 30)) {
            range.length = [self.msgList[indexPath.row] length] - range.location - 1;
            range.location += 1;
            cell.textLabel.text = [self.msgList[indexPath.row] substringWithRange:range];
        } else {
            cell.textLabel.text = self.msgList[indexPath.row];
        }
        
        cell.imageView.image = [UIImage imageNamed:@"dot.png"];
    }
    return cell;
}




#pragma mark - Navigation

- (void)prepareTextViewController:(TextViewController *)textTvc Title:(NSString *)msgTitle Content:(NSString *)msgContent
{
    textTvc.newsContent = [NSMutableString stringWithString:msgContent];
    textTvc.newsTitle   = [NSMutableString stringWithString:msgTitle];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"Display Msg"])
            {
                if ([segue.destinationViewController isKindOfClass:[TextViewController class]])
                {
                    NSString *cellTitle = self.msgList[indexPath.row];
                    NSString *msgContent = [self.msgInfo objectForKey:cellTitle];
                    [self prepareTextViewController:segue.destinationViewController
                                              Title:cellTitle
                                            Content:msgContent ];
                }
            }
        }
    }
}


@end
