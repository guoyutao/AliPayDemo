//
//  UIButton+Align.m
//  AliPayDemo
//
//  Created by guoyutao on 2017/6/26.
//  Copyright © 2017年 guoyutao. All rights reserved.
//

#import "UIButton+Align.h"

@implementation UIButton (Align)
- (void)alignImageAndTitleVertically {
    CGFloat padding = 6.0;
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGFloat totalHeight = imageSize.height + titleSize.height + padding;
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), (self.frame.size.width - imageSize.width) / 2 - 5, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.frame.size.width - titleSize.width) / 2 - 10, -(totalHeight - titleSize.height), 0);
}
@end
