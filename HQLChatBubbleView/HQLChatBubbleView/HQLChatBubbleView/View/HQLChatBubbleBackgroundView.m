//
//  HQLChatBubbleView.m
//  HQLChatBubbleView
//
//  Created by weplus on 2017/6/29.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "HQLChatBubbleBackgroundView.h"

@interface HQLChatBubbleBackgroundView ()

@property (strong, nonatomic) CAShapeLayer *maskLayer; // layer

@property (strong, nonatomic) UIView *contentView;
@property (assign, nonatomic) HQLChatBubbleViewTailPosition tailPosition;

@end

@implementation HQLChatBubbleBackgroundView

#pragma mark - life cycle

- (instancetype)init {
    if (self = [super init]) {
        [self viewConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self viewConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self= [super initWithCoder:aDecoder]) {
        [self viewConfig];
    }
    return self;
}

#pragma mark - event

- (void)viewConfig {
    self.tailWidth = 5;
    self.tailHeight = 8;
    self.viewCornerRadius = 10;
    self.tailTopMargin = 10;
    
    self.contentViewTopMargin = 0;
    self.contentViewLeftMargin = 0;
    self.contentViewBottomMargin = 0;
    self.contentViewRightMargin = 0;
    
    self.fillColor = [UIColor whiteColor];
    self.borderColor = nil;
    self.borderWidth = 0;
}

- (void)drawBubble {
//    if (!self.contentView) {
//        return;
//    }
    
    CGFloat width = 100;
    CGFloat height = 100;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, self.viewCornerRadius + self.tailWidth, 0);
    CGPathAddLineToPoint(path, NULL, width - self.viewCornerRadius, 0);
    CGPathAddArcToPoint(path, NULL, width, 0, width, self.viewCornerRadius, self.viewCornerRadius);
    
    CGPathAddLineToPoint(path, NULL, width, height - self.viewCornerRadius);
    CGPathAddArcToPoint(path, NULL, width, height, width - self.viewCornerRadius, height, self.viewCornerRadius);
    
    CGPathAddLineToPoint(path, NULL, self.viewCornerRadius + self.tailWidth, height);
    CGPathAddArcToPoint(path, NULL, self.tailWidth, height, self.tailWidth, height - self.viewCornerRadius, self.viewCornerRadius);
    
    CGPathAddLineToPoint(path, NULL, self.tailWidth, self.viewCornerRadius);
    CGPathAddArcToPoint(path, NULL, self.tailWidth, 0, self.viewCornerRadius + self.tailWidth, 0, self.viewCornerRadius);
    
    CGPathMoveToPoint(path, NULL, self.tailWidth, self.tailTopMargin + self.tailHeight);
    
    CGPathAddArcToPoint(path, NULL, 0, self.tailTopMargin + self.tailHeight, 0, (self.tailTopMargin + self.tailHeight - self.tailWidth), self.tailWidth);
    
//    CGPathAddLineToPoint(path, NULL, 0, self.tailTopMargin + self.tailHeight * 0.5);
//    
//    CGFloat x = [self getArcXWithArcCenter:CGPointMake(self.viewCornerRadius + self.tailWidth, self.viewCornerRadius) arcY:self.tailTopMargin radius:self.viewCornerRadius];
//    
//    CGPathAddLineToPoint( path, NULL, x, self.tailTopMargin);
    
//    CGPathCloseSubpath(path);
    
    self.maskLayer.path = path;
}

- (void)drawBubbleWithContentView:(UIView *)contentView tailPosition:(HQLChatBubbleViewTailPosition)tailPosition {
    self.contentView = contentView;
    self.tailPosition = tailPosition;
    [self drawBubble];
}

#pragma mark - tool method

// 求两点的中点(弧线的坐标) ， yesOrNo - yes就是向上弯 no就是向下弯
- (CGPoint)getTwoPointArcCenterPointWitPointA:(CGPoint)pointA pointB:(CGPoint)pointB arcDirectionUpOrDown:(BOOL)yesOrNo {
    if (pointA.x == pointB.x) {
        return CGPointMake(pointA.x, fabs(pointA.y - pointB.y) * 0.5);
    } else if (pointA.y == pointB.y) {
        return CGPointMake(fabs(pointA.x - pointB.x) * 0.5, pointA.y);
    }
    
    CGPoint topPoint2;
    CGPoint bottomPoint2;
    CGPoint topPoint = pointA.y < pointB.y ? pointA : pointB;
    CGPoint bottomPoint = pointA.y > pointB.y ? pointA : pointB;
    
    if (yesOrNo) { // 弧线向上
        bottomPoint2.y = topPoint.y;
        if (topPoint.x < bottomPoint.x) {
            bottomPoint2.x = topPoint.x + (bottomPoint.x - topPoint.x) * 0.5;
        } else {
            bottomPoint2.x = bottomPoint.x + (topPoint.x - bottomPoint.x) * 0.5;
        }
        
        topPoint2 = CGPointMake(bottomPoint.x, topPoint.y + (bottomPoint.y - topPoint.y) * 0.5);
    } else {
        topPoint2.y = bottomPoint.y;
        if (topPoint.x < bottomPoint.x) {
            topPoint2.x = topPoint.x + (bottomPoint.x - topPoint.x) * 0.5;
        } else {
            topPoint2.x = bottomPoint.x + (topPoint.x - bottomPoint.x) * 0.5;
        }
        
        bottomPoint2.y = topPoint.y + (bottomPoint.y - topPoint.y) * 0.5;
        bottomPoint2.x = topPoint.x;
    }
    
    
    
    return CGPointZero;
}

// 根据圆轨迹方程 获得x
- (CGFloat)getArcXWithArcCenter:(CGPoint)arcCenter arcY:(CGFloat)arcY radius:(CGFloat)radius {
    if (radius < 0) {
        return 0;
    }
    CGFloat centerX = arcCenter.x;
    CGFloat centerY = arcCenter.y;
    return (centerX - sqrt(pow(radius, 2) - pow((centerY - arcY), 2)));
}

// 根据圆轨迹方程 获得y
- (CGFloat)getArcYWithArcCenter:(CGPoint)arcCenter arcX:(CGFloat)arcX radius:(CGFloat)radius {
    if (radius < 0) {
        return 0;
    }
    CGFloat centerX = arcCenter.x;
    CGFloat centerY = arcCenter.y;
    return (centerY - sqrt(pow(radius, 2) - pow((centerX - arcX), 2)));
}

#pragma mark - setter

- (void)setFillColor:(UIColor *)fillColor {
    fillColor = fillColor ? fillColor : [UIColor clearColor];
    _fillColor = fillColor;
    self.maskLayer.fillColor = fillColor.CGColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
    borderColor = borderColor ? borderColor : [UIColor clearColor];
    _borderColor = borderColor;
    self.maskLayer.strokeColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    borderWidth = borderWidth < 0 ? 0 : borderWidth;
    self.maskLayer.borderWidth = borderWidth;
}

#pragma mark - getter

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [[CAShapeLayer alloc] init];
//        _maskLayer.frame = self.bounds;
        
        [self.layer addSublayer:_maskLayer];
    }
    return _maskLayer;
}

@end
