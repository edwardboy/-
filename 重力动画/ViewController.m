//
//  ViewController.m
//  重力动画
//
//  Created by dfc on 2018/3/2.
//  Copyright © 2018年 dfc. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface ViewController ()
{
    UIDynamicAnimator *_dynamicAnimator;    // 物理动画引擎
    UIDynamicItemBehavior *_dynamicItemBehavior;// 物理行为
    UIGravityBehavior *_gravityBehavior;    // 重力行为
    UICollisionBehavior *_collisionBehavior;    // 碰撞行为
}

/**
 传感器
 */
@property (nonatomic,strong) CMMotionManager *motionManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDynamic];
    
    [self setupMotionManager];
    
    [self setupUI];
}

- (void)createDynamic{
    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    _dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
    _dynamicItemBehavior.elasticity = 0.5;
    
    _gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];
    
    _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [_dynamicAnimator addBehavior:_dynamicItemBehavior];
    [_dynamicAnimator addBehavior:_gravityBehavior];
    [_dynamicAnimator addBehavior:_collisionBehavior];
}

- (void)setupMotionManager{
    _motionManager = [[CMMotionManager alloc] init];
    if ([_motionManager isDeviceMotionAvailable]) {
        _motionManager.deviceMotionUpdateInterval = 1;
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            double gravityX = motion.gravity.x;
            double gravityY = motion.gravity.y;
            // double gravityZ = motion.gravity.z;
            // 获取手机的倾斜角度(z是手机与水平面的夹角， xy是手机绕自身旋转的角度)：
            //double z = atan2(gravityZ,sqrtf(gravityX * gravityX + gravityY * gravityY))  ;
            double xy = atan2(gravityX, gravityY);
            // 计算相对于y轴的重力方向
            _gravityBehavior.angle = xy-M_PI_2;
            
//            for (UIView *subview in self.view.subviews) {
//                subview.layer.transform = CATransform3DMakeRotation(xy-M_PI_2, 1, 0, 0);
//            }
        }];
    }
}

- (void)setupUI{
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(60, 60, 60, 60)];
    [but setTitle:@"on" forState:UIControlStateNormal];
    [but setBackgroundColor:[UIColor cyanColor]];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    [_dynamicItemBehavior addItem:but];
    [_gravityBehavior addItem:but];
    [_collisionBehavior addItem:but];
}

- (void)click:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"on"]) {
        [sender setTitle:@"off" forState:UIControlStateNormal];
    }else {
        [sender setTitle:@"on" forState:UIControlStateNormal];
    }
}

@end
