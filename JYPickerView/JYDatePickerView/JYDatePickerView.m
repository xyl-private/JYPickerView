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

typedef NS_OPTIONS(NSInteger, JYDatePickerComponentsOption) {
    kJYDatePickerComponentsOptionYear = 1,
    kJYDatePickerComponentsOptionMonth = 1 << 1,
    kJYDatePickerComponentsOptionDay = 1 << 2,
    kJYDatePickerComponentsOptionHour = 1 << 3,
    kJYDatePickerComponentsOptionMinute = 1 << 4,
    kJYDatePickerComponentsOptionCount = 5
};

static NSInteger const kAllDateOptions[] = {
    kJYDatePickerComponentsOptionYear,
    kJYDatePickerComponentsOptionMonth,
    kJYDatePickerComponentsOptionDay,
    kJYDatePickerComponentsOptionHour,
    kJYDatePickerComponentsOptionMinute,
};

JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYMDHM = kJYDatePickerComponentsOptionYear | kJYDatePickerComponentsOptionMonth | kJYDatePickerComponentsOptionDay | kJYDatePickerComponentsOptionHour | kJYDatePickerComponentsOptionMinute;
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleMDHM = kJYDatePickerComponentsOptionMonth | kJYDatePickerComponentsOptionDay | kJYDatePickerComponentsOptionHour | kJYDatePickerComponentsOptionMinute;;
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleDHM = kJYDatePickerComponentsOptionDay | kJYDatePickerComponentsOptionHour | kJYDatePickerComponentsOptionMinute;
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleYMD = kJYDatePickerComponentsOptionYear | kJYDatePickerComponentsOptionMonth | kJYDatePickerComponentsOptionDay;
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleMD = kJYDatePickerComponentsOptionMonth | kJYDatePickerComponentsOptionDay;
JYDatePickerComponentsStyle const kJYDatePickerComponentsStyleHM = kJYDatePickerComponentsOptionHour | kJYDatePickerComponentsOptionMinute;


static CGFloat const kConfirmBtnHeight = 50;

@interface JYDatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) BOOL needReload;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSMutableArray<NSNumber *> *> *optionToUnitDic;
@property (nonatomic, copy) void (^confirmBlock)(NSDate *date);

@end


@implementation JYDatePickerView{
@private
    NSDate *_selectDate;
    NSDate *_minLimitDate;
    NSDate *_maxLimitDate;
    NSMutableArray<NSNumber *> *_optionArray;
}

+ (void)jy_datePickerWithStyle:(JYDatePickerComponentsStyle)style configuration:(void (^)(JYDatePickerView * datePickerView))configuration resultDateBlock:(void (^)(NSDate *date))resultDateBlock{
    CGRect windowBounds = UIApplication.sharedApplication.keyWindow.bounds;
    CGFloat pickerHeight = CGRectGetHeight(windowBounds) * 0.35;
    JYDatePickerView * datePick = [[self alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(windowBounds) - pickerHeight , CGRectGetWidth(windowBounds), pickerHeight) style:style confirmBlock:resultDateBlock];
    
    if (configuration) {
        configuration(datePick);
    }
    [datePick show];
}


- (void)show {
    UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
    if (self.superview.superview == keyWindow) {
        return;
    }
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [container addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    container.frame = keyWindow.bounds;
    [container addSubview:self];
    
    JYPickerToolBarView * pickerToolBarView = [[JYPickerToolBarView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y - kConfirmBtnHeight, CGRectGetWidth(self.frame), kConfirmBtnHeight) didConfirmDate:^(JYPickerToolBarViewButtonType type) {
        if (type == JYPickerToolBarViewButtonTypeLeft) {
            [self dismiss];
            NSLog(@"左侧按钮");
        }else{
            [self didConfirm];
            NSLog(@"右侧按钮");
        }
    }];
    [container addSubview:pickerToolBarView];
    [keyWindow addSubview:container];
}

- (void)dismiss {
    [self.superview removeFromSuperview];
}

- (void)didConfirm{
    if (nil != _confirmBlock) {
        _confirmBlock(_selectDate);
    }
    [self dismiss];
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

- (NSDate *)minLimitDate {
    if (nil == _minLimitDate) {
        _minLimitDate = [NSDate dateWithStr:@"1900-01-01 00:00" format:@"yyyy-MM-dd HH:mm"];
    }
    return _minLimitDate;
}

- (void)setMinLimitDate:(NSDate *)minLimitDate {
    if (nil != _minLimitDate || ![_minLimitDate isEqualToDate:minLimitDate]) {
        _minLimitDate = minLimitDate;
        [self setNeedReload];
    }
    NSParameterAssert(nil == _minLimitDate || nil == _maxLimitDate || [_minLimitDate isEarlierThanDate:_maxLimitDate]);
}

- (NSDate *)maxLimitDate {
    if (nil == _maxLimitDate) {
        _maxLimitDate = [NSDate dateWithStr:@"2099-12-31 23:59" format:@"yyyy-MM-dd HH:mm"];
    }
    return _maxLimitDate;
}

- (void)setMaxLimitDate:(NSDate *)maxLimitDate {
    if (nil == _maxLimitDate || ![_maxLimitDate isEqualToDate:maxLimitDate]) {
        _maxLimitDate = maxLimitDate;
        [self setNeedReload];
    }
    NSParameterAssert(nil == _minLimitDate || nil == _maxLimitDate || [_minLimitDate isEarlierThanDate:_maxLimitDate]);
}

- (void)setSelectDate:(NSDate *)selectDate {
    if (nil == _selectDate || ![_selectDate isEqualToDate:selectDate]) {
        _selectDate = selectDate;
        [self setNeedReload];
    }
}

- (NSDate *)selectDate {
    if (nil == _selectDate) {
        _selectDate = NSDate.date;
    }
    if ([_selectDate isEarlierThanDate:self.minLimitDate]) {
        _selectDate = _minLimitDate;
    } else if ([_selectDate isLaterThanDate:self.maxLimitDate]) {
        _selectDate = _maxLimitDate;
    }
    return _selectDate;
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
        
        NSDate *date = wSelf.selectDate;
        
        NSMutableArray *yearArray = [wSelf unitArrayForOption:kJYDatePickerComponentsOptionYear];
        NSMutableArray *monthArray = [wSelf unitArrayForOption:kJYDatePickerComponentsOptionMonth];
        NSMutableArray *dayArray = [wSelf unitArrayForOption:kJYDatePickerComponentsOptionDay];
        NSMutableArray *hourArray = [wSelf unitArrayForOption:kJYDatePickerComponentsOptionHour];
        NSMutableArray *minuteArray = [wSelf unitArrayForOption:kJYDatePickerComponentsOptionMinute];
        [yearArray removeAllObjects];
        [monthArray removeAllObjects];
        [dayArray removeAllObjects];
        [hourArray removeAllObjects];
        [minuteArray removeAllObjects];
        
        NSInteger minYear = wSelf.minLimitDate.year;
        NSInteger maxYear = wSelf.maxLimitDate.year;
        for (NSInteger i = minYear; i <= maxYear; ++i) {
            [yearArray addObject:@(i)];
        }
        
        NSInteger minMonth = 1;
        NSInteger minDay = 1;
        NSInteger minHour = 0;
        NSInteger minMinute = 0;
        if (date.year == minYear) {
            minMonth = wSelf.minLimitDate.month;
            if (date.month == minMonth) {
                minDay = wSelf.minLimitDate.day;
                if (date.day == minDay) {
                    minHour = wSelf.minLimitDate.hour;
                    if (date.hour == minHour) {
                        minMinute = wSelf.minLimitDate.minute;
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
        if (date.year == maxYear) {
            maxMonth = wSelf.maxLimitDate.month;
            if (date.month == maxMonth) {
                maxDay = wSelf.maxLimitDate.day;
                if (date.day == maxDay) {
                    maxHour = wSelf.maxLimitDate.hour;
                    if (date.hour == maxHour) {
                        maxMinute = wSelf.maxLimitDate.minute;
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
        default:
            break;
    }
    NSArray *arry = [self unitArrayForOption:option];
    label.text = [NSString stringWithFormat:@"%@%@", arry[row], suffix];
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger year = _selectDate.year;
    NSInteger month = _selectDate.month;
    NSInteger day = _selectDate.day;
    NSInteger hour = _selectDate.hour;
    NSInteger minute = _selectDate.minute;
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
        default:
            break;
    }
    NSDate *date = [NSDate dateWithStr:[NSString stringWithFormat:@"%zd-%zd-01 00:00", year, month] format:@"yyyy-MM-dd HH:mm"];
    NSRange days = [NSCalendar.currentCalendar rangeOfUnit:NSCalendarUnitDay
                                                    inUnit:NSCalendarUnitMonth
                                                   forDate:date];
    self.selectDate = [NSDate dateWithStr:[NSString stringWithFormat:@"%zd-%zd-%zd %zd:%zd", year, month, MIN(day, days.length), hour, minute] format:@"yyyy-MM-dd HH:mm"];
}

- (void)dealloc{
    NSLog(@"----- JYDatePickerView ----- 销毁");
}

@end
