//
//  main.m
//  Shutterbug
//
//  Created by 樊凡 on 15/5/23.
//  Copyright (c) 2015年 Appress. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        NSString *appKey = @"adcbad19739d4cc0c7e369f88b08613a";
        [Bmob registerWithAppKey:appKey];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
