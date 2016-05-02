//
//  msgNavigation.m
//  Shutterbug
//
//  Created by 樊凡 on 15/8/4.
//  Copyright (c) 2015年 Appress. All rights reserved.
//

#import "msgNavigation.h"

@interface msgNavigation ()

@end

@implementation msgNavigation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    NSDictionary *attributes  = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
