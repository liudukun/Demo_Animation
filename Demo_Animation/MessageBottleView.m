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
    UIImageView *frameImageView;
    UILabel *messageLabel;
    UIImageView *bottleImageView;
}

@end

@implementation Bottle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)loadView{
    NSString * randomBottle = [NSString stringWithFormat:@"bottle-%i",1+arc4random_uniform(4)];
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
    
    frameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, selfWidth, 70)];
    frameImageView.image = frameImage;
    [self addSubview:frameImageView];
    
    messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, selfWidth, 50)];
    messageLabel.attributedText = [[NSAttributedString alloc]initWithString:self.model.message attributes:attr];
    [self addSubview:messageLabel];

    CGFloat bottleWidth = 80;
    CGFloat bottleHeight = bottleWidth * bottleSize.height/bottleSize.width;
    bottleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((selfWidth - bottleWidth)/2, 70 - 5,  bottleWidth, bottleHeight)];
    bottleImageView.image = bottleImage;
    [self addSubview:bottleImageView];
    CGRect rect = self.frame;
    rect.size.height = CGRectGetMaxY(bottleImageView.frame) - bottleHeight/2.5;
    self.frame = rect;
    
    [self runAnimation];
}

- (void)setModel:(BottleModel *)model{
    _model = model;
    attr = @{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:10],NSForegroundColorAttributeName:[UIColor colorWithRed:43.0/255 green:98.0/255 blue:149.0/255 alpha:1]};
    CGSize size =  [self.model.message sizeWithAttributes:attr];
    selfWidth = size.width + 40;
    CGRect rect = self.frame;
    rect.size.width = selfWidth;
    self.frame = rect;
    
    [self loadView];
}

- (void)runAnimation{
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animate.repeatCount = CGFLOAT_MAX;
    animate.fillMode = kCAFillModeForwards;
    animate.autoreverses = YES;
    animate.duration = 6;
    animate.byValue = @(3.14/360*30);
    [bottleImageView.layer addAnimation:animate forKey:@"runwave"];
}

@end



@interface MessageBottleView ()<CAAnimationDelegate>
{
    int count;
    NSMutableArray *bottles;
    NSTimer *timer ;
    BOOL isNight;
}
@end

@implementation MessageBottleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        bottles = [NSMutableArray array];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
    return self;
}

- (void)tapGesture:(UITapGestureRecognizer *)tap{
    CGPoint touchPoint = [tap locationInView:self];
    [bottles enumerateObjectsUsingBlock:^(Bottle  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.layer.presentationLayer hitTest:touchPoint]) {
            self.actionBottle(obj.model);
            *stop = YES;
        }
    }];
    
}

- (void)setModels:(NSArray *)models{
    _models = models;
}

- (void)reloadAnimation{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:bgView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    int time = [str intValue];
    NSString * bg;

    if (time>=18||time<=06) {
        isNight = YES;
    }
    else{
        isNight = NO;
    }
    if (isNight) {
        bg = @"bg_night";
    }else{
        bg = @"bg_light";
    }
    bgView.image = [UIImage imageNamed:bg];

    
    [self createWave];
    if (!isNight) {

        [self createBallon:@"ballon-1" point:CGPointMake(self.frame.size.width / 4, 40)];
        [self createBallon:@"ballon-2" point:CGPointMake(self.frame.size.width / 4*3, 40)];
    }
    [self createSeagull:@"seagull-1" point:CGPointMake(self.frame.size.width / 2 - 20, 90)];
    [self createSeagull:@"seagull-2" point:CGPointMake(self.frame.size.width / 2 + 20, 80)];
    if (!timer) {
        timer =  [NSTimer timerWithTimeInterval:40/3.0 target:self selector:@selector(timerCreate) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [timer fire];
    }else{
        [timer setFireDate:[NSDate date]];
    }
}

- (void)timerCreate{
 
    [self createBottleWithModel:self.models[count%self.models.count]];
    count ++;
}

- (void)createSeagull:(NSString *)imageName point:(CGPoint)position{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *seagull = [[UIImageView alloc]init];
    CGFloat width = 14 + arc4random_uniform(10);

    seagull.frame = CGRectMake(-100, -100, width, width / image.size.width * image.size.height);
    seagull.image = image;
    [self insertSubview:seagull atIndex:1];
    
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animate.repeatCount = CGFLOAT_MAX;
    animate.fillMode = kCAFillModeForwards;
    animate.autoreverses = YES;
    animate.duration = 6;
    animate.path = [self wavePath:position];
    [seagull.layer addAnimation:animate forKey:@"runwave"];
    
    CGPathRelease(animate.path);
    
}

- (void)createBallon:(NSString *)imageName point:(CGPoint)position{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *ballon = [[UIImageView alloc]init];
    CGFloat width = 22 + arc4random_uniform(10);
    ballon.frame = CGRectMake(-100, -100, width, width / image.size.width * image.size.height);
    ballon.image = image;
    [self insertSubview:ballon atIndex:1];
    
    
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animate.repeatCount = CGFLOAT_MAX;
    animate.fillMode = kCAFillModeForwards;
    animate.autoreverses = YES;
    animate.duration = 6;
    animate.path = [self wavePath:position];
    [ballon.layer addAnimation:animate forKey:@"runBallon"];
    
    CGPathRelease(animate.path);
    
    
}

- (void)createWave{
    UIImage *image = [UIImage imageNamed:@"wave"];
    UIImageView *wave = [[UIImageView alloc]init];
    wave.frame = CGRectMake(0, 150, self.frame.size.width, self.frame.size.width / image.size.width * image.size.height);
    wave.image = image;
    [self insertSubview:wave atIndex:1];
    
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animate.repeatCount = CGFLOAT_MAX;
    animate.fillMode = kCAFillModeForwards;
    animate.autoreverses = YES;
    animate.duration = 4;
    animate.path = [self wavePath:CGPointMake(self.frame.size.width / 2, 150)];
    [wave.layer addAnimation:animate forKey:@"runwave"];
    
    CGPathRelease(animate.path);
    
}


- (void)createBottleWithModel:(BottleModel *)model{
    Bottle *bottle = [[Bottle alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/8, self.frame.size.width/4)];
    bottle.model = model;
    [self addSubview:bottle];
    [bottles addObject:bottle];
    
    CAKeyframeAnimation *animate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animate setValue:bottle forKey:@"bottle-1"];
    animate.duration = 40;
    animate.delegate = self;
    animate.fillMode = kCAFillModeForwards;
    animate.repeatCount = 0;
    animate.path = [self bottlePath];
    animate.removedOnCompletion = NO;
    [bottle.layer addAnimation:animate forKey:@"runbottle"];
    
    CGPathRelease(animate.path);
}


- (CGPathRef )wavePath:(CGPoint)startPoint{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    int i = arc4random_uniform(2);
    if (i) {
        CGPathAddLineToPoint(path, NULL, startPoint.x, startPoint.y + 10);
    }else{
        CGPathAddLineToPoint(path, NULL, startPoint.x, startPoint.y - 10);
    }
    return path;
}

- (CGPathRef )bottlePath{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat w = self.frame.size.width / 10;
    CGFloat baseLine = 90;
    CGFloat jump = 30;
    
    for (int i =0; i< 15; i++) {
        CGFloat h = 0;
        if (i%2 ==0) {
            h = baseLine - arc4random_uniform(jump);
        }else{
            h = arc4random_uniform(jump)+ baseLine;
        }
        
        CGPoint startPoint = CGPointMake(w*i, baseLine);
        CGPoint endPoint = CGPointMake(w*(i+1),baseLine);
        CGPoint controlPoint = CGPointMake(w*i + arc4random_uniform(w) , h);
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

}

@end
