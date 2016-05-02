//
//  TextViewController.h
//  Shutterbug
//
//  Created by 樊凡 on 15/7/24.
//  Copyright (c) 2015年 Appress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController
@property (nonatomic,strong)NSMutableString *newsContent;
@property (nonatomic,strong)NSMutableString *newsTitle;
@property (nonatomic)CGFloat contentSize;
@property (nonatomic)CGFloat tailSize;
@property (nonatomic,strong)UIView *FontView;
@end
