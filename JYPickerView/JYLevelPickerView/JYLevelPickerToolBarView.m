//
//  JYLevelPickerToolBarView.m
//  JYUIComponents
//
//  Created by McIntosh on 2018/11/12.
//

#import "JYLevelPickerToolBarView.h"

@interface JYLevelPickerToolBarView()
/** 左侧按钮 */
@property (nonatomic, strong) UIButton * leftButton;
/** 右侧按钮 */
@property (nonatomic, strong) UIButton * rightButton;
/** 标题 */
@property (nonatomic, strong) UILabel *  titleLabel;
/** 下边界线 */
@property (nonatomic, strong) UIView * lineView;

/** block */
@property (nonatomic, copy) LevelPickerToolBarViewBlock pickerToolBarViewBlock;
@end


static CGFloat const kConfirmBtnWidth = 60;
static CGFloat const kConfirmBtnX = 4;

@implementation JYLevelPickerToolBarView

- (instancetype)initWithFrame:(CGRect)frame didConfirmDate:(LevelPickerToolBarViewBlock)confirmBlock {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineView];
        self.pickerToolBarViewBlock = confirmBlock;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIButton *)leftButton{
    if (_leftButton == nil) {
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 999999
        [leftBtn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [leftBtn addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.frame = CGRectMake(kConfirmBtnX, 0, kConfirmBtnWidth, CGRectGetHeight(self.frame));
        _leftButton = leftBtn;

    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (_rightButton == nil) {
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        // 4A78F8
        [rightBtn setTitleColor:[UIColor colorWithRed:74/255.0 green:120/255.0 blue:248/255.0 alpha:1] forState:UIControlStateNormal];
        [rightBtn setBackgroundColor:[UIColor whiteColor]];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [rightBtn addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - kConfirmBtnX - kConfirmBtnWidth, 0, kConfirmBtnWidth, CGRectGetHeight(self.frame));
        _rightButton = rightBtn;

    }
    return _rightButton;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.text = @"选择器";
        // 656E7B
        [titleLabel setTextColor:[UIColor colorWithRed:101/255.0 green:110/255.0 blue:123/255.0 alpha:1]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font =  [UIFont boldSystemFontOfSize:16];
        titleLabel.frame = CGRectMake(kConfirmBtnWidth + kConfirmBtnX, 0, CGRectGetWidth(self.frame) - (kConfirmBtnWidth + kConfirmBtnX)*2, CGRectGetHeight(self.frame));
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (void)leftButtonAction{
    if (self.pickerToolBarViewBlock) {
        self.pickerToolBarViewBlock(JYLevelPickerToolBarViewButtonTypeLeft);
    }
}

- (void)rightButtonAction{
    if (self.pickerToolBarViewBlock) {
        self.pickerToolBarViewBlock(JYLevelPickerToolBarViewButtonTypeRight);
    }
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1)];
        _lineView.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _lineView.hidden = YES;
    }
    return _lineView;
}
#pragma mark - 基础设置

- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor{
    _titleTextColor = titleTextColor;
    self.titleLabel.textColor = titleTextColor;
}

- (void)setTitleTextFont:(UIFont *)titleTextFont{
    _titleTextFont = titleTextFont;
    self.titleLabel.font = titleTextFont;
}

- (void)setLeftTitleText:(NSString *)leftTitleText{
    _leftTitleText = leftTitleText;
    [self.leftButton setTitle:leftTitleText forState:UIControlStateNormal];
}

- (void)setLeftTextFont:(UIFont *)leftTextFont{
    _leftTextFont = leftTextFont;
    self.leftButton.titleLabel.font = leftTextFont;
}

- (void)setLeftTextColor:(UIColor *)leftTextColor{
    _leftTextColor = leftTextColor;
    [self.leftButton setTitleColor:leftTextColor forState:UIControlStateNormal];
}

- (void)setRightTitleText:(NSString *)rightTitleText{
    _rightTitleText = rightTitleText;
    [self.rightButton setTitle:rightTitleText forState:UIControlStateNormal];
}

- (void)setRightTextFont:(UIFont *)rightTextFont{
    _rightTextFont = rightTextFont;
    self.rightButton.titleLabel.font = rightTextFont;
}

- (void)setRightTextColor:(UIColor *)rightTextColor{
    _rightTextColor = rightTextColor;
    [self.rightButton setTitleColor:rightTextColor forState:UIControlStateNormal];
}

- (void)setToolbarBackgroundColor:(UIColor *)toolbarBackgroundColor{
    _toolbarBackgroundColor = toolbarBackgroundColor;
    self.backgroundColor = toolbarBackgroundColor;
    self.titleLabel.backgroundColor = toolbarBackgroundColor;
    self.leftButton.backgroundColor = toolbarBackgroundColor;
    self.rightButton.backgroundColor = toolbarBackgroundColor;
}

- (void)setIsShowLine:(BOOL)isShowLine{
    _isShowLine = isShowLine;
    self.lineView.hidden = !isShowLine;
}

- (void)setLineViewColor:(UIColor *)lineViewColor{
    _lineViewColor = lineViewColor;
    self.lineView.backgroundColor = lineViewColor;
}
@end
