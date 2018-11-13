//
//  JYLevelPickerViewModel.h
//  JYPickerView
//
//  Created by McIntosh on 2018/11/13.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYLevelPickerViewModel : NSObject

/**
 获取本地缓存后的数据

 @param sqliteName 数据库名字
 @return return
 */
+ (NSMutableArray *) jy_getAllAddressDataSourceWithSqliteName:(NSString *)sqliteName;

/**
 从sqlite获取数据

 @param array array description
 @param sqliteName sqliteName description
 @return return value description
 */
+ (NSMutableArray *) jy_getAllAddressInfoWithSubAddrs:(NSArray *)array sqliteName:(NSString *)sqliteName;

/**
 根据条件查询数据地址sqlite

 @param sqliteName sqliteName 名字
 @param code 地区编码
 @param conditional 查询条件
 @return return value description
 */
+ (NSMutableArray *) jy_getAddressInfoWithSqliteName:(NSString *)sqliteName code:(NSString*)code conditional:(NSString *)conditional;
@end

NS_ASSUME_NONNULL_END
