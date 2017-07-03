//
//  HQLChatBubbleView.m
//  HQLChatBubbleView
//
//  Created by weplus on 2017/6/29.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "HQLChatBubbleBackgroundView.h"

#define kAngle(angle) ((angle) / 180.0 * M_PI)

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
    self.tailHeight = 5;
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
    
    /***/
    
    CGPoint pointD = CGPointMake(self.viewCornerRadius + self.tailWidth, height);
    
//    CGPoint pointA = CGPointMake(self.viewCornerRadius + self.tailWidth - self.viewCornerRadius * 0.6, height - self.viewCornerRadius * 0.3);
    
    
    CGPoint center4 = CGPointMake(self.tailWidth + self.viewCornerRadius, height - self.viewCornerRadius);
    
    UIView *center4View = [[UIView alloc] initWithFrame:CGRectMake(center4.x - 0.5, center4.y - 0.5, 1, 1)];
    [center4View setBackgroundColor:[UIColor yellowColor]];
//    [self addSubview:center4View];
    
    CGPoint pointA = [self getArcPointWithCenterPoint:center4 radius:self.viewCornerRadius radian:(kAngle(325))];
    
    UIView *pointAView = [[UIView alloc] initWithFrame:CGRectMake(pointA.x - 0.5, pointA.y - 0.5, 1, 1)];
    pointAView.backgroundColor = [UIColor blackColor];
//    [self addSubview:pointAView];
    
    CGPoint pointB = CGPointMake(0, height);
    CGPoint center = [self getTwoPointArcCenterPointWithPointA:pointA pointB:pointB arcDirectionUpOrDown:NO];
    
    CGPoint center3 = [self getTwoPointArcCenterPointWithPointA:pointD pointB:pointA arcDirectionUpOrDown:NO];
//    CGPathAddCurveToPoint(path, NULL, pointD.x, pointD.y, center3.x, center3.y, pointA.x, pointA.y);
    
    CGPathAddArc(path, NULL, self.tailWidth + self.viewCornerRadius, height - self.viewCornerRadius, self.viewCornerRadius, (kAngle(325)), (kAngle(270)), NO);
    
    CGPoint pointE = [self getArcPointWithCenterPoint:center4 radius:self.viewCornerRadius radian:kAngle(270 + 45 + 22.5)];
    
    UIView *poineEView = [[UIView alloc] initWithFrame:CGRectMake(pointE.x - 0.5, pointE.y - 0.5, 1, 1)];
    poineEView.backgroundColor = [UIColor redColor];
//    [self addSubview:poineEView];
    
//    CGPathAddArcToPoint(path, NULL, pointE.x, pointE.y, pointA.x, pointA.y, self.viewCornerRadius);
    
//    CGPathAddArcToPoint(path, NULL, self.viewCornerRadius + self.tailWidth - self.viewCornerRadius * 0.5, height, pointA.x, pointA.y, self.viewCornerRadius * 0.5);
    
    CGPathAddCurveToPoint(path, NULL, pointA.x, pointA.y, center.x, center.y, pointB.x, pointB.y);
    
    CGPoint pointC = CGPointMake(self.tailWidth, height - self.viewCornerRadius * 0.5);
    CGPoint center2 = [self getTwoPointArcCenterPointWithPointA:pointB pointB:pointC arcDirectionUpOrDown:NO];
    
    CGPathAddCurveToPoint(path, NULL, pointB.x, pointB.y, center2.x, center2.y, pointC.x, pointC.y);
    /***/
    
    CGPathAddLineToPoint(path, NULL, self.tailWidth, self.viewCornerRadius);
    CGPathAddArcToPoint(path, NULL, self.tailWidth, 0, self.tailWidth + self.viewCornerRadius, 0, self.viewCornerRadius);
    
    self.maskLayer.path = path;
}

- (void)drawBubbleWithContentView:(UIView *)contentView tailPosition:(HQLChatBubbleViewTailPosition)tailPosition {
    self.contentView = contentView;
    self.tailPosition = tailPosition;
    [self drawBubble];
}

#pragma mark - tool method

- (CGPoint)getArcPointWithCenterPoint:(CGPoint)centerPoint radius:(CGFloat)radius radian:(double)radian {
    CGFloat x = centerPoint.x + radius * sin(radian);
    CGFloat y = centerPoint.y + radius * cos(radian);
    return CGPointMake(x, y);
}

- (CGFloat)getTwoPointDistanceWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB {
    CGFloat xLine = fabs(pointA.x - pointB.x);
    CGFloat yLine = fabs(pointA.y - pointB.y);
    return sqrt(pow(xLine, 2) + pow(yLine, 2));
}

// 求两点的中点(弧线的坐标) ， yesOrNo - yes就是向上弯 no就是向下弯
- (CGPoint)getTwoPointArcCenterPointWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB arcDirectionUpOrDown:(BOOL)yesOrNo {
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
    
    // 直线方程一般式 y = kx + b --- k为斜率
    // 计算k 跟 b
    // k = (y1 - y2)/(x1 - x2)
    // b = y1 - (y1 - y2)/(x1 - x2) * x1
    // 如果x1 - x2 == 0 则直线平行于x轴 k = 0 , b = y1
    CGFloat topK , topB;
    
    if (topPoint.x - topPoint2.x == 0) {
        topK = 0;
        topB = topPoint.y;
    } else {
        topK = (topPoint.y - topPoint2.y) / (topPoint.x - topPoint2.x);
        topB = topPoint.y - (topPoint.y - topPoint2.y) / (topPoint.x - topPoint2.x) * topPoint.x;
    }
    
    CGFloat bottomK , bottomB;
    if (bottomPoint.x - bottomPoint2.x == 0) {
        bottomK = 0;
        bottomB = bottomPoint.y;
    } else {
        bottomK = (bottomPoint.y - bottomPoint2.y) / (bottomPoint.x - bottomPoint2.x);
        bottomB = bottomPoint.y - (bottomPoint.y - bottomPoint2.y) / (bottomPoint.x - bottomPoint2.x) * bottomPoint.x;
    }
    
    if (bottomK == topK) { // 斜率相等 两直线平行
        return CGPointZero;
    }
    
    // 求相交坐标
    // y = ax + b和y = cx + d两条直线的交点
    // x = (d - b)/(a - c)
    // y = a(d - b)/(a - c) + b;
    if (topK - bottomK == 0) {
        return CGPointZero;
    } else {
        CGFloat x = (bottomB - topB) / (topK - bottomK);
        CGFloat y = topK * (bottomB - topB) / (topK - bottomK) + topB;
        return CGPointMake(x, y);
    }
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
