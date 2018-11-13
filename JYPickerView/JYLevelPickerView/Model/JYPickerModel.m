//
//  JYPickerModel.m
//  JYPickerView
//
//  Created by McIntosh on 2018/11/13.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import "JYPickerModel.h"
static id _shareInstance;
@implementation JYPickerModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [super allocWithZone:zone];
    });
    return _shareInstance;
}

+ (instancetype)sharePickerModel
{
    return [[self alloc]init];
}

- (id)copyWithZone:(NSZone *)zone
{
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _shareInstance;
}
@end
