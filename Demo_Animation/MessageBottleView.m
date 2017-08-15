//
//  AnimationView.m
//  Demo_Animation
//
//  Created by liudukun on 2017/8/4.
//  Copyright © 2017年 liudukun. All rights reserved.
//

#import "MessageBottleView.h"


@interface Bottle()
{
    CGFloat hideHeight;
    CGFloat selfWidth;
    NSDictionary *attr ;
    CGFloat bottleWidth;
}

@end

@implementation Bottle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        bottleWidth = frame.size.width;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    NSString * randomBottle = [NSString stringWithFormat:@"bottle-%i",1+arc4random_uniform(1)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    int time = [str intValue];
    NSString * frame;
    
    if (time>=18||time<=06) {
        frame = @"frame-2";
    }
    else{
        frame = @"frame-1";
    }
    
    UIImage *bottleImage = [UIImage imageNamed:randomBottle];
    UIImage *frameImage = [UIImage imageNamed:frame];
    CGSize bottleSize = bottleImage.size;
    
    [frameImage drawInRect:CGRectMake(0, 0, selfWidth,  70)];
    [self.model.message drawInRect:CGRectMake(20, 70 /4.5, selfWidth, 50) withAttributes:attr];
    
    
    CGFloat bottleHeight = selfWidth * bottleSize.height/bottleSize.width;
    [bottleImage drawInRect:CGRectMake(0, 70 - 10,  rect.size.width/5*4, bottleHeight)];
    
}

- (void)setModel:(BottleModel *)model{
    _model = model;
    attr = @{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:8],NSForegroundColorAttributeName:[UIColor colorWithRed:43.0/255 green:98.0/255 blue:149.0/255 alpha:1]};
    CGSize size =  [self.model.message sizeWithAttributes:attr];
    selfWidth = size.width + 40;
    CGRect rect = self.frame;
    rect.size.width = selfWidth;
    self.frame = rect;
    
    [self setNeedsDisplay];
}



@end



@interface MessageBottleView ()<CAAnimationDelegate>
{
    int count;
    NSMutableArray *bottles;
}
@end

@implementation MessageBottleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.bounds];
        bgView.image = [UIImage imageNamed:@"bg_light"];
        bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:bgView];
        bottles = [NSMutableArray array];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)tapGesture:(UITapGestureRecognizer *)tap{
    CGPoint touchPoint = [tap locationInView:self];
    [bottles enumerateObjectsUsingBlock:^(Bottle  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.layer.presentationLayer hitTest:touchPoint]) {
            self.actionBottle(obj.model);
        }
    }];
    
    
}

- (void)setModels:(NSArray *)models{
    _models = models;
    
    NSTimer *timer =  [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerCreate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}

- (void)timerCreate{
    
    if (count % 2 == 0) {
        [self createSeagull];
    }
    if (count % 3 == 0) {
        [self createBallon];
    }
    
    [self createBottleWithModel:self.models[count%self.models.count]];
    count ++;
}

- (void)createSeagull{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"seagull-%i",arc4random_uniform(2)+1]];
    UIImageView *seagull = [[UIImageView alloc]init];
    seagull.frame = CGRectMake(-100, -100, 40, 40 / image.size.width * image.size.height);
    seagull.image = image;
    [self insertSubview:seagull atIndex:1];
    
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animate.path = [self seagullPath];
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)];

    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    [group setValue:seagull forKey:@"seagull"];
    group.duration = 4;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;

    group.animations = @[scaleAnim,animate];
    [seagull.layer addAnimation:group forKey:@"runSeagull"];
    group.removedOnCompletion = NO;
    CGPathRelease(animate.path);
    
}

- (void)createBallon{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ballon-%i",arc4random_uniform(2)+1]];
    UIImageView *ballon = [[UIImageView alloc]init];
    ballon.frame = CGRectMake(-100, -100, 40, 40 / image.size.width * image.size.height);
    ballon.image = image;
    [self insertSubview:ballon atIndex:1];
    
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animate.path = [self ballonPath];
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    [group setValue:ballon forKey:@"ballon"];
    group.duration = 10;
    group.repeatCount = 1;
    group.fillMode = kCAFillModeForwards;
    
    group.animations = @[scaleAnim,animate];
    [ballon.layer addAnimation:group forKey:@"runBallon"];
    group.removedOnCompletion = NO;
    CGPathRelease(animate.path);
    
}


- (void)createBottleWithModel:(BottleModel *)model{
    Bottle *bottle = [[Bottle alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/8, self.frame.size.width/4)];
    bottle.model = model;
    [self addSubview:bottle];
    [bottles addObject:bottle];
    
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animate setValue:bottle forKey:@"bottle-1"];
    animate.duration = 20;
    animate.delegate = self;
    animate.fillMode = kCAFillModeForwards;
    animate.repeatCount = 0;
    animate.path = [self bottlePath];
    animate.removedOnCompletion = NO;
    [bottle.layer addAnimation:animate forKey:@"runbottle"];
    
    CGPathRelease(animate.path);
}

- (CGPathRef )ballonPath{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint startPoint = CGPointMake(self.frame.size.width - 40, 100);
    CGPoint endPoint = CGPointMake(arc4random_uniform(100)+120,0);
    CGPoint controlPoint = CGPointMake(endPoint.x/3 ,startPoint.y/3);
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddQuadCurveToPoint(path, NULL, controlPoint.x , controlPoint.y, endPoint.x, endPoint.y);
    return path;
}

- (CGPathRef )seagullPath{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint startPoint = CGPointMake(0, arc4random_uniform(120));
    CGPoint endPoint = CGPointMake(self.frame.size.width -  arc4random_uniform(120),0);
    CGPoint controlPoint = CGPointMake(endPoint.x/2 ,startPoint.y/3);
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddQuadCurveToPoint(path, NULL, controlPoint.x , controlPoint.y, endPoint.x, endPoint.y);
    return path;
}

- (CGPathRef )bottlePath{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat w = self.frame.size.width/5;
    CGFloat baseLine = 100;
    CGFloat jump = 50;
    
    for (int i =0; i<10; i++) {
        CGFloat h = 0;
        if (i%2 ==0) {
            h = baseLine - arc4random_uniform(jump);
        }else{
            h = arc4random_uniform(jump)+ baseLine;
        }
        
        CGPoint startPoint = CGPointMake(w*i, baseLine);
        CGPoint endPoint = CGPointMake(w*(i+1),baseLine);
        CGPoint controlPoint = CGPointMake(w*(i+1) + arc4random_uniform(w) , h);
        CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
        CGPathAddQuadCurveToPoint(path, NULL, controlPoint.x , controlPoint.y, endPoint.x, endPoint.y);
    }
    
    return path;
}


- (void)animationDidStart:(CAAnimation *)anim{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    Bottle *bottle = [anim valueForKey:@"bottle-1"];
    [bottle removeFromSuperview];
    
    UIImageView *seagull = [anim valueForKey:@"seagull"];
    [seagull removeFromSuperview];
    
    UIImageView *ballon = [anim valueForKey:@"ballon"];
    [ballon removeFromSuperview];
    
}

@end
