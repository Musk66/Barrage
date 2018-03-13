//
//  BulletView.m
//  Barrage01
//
//  Created by tiger on 16/8/9.
//  Copyright © 2016年 tqsoft. All rights reserved.
//

#import "BulletView.h"

//弹幕的内间距
#define kPadding 10
#define kIconWH 30

@interface BulletView()

//评论标签
@property (nonatomic, strong) UILabel *commentLbl;
//用户头像
@property (nonatomic, strong) UIImageView *userIcon;

@end

@implementation BulletView

- (instancetype)initWithComment:(NSString *)comment
{
    if (self = [super init]) {
        //self.backgroundColor = [UIColor redColor];
        //计算弹幕的实际宽度
        /*
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat commentWidth = [comment sizeWithAttributes:attrs].width;
        self.bounds = CGRectMake(0, 0, commentWidth + kPadding * 2, 30);
        self.commentLbl.text = comment;
        self.commentLbl.frame = CGRectMake(kPadding, 0, commentWidth, 30);
        */
        
        self.layer.cornerRadius = kIconWH / 2;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat commentWidth = [comment sizeWithAttributes:attrs].width;
        self.bounds = CGRectMake(0, 0, commentWidth + kPadding * 2 + kIconWH, kIconWH);
        self.commentLbl.text = comment;
        self.commentLbl.frame = CGRectMake(kPadding + kIconWH, 0, commentWidth, kIconWH);
        
        self.userIcon.frame = CGRectMake(-kPadding, -kPadding, kPadding + kIconWH, kPadding + kIconWH);
        self.userIcon.layer.masksToBounds = YES;
        self.userIcon.layer.cornerRadius = (kIconWH + kPadding) / 2;
        self.userIcon.layer.borderColor = [UIColor blueColor].CGColor;
        self.userIcon.layer.borderWidth = 1;
        self.userIcon.image = [UIImage imageNamed:@"alq.png"];
        
    }
    return self;
}

- (void)startAnimation
{
    //根据弹幕长度执行动画效果
    //根据v=s/t，时间相同情况下，距离越长，速度就越快
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 8.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    //弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(MoveBegin);
    }
    
    //弹幕进入屏幕
    //t = s / v
    CGFloat speed = wholeWidth / duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds) / speed;
    
    //当弹幕完全进入屏幕时
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    //弹幕滑动动画
    __block CGRect tframe = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        tframe.origin.x -= wholeWidth;
        self.frame = tframe;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStatusBlock) {
            self.moveStatusBlock(MoveEnd);
        }
    }];
}

- (void)stopAnimation
{
    //[NSObject cancelPreviousPerformRequestsWithTarget: selector: object:];
    //取消动画
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
    //动画是加在layer上的？
}

- (void)enterScreen
{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(MoveEnter);
    }
}

//初始化commentLbl
- (UILabel *)commentLbl
{
    if (!_commentLbl) {
        _commentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLbl.font = [UIFont systemFontOfSize:14];
        _commentLbl.textColor = [UIColor whiteColor];
        _commentLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_commentLbl];
    }
    return _commentLbl;
}

//初始化userIcon
- (UIImageView *)userIcon
{
    if (!_userIcon) {
        _userIcon = [UIImageView new];
        _userIcon.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_userIcon];
    }
    return _userIcon;
}

@end
