//
//  BulletManager.m
//  Barrage01
//
//  Created by tiger on 16/8/9.
//  Copyright © 2016年 tqsoft. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager()

//弹幕的数据来源
@property (nonatomic, strong) NSMutableArray *commentsData;
//弹幕使用过程中的数组变量
@property (nonatomic, strong) NSMutableArray *bulletComments;
//存储弹幕view的数组变量
@property (nonatomic, strong) NSMutableArray *bulletViews;

@property (nonatomic, assign) BOOL isStopAnimation;

@end

@implementation BulletManager

- (instancetype)init {
    if (self = [super init]) {
        self.isStopAnimation = YES;
    }
    return self;
}

- (NSMutableArray *)commentsData {
    if (!_commentsData) {
        _commentsData = [NSMutableArray arrayWithArray:@[@"弹幕1~~~~~~~",
                                                         @"弹幕2~~~~~~~~~~~~~~~~~~~~~~~~",
                                                         @"弹幕3~~",
                                                         @"弹幕4~~~~~~~~~~~~~~~",
                                                         @"弹幕5~~~~~",
                                                         @"弹幕6~~~~~~~~~~",
                                                         @"弹幕7~",
                                                         @"弹幕8~~~~~~~~~~~~~~~~~~~~",
                                                         @"弹幕9~~",
                                                         @"弹幕10~~~~~~~~~~~~",
                                                         @"弹幕11~~~~~",
                                                         @"弹幕12~~~~~~~~~~~~~~~~~"]];
    }
    return _commentsData;
}

- (NSMutableArray *)bulletComments {
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews {
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

- (void)start
{
    //如果已经执行了则不做任何事情
    if (!self.isStopAnimation) {
        return ;
    }
    
    //清空所有数据
    [self.bulletComments removeAllObjects];
    //从数据源中配置弹幕数据
    [self.bulletComments addObjectsFromArray:self.commentsData];
    
    if (self.bulletComments.count > 0) {
        self.isStopAnimation = NO;
        [self initBulletComment];
    }
}

- (void)stop
{
    if (self.isStopAnimation) {
        return ;
    }
    self.isStopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *bulletView = obj;
        [bulletView stopAnimation];
        bulletView = nil;
    }];
    [self.bulletViews removeAllObjects];
}

//初始化弹幕，随机分配弹幕轨迹
- (void)initBulletComment
{
    NSMutableArray *trajectoryArr = [NSMutableArray arrayWithArray:@[@(0), @(1), @(2)]];
    int trajectoryCount = (int)trajectoryArr.count;
    for (int i = 0; i < trajectoryCount; i++) {
        //保证不能为空
        if (self.bulletComments.count > 0) {
            //通过随机数，获得弹幕的轨迹(0-2的随机数)
            NSInteger index = arc4random() % trajectoryArr.count;
            int trajectory = [[trajectoryArr objectAtIndex:index] intValue];
            [trajectoryArr removeObjectAtIndex:index];
            
            //从弹幕数组中逐一获取弹幕数据
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            
            //创建弹幕view
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}

- (void)createBulletView:(NSString *)comment trajectory:(int)trajectory
{
    if (self.isStopAnimation) {
        return ;
    }
    BulletView *bulletView = [[BulletView alloc] initWithComment:comment];
    bulletView.trajectory = trajectory;
    [self.bulletViews addObject:bulletView];
    
    __weak typeof(bulletView) weakView = bulletView;
    __weak typeof(self) weakSelf = self;
    bulletView.moveStatusBlock = ^(MoveStatus status) {
        if (self.isStopAnimation) {
            return ;
        }
        switch (status) {
            case MoveBegin: {
                //弹幕开始进入屏幕，将view加入弹幕管理的变量bulletViews中
                [self.bulletViews addObject:weakView];
                break;
            }
            case MoveEnter: {
                //弹幕完全进入屏幕，判断数据源中是否还有其他内容，如果有，则在该弹幕轨迹中创建一个
                NSString *comment = [weakSelf nextComment];
                if (comment) {
                    [weakSelf createBulletView:comment trajectory:trajectory];
                }
                break;
            }
            case MoveEnd: {
                //弹幕移出屏幕后，将view从bulletViews中移出，释放资源
                if ([self.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                
                if (self.bulletViews.count == 0) {
                    //说明屏幕上已经没有弹幕了，开始循环滚动
                    self.isStopAnimation = YES;
                    [weakSelf start];
                }
                break;
            }
            default:
                break;
        }
    };
    
    //回调给vc
    if (self.generateViewBlock) {
        self.generateViewBlock(weakView);
    }
}

- (NSString *)nextComment
{
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        //为了防止内容一致时出现bug，使用删除索引对应的元素
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}

@end
