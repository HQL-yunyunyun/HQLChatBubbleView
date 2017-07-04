//
//  HQLChatBubbleView.m
//  HQLChatBubbleView
//
//  Created by weplus on 2017/6/29.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "HQLChatBubbleBackgroundView.h"

#define kAngle(angle) ((angle) / 180.0 * M_PI)
#define kiMessageArcAngle 40

#define kMinViewWidth 20
#define kMinViewHeight 20

typedef enum {
    HQLPointPositionInCircleRightTop, // 右上角
    HQLPointPositionInCircleLeftTop, // 左上角
    HQLPointPositionInCircleRightDown, // 右下角
    HQLPointPositionInCircleLeftDown, // 左下角
} HQLPointPositionInCircle;

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
    
    self.fillColor = [UIColor blueColor];
}

- (void)drawBubble {
    if (!self.contentView) {
        return;
    }
    
    CGFloat width = self.contentView.frame.size.width + self.contentViewLeftMargin + self.contentViewRightMargin;
    if (width < 2 * self.viewCornerRadius) {
        width = 2 * self.viewCornerRadius;
    }
    if (width < kMinViewWidth) {
        width = kMinViewWidth;
    }
    
    CGFloat height = self.contentView.frame.size.height + self.contentViewTopMargin + self.contentViewBottomMargin;
    if (height < 2 * self.viewCornerRadius) {
        height = 2 * self.viewCornerRadius;
    }
    if (height < kMinViewHeight) {
        height = kMinViewHeight;
    }
    
    if (self.tailHeight > height) {
        self.tailHeight = 5;
    }
    if (self.tailTopMargin + self.tailHeight > height) {
        self.tailTopMargin = self.viewCornerRadius;
    }
    
    
    CGSize size = CGSizeMake(width, height);
    
    self.contentView.frame = CGRectMake(self.contentViewLeftMargin, self.contentViewTopMargin, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    
    if ([self.delegate respondsToSelector:@selector(chatBubbleBackgroundViewDidChangeFrame:)]) {
        [self.delegate chatBubbleBackgroundViewDidChangeFrame:self];
    }
    
    switch (self.style) {
        case HQLChatBubbleViewWeChatStyle: {
            self.maskLayer.path = [self createBubbleWechatStylePathWithSize:size];
            break;
        }
        case HQLChatBubbleViewQQStyle: {
            self.maskLayer.path = [self createBubbleQQStylePathWithSize:size];
            break;
        }
        case HQLChatBubbleViewiMessageStyle: {
            self.maskLayer.path = [self createBubbleiMessageStylePathWithSize:size];
            break;
        }
    }
}

- (void)drawBubbleWithContentView:(UIView *)contentView tailPosition:(HQLChatBubbleViewTailPosition)tailPosition {
    // 将以前的contentView移除
    [self.contentView removeFromSuperview];
    [self addSubview:contentView];
    
    self.contentView = contentView;
    self.tailPosition = tailPosition;
    [self drawBubble];
}

#pragma mark - create path method

// 创建iMessage样式的path
- (CGMutablePathRef)createBubbleiMessageStylePathWithSize:(CGSize)pathSize {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint firstCornerEndPoint, firstCornerBeginPoint, firstCornerMidPoint;
    CGPoint secondCornerBeginPoint, secondCornerMidPoint, secondCornerEndPoint;
    CGPoint thirdCornerBeginPoint, thirdCornerMidPoint, thirdCornerEndPoint;
    CGPoint fourthCornerBeginPoint;
    CGPoint tailBottomBeginPoint, tailTipPoint, tailTopEndPoint;
    
    CGPoint tailArcCenterPoint;
    
    CGFloat startAngle, endAngle;
    
    CGFloat leftX, rightX; // 每个点在框上的 就是边边的x
    
    BOOL closewise;
    
    switch (self.tailPosition) {
        case HQLChatBubbleViewTailPositionLeft: {
            leftX = self.tailWidth;
            
            firstCornerBeginPoint = CGPointMake(leftX, self.viewCornerRadius);
            firstCornerMidPoint = CGPointMake(leftX, 0);
            firstCornerEndPoint = CGPointMake(leftX + self.viewCornerRadius, 0);
            
            secondCornerBeginPoint = CGPointMake(pathSize.width - self.viewCornerRadius, 0);
            secondCornerMidPoint = CGPointMake(pathSize.width, 0);
            secondCornerEndPoint = CGPointMake(pathSize.width, self.viewCornerRadius);
            
            thirdCornerBeginPoint = CGPointMake(pathSize.width, pathSize.height - self.viewCornerRadius);
            thirdCornerMidPoint = CGPointMake(pathSize.width, pathSize.height);
            thirdCornerEndPoint = CGPointMake(pathSize.width - self.viewCornerRadius, pathSize.height);
            
            fourthCornerBeginPoint = CGPointMake(leftX + self.viewCornerRadius, pathSize.height);
            
            tailArcCenterPoint = CGPointMake(leftX + self.viewCornerRadius, pathSize.height - self.viewCornerRadius);
            
            tailBottomBeginPoint = [self getArcPointWithCenterPoint:tailArcCenterPoint radius:self.viewCornerRadius radian:kAngle(-kiMessageArcAngle)];
            tailTipPoint = CGPointMake(0, pathSize.height);
            tailTopEndPoint = CGPointMake(leftX, pathSize.height - self.viewCornerRadius * 0.5);
            
            startAngle = kAngle(90);
            endAngle = kAngle(90 + kiMessageArcAngle);
            closewise = NO;
            
            break;
        }
        case HQLChatBubbleViewTailPositionRight: {
            rightX = pathSize.width - self.tailWidth;
            
            firstCornerBeginPoint = CGPointMake(rightX, self.viewCornerRadius);
            firstCornerMidPoint = CGPointMake(rightX, 0);
            firstCornerEndPoint = CGPointMake(rightX - self.viewCornerRadius, 0);
            
            secondCornerBeginPoint = CGPointMake(self.viewCornerRadius, 0);
            secondCornerMidPoint = CGPointMake(0, 0);
            secondCornerEndPoint = CGPointMake(0, self.viewCornerRadius);
            
            thirdCornerBeginPoint = CGPointMake(0, pathSize.height - self.viewCornerRadius);
            thirdCornerMidPoint = CGPointMake(0, pathSize.height);
            thirdCornerEndPoint = CGPointMake(self.viewCornerRadius, pathSize.height);
            
            fourthCornerBeginPoint = CGPointMake(rightX - self.viewCornerRadius, pathSize.height);
            
            tailArcCenterPoint = CGPointMake(rightX - self.viewCornerRadius, pathSize.height - self.viewCornerRadius);
            
            tailBottomBeginPoint = [self getArcPointWithCenterPoint:tailArcCenterPoint radius:self.viewCornerRadius radian:kAngle(kiMessageArcAngle)];
            tailTipPoint = CGPointMake(pathSize.width, pathSize.height);
            tailTopEndPoint = CGPointMake(rightX, pathSize.height - self.viewCornerRadius * 0.5);
            
            startAngle = kAngle(90);
            endAngle = kAngle(90 - kiMessageArcAngle);
            closewise = YES;
            
            break;
        }
    }
    
    CGPathMoveToPoint(path, NULL, firstCornerEndPoint.x, firstCornerEndPoint.y);
    CGPathAddLineToPoint(path, NULL, secondCornerBeginPoint.x, secondCornerBeginPoint.y);
    CGPathAddArcToPoint(path, NULL, secondCornerMidPoint.x, secondCornerMidPoint.y, secondCornerEndPoint.x, secondCornerEndPoint.y, self.viewCornerRadius);
    
    CGPathAddLineToPoint(path, NULL, thirdCornerBeginPoint.x, thirdCornerBeginPoint.y);
    CGPathAddArcToPoint(path, NULL, thirdCornerMidPoint.x, thirdCornerMidPoint.y, thirdCornerEndPoint.x, thirdCornerEndPoint.y, self.viewCornerRadius);
    
    CGPathAddArc(path, NULL, tailArcCenterPoint.x, tailArcCenterPoint.y, self.viewCornerRadius, startAngle, endAngle, closewise);
    
    CGPoint tailBottomMidPoint = [self getTwoPointArcCenterPointWithPointA:tailBottomBeginPoint pointB:tailTipPoint arcDirectionUpOrDown:NO];
    CGPathAddCurveToPoint(path, NULL, tailBottomBeginPoint.x, tailBottomBeginPoint.y, tailBottomMidPoint.x, tailBottomMidPoint.y, tailTipPoint.x, tailTipPoint.y);
    
    CGPoint tailTopMidPint = [self getTwoPointArcCenterPointWithPointA:tailTipPoint pointB:tailTopEndPoint arcDirectionUpOrDown:NO];
    CGPathAddCurveToPoint(path, NULL, tailTipPoint.x, tailTipPoint.y, tailTopMidPint.x, tailTopMidPint.y, tailTopEndPoint.x, tailTopEndPoint.y);
    
    CGPathAddLineToPoint(path, NULL, firstCornerBeginPoint.x, firstCornerBeginPoint.y);
    CGPathAddArcToPoint(path, NULL, firstCornerMidPoint.x, firstCornerMidPoint.y, firstCornerEndPoint.x, firstCornerEndPoint.y, self.viewCornerRadius);
    
    return path;
}

// 三角形
- (CGMutablePathRef)createBubbleWechatStylePathWithSize:(CGSize)size {
    CGMutablePathRef path = [self createCornerPathWithSize:size];
    
    CGPoint topPoint, bottomPoint, midPoint;
    
    midPoint = CGPointMake(0, self.tailTopMargin + self.tailHeight * 0.5);
    topPoint = CGPointMake(0, self.tailTopMargin);
    bottomPoint = CGPointMake(0, self.tailTopMargin + self.tailHeight);
    
    switch (self.tailPosition) {
        case HQLChatBubbleViewTailPositionLeft: {
            CGPoint topCenter = CGPointMake(self.tailWidth + self.viewCornerRadius, self.viewCornerRadius);
            CGPoint bottomCenter = CGPointMake(self.tailWidth + self.viewCornerRadius, size.height - self.viewCornerRadius);
            
            if (self.tailTopMargin < self.viewCornerRadius) {
                topPoint.x = [self getArcXWithArcCenter:topCenter arcY:topPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleLeftTop];
            } else if (self.tailTopMargin > size.height - self.viewCornerRadius) {
                topPoint.x = [self getArcXWithArcCenter:bottomCenter arcY:topPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleLeftDown];
            } else {
                topPoint.x = self.tailWidth;
            }
            
            if (self.tailTopMargin + self.tailHeight < self.viewCornerRadius) {
                bottomPoint.x = [self getArcXWithArcCenter:topCenter arcY:bottomPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleLeftTop];
            } else if (self.tailTopMargin + self.tailHeight > size.height - self.viewCornerRadius) {
                bottomPoint.x = [self getArcXWithArcCenter:bottomCenter arcY:bottomPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleLeftDown];
            } else {
                bottomPoint.x = self.tailWidth;
            }
            
            midPoint.x = 0;
            
            break;
        }
        case HQLChatBubbleViewTailPositionRight: {
            
            CGPoint topCenter = CGPointMake(size.width - self.tailWidth - self.viewCornerRadius, self.viewCornerRadius);
            CGPoint bottomCenter = CGPointMake(size.width - self.tailWidth - self.viewCornerRadius, size.height - self.viewCornerRadius);
            
            if (self.tailTopMargin < self.viewCornerRadius) {
                topPoint.x = [self getArcXWithArcCenter:topCenter arcY:topPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleRightTop];
            } else if (self.tailTopMargin > size.height - self.viewCornerRadius) {
                topPoint.x = [self getArcXWithArcCenter:bottomCenter arcY:topPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleRightDown];
            } else {
                topPoint.x = size.width - self.tailWidth;
            }
            
            if (self.tailTopMargin + self.tailHeight < self.viewCornerRadius) {
                bottomPoint.x = [self getArcXWithArcCenter:topCenter arcY:bottomPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleRightTop];
            } else if (self.tailTopMargin + self.tailHeight > size.height - self.viewCornerRadius) {
                bottomPoint.x = [self getArcXWithArcCenter:bottomCenter arcY:bottomPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleRightDown];
            } else {
                bottomPoint.x = size.width - self.tailWidth;
            }
            
            midPoint.x = size.width;
            
            break;
        }
    }
    
    CGPathMoveToPoint(path, NULL, topPoint.x, topPoint.y);
    CGPathAddLineToPoint(path, NULL, midPoint.x, midPoint.y);
    CGPathAddLineToPoint(path, NULL, bottomPoint.x, bottomPoint.y);
    
    return path;
}

- (CGMutablePathRef)createBubbleQQStylePathWithSize:(CGSize)size {
    CGMutablePathRef path = [self createCornerPathWithSize:size];
    
    CGPoint topPoint, bottomPoint, midPoint;
    
    midPoint = CGPointMake(0, self.tailTopMargin - self.tailHeight * 0.5);
    topPoint = CGPointMake(0, self.tailTopMargin);
    bottomPoint = CGPointMake(0, self.tailTopMargin + self.tailHeight);
    
    switch (self.tailPosition) {
        case HQLChatBubbleViewTailPositionLeft: {
            CGPoint topCenter = CGPointMake(self.tailWidth + self.viewCornerRadius, self.viewCornerRadius);
            CGPoint bottomCenter = CGPointMake(self.tailWidth + self.viewCornerRadius, size.height - self.viewCornerRadius);
            
            if (self.tailTopMargin < self.viewCornerRadius) {
                topPoint.x = [self getArcXWithArcCenter:topCenter arcY:topPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleLeftTop];
            } else if (self.tailTopMargin > size.height - self.viewCornerRadius) {
                topPoint.x = [self getArcXWithArcCenter:bottomCenter arcY:topPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleLeftDown];
            } else {
                topPoint.x = self.tailWidth;
            }
            
            if (self.tailTopMargin + self.tailHeight < self.viewCornerRadius) {
                bottomPoint.x = [self getArcXWithArcCenter:topCenter arcY:bottomPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleLeftTop];
            } else if (self.tailTopMargin + self.tailHeight > size.height - self.viewCornerRadius) {
                bottomPoint.x = [self getArcXWithArcCenter:bottomCenter arcY:bottomPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleLeftDown];
            } else {
                bottomPoint.x = self.tailWidth;
            }
            
            midPoint.x = 0;
            
            break;
        }
        case HQLChatBubbleViewTailPositionRight: {
            
            CGPoint topCenter = CGPointMake(size.width - self.tailWidth - self.viewCornerRadius, self.viewCornerRadius);
            CGPoint bottomCenter = CGPointMake(size.width - self.tailWidth - self.viewCornerRadius, size.height - self.viewCornerRadius);
            
            if (self.tailTopMargin < self.viewCornerRadius) {
                topPoint.x = [self getArcXWithArcCenter:topCenter arcY:topPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleRightTop];
            } else if (self.tailTopMargin > size.height - self.viewCornerRadius) {
                topPoint.x = [self getArcXWithArcCenter:bottomCenter arcY:topPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleRightDown];
            } else {
                topPoint.x = size.width - self.tailWidth;
            }
            
            if (self.tailTopMargin + self.tailHeight < self.viewCornerRadius) {
                bottomPoint.x = [self getArcXWithArcCenter:topCenter arcY:bottomPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleRightTop];
            } else if (self.tailTopMargin + self.tailHeight > size.height - self.viewCornerRadius) {
                bottomPoint.x = [self getArcXWithArcCenter:bottomCenter arcY:bottomPoint.y radius:self.viewCornerRadius pointPosition:HQLPointPositionInCircleRightDown];
            } else {
                bottomPoint.x = size.width - self.tailWidth;
            }
            
            midPoint.x = size.width;
            
            break;
        }
    }
    
    CGPoint topLineMidPoint = [self getTwoPointArcCenterPointWithPointA:topPoint pointB:midPoint arcDirectionUpOrDown:NO];
    CGPoint bottomLineMidPoint = [self getTwoPointArcCenterPointWithPointA:midPoint pointB:bottomPoint arcDirectionUpOrDown:NO];
    
    CGPathMoveToPoint(path, NULL, bottomPoint.x, bottomPoint.y);
    CGPathAddCurveToPoint(path, NULL, bottomPoint.x, bottomPoint.y, bottomLineMidPoint.x, bottomLineMidPoint.y, midPoint.x, midPoint.y);
    CGPathAddCurveToPoint(path, NULL, midPoint.x, midPoint.y, topLineMidPoint.x, topLineMidPoint.y, topPoint.x, topPoint.y);
    
    return path;
}

- (CGMutablePathRef)createCornerPathWithSize:(CGSize)size {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat leftX, rightX;
    switch (self.tailPosition) {
        case HQLChatBubbleViewTailPositionLeft: {
            leftX = self.tailWidth;
            rightX = size.width;
            break;
        }
        case HQLChatBubbleViewTailPositionRight: {
            leftX = 0;
            rightX = size.width - self.tailWidth;
            break;
        }
    }
    
    CGPathMoveToPoint(path, NULL, leftX + self.viewCornerRadius, 0);
    CGPathAddLineToPoint(path, NULL, rightX - self.viewCornerRadius, 0);
    CGPathAddArcToPoint(path, NULL, rightX, 0, rightX, self.viewCornerRadius, self.viewCornerRadius);
    
    CGPathAddLineToPoint(path, NULL, rightX, size.height - self.viewCornerRadius);
    CGPathAddArcToPoint(path, NULL, rightX, size.height, rightX - self.viewCornerRadius, size.height, self.viewCornerRadius);
    
    CGPathAddLineToPoint(path, NULL, leftX + self.viewCornerRadius, size.height);
    CGPathAddArcToPoint(path, NULL, leftX, size.height, leftX, size.height - self.viewCornerRadius, self.viewCornerRadius);
    
    CGPathAddLineToPoint(path, NULL, leftX, self.viewCornerRadius);
    CGPathAddArcToPoint(path, NULL, leftX, 0, leftX + self.viewCornerRadius, 0, self.viewCornerRadius);
    
    return path;
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
- (CGFloat)getArcXWithArcCenter:(CGPoint)arcCenter arcY:(CGFloat)arcY radius:(CGFloat)radius pointPosition:(HQLPointPositionInCircle)pointPosition {
    if (radius < 0) {
        return 0;
    }
    CGFloat centerX = arcCenter.x;
    CGFloat centerY = arcCenter.y;
    CGFloat result = (centerX - sqrt(pow(radius, 2) - pow((centerY - arcY), 2)));
    // 根据位置获得坐标
    switch (pointPosition) {
        case HQLPointPositionInCircleLeftTop:
        case HQLPointPositionInCircleLeftDown: {
            return result;
        }
        case HQLPointPositionInCircleRightTop:
        case HQLPointPositionInCircleRightDown: {
            CGFloat distance = fabs(centerX - result);
            result = result + 2 * distance;
            return result;
        }
    }
}

// 根据圆轨迹方程 获得y
- (CGFloat)getArcYWithArcCenter:(CGPoint)arcCenter arcX:(CGFloat)arcX radius:(CGFloat)radius pointPosition:(HQLPointPositionInCircle)pointPosition {
    if (radius < 0) {
        return 0;
    }
    CGFloat centerX = arcCenter.x;
    CGFloat centerY = arcCenter.y;
    CGFloat result = (centerY - sqrt(pow(radius, 2) - pow((centerX - arcX), 2)));
    // 根据位置获得坐标
    switch (pointPosition) {
        case HQLPointPositionInCircleLeftTop:
        case HQLPointPositionInCircleRightTop:{
            return result;
        }
        case HQLPointPositionInCircleLeftDown:
        case HQLPointPositionInCircleRightDown: {
            CGFloat distance = fabs(centerY - result);
            result = result + 2 * distance;
            return result;
        }
    }
}

#pragma mark - setter

- (void)setFillColor:(UIColor *)fillColor {
    fillColor = fillColor ? fillColor : [UIColor clearColor];
    _fillColor = fillColor;
    self.layer.backgroundColor = fillColor.CGColor;
}

- (void)setTailHeight:(CGFloat)tailHeight {
    tailHeight = tailHeight < 1 ? 1 : tailHeight;
    _tailHeight = tailHeight;
}

- (void)setTailTopMargin:(CGFloat)tailTopMargin {
    tailTopMargin = tailTopMargin < 0 ? 0   : tailTopMargin;
    _tailTopMargin = tailTopMargin;
}

- (void)setViewCornerRadius:(CGFloat)viewCornerRadius {
    viewCornerRadius = viewCornerRadius < 0 ? 0 : viewCornerRadius;
    _viewCornerRadius = viewCornerRadius;
}

#pragma mark - getter

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [[CAShapeLayer alloc] init];

        self.layer.mask = _maskLayer;
    }
    return _maskLayer;
}

@end
