//
//  ViewController.m
//  Barrage01
//
//  Created by tiger on 16/8/9.
//  Copyright © 2016年 tqsoft. All rights reserved.
//

#import "ViewController.h"
#import "BulletView.h"
#import "BulletManager.h"

@interface ViewController ()

@property (nonatomic, strong) BulletManager *bulletManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkTextColor];
    
    self.bulletManager = [[BulletManager alloc] init];
    __weak typeof(self) weakSelf = self;
    self.bulletManager.generateViewBlock = ^ (BulletView *bulletView) {
        [weakSelf addBulletView:bulletView];
    };
}

- (IBAction)startClick:(UIButton *)sender {
    [self.bulletManager start];
}

- (IBAction)stopClick:(UIButton *)sender {
    [self.bulletManager stop];
}

- (void)addBulletView:(BulletView *)bulletView {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    bulletView.frame = CGRectMake(screenWidth, 100 + bulletView.trajectory * 50, CGRectGetWidth(bulletView.bounds), CGRectGetHeight(bulletView.bounds));
    [self.view addSubview:bulletView];
    [bulletView startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
