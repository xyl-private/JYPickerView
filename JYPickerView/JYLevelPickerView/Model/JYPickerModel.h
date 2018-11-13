//
//  JYPickerModel.h
//  JYPickerView
//
//  Created by McIntosh on 2018/11/13.
//  Copyright © 2018 xyanl. All rights reserved.
//
//  单例 用来缓存数据的
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYPickerModel : NSObject
+ (instancetype)sharePickerModel;

/** Description */
@property (nonatomic, strong) NSArray * address;
@end

NS_ASSUME_NONNULL_END
