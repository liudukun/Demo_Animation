//
//  AnimationView.h
//  Demo_Animation
//
//  Created by liudukun on 2017/8/4.
//  Copyright © 2017年 liudukun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottleModel.h"


///点击漂流瓶block
typedef void(^ActionBottle)(BottleModel *model);

/// 漂流瓶
@interface Bottle:UIView

@property (nonatomic,strong) BottleModel *model;

@end


@interface MessageBottleView : UIView

//
@property (nonatomic,strong) NSArray *models;

//点击漂流瓶调用
@property (nonatomic,strong) ActionBottle actionBottle;

//开始动画或重新开始动画,用initWithFrame方法初始化,在viewWillAppear方法需要调用此方法.
- (void)reloadAnimation;

@end
