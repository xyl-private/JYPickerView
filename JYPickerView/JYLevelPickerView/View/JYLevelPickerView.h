//
//  JYLevelPickerView.h
//  YYModelDemo
//
//  Created by xyanl on 2018/10/31.
//  Copyright © 2018 xyl~Pro. All rights reserved.
//
//  二级选择器控件 支持 一二级的

#import <UIKit/UIKit.h>
#import "JYLevelPickerToolBarView.h"
#import "JYLevelPickerModel.h"
NS_ASSUME_NONNULL_BEGIN
@class JYLevelPickerView;
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
/** picker Tool Bar View */
@property (nonatomic, strong) JYLevelPickerToolBarView * pickerToolBarView;

/** 设置 内容字体 */
@property (nonatomic, strong) UIFont * contentTextFont;
/** 设置 内容文本颜色 */
@property (nonatomic, strong) UIColor * contentTextColor;

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
