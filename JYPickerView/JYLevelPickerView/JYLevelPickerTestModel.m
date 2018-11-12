//
//  JYLevelPickerTestModel.m
//  YYModelDemo
//
//  Created by McIntosh on 2018/11/3.
//  Copyright © 2018 xyl~Pro. All rights reserved.
//

#import "JYLevelPickerTestModel.h"

@implementation JYLevelPickerTestModel

// 返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
// key 是自定义的   value 是 json 中的
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"dataName":@"name",
             @"dataCode":@"code",
             @"dataList":@"list"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"dataList" : @"JYLevelPickerTestModel",
             };
}

// 三级测试数据
+ (NSArray *) threeLevelDataSource{
    return @[
             @{
                 @"name": @"北京",
                 @"code": @"110100",
                 @"list":
                     @[
                         @{
                             @"name": @"北京",
                             @"code": @"110111",
                             @"list":
                                 @[
                                     @{
                                         @"name": @"东城区",
                                         @"code": @"110101",
                                         },
                                     @{
                                         @"name": @"西城区",
                                         @"code": @"110101",
                                         },
                                     @{
                                         @"name": @"朝阳区",
                                         @"code": @"110103",
                                         },
                                     @{
                                         @"name": @"丰台区",
                                         @"code": @"110104",
                                         },
                                     @{
                                         @"name": @"石景山区",
                                         @"code": @"110105",
                                         },
                                     @{
                                         @"name": @"海淀区",
                                         @"code": @"110106",
                                         },
                                     @{
                                         @"name": @"顺义区",
                                         @"code": @"110107",
                                         },
                                     @{
                                         @"name": @"通州区",
                                         @"code": @"110108",
                                         },
                                     ]
                             },
                         ]
                 },
             @{
                 @"name": @"黑龙江",
                 @"code": @"200",
                 @"list":
                     @[
                         @{
                             @"name": @"哈尔滨",
                             @"code": @"201",
                             @"list":
                                 @[
                                     @{
                                         @"name": @"南岗区",
                                         @"code": @"230103",
                                         },
                                     @{
                                         @"name": @"道里区",
                                         @"code": @"230102",
                                         },
                                     @{
                                         @"name": @"道外区",
                                         @"code": @"230104",
                                         },
                                     @{
                                         @"name": @"平房区",
                                         @"code": @"230108",
                                         },
                                     @{
                                         @"name": @"松北区",
                                         @"code": @"230109",
                                         },
                                     @{
                                         @"name": @"香坊区",
                                         @"code": @"230110",
                                         },
                                     @{
                                         @"name": @"呼兰区",
                                         @"code": @"230111",
                                         },
                                     @{
                                         @"name": @"阿城区",
                                         @"code": @"230112",
                                         }
                                     
                                     ]
                             },
                         @{
                             @"name": @"大庆",
                             @"code": @"230600",
                             @"list":
                                 @[
                                     @{
                                         @"name": @"林甸县",
                                         @"code": @"230623",
                                         },
                                     @{
                                         @"name": @"杜尔伯特蒙古族自治县",
                                         @"code": @"230624",
                                         },
                                     @{
                                         @"name": @"龙凤区",
                                         @"code": @"230603",
                                         },
                                     @{
                                         @"name": @"萨尔图区",
                                         @"code": @"230602",
                                         },
                                     @{
                                         @"name": @"让胡路区",
                                         @"code": @"230604",
                                         },
                                     @{
                                         @"name": @"红岗区",
                                         @"code": @"230605",
                                         },
                                     @{
                                         @"name": @"大同区",
                                         @"code": @"230606",
                                         },
                                     @{
                                         @"name": @"肇源县",
                                         @"code": @"230622",
                                         },
                                     ]
                             },
                         @{
                             @"name": @"齐齐哈尔",
                             @"code": @"203",
                             @"list":
                                 @[
                                     @{
                                         @"name": @"龙沙区",
                                         @"code": @"230202",
                                         },
                                     @{
                                         @"name": @"建华区",
                                         @"code": @"230203",
                                         },
                                     @{
                                         @"name": @"铁锋区",
                                         @"code": @"230204",
                                         },
                                     @{
                                         @"name": @"昂昂溪区",
                                         @"code": @"230205",
                                         },
                                     @{
                                         @"name": @"富拉尔基区",
                                         @"code": @"230206",
                                         },
                                     @{
                                         @"name": @"碾子山区",
                                         @"code": @"230207",
                                         },
                                     @{
                                         @"name": @"梅里斯达斡尔族区",
                                         @"code": @"230208",
                                         },
                                     @{
                                         @"name": @"龙江县",
                                         @"code": @"230221",
                                         },
                                     @{
                                         @"name": @"依安县",
                                         @"code": @"230223",
                                         },
                                     ]
                             }
                         ]
                 },
             @{
                 @"name": @"辽宁",
                 @"code": @"300",
                 @"list":
                     @[
                         @{
                             @"name": @"沈阳",
                             @"code": @"210100",
                             @"list":
                                 @[
                                     @{
                                         @"name": @"和平区",
                                         @"code": @"311",
                                         },
                                     @{
                                         @"name": @"沈河区",
                                         @"code": @"312",
                                         },
                                     @{
                                         @"name": @"大东区",
                                         @"code": @"313",
                                         },
                                     @{
                                         @"name": @"皇姑区",
                                         @"code": @"314",
                                         }
                                     ]
                             },
                         @{
                             @"name": @"大连",
                             @"code": @"210200",
                             @"list":
                                 @[
                                     @{
                                         @"name": @"中山区",
                                         @"code": @"321",
                                         },
                                     @{
                                         @"name": @"西岗区",
                                         @"code": @"322",
                                         },
                                     @{
                                         @"name": @"沙河口区",
                                         @"code": @"323",
                                         },
                                     @{
                                         @"name": @"甘井子区",
                                         @"code": @"324",
                                         },
                                     @{
                                         @"name": @"旅顺口区",
                                         @"code": @"325",
                                         },
                                     ]
                             },
                         @{
                             @"name": @"铁岭市",
                             @"code": @"211200",
                             @"list":
                                 @[
                                     @{
                                         @"name": @"银州区",
                                         @"code": @"331",
                                         },
                                     @{
                                         @"name": @"清河区",
                                         @"code": @"332",
                                         },
                                     @{
                                         @"name": @"调兵山市",
                                         @"code": @"333",
                                         },
                                     @{
                                         @"name": @"铁岭县",
                                         @"code": @"334",
                                         },
                                     @{
                                         @"name": @"昌图县",
                                         @"code": @"335",
                                         },
                                     ]
                             }
                         ]
                 }
             ];
}

@end
