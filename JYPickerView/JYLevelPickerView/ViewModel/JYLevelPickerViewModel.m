//
//  JYLevelPickerViewModel.m
//  JYPickerView
//
//  Created by McIntosh on 2018/11/13.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import "JYLevelPickerViewModel.h"
#import "JYLevelPickerModel.h"
#import "JYPickerModel.h"

#import "FMDB.h"

@implementation JYLevelPickerViewModel


+ (NSMutableArray *) jy_getAllAddressDataSourceWithSqliteName:(NSString *)sqliteName{
    JYPickerModel * pickerModel = [JYPickerModel sharePickerModel];
    if (pickerModel.address.count == 0) {
        NSArray * arr = [JYLevelPickerViewModel jy_getAllAddressInfoWithSubAddrs:@[] sqliteName:sqliteName];
        pickerModel.address = arr;
    }
    return pickerModel.address.mutableCopy;
}

+ (NSMutableArray *) jy_getAllAddressInfoWithSubAddrs:(NSArray *)array sqliteName:(NSString *)sqliteName{
    if (array.count == 0) {
        array = [JYLevelPickerViewModel jy_getAddressInfoWithSqliteName:sqliteName code:@"0" conditional:@"parentId"];
    }
    NSMutableArray * mArr = [NSMutableArray array];
    for (NSDictionary * cityDic in array) {
        NSArray * cityArray = [JYLevelPickerViewModel jy_getAddressInfoWithSqliteName:sqliteName code:cityDic[@"areaCode"] conditional:@"parentId"];
        NSMutableDictionary * mDic = [cityDic mutableCopy];
        if (cityArray.count > 0) {
            NSArray * countyArr = [JYLevelPickerViewModel jy_getAddressInfoWithSqliteName:sqliteName code:cityDic[@"areaCode"] conditional:@"parentId"];
            NSMutableArray * countyMArr = [NSMutableArray array];
            for (NSDictionary * countyDic in countyArr) {
                NSArray * areaArray = [JYLevelPickerViewModel jy_getAddressInfoWithSqliteName:sqliteName code:countyDic[@"areaCode"] conditional:@"parentId"];
                NSMutableDictionary * areaDic = [countyDic mutableCopy];
                areaDic[@"dataList"] = areaArray;
                [countyMArr addObject:areaDic];
            }
            mDic[@"dataList"] = countyMArr;
        }
        [mArr addObject:mDic];
    }
    return mArr;
}

/**
 根据 code 查询地址 区域信息

 @param code 区域编号
 @param conditional 查询条件  areacode 区域编号   parentid 父级的编号  areaName 地区名字
 @return  地址详情 model
 */
+ (NSMutableArray *)jy_getAddressInfoWithSqliteName:(NSString *)sqliteName code:(NSString*)code conditional:(NSString *)conditional{
    NSMutableArray * areas = [NSMutableArray array];
    if (sqliteName == nil || [sqliteName isEqualToString:@""]) {
        sqliteName = @"jyAddress";// 本地数据表
    }

    if ([code isEqualToString:@""] ||
        code == nil ||
        [conditional isEqualToString:@""] ||
        conditional == nil) {
        return @[].mutableCopy;
    }
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:sqliteName ofType:@".sqlite"]];
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    FMResultSet * parentIdResult = [db executeQuery:[NSString stringWithFormat:@"select * from area where %@ = %d order by id",conditional,code.intValue]];
    while ([parentIdResult next])
    {
        NSMutableDictionary * mDic = [NSMutableDictionary dictionary];
        mDic[@"areaName"] = [parentIdResult stringForColumn:@"areaName"];
        mDic[@"areaCode"] = [parentIdResult stringForColumn:@"areaCode"];
        mDic[@"parentId"] = [parentIdResult stringForColumn:@"parentId"];
        [areas addObject:mDic];
    }
    [db close];
    return areas;
}


@end
