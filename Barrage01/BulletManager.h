//
//  BulletManager.h
//  Barrage01
//
//  Created by tiger on 16/8/9.
//  Copyright © 2016年 tqsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;

@interface BulletManager : NSObject

//创建弹幕view的回调
@property (nonatomic, copy) void (^generateViewBlock) (BulletView *view);

//弹幕开始执行
- (void)start;

//弹幕停止执行
- (void)stop;

@end
