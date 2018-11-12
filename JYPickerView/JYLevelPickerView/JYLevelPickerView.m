//
//  JYLevelPickerView.m
//  YYModelDemo
//
//  Created by McIntosh on 2018/10/31.
//  Copyright © 2018 xyl~Pro. All rights reserved.
//

#import "JYLevelPickerView.h"
#import "JYLevelPickerModel.h"

#define IS_IPHONE_X ([UIScreen mainScreen].bounds.size.height == 812.0f) ? YES : NO

static const int ToobarHeight = 40;
static const int DangerArea = 34;

@interface JYLevelPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
// model
@property (nonatomic, strong) JYLevelPickerModel * pickerModel;
// 数据源数组
@property (nonatomic, strong) NSArray * pickerModels;
// 选择器视图
@property (nonatomic, strong) UIPickerView * pickerView;
// pickeview 的高度
@property (nonatomic, assign) NSInteger pickeviewHeight;
// 背景蒙版
@property (nonatomic, strong) UIView * backgroundView;
// 选择器view
@property (nonatomic, strong) UIView * showView;

// 确定/取消/标题控件所在的bar
@property (nonatomic, strong) UIView * toolbar;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UIButton * leftButton;


// 第二列选中的行
@property (nonatomic,assign) NSInteger secondRow;
// 第三列选中的行
@property (nonatomic,assign) NSInteger thirdRow;

/** 数据层级数量 目前支持一级和两级 */
@property (nonatomic, assign) int component;

/** 回调 返回选中的数据 */
@property (nonatomic, copy) LevelPickerChosseResultBlock resultModelBlock;

@end

@implementation JYLevelPickerView
#pragma mark - 初始化

+ (void)jy_initPickviewWithDataSourcesArray:(NSArray<JYLevelPickerModel *> *)array level:(JYLevelPickerViewLevel)level configuration:(void (^)(JYLevelPickerView * pickerView)) configuration resultModelBlock:(LevelPickerChosseResultBlock)resultModelBlock{

    JYLevelPickerView * pickView =  [[JYLevelPickerView alloc] init];
    pickView.frame = [UIScreen mainScreen].bounds;
    pickView.pickerModels = array;
    pickView.component = level;

    [pickView setBaseView];
    [pickView initUI];

    if (configuration) {
        configuration(pickView);
    }
    pickView.resultModelBlock = resultModelBlock;

    [pickView show];
}

/**
 初始化 默认值
 */
- (void) initUI{
    self.contentTextColor = [UIColor colorWithRed:55/255.0 green:73/255.0 blue:83/255.0 alpha:1/1.0];
    self.contentTextFont = [UIFont systemFontOfSize:18];
}

- (void)setBaseView {
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.backgroundView];
    [self.showView addSubview:self.toolbar];
    [self.showView addSubview:self.pickerView];
}

#pragma mark - piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.pickerModels.count;
    }else if (component == 1){
        // 根据选中行号确定位置
        JYLevelPickerModel *pickerModel = self.pickerModels[self.secondRow];
        // 根据上一列的位置确定下一列的数量
        return pickerModel.dataList.count;
    }else{
        // 根据选中行号确定位置
        JYLevelPickerModel *secondpickerModel = self.pickerModels[self.secondRow];
        if (self.thirdRow >= secondpickerModel.dataList.count) {
            self.thirdRow = secondpickerModel.dataList.count - 1;
        }
        JYLevelPickerModel *thirdpickerModel = secondpickerModel.dataList[self.thirdRow];
        // 根据上一列的位置确定下一列的数量
        return thirdpickerModel.dataList.count;
    }
}

#pragma mark - 代理方法
/**
 *  pickerView第component列的第row行显示的字符串
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //判断当前是第几列
    if (component == 0) {
        JYLevelPickerModel *pickerModel = self.pickerModels[row];
        return pickerModel.dataName;
    }else if (component == 1){
        JYLevelPickerModel *pickerModel = self.pickerModels[self.secondRow];
        JYLevelPickerModel * childPickerModel = pickerModel.dataList[row];
        return childPickerModel.dataName;
    }else{
        JYLevelPickerModel *pickerModel = self.pickerModels[self.secondRow];
        JYLevelPickerModel * childPickerModel = pickerModel.dataList[self.thirdRow];
        JYLevelPickerModel * thirdModel = childPickerModel.dataList[row];
        return thirdModel.dataName;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *contentLabel = (UILabel *)view;
    if (!contentLabel) {
        contentLabel = [[UILabel alloc] init];
        contentLabel.minimumScaleFactor = 8;//设置最小字体，与minimumFontSize相同，minimumFontSize在IOS 6后不能使用。
        contentLabel.adjustsFontSizeToFitWidth = YES;//设置字体大小是否适应lalbel宽度
        //在这里设置字体相关属性
        contentLabel.font = self.contentTextFont;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = self.contentTextColor;
        [contentLabel setBackgroundColor:[UIColor clearColor]];
    }
    //重新加载lbl的文字内容
    contentLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return contentLabel;
}

/**
 *  当选中了pickerView的第component列的第row行会调用这个方法
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        // 获得第0列当前选中的行号
        self.secondRow = [self.pickerView selectedRowInComponent:0];
        if (self.component > 1) {// 当有两个层级的时候 才会调用这个  刷新下一个层级
            // 下一级默认回到第一条数据
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            [self pickerView:self.pickerView didSelectRow:0 inComponent:1];
            //刷新 第二列数据
            [pickerView reloadComponent:1];
            if (self.component > 2) {
                [self.pickerView selectRow:0 inComponent:2 animated:YES];
                [self pickerView:self.pickerView didSelectRow:0 inComponent:2];
                //刷新 第三列数据
                [pickerView reloadComponent:2];
            }
        }
    }else if (component == 1 && self.component > 2){
        self.thirdRow = [self.pickerView selectedRowInComponent:1];
        // 下一级默认回到第一条数据
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        [self pickerView:self.pickerView didSelectRow:0 inComponent:2];
        [pickerView reloadComponent:2];
    }

    JYLevelPickerModel *pickerModel = self.pickerModels[self.secondRow];
    // 获得第1列当前选中的行号
    if (self.component > 1) {
        NSInteger firstRow = [pickerView selectedRowInComponent:1];
        pickerModel.selectedChildModel = pickerModel.dataList[firstRow];
        if (self.component > 2) {
            NSInteger thirdRow = [pickerView selectedRowInComponent:2];
            pickerModel.selectedChildModel.selectedChildModel = pickerModel.selectedChildModel.dataList[thirdRow];
        }
    }
    self.pickerModel = pickerModel;
}

#pragma mark - 事件触发

-(void)remove{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = self.pickeviewHeight + ToobarHeight;
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.25 animations:^{
        self.showView.frame = CGRectMake(toolViewX, [UIScreen mainScreen].bounds.size.height, toolViewW, toolViewH);
        [self.backgroundView setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show{
    self.pickerView.frame=CGRectMake(0, ToobarHeight, self.toolbar.frame.size.width, self.pickerView.frame.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGFloat toolViewX = 0;
    CGFloat toolViewH = self.pickeviewHeight+ToobarHeight;
    CGFloat toolViewY = [UIScreen mainScreen].bounds.size.height - toolViewH;
    if (IS_IPHONE_X) {
        toolViewY -= DangerArea;
    }
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.showView.frame = CGRectMake(toolViewX, [UIScreen mainScreen].bounds.size.height, toolViewW, toolViewH);
    [UIView animateWithDuration:0.25 animations:^{
        self.showView.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
        [self.backgroundView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6]];
    }];
}

-(void)rightButtonClick{
    if (self.pickerModel == nil) {
        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    }
    if (self.resultModelBlock) {
        JYLevelPickerModel * lastModel = [[JYLevelPickerModel alloc] init];
        if (self.component == 1) {
            lastModel = self.pickerModel;
        }else if (self.component == 2){
            lastModel = self.pickerModel.selectedChildModel;
        }else if (self.component == 3){
            lastModel = self.pickerModel.selectedChildModel.selectedChildModel;
        }
        self.resultModelBlock(self.pickerModel,lastModel);
    }
    [self remove];
}

#pragma mark - 懒加载

- (UIView *)backgroundView{
    if (_backgroundView == nil) {
        if (IS_IPHONE_X) {
            _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - DangerArea)];
        }else{
            _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }

        [_backgroundView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6]];
        UITapGestureRecognizer* singleRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        //添加一个手势监测；
        [_backgroundView addGestureRecognizer:singleRecognizer];
    }
    return _backgroundView;
}

- (UIView *)showView {
    if (_showView == nil) {
        _showView = [[UIView alloc] init];
        [self.backgroundView addSubview:_showView];
    }
    return _showView;
}

- (UIPickerView *)pickerView{
    if (_pickerView == nil) {
        UIPickerView *pickView = [[UIPickerView alloc] init];
        pickView.backgroundColor = [UIColor whiteColor];
        pickView.delegate = self;
        pickView.dataSource = self;
        pickView.frame = CGRectMake(0, ToobarHeight, self.toolbar.frame.size.width, pickView.frame.size.height);
        _pickerView = pickView;
        self.pickeviewHeight = pickView.frame.size.height;
    }
    return _pickerView;
}

- (UIView *)toolbar{
    if (_toolbar == nil) {
        UIView *toolbarV=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, ToobarHeight)];
        [toolbarV setBackgroundColor:[UIColor whiteColor]];
        _toolbar = toolbarV;
        [_toolbar addSubview:self.leftButton];
        [_toolbar addSubview:self.rightButton];
        [_toolbar addSubview:self.titleLabel];
    }
    return _toolbar;
}

- (UIButton *)leftButton{
    if (_leftButton == nil) {
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [leftButton setFrame:CGRectMake(10, 0, ToobarHeight, ToobarHeight)];
        [leftButton addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:18];
        // 999999
        [leftButton setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        _leftButton = leftButton;
    }
    return _leftButton;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, ToobarHeight)];
        [titleLabel setBackgroundColor:[UIColor whiteColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        // 656E7B
        [titleLabel setTextColor:[UIColor colorWithRed:101/255.0 green:110/255.0 blue:123/255.0 alpha:1]];
        titleLabel.font =  [UIFont boldSystemFontOfSize:16];
        [titleLabel setCenter:self.toolbar.center];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

-(UIButton *)rightButton{
    if (_rightButton == nil) {
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - (10+ToobarHeight), 0, ToobarHeight, ToobarHeight)];
        [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:18];
        // 4A78F8
        [rightButton setTitleColor:[UIColor colorWithRed:74/255.0 green:120/255.0 blue:248/255.0 alpha:1] forState:UIControlStateNormal];
        _rightButton = rightButton;
    }
    return _rightButton;
}

#pragma mark - 基础设置
- (void)setDefaultCode:(NSString *)defaultCode{
    _defaultCode = defaultCode;
    if (defaultCode == nil || [defaultCode isEqualToString:@""]) {
        return;
    }
    // 用来保存每一个层级默认初始化的位置
    NSMutableArray * mArr = [NSMutableArray array];
    for (int i = 0 ; i < self.component; i++) {
        mArr[i] = @"0";
    }

    if (self.pickerModels.count > 0) {
        [self.pickerModels enumerateObjectsUsingBlock:^(JYLevelPickerModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.dataCode isEqualToString:defaultCode]) {
                mArr[0] = [NSString stringWithFormat:@"%lu",(unsigned long)idx];
                *stop = YES;
            }else{
                [model.dataList enumerateObjectsUsingBlock:^(JYLevelPickerModel * childModel, NSUInteger childIdx, BOOL * _Nonnull stop) {
                    if ([childModel.dataCode isEqualToString:defaultCode]) {
                        mArr[0] = [NSString stringWithFormat:@"%lu",(unsigned long)idx];
                        mArr[1] = [NSString stringWithFormat:@"%lu",(unsigned long)childIdx];
                        *stop = YES;
                    }else{
                        [childModel.dataList enumerateObjectsUsingBlock:^(JYLevelPickerModel * thirdModel, NSUInteger thirdIdx, BOOL * _Nonnull stop) {
                            if ([thirdModel.dataCode isEqualToString:defaultCode]) {
                                mArr[0] = [NSString stringWithFormat:@"%lu",(unsigned long)idx];
                                mArr[1] = [NSString stringWithFormat:@"%lu",(unsigned long)childIdx];
                                mArr[2] = [NSString stringWithFormat:@"%lu",(unsigned long)thirdIdx];
                                *stop = YES;
                            }
                        }];
                    }
                }];
            }
        }];
        NSString * first = mArr.firstObject;
        self.secondRow = first.integerValue;
        for (int i = 0; i < mArr.count; i++) {
            NSString * row = mArr[i];
            [self.pickerView selectRow:row.integerValue inComponent:i animated:YES];
            [self pickerView:self.pickerView didSelectRow:row.integerValue inComponent:i];
            [self.pickerView reloadComponent:i];
        }
    }
}

- (void)setContentTextFont:(UIFont *)contentTextFont{
    _contentTextFont = contentTextFont;
    [self.pickerView reloadAllComponents];
}

-(void)setContentTextColor:(UIColor *)contentTextColor{
    _contentTextColor = contentTextColor;
    [self.pickerView reloadAllComponents];
}

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
    self.toolbar.backgroundColor = toolbarBackgroundColor;
    self.titleLabel.backgroundColor = toolbarBackgroundColor;
}

-(void)dealloc{
    NSLog(@"JYLevelPickerView  dealloc 销毁");
}

@end