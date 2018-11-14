//
//  JYDatePickerView.m
//  DatePicker-Demo
//
//  Created by xyanl on 2018/11/9.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import "JYDatePickerView.h"
#import "NSDate+JYPickerDate.h"
#import "JYPickerToolBarView.h"

#define IS_IPHONE_X ([UIScreen mainScreen].bounds.size.height == 812.0f) ? YES : NO

typedef NS_OPTIONS(NSInteger, JYDatePickerComponentsOption) {
    kJYDatePickerComponentsOptionYear = 1,
    kJYDatePickerComponentsOptionMonth = 1 << 1,
    kJYDatePickerComponentsOptionDay = 1 << 2,
    kJYDatePickerComponentsOptionHour = 1 << 3,
    kJYDatePickerComponentsOptionMinute = 1 << 4,
    kJYDatePickerComponentsOptionSecond = 1 << 5,
    kJYDatePickerComponentsOptionCount = 6
};

static NSInteger const kAllDateOptions[] = {
    kJYDatePickerComponentsOptionYear,
    kJYDatePickerComponentsOptionMonth,
    kJYDatePickerComponentsOptionDay,
    kJYDatePickerComponentsOptionHour,
    kJYDatePickerComponentsOptionMinute,
    kJYDatePickerComponentsOptionSecond,
};
// 年月日 时分秒
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYMDHMS =
kJYDatePickerComponentsOptionYear |
kJYDatePickerComponentsOptionMonth |
kJYDatePickerComponentsOptionDay |
kJYDatePickerComponentsOptionHour |
kJYDatePickerComponentsOptionMinute |
kJYDatePickerComponentsOptionSecond;

// 年月日 时分
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYMDHM = kJYDatePickerComponentsOptionYear |
kJYDatePickerComponentsOptionMonth |
kJYDatePickerComponentsOptionDay |
kJYDatePickerComponentsOptionHour |
kJYDatePickerComponentsOptionMinute;

// 年
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleY = kJYDatePickerComponentsOptionYear;

// 年月
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYM = kJYDatePickerComponentsOptionYear |
kJYDatePickerComponentsOptionMonth;

// 年月日
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYMD = kJYDatePickerComponentsOptionYear |
kJYDatePickerComponentsOptionMonth |
kJYDatePickerComponentsOptionDay;

// 月日
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleMD = kJYDatePickerComponentsOptionMonth |
kJYDatePickerComponentsOptionDay;

// 月日 时分
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleMDHM = kJYDatePickerComponentsOptionMonth |
kJYDatePickerComponentsOptionDay |
kJYDatePickerComponentsOptionHour |
kJYDatePickerComponentsOptionMinute;

// 日 时分
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleDHM = kJYDatePickerComponentsOptionDay |
kJYDatePickerComponentsOptionHour |
kJYDatePickerComponentsOptionMinute;

// 时分
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleHM = kJYDatePickerComponentsOptionHour |
kJYDatePickerComponentsOptionMinute;

// 时分秒
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleHMS  = kJYDatePickerComponentsOptionHour |
kJYDatePickerComponentsOptionMinute |
kJYDatePickerComponentsOptionSecond;

static CGFloat const kConfirmBtnHeight = 44;

@interface JYDatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
// 是否需要刷新 yes 刷新
@property (nonatomic, assign) BOOL needReload;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<NSNumber *> *> *optionToUnitDic;
@property (nonatomic, copy) void (^confirmBlock)(NSDate *date);

/** Description */
@property (nonatomic, strong) UIView *container;

/** picker Tool Bar View */
@property (nonatomic, strong) JYPickerToolBarView * pickerToolBarView;

@end


@implementation JYDatePickerView{
@private
    NSDate *_defaultDate;
    NSDate *_minimumDate;
    NSDate *_maximumDate;
    NSMutableArray<NSNumber *> *_optionArray;
}

+ (void)jy_datePickerWithStyle:(JYDatePickerComponentsStyle)style configuration:(void (^)(JYDatePickerView * datePickerView))configuration resultDateBlock:(void (^)(NSDate *date))resultDateBlock{
    CGRect windowBounds = UIApplication.sharedApplication.keyWindow.bounds;
    CGFloat pickerHeight = CGRectGetHeight(windowBounds) * 0.3;
    JYDatePickerView * datePick = [[self alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(windowBounds) - pickerHeight , CGRectGetWidth(windowBounds), pickerHeight) style:style confirmBlock:resultDateBlock];
    datePick.isShowUnit = YES;
    if (configuration) {
        configuration(datePick);
    }
    [datePick show];
}

- (instancetype)initWithFrame:(CGRect)frame style:(JYDatePickerComponentsStyle)style confirmBlock:(void (^)(NSDate *date))confirmBlock {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.backgroundColor = UIColor.whiteColor;
        self.delegate = self;
        self.dataSource = self;
        _confirmBlock = confirmBlock;
        [self setNeedReload];
    }
    return self;
}

- (void)show {
    UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
    if (self.superview.superview == keyWindow) {
        return;
    }
    [keyWindow addSubview:self.container];
}

- (void)dismiss {
    [self.superview removeFromSuperview];
}

- (void)didConfirm{
    if (nil != _confirmBlock) {
        _confirmBlock(_defaultDate);
    }
    [self dismiss];
}

- (void)setNeedReload {
    _needReload = YES;
    [self reload];
}

- (void)reload {
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nil == wSelf || !wSelf.needReload) {
            return;
        }
        wSelf.needReload = NO;
        
        NSDate *date = wSelf.defaultDate;
        
        NSMutableArray *yearArray = [wSelf unitArrayForOption:kJYDatePickerComponentsOptionYear];
        NSMutableArray *monthArray = [wSelf unitArrayForOption:kJYDatePickerComponentsOptionMonth];
        NSMutableArray *dayArray = [wSelf unitArrayForOption:kJYDatePickerComponentsOptionDay];
        NSMutableArray *hourArray = [wSelf unitArrayForOption:kJYDatePickerComponentsOptionHour];
        NSMutableArray *minuteArray = [wSelf unitArrayForOption:kJYDatePickerComponentsOptionMinute];
        NSMutableArray *secondArray = [wSelf unitArrayForOption:kJYDatePickerComponentsOptionSecond];
        [yearArray removeAllObjects];
        [monthArray removeAllObjects];
        [dayArray removeAllObjects];
        [hourArray removeAllObjects];
        [minuteArray removeAllObjects];
        [secondArray removeAllObjects];
        
        NSInteger minYear = wSelf.minimumDate.year;
        NSInteger maxYear = wSelf.maximumDate.year;
        for (NSInteger i = minYear; i <= maxYear; ++i) {
            [yearArray addObject:@(i)];
        }
        
        NSInteger minMonth = 1;
        NSInteger minDay = 1;
        NSInteger minHour = 0;
        NSInteger minMinute = 0;
        NSInteger minSecond = 0;
        if (date.year == minYear) {
            minMonth = wSelf.minimumDate.month;
            if (date.month == minMonth) {
                minDay = wSelf.minimumDate.day;
                if (date.day == minDay) {
                    minHour = wSelf.minimumDate.hour;
                    if (date.hour == minHour) {
                        minMinute = wSelf.minimumDate.minute;
                        if (date.minute == minMinute) {
                            minSecond = wSelf.minimumDate.seconds;
                        }
                    }
                }
            }
        }
        NSInteger maxMonth = 12;
        NSCalendar *c = [NSCalendar currentCalendar];
        NSRange days = [c rangeOfUnit:NSCalendarUnitDay
                               inUnit:NSCalendarUnitMonth
                              forDate:date];
        NSInteger maxDay = days.length;
        NSInteger maxHour = 23;
        NSInteger maxMinute = 59;
        NSInteger maxSecond = 59;
        if (date.year == maxYear) {
            maxMonth = wSelf.maximumDate.month;
            if (date.month == maxMonth) {
                maxDay = wSelf.maximumDate.day;
                if (date.day == maxDay) {
                    maxHour = wSelf.maximumDate.hour;
                    if (date.hour == maxHour) {
                        maxMinute = wSelf.maximumDate.minute;
                        if (date.minute == maxMinute) {
                            maxSecond = wSelf.maximumDate.seconds;
                        }
                    }
                }
            }
        }
        
        for (NSInteger i = minMonth; i <= maxMonth; ++i) {
            [monthArray addObject:@(i)];
        }
        for (NSInteger i = minDay; i <= maxDay; ++i) {
            [dayArray addObject:@(i)];
        }
        for (NSInteger i = minHour; i <= maxHour; ++i) {
            [hourArray addObject:@(i)];
        }
        for (NSInteger i = minMinute; i <= maxMinute; ++i) {
            [minuteArray addObject:@(i)];
        }
        for (NSInteger i = minSecond; i <= maxSecond; ++i) {
            [secondArray addObject:@(i)];
        }
        
        [wSelf reloadAllComponents];
        
        for (NSInteger i = 0; i < wSelf.optionArray.count; ++i) {
            JYDatePickerComponentsOption option = self.optionArray[i].integerValue;
            NSArray *arry = [self unitArrayForOption:option];
            switch (option) {
                case kJYDatePickerComponentsOptionYear: {
                    [wSelf selectRow:[arry indexOfObject:@(date.year)] inComponent:i animated:NO];
                }
                    break;
                case kJYDatePickerComponentsOptionMonth: {
                    [wSelf selectRow:[arry indexOfObject:@(date.month)] inComponent:i animated:NO];
                }
                    break;
                case kJYDatePickerComponentsOptionDay: {
                    [wSelf selectRow:[arry indexOfObject:@(date.day)] inComponent:i animated:NO];
                }
                    break;
                case kJYDatePickerComponentsOptionHour: {
                    [wSelf selectRow:[arry indexOfObject:@(date.hour)] inComponent:i animated:NO];
                }
                    break;
                case kJYDatePickerComponentsOptionMinute: {
                    [wSelf selectRow:[arry indexOfObject:@(date.minute)] inComponent:i animated:NO];
                }
                    break;
                case kJYDatePickerComponentsOptionSecond: {
                    [wSelf selectRow:[arry indexOfObject:@(date.seconds)] inComponent:i animated:NO];
                }
                    break;
                default:
                    break;
            }
        }
    });
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.optionArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self unitArrayForOption:self.optionArray[component].integerValue].count;
}


#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UILabel *label = (UILabel *)view ?: ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    JYDatePickerComponentsOption option = self.optionArray[component].integerValue;
    
    NSString *suffix = nil;
    switch (option) {
        case kJYDatePickerComponentsOptionYear:
            suffix = @"年";
            break;
        case kJYDatePickerComponentsOptionMonth:
            suffix = @"月";
            break;
        case kJYDatePickerComponentsOptionDay:
            suffix = @"日";
            break;
        case kJYDatePickerComponentsOptionHour:
            suffix = @"时";
            break;
        case kJYDatePickerComponentsOptionMinute:
            suffix = @"分";
            break;
        case kJYDatePickerComponentsOptionSecond:
            suffix = @"秒";
            break;
        default:
            break;
    }
    // 是否显示 单位
    if (!self.isShowUnit) {
        suffix = @"";
    }

    NSArray *arry = [self unitArrayForOption:option];
    label.text = [NSString stringWithFormat:@"%@%@", arry[row], suffix];
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger year = _defaultDate.year;
    NSInteger month = _defaultDate.month;
    NSInteger day = _defaultDate.day;
    NSInteger hour = _defaultDate.hour;
    NSInteger minute = _defaultDate.minute;
    NSInteger second = _defaultDate.seconds;
    JYDatePickerComponentsOption option = self.optionArray[component].integerValue;
    NSInteger num = [self unitArrayForOption:option][row].integerValue;
    switch (option) {
        case kJYDatePickerComponentsOptionYear:
            year = num;
            break;
        case kJYDatePickerComponentsOptionMonth:
            month = num;
            break;
        case kJYDatePickerComponentsOptionDay:
            day = num;
            break;
        case kJYDatePickerComponentsOptionHour:
            hour = num;
            break;
        case kJYDatePickerComponentsOptionMinute:
            minute = num;
            break;
        case kJYDatePickerComponentsOptionSecond:
            second = num;
            break;
        default:
            break;
    }
    NSDate *date = [NSDate dateWithStr:[NSString stringWithFormat:@"%zd-%zd-01 00:00:00", year, month] format:@"yyyy-MM-dd HH:mm:ss"];
    NSRange days = [NSCalendar.currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                    inUnit:NSCalendarUnitMonth
                                                   forDate:date];
    self.defaultDate = [NSDate dateWithStr:[NSString stringWithFormat:@"%zd-%zd-%zd %zd:%zd:%zd", year, month, MIN(day, days.length), hour, minute,second] format:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark - 懒加载

- (UIView *)container{
    if (_container == nil) {
        UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
        UIView *container = [[UIView alloc] init];
        container.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.6];
        UITapGestureRecognizer* singleRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        //添加一个手势监测；
        [container addGestureRecognizer:singleRecognizer];
        if (IS_IPHONE_X) {
            container.frame = CGRectMake(0, 0, keyWindow.bounds.size.width, keyWindow.bounds.size.height - 34);
        }else{
            container.frame = keyWindow.bounds;
        }
        [container addSubview:self];
        [container addSubview:self.pickerToolBarView];
        _container = container;
    }
    return _container;
}

- (JYPickerToolBarView *)pickerToolBarView{
    if (_pickerToolBarView == nil) {
        _pickerToolBarView = [[JYPickerToolBarView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y - kConfirmBtnHeight, CGRectGetWidth(self.frame), kConfirmBtnHeight) didConfirmDate:^(JYPickerToolBarViewButtonType type) {
            if (type == JYPickerToolBarViewButtonTypeLeft) {
                [self dismiss];
                NSLog(@"左侧按钮");
            }else{
                [self didConfirm];
                NSLog(@"右侧按钮");
            }
        }];
    }
    return _pickerToolBarView;
}

- (NSDate *)minimumDate {
    if (nil == _minimumDate) {
        _minimumDate = [NSDate dateWithStr:@"1900-01-01 00:00:00" format:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _minimumDate;
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    if (nil != _minimumDate || ![_minimumDate isEqualToDate:minimumDate]) {
        _minimumDate = minimumDate;
        [self setNeedReload];
    }
    NSParameterAssert(nil == _minimumDate || nil == _maximumDate || [_minimumDate isEarlierThanDate:_maximumDate]);
}

- (NSDate *)maximumDate {
    if (nil == _maximumDate) {
        _maximumDate = [NSDate dateWithStr:@"2099-12-31 23:59:59" format:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _maximumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    if (nil == _maximumDate || ![_maximumDate isEqualToDate:maximumDate]) {
        _maximumDate = maximumDate;
        [self setNeedReload];
    }
    NSParameterAssert(nil == _minimumDate || nil == _maximumDate || [_minimumDate isEarlierThanDate:_maximumDate]);
}

- (void)setDefaultDate:(NSDate *)defaultDate {
    if (nil == _defaultDate || ![_defaultDate isEqualToDate:defaultDate]) {
        _defaultDate = defaultDate;
        [self setNeedReload];
    }
}

- (NSDate *)defaultDate {
    if (nil == _defaultDate) {
        _defaultDate = NSDate.date;
    }
    if ([_defaultDate isEarlierThanDate:self.minimumDate]) {
        _defaultDate = _minimumDate;
    } else if ([_defaultDate isLaterThanDate:self.maximumDate]) {
        _defaultDate = _maximumDate;
    }
    return _defaultDate;
}

- (void)setStyle:(JYDatePickerComponentsStyle)style {
    if (_style != style) {
        _style = style;

        [_optionArray removeAllObjects];
        if (nil == _optionArray) {
            _optionArray = [NSMutableArray array];
        }
        for (NSInteger i = 0; i < kJYDatePickerComponentsOptionCount; ++i) {
            NSInteger option = kAllDateOptions[i];
            if ((option & _style) == option) {
                [_optionArray addObject:@(option)];
            }
        }
        [self setNeedReload];
    }
}

- (NSArray<NSNumber *> *)optionArray {
    return _optionArray;
}

- (NSMutableArray<NSNumber *> *)unitArrayForOption:(JYDatePickerComponentsOption)option {
    NSMutableArray<NSNumber *> *array = _optionToUnitDic[@(option)];
    if (nil == array) {
        array = [NSMutableArray array];
        if (nil == _optionToUnitDic) {
            _optionToUnitDic = [NSMutableDictionary dictionary];
        }
        _optionToUnitDic[@(option)] = array;
    }
    return array;
}

-(void)setIsShowUnit:(BOOL)isShowUnit{
    _isShowUnit = isShowUnit;
}

- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    self.pickerToolBarView.titleText = titleText;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor{
    _titleTextColor = titleTextColor;
    self.pickerToolBarView.titleTextColor = titleTextColor;
}

- (void)setTitleTextFont:(UIFont *)titleTextFont{
    _titleTextFont = titleTextFont;
    self.pickerToolBarView.titleTextFont = titleTextFont;
}

- (void)setLeftTitleText:(NSString *)leftTitleText{
    _leftTitleText = leftTitleText;
    self.pickerToolBarView.leftTitleText = leftTitleText;
}

- (void)setLeftTextFont:(UIFont *)leftTextFont{
    _leftTextFont = leftTextFont;
    self.pickerToolBarView.leftTextFont = leftTextFont;
}

- (void)setLeftTextColor:(UIColor *)leftTextColor{
    _leftTextColor = leftTextColor;
    self.pickerToolBarView.leftTextColor = leftTextColor;
}

- (void)setRightTitleText:(NSString *)rightTitleText{
    _rightTitleText = rightTitleText;
    self.pickerToolBarView.rightTitleText = rightTitleText;
}

- (void)setRightTextFont:(UIFont *)rightTextFont{
    _rightTextFont = rightTextFont;
    self.pickerToolBarView.rightTextFont = rightTextFont;
}

- (void)setRightTextColor:(UIColor *)rightTextColor{
    _rightTextColor = rightTextColor;
    self.pickerToolBarView.rightTextColor = rightTextColor;
}

- (void)setToolbarBackgroundColor:(UIColor *)toolbarBackgroundColor{
    _toolbarBackgroundColor = toolbarBackgroundColor;
    self.pickerToolBarView.toolbarBackgroundColor = toolbarBackgroundColor;
}

- (void)setIsShowLine:(BOOL)isShowLine{
    _isShowLine = isShowLine;
    self.pickerToolBarView.isShowLine = isShowLine;
}

- (void)setLineViewColor:(UIColor *)lineViewColor{
    _lineViewColor = lineViewColor;
    self.pickerToolBarView.lineViewColor = lineViewColor;
}

- (void)dealloc{
    NSLog(@"----- JYDatePickerView ----- 销毁");
}

@end
