//
//  AnimationView.h
//  Demo_Animation
//
//  Created by liudukun on 2017/8/4.
//  Copyright © 2017年 liudukun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottleModel.h"



typedef void(^ActionBottle)(BottleModel *model);

@interface Bottle:UIView

@property (nonatomic,strong) BottleModel *model;



@end


@interface MessageBottleView : UIView

@property (nonatomic,strong) NSArray *models;

@property (nonatomic,strong) ActionBottle actionBottle;

- (void)reloadAnimation;

@end
