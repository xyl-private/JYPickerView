//
//  JYLevelPickerModel.m
//  YYModelDemo
//
//  Created by xyanl on 2018/10/31.
//  Copyright © 2018 xyl~Pro. All rights reserved.
//

#import "JYLevelPickerModel.h"

@implementation JYLevelPickerModel

+ (NSArray *) dataSource{
    return @[
             @{
                 @"dataName": @"日常消费",
                 @"dataCode": @"101",
                 @"dataList":
                     @[
                         @{
                             @"dataName": @"购车",
                             @"dataCode": @"11",
                             @"showOrder": @"4",
                             @"isGiveUp": @"0"
                             },
                         @{
                             @"dataName" : @"购生活品",
                             @"dataCode" : @"2",
                             @"showOrder": @"3",
                             @"isGiveUp": @"0"
                             },
                         @{
                             @"dataName":@"旅游",
                             @"dataCode":@"4",
                             @"showOrder": @"2",
                             @"isGiveUp": @"0"
                             },
                         @{
                             @"dataName":@"医疗救治",
                             @"dataCode":@"12",
                             @"showOrder": @"1",
                             @"isGiveUp": @"0"
                             }
                         ]
                 },
             @{
                 @"dataName": @"教育支出",
                 @"dataCode": @"102",
                 @"dataList":
                     @[
                         @{
                             @"dataName":@"留学",
                             @"dataCode":@"13",
                             @"showOrder": @"2",
                             @"isGiveUp": @"0"
                             },
                         @{
                             @"dataName":@"学业深造",
                             @"dataCode":@"14",
                             @"showOrder": @"1",
                             @"isGiveUp": @"0"
                             },
                         ]
                 },
             @{
                 @"dataName": @"经营周转",
                 @"dataCode": @"103",
                 @"dataList":
                     @[
                         @{
                             @"dataName":@"购原材料",
                             @"dataCode":@"5",
                             @"showOrder": @"1",
                             @"isGiveUp": @"0"
                             },
                         @{
                             @"dataName":@"副业经营",
                             @"dataCode":@"15",
                             @"showOrder": @"3",
                             @"isGiveUp": @"0"
                             },
                         @{
                             @"dataName":@"扩大经营",
                             @"dataCode":@"16",
                             @"showOrder": @"2",
                             @"isGiveUp": @"0"
                             },
                         @{
                             @"dataName":@"购买设备",
                             @"dataCode":@"17",
                             @"showOrder": @"4",
                             @"isGiveUp": @"0"
                             }
                         ]
                 },
             @{
                 @"dataName": @"房屋装修",
                 @"dataCode": @"104",
                 @"dataList":
                     @[
                         @{
                             @"dataName":@"新房装修",
                             @"dataCode":@"18",
                             @"showOrder": @"1",
                             @"isGiveUp": @"0"
                             },
                         @{
                             @"dataName":@"老房翻新",
                             @"dataCode":@"19",
                             @"showOrder": @"2",
                             @"isGiveUp": @"0"
                             },
                         @{
                             @"dataName":@"购买家具",
                             @"dataCode":@"20",
                             @"showOrder": @"3",
                             @"isGiveUp": @"0"
                             }
                         ]
                 },
             @{
                 @"dataName": @"其他",
                 @"dataCode": @"105",
                 @"dataList":
                     @[
                         @{
                             @"dataName":@"资金周转",
                             @"dataCode":@"1",
                             @"showOrder": @"1",
                             @"isGiveUp": @"1"
                             },
                         @{
                             @"dataName":@"教育支出",
                             @"dataCode":@"3",
                             @"showOrder": @"2",
                             @"isGiveUp": @"1"
                             },
                         @{
                             @"dataName":@"装修家居",
                             @"dataCode":@"6",
                             @"showOrder": @"3",
                             @"isGiveUp": @"1"
                             },
                         @{
                             @"dataName":@"生活消费",
                             @"dataCode":@"8",
                             @"showOrder": @"4",
                             @"isGiveUp": @"1"
                             },
                         @{
                             @"dataName":@"其他",
                             @"dataCode":@"7",
                             @"showOrder": @"5",
                             @"isGiveUp": @"1"
                             }
                         ]
                 }
             ];
}
@end
