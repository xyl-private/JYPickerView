//
//  JYLevelPickerView.h
//  YYModelDemo
//
//  Created by xyanl on 2018/10/31.
//  Copyright © 2018 xyl~Pro. All rights reserved.
//
//  二级选择器控件 支持 一二级的

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JYLevelPickerView,JYLevelPickerModel;
typedef NS_ENUM(NSUInteger, JYLevelPickerViewLevel) {
    /// 没有
    JYLevelPickerViewLevelNor = 0,
    /// 一级
    JYLevelPickerViewLevelOne,
    /// 二级
    JYLevelPickerViewLevelTwo,
    /// 三级
    JYLevelPickerViewLevelThree,
};

typedef void (^LevelPickerChosseResultBlock)(JYLevelPickerModel * resultModel,JYLevelPickerModel * lastModel);

@interface JYLevelPickerView : UIView

/** 默认展示的code */
@property (nonatomic, copy) NSString * defaultCode;


/** 设置 内容字体 */
@property (nonatomic, strong) UIFont * contentTextFont;
/** 设置 内容文本颜色 */
@property (nonatomic, strong) UIColor * contentTextColor;


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

/**
 初始化控件

 @param array 数据源
 @param level 数据层级数
 @param configuration 当前视图
 @param resultModelBlock 选择后的结果
 */
+ (void)jy_initPickviewWithDataSourcesArray:(NSArray<JYLevelPickerModel *> *)array level:(JYLevelPickerViewLevel)level configuration:(void (^)(JYLevelPickerView * pickerView)) configuration resultModelBlock:(LevelPickerChosseResultBlock)resultModelBlock;

@end

NS_ASSUME_NONNULL_END
