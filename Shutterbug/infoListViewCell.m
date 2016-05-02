//
//  infoListViewCell.m
//  Shutterbug
//
//  Created by 樊凡 on 15/8/9.
//  Copyright (c) 2015年 Appress. All rights reserved.
//

#import "infoListViewCell.h"

@implementation infoListViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(5,16,10, 10)];
    
    CGFloat x = self.imageView.frame.origin.x + self.imageView.frame.size.width + 4.0;
    CGFloat y = self.textLabel.frame.origin.y;
    CGFloat width = self.contentView.frame.size.width - x -2.0;
    CGFloat heigh = self.textLabel.frame.size.height;
    self.textLabel.frame = CGRectMake(x, y, width, heigh);
    
    /*y = self.detailTextLabel.frame.origin.y + 2;
    width = self.detailTextLabel.frame.size.width;
    heigh = self.detailTextLabel.frame.size.height;
    self.detailTextLabel.frame = CGRectMake(x, y, width, heigh);*/
}

@end
