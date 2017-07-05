//
//  HQLChatBubbleView.m
//  HQLChatBubbleView
//
//  Created by weplus on 2017/7/4.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "HQLChatBubbleView.h"

#define kLabelDefaultMargin 5
#define kImageDefaultMargin 0

@interface HQLChatBubbleView () <HQLChatBubbleBackgroundViewDelegate>

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) HQLChatBubbleBackgroundView *backgroundView;

@end

@implementation HQLChatBubbleView

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
    
    self.labelTextColor = [UIColor blackColor];
    self.labelFont = [UIFont systemFontOfSize:10];
    
    self.fillColor = [UIColor whiteColor];
}

- (void)drawBubble {
    [self.backgroundView drawBubble];
}

- (void)drawBubbleWithImage:(UIImage *)image tailPosition:(HQLChatBubbleViewTailPosition)tailPosition {
    [self.label setHidden:YES];
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] init];
    }
    
    self.imageView.image = image;
    CGFloat imageViewHieght = (image.size.height * self.imageViewWidth) / image.size.width;
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageViewWidth, imageViewHieght);
    
    self.contentViewTopMargin = kImageDefaultMargin;
    self.contentViewRightMargin = kImageDefaultMargin;
    self.contentViewBottomMargin = kImageDefaultMargin;
    self.contentViewLeftMargin = kImageDefaultMargin;
    
    [self.backgroundView drawBubbleWithContentView:self.imageView tailPosition:tailPosition];
}

- (void)drawBubbleWithString:(NSString *)string tailPosition:(HQLChatBubbleViewTailPosition)tailPosition {
    [self.imageView setHidden:YES];
    if (!self.label) {
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
    }
    self.label.font = self.labelFont;
    self.label.textColor = self.labelTextColor;
    self.label.frame = CGRectMake(self.label.frame.origin.x, self.label.frame.origin.y, self.labelMaxWidth, self.label.frame.size.height);
    
    self.label.text = string;
    [self.label sizeToFit];
    
    self.contentViewTopMargin = kLabelDefaultMargin;
    self.contentViewLeftMargin = kLabelDefaultMargin + (tailPosition == HQLChatBubbleViewTailPositionLeft ? self.tailWidth : 0);
    self.contentViewBottomMargin = kLabelDefaultMargin;
    self.contentViewRightMargin = kLabelDefaultMargin + (tailPosition == HQLChatBubbleViewTailPositionRight ? self.tailWidth : 0);
    
    [self.backgroundView drawBubbleWithContentView:self.label tailPosition:tailPosition];
}

- (void)drawBubbleWithContentView:(UIView *)contentView tailPosition:(HQLChatBubbleViewTailPosition)tailPosition {
    [self.backgroundView drawBubbleWithContentView:contentView tailPosition:tailPosition];
}

#pragma mark - bubble background view delegate

- (void)chatBubbleBackgroundViewDidChangeFrame:(HQLChatBubbleBackgroundView *)bubbleBackgroundView {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, bubbleBackgroundView.frame.size.width, bubbleBackgroundView.frame.size.height);
    if ([self.delegate respondsToSelector:@selector(chatBubbleViewDidChageFrame:)]) {
        [self.delegate chatBubbleViewDidChageFrame:self];
    }
}

#pragma mark - setter

- (void)setFillColor:(UIColor *)fillColor {
    fillColor = fillColor ? fillColor : [UIColor clearColor];
    _fillColor = fillColor;
    self.backgroundView.fillColor = fillColor;
}

- (void)setTailHeight:(CGFloat)tailHeight {
    tailHeight = tailHeight < 1 ? 1 : tailHeight;
    _tailHeight = tailHeight;
    self.backgroundView.tailWidth = tailHeight;
}

- (void)setTailTopMargin:(CGFloat)tailTopMargin {
    tailTopMargin = tailTopMargin < 0 ? 0   : tailTopMargin;
    _tailTopMargin = tailTopMargin;
    self.backgroundView.tailTopMargin = tailTopMargin;
}

- (void)setViewCornerRadius:(CGFloat)viewCornerRadius {
    viewCornerRadius = viewCornerRadius < 0 ? 0 : viewCornerRadius;
    _viewCornerRadius = viewCornerRadius;
    self.backgroundView.viewCornerRadius = viewCornerRadius;
}

- (void)setTailWidth:(CGFloat)tailWidth {
    tailWidth = tailWidth < 0 ? 1 : tailWidth;
    _tailWidth = tailWidth;
    self.backgroundView.tailWidth = tailWidth;
}

- (void)setStyle:(HQLChatBubbleViewStyle)style {
    _style = style;
    self.backgroundView.style = style;
}

- (void)setLabelMaxWidth:(CGFloat)labelMaxWidth {
    labelMaxWidth = labelMaxWidth < 1 ? 1 : labelMaxWidth;
    _labelMaxWidth = labelMaxWidth;
}

- (void)setImageViewWidth:(CGFloat)imageViewWidth {
    imageViewWidth = imageViewWidth < 1 ? 1 : imageViewWidth;
    _imageViewWidth = imageViewWidth;
}

- (void)setContentViewTopMargin:(CGFloat)contentViewTopMargin {
    _contentViewTopMargin = contentViewTopMargin;
    self.backgroundView.contentViewTopMargin = contentViewTopMargin;
}

- (void)setContentViewLeftMargin:(CGFloat)contentViewLeftMargin {
    _contentViewLeftMargin = contentViewLeftMargin;
    self.backgroundView.contentViewLeftMargin = contentViewLeftMargin;
}

- (void)setContentViewBottomMargin:(CGFloat)contentViewBottomMargin {
    _contentViewBottomMargin = contentViewBottomMargin;
    self.backgroundView.contentViewBottomMargin = contentViewBottomMargin;
}

- (void)setContentViewRightMargin:(CGFloat)contentViewRightMargin {
    _contentViewRightMargin = contentViewRightMargin;
    self.backgroundView.contentViewRightMargin = contentViewRightMargin;
}

- (void)setLabelTextColor:(UIColor *)labelTextColor {
    labelTextColor = labelTextColor ? labelTextColor : [UIColor blackColor];
    _labelTextColor = labelTextColor;
}

- (void)setLabelFont:(UIFont *)labelFont {
    labelFont = labelFont ? labelFont : [UIFont systemFontOfSize:10];
    _labelFont = labelFont;
}

#pragma mark - getter

- (HQLChatBubbleBackgroundView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[HQLChatBubbleBackgroundView alloc] initWithFrame:self.bounds];
        _backgroundView.delegate = self;
        
        [self insertSubview:_backgroundView atIndex:0];
    }
    return _backgroundView;
}

@end
