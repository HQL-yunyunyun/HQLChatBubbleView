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

@interface HQLChatBubbleView : UIView

@property (strong, nonatomic) UIView *contentView; // 显示的contentView [UIimageView 或 UILabel 或其他]
@property (assign, nonatomic) CGFloat tailWidth; // 尾巴的宽度
@property (assign, nonatomic) CGFloat tailHeight; // 尾巴的高度
@property (assign, nonatomic) CGFloat viewCornerRadius; // 圆角
@property (assign, nonatomic) CGFloat tailTopMargin; // 尾巴离顶部的margin - iMessages样式不适用
@property (assign, nonatomic) HQLChatBubbleViewStyle style; // 样式

@end
