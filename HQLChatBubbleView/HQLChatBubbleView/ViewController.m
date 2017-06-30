//
//  ViewController.m
//  HQLChatBubbleView
//
//  Created by weplus on 2017/6/29.
//  Copyright © 2017年 weplus. All rights reserved.
//

#import "ViewController.h"

#import "HQLChatBubbleBackgroundView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    HQLChatBubbleBackgroundView *backView = [[HQLChatBubbleBackgroundView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    backView.backgroundColor = [UIColor blueColor];
    
    [backView drawBubble];
    [self.view addSubview:backView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
