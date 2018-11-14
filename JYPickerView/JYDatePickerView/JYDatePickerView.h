//
//  JYDatePickerView.h
//  DatePicker-Demo
//
//  Created by xyanl on 2018/11/9.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYPickerToolBarView.h"

NS_ASSUME_NONNULL_BEGIN
//@class JYPickerToolBarView;
typedef NSInteger JYDatePickerComponentsStyle;
/// 年月日时分
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYMDHM;
/// 年
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleY;
/// 年月
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYM;
/// 年月日
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYMD;
/// 月日
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleMD;
/// 月日时分
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleMDHM;
/// 日时分
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleDHM;
/// 时分
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleHM;

#pragma mark - 带完善
/// 年月日时分秒
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYMDHMS;
/// 时分秒
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleHMS;
/// 分秒
extern JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleMS;

@interface JYDatePickerView : UIPickerView

/**
 初始化 时间选择器

 @param style 时间组件类型
 @param configuration 返回时间组件view 便于设置样式
 @param resultDateBlock 返回 选中时间结果
 */
+ (void)jy_datePickerWithStyle:(JYDatePickerComponentsStyle)style configuration:(void (^)(JYDatePickerView * datePickerView)) configuration resultDateBlock:(void (^)(NSDate *date))resultDateBlock;

/** 时间组件类型*/
@property (nonatomic, assign) JYDatePickerComponentsStyle style;
/** 最小时间 */
@property (nonatomic, strong) NSDate *minimumDate;
/** 最大时间 */
@property (nonatomic, strong) NSDate *maximumDate;
/** 选中时间,定位 */
@property (nonatomic, strong) NSDate *defaultDate;
/** 是否显示时间单位 */
@property (nonatomic, assign) BOOL isShowUnit;

/** 设置 标题文本 */
@property (nonatomic, copy) NSString * titleText;
/** 设置 标题文本颜色 */
@property (nonatomic, strong) UIColor * titleTextColor;
/** 设置 标题文本字体 */
@property (nonatomic, strong) UIFont * titleTextFont;


/** 设置 左侧按钮title */
@property (nonatomic, copy) NSString * leftTitleText;
/** 设置 左侧按钮文本颜色 */
@property (nonatomic, strong) UIColor * leftTextColor;
/** 设置 左侧按钮文本字体 */
@property (nonatomic, strong) UIFont * leftTextFont;


/** 设置 右侧按钮title */
@property (nonatomic, copy) NSString * rightTitleText;
/** 设置 右侧按钮文本颜色 */
@property (nonatomic, strong) UIColor * rightTextColor;
/** 设置 右侧按钮文本字体 */
@property (nonatomic, strong) UIFont * rightTextFont;

/** toolbar 的背景色 */
@property (nonatomic, strong) UIColor * toolbarBackgroundColor;
/** 下边的边界线 的颜色 */
@property (nonatomic, strong) UIColor * lineViewColor;
/** 是否显示 下边的边界线 yes 显示  默认是NO 隐藏的*/
@property (nonatomic, assign) BOOL isShowLine;

@end
NS_ASSUME_NONNULL_END
