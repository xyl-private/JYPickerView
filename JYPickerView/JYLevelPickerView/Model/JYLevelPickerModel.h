//
//  JYLevelPickerModel.h
//  YYModelDemo
//
//  Created by xyanl on 2018/10/31.
//  Copyright © 2018 xyl~Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYLevelPickerModel : NSObject

/** title name */
@property (nonatomic, copy) NSString * dataName;
/** datacode */
@property (nonatomic, copy) NSString * dataCode;
/** 父级id */
@property (nonatomic, copy) NSString * parentId;
/** 排序使用 */
@property (nonatomic, copy) NSString * showOrder;
/** 是否 弃用 */
@property (nonatomic, copy) NSString * isGiveUp;

@property (nonatomic, strong)NSArray * dataList;

/** 选中的子集model */
@property (nonatomic, strong) JYLevelPickerModel * selectedChildModel;

+ (NSArray *) dataSource;
@end

NS_ASSUME_NONNULL_END
