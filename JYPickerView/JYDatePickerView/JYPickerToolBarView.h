//
//  JYPickerToolBarView.h
//  DatePicker-Demo
//
//  Created by xyanl on 2018/11/9.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, JYPickerToolBarViewButtonType) {
    JYPickerToolBarViewButtonTypeLeft,
    JYPickerToolBarViewButtonTypeRight,
};

typedef void(^PickerToolBarViewBlock)(JYPickerToolBarViewButtonType type);

@interface JYPickerToolBarView : UIView

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


- (instancetype)initWithFrame:(CGRect)frame didConfirmDate:(PickerToolBarViewBlock)confirmBlock;

@end

NS_ASSUME_NONNULL_END
