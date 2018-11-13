//
//  JYLevelPickerToolBarView.h
//  JYUIComponents
//
//  Created by McIntosh on 2018/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, JYLevelPickerToolBarViewButtonType) {
    JYLevelPickerToolBarViewButtonTypeLeft,
    JYLevelPickerToolBarViewButtonTypeRight,
};

typedef void(^LevelPickerToolBarViewBlock)(JYLevelPickerToolBarViewButtonType type);

@interface JYLevelPickerToolBarView : UIView

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

/** 是否显示 下边的边界线 yes 显示  默认是NO 隐藏的*/
@property (nonatomic, assign) BOOL isShowLine;
/** 下边的边界线 的颜色 */
@property (nonatomic, strong) UIColor * lineViewColor;

- (instancetype)initWithFrame:(CGRect)frame didConfirmDate:(LevelPickerToolBarViewBlock)confirmBlock;

@end
NS_ASSUME_NONNULL_END
