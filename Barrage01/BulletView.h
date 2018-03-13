//
//  BulletView.h
//  Barrage01
//
//  Created by tiger on 16/8/9.
//  Copyright © 2016年 tqsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
typedef enum {
    MoveBegin,
    MoveEnter,
    MoveEnd
}MoveStatus;
*/

typedef NS_ENUM(NSInteger, MoveStatus) {
    MoveBegin,
    MoveEnter,
    MoveEnd
};

@interface BulletView : UIView

//弹道
@property (nonatomic, assign) int trajectory;

//弹幕的状态回调
@property (nonatomic, copy) void (^moveStatusBlock)(MoveStatus status);

//初始化弹幕
- (instancetype)initWithComment:(NSString *)comment;

//开始动画
- (void)startAnimation;

//结束动画
- (void)stopAnimation;

@end
