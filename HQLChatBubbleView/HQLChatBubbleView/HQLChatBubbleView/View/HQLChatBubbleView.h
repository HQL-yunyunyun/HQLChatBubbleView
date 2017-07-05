//
//  HQLChatBubbleView.h
//  HQLChatBubbleView
//
//  Created by weplus on 2017/7/4.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HQLChatBubbleBackgroundView.h"

@class HQLChatBubbleView;

@protocol HQLChatBubbleViewDelegate <NSObject>

@optional
- (void)chatBubbleViewDidChageFrame:(HQLChatBubbleView *)bubbleView;

@end

@interface HQLChatBubbleView : UIView

@property (assign, nonatomic) CGFloat labelMaxWidth; // default 200
@property (assign, nonatomic) CGFloat imageViewWidth; // default 100

/*
@property (copy, nonatomic) NSString *string;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIView *contentView;
*/

@property (strong, nonatomic) UIFont *labelFont;
@property (strong, nonatomic) UIColor *labelTextColor;

@property (strong, nonatomic) UIColor *fillColor; // bubble 背景颜色
@property (assign, nonatomic) CGFloat tailWidth; // 尾巴的宽度 deault 5
@property (assign, nonatomic) CGFloat tailHeight; // 尾巴的高度 default 5
@property (assign, nonatomic) CGFloat viewCornerRadius; // 圆角 default 10
@property (assign, nonatomic) CGFloat tailTopMargin; // 尾巴离顶部的margin - iMessages样式不适用 deafult 10
@property (assign, nonatomic) HQLChatBubbleViewStyle style;

@property (assign, nonatomic) CGFloat contentViewTopMargin; // 顶部margin contentView default 0 -- label default 5
@property (assign, nonatomic) CGFloat contentViewLeftMargin; // 左边margin contentView default 0 -- label default 5 --- 要算上tailWidth
@property (assign, nonatomic) CGFloat contentViewBottomMargin; // 底部margin contentView default 0 -- label default 5 --- 要算上tailWidth
@property (assign, nonatomic) CGFloat contentViewRightMargin; // 右边margin contentView default 0 -- label default 5 

@property (assign, nonatomic) id <HQLChatBubbleViewDelegate>delegate;

- (void)drawBubble;
- (void)drawBubbleWithContentView:(UIView *)contentView tailPosition:(HQLChatBubbleViewTailPosition)tailPosition;
- (void)drawBubbleWithString:(NSString *)string tailPosition:(HQLChatBubbleViewTailPosition)tailPosition;
- (void)drawBubbleWithImage:(UIImage *)image tailPosition:(HQLChatBubbleViewTailPosition)tailPosition;

@end
