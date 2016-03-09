//
//  GZHRightCell.m
//  五子棋
//
//  Created by 高增洪 on 16/3/9.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHRightCell.h"
#import "UIView+MJExtension.h"

@implementation GZHRightCell

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

    self.imageView.frame = CGRectMake(5, (self.frame.size.height-25)/2, 25, 25);
    
    self.textLabel.mj_x = CGRectGetMaxX(self.imageView.frame)+5;
    self.textLabel.mj_width = self.frame.size.width-self.textLabel.mj_x-5;
   
}
@end
