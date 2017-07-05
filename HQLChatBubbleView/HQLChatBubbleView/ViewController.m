//
//  ViewController.m
//  HQLChatBubbleView
//
//  Created by weplus on 2017/6/29.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "ViewController.h"

#import "HQLChatBubbleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    HQLChatBubbleView *bubbleView = [[HQLChatBubbleView alloc] initWithFrame:CGRectMake(100, 100, 10, 10)];
    bubbleView.fillColor = [UIColor greenColor];
    bubbleView.style = HQLChatBubbleViewWeChatStyle;
    bubbleView.viewCornerRadius = 5;
    bubbleView.tailWidth = 3;
    bubbleView.tailTopMargin = 5;
    [bubbleView drawBubbleWithString:@"这" tailPosition:HQLChatBubbleViewTailPositionRight];
    [self.view addSubview:bubbleView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
