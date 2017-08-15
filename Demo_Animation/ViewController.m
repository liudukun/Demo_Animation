//
//  ViewController.m
//  Demo_Animation
//
//  Created by liudukun on 2017/8/4.
//  Copyright © 2017年 liudukun. All rights reserved.
//

#import "ViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "MessageBottleView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    BottleModel *model = [BottleModel new];
    model.message = @"优惠0.63/升";
    model.messageID = @"12";
    
    BottleModel *model1 = [BottleModel new];
    model1.message = @"加油送纸巾干嘛";
    model1.messageID = @"1a2";
    
    BottleModel *model2 = [BottleModel new];
    model2.message = @"96折加油";
    model2.messageID = @"123";
    
    MessageBottleView *view = [[MessageBottleView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    view.models = @[model,model1,model2];
    [view setActionBottle:^(BottleModel *model){
        NSLog(@"%@",model.message);
    }];

    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    
}



@end
