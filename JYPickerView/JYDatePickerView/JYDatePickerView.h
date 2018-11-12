//
//  JYDatePickerView.h
//  DatePicker-Demo
//
//  Created by xyanl on 2018/11/9.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSInteger JYDatePickerComponentsStyle;
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYMDHM;
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleMDHM;
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleDHM;
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYMD;
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleMD;
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleHM;

@interface JYDatePickerView : UIPickerView

/**
 初始化 时间选择器

 @param style 时间组件类型
 @param configuration 返回时间组件view 便于设置样式
 @param resultDateBlock 返回 选中时间结果
 */
+ (void)jy_datePickerWithStyle:(JYDatePickerComponentsStyle)style configuration:(void (^)(JYDatePickerView * datePickerView)) configuration resultDateBlock:(void (^)(NSDate *date))resultDateBlock;
/**
 时间组件类型
 */
@property (nonatomic, assign) JYDatePickerComponentsStyle style;

/**
 最小时间
 */
@property (nonatomic, strong) NSDate *minLimitDate;

/**
 最大时间
 */
@property (nonatomic, strong) NSDate *maxLimitDate;

/**
 选中时间,定位
 */
@property (nonatomic, strong) NSDate *selectDate;

@end
NS_ASSUME_NONNULL_END
