//
//  msgListViewCell.m
//  Shutterbug
//
//  Created by 樊凡 on 15/8/5.
//  Copyright (c) 2015年 Appress. All rights reserved.
//

#import "msgListViewCell.h"

@implementation msgListViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(18,10,30, 25)];
    //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat x = self.imageView.frame.origin.x + self.imageView.frame.size.width + 8.0;
    CGFloat y = self.textLabel.frame.origin.y;
    CGFloat width = self.contentView.frame.size.width - x -2.0;
    CGFloat heigh = self.textLabel.frame.size.height;
    self.textLabel.frame = CGRectMake(x, y, width, heigh);
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
