# JYPickerView
选择器


JYLevelPickerView

多级选择器,可以支持单列、双列和三列的展示

####1.不同于JYLevelPickerModel 数据模型转换 JYLevelPickerModel 该model 是基础model，代码实现都基于该model不可更改。当你要使用的多级数据源中的key和JYLevelPickerModel中的属性名不符的时候可以借鉴 JYLevelPickerTestModel，新建一个model， 并且该 model 继承于 JYLevelPickerModel ，使用 model 转换三方库(这里使用的是 YYModel)的时候，可以在这里更改成你想要的key，例如👇代码。

@implementation JYLevelPickerTestModel

// 返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
// key 是自定义的   value 是 json 中的
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"dataName":@"name",
             @"dataCode":@"code",
             @"childDataList":@"list"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"childDataList" : @"JYLevelPickerTestModel",
             };
}
@end
