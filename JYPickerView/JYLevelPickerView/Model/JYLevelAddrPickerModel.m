//
//  JYLevelAddrPickerModel.m
//  JYPickerView
//
//  Created by McIntosh on 2018/11/13.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import "JYLevelAddrPickerModel.h"

@implementation JYLevelAddrPickerModel
// 返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
// key 是自定义的   value 是 json 中的
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"dataName":@"areaName",
             @"dataCode":@"areaCode",
             @"parentId":@"parentId",
             @"dataList":@"dataList"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"dataList" : @"JYLevelAddrPickerModel",
             };
}

@end

