//
//  HQLChatBubbleView.h
//  HQLChatBubbleView
//
//  Created by weplus on 2017/7/4.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HQLChatBubbleBackgroundView.h"

@interface HQLChatBubbleView : UIView

@property (assign, nonatomic) CGFloat viewMaxWidth;
@property (assign, nonatomic) CGFloat imageViewWidth;

@property (copy, nonatomic) NSString *string;
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) UIView *contentView;

@property (assign, nonatomic) CGFloat tailWidth; // 尾巴的宽度 deault 5
@property (assign, nonatomic) CGFloat tailHeight; // 尾巴的高度 default 5
@property (assign, nonatomic) CGFloat viewCornerRadius; // 圆角 default 10
@property (assign, nonatomic) CGFloat tailTopMargin; // 尾巴离顶部的margin - iMessages样式不适用 deafult 10
@property (assign, nonatomic) HQLChatBubbleViewStyle style;

- (void)drawBubble;
- (void)drawBubbleWithContentView:(UIView *)contentView tailPosition:(HQLChatBubbleViewTailPosition)tailPosition;

@end
