//
//  FlickrPhotosTVC.m
//  Shutterbug
//
//  Created by 樊凡 on 15/5/23.
//  Copyright (c) 2015年 Appress. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "msgListTVC.h"
#import "msgListViewCell.h"
#import <BmobSDK/Bmob.h>

@interface FlickrPhotosTVC ()

@end

@implementation FlickrPhotosTVC

#pragma mark - Init


- (NSMutableArray *)typeID
{
    if (!_typeID) _typeID = [[NSMutableArray alloc] init];
    return _typeID;
}

- (NSMutableArray *)objectID
{
    if (!_objectID) _objectID = [[NSMutableArray alloc] init];
    return _objectID;
}

- (NSMutableArray *)sectionTitle
{
    if (!_sectionTitle) _sectionTitle = [[NSMutableArray alloc] init];
    return _sectionTitle;
}

- (NSMutableDictionary *)section
{
    if (!_section) _section = [[NSMutableDictionary alloc] init];
    return _section;
}
- (NSMutableDictionary *)economyInfo
{
    if (!_economyInfo) _economyInfo = [[NSMutableDictionary alloc] init];
    return _economyInfo;
}

- (NSMutableDictionary *)economyList
{
    if (!_economyList) _economyList = [[NSMutableDictionary alloc] init];
    return _economyList;
}

- (void)viewDidLoad
{
    //self.tableView.rowHeight = 90;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@""
                                                             style:UIBarButtonItemStylePlain
                                                            target:nil
                                                            action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.sectionFooterHeight = 0;
    
    
    //存储文字大小信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ((0 == [userDefaults floatForKey:@"contentSize"]) || (0 == [userDefaults floatForKey:@"tailSize"])) {
        CGFloat contentSize = 18;
        CGFloat tailSize = 12;
        
        [userDefaults setFloat:contentSize forKey:@"contentSize"];
        [userDefaults setFloat:tailSize    forKey:@"tailSize"];
        [userDefaults synchronize];
    }
}


- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
}


#pragma mark - UITableViewDataSource

static const unsigned int MAX_SECTION = 10;
- (NSUInteger)getNumberOfSection
{
    NSUInteger numOfSection = 0;
    numOfSection = [self.sectionTitle count] > MAX_SECTION ? MAX_SECTION:[self.sectionTitle count];
    return numOfSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return [self getNumberOfSection];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // Return the number of rows in the section.
    NSUInteger sectionNum = 0;
    if ([self.section count]) {
        NSArray *tmp = [self.section objectForKey:self.sectionTitle[section]];
        sectionNum = [tmp count];
    }
    else {
        sectionNum = 1;
    }
    
    return sectionNum;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.section count]) {
        return self.sectionTitle[section];
    }
    else
    {
        return @"";
    }
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSRange range;
    range.location = 0;
    range.length   = 4;
    NSString *year = [self.sectionTitle[section] substringWithRange:range];
    range.location = 4;
    range.length = 2;
    NSString *month = [self.sectionTitle[section] substringWithRange:range];
    range.location = 6;
    range.length = 2;
    NSString *day = [self.sectionTitle[section] substringWithRange:range];
    NSString *date = [[NSString alloc] initWithFormat:@"%@年%@月%@日",year,month,day];
    NSLog(@"date = %@",date);
    
    CGFloat y = 6;
    if (section == 0) y = 8;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,25)];
    
    headerView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.f];
    headerView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    headerView.layer.borderWidth = 1.0;
    

    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"日期图标.png"]];
    headerImageView.frame = CGRectMake(20, y, 30, 25);
    [headerView addSubview:headerImageView];
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(57, y, tableView.frame.size.width-50, 25);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel.text = date;
    headerLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:headerLabel];
    
    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 36;
    
    return 35.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    msgListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (([self.sectionTitle count]) && ([self.section count])) {
        NSString *cellTitle = [self.section objectForKey:self.sectionTitle[indexPath.section]][indexPath.row];
        NSRange range;
        range.location = [cellTitle length] - 1;
        range.length   = 1;
        NSString *flag = [cellTitle substringWithRange:range];
        
        if ([flag isEqualToString:@"1"]) {
            cell.textLabel.text = @"每日经济要点";
            cell.imageView.image = [UIImage imageNamed:@"经济图标.png"];
        } else if ([flag isEqualToString:@"2"]) {
            cell.textLabel.text = @"每日金融要点";
            cell.imageView.image = [UIImage imageNamed:@"金融图标.png"];
        } else {
            cell.textLabel.text = @"";
        }
    }

    return cell;
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
//    if ([detail isKindOfClass:[ImageViewController class]]) {
//        [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
//    }
}

#pragma mark - Navigation

- (void)prepareMsgListViewController:(msgListTVC *)ivc displayTypeID:(NSString *)typeID displayObjectID:(NSString *)objectID
{
    ivc.typeID = typeID;
    ivc.objectID = objectID;
    NSLog(@"typeID = %@ objID = %@",typeID,objectID);
}
// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"Display Msg List"])
            {
                if ([segue.destinationViewController isKindOfClass:[msgListTVC class]])
                {
                    NSString *sectionTitle = self.sectionTitle[indexPath.section];
                   
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    NSString *cellTitle = [[NSString alloc] init];
                    if ([cell.textLabel.text length]) {
                        if ([cell.textLabel.text isEqualToString:@"每日金融要点"]) {
                            NSString *title = [[NSString alloc ] initWithFormat:@"%@_2",sectionTitle];
                            cellTitle = [NSString stringWithString:title];
                            
                        }
                        else if ([cell.textLabel.text isEqualToString:@"每日经济要点"]) {
                            NSString *title = [[NSString alloc ] initWithFormat:@"%@_1",sectionTitle];
                            cellTitle = [NSString stringWithString:title];
                        }
                        
                        for (int i = 0; i < [self.typeID count]; i++) {
                            if ([self.typeID[i] isEqualToString:cellTitle]) {
                                [self prepareMsgListViewController:segue.destinationViewController
                                                     displayTypeID:self.typeID[i]
                                                   displayObjectID:self.objectID[i]];
                            }
                        }
                    }
                }
                
            }
        }
    }
}


@end
