//
//  HQLChatBubbleView.h
//  HQLChatBubbleView
//
//  Created by weplus on 2017/6/29.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HQLChatBubbleViewiMessageStyle , // iMessage 的样式
    HQLChatBubbleViewQQStyle , // QQ的样式
    HQLChatBubbleViewWeChatStyle , // 微信的样式
} HQLChatBubbleViewStyle;

typedef enum {
    HQLChatBubbleViewTailPositionLeft , // 在左边
    HQLChatBubbleViewTailPositionRight , // 在右边
} HQLChatBubbleViewTailPosition;

@interface HQLChatBubbleBackgroundView : UIView

@property (assign, nonatomic) CGFloat tailWidth; // 尾巴的宽度 deault 5
@property (assign, nonatomic) CGFloat tailHeight; // 尾巴的高度 default 8
@property (assign, nonatomic) CGFloat viewCornerRadius; // 圆角 default 10
@property (assign, nonatomic) CGFloat tailTopMargin; // 尾巴离顶部的margin - iMessages样式不适用 deafult 8
@property (assign, nonatomic) HQLChatBubbleViewStyle style; // 样式

@property (assign, nonatomic) CGFloat contentViewTopMargin; // 顶部margin
@property (assign, nonatomic) CGFloat contentViewLeftMargin; // 左边margin
@property (assign, nonatomic) CGFloat contentViewBottomMargin; // 底部margin
@property (assign, nonatomic) CGFloat contentViewRightMargin; // 右边margin

@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic) UIColor *borderColor;
@property (assign, nonatomic) CGFloat borderWidth;

// set contentView 的时候 会自动调用 drawBubble
//@property (strong, nonatomic) UIView *contentView; // 显示的contentView [UIimageView 或 UILabel 或其他]

- (void)drawBubbleWithContentView:(UIView *)contentView tailPosition:(HQLChatBubbleViewTailPosition)tailPosition;
- (void)drawBubble;

@end
