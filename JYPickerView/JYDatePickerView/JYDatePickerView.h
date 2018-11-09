//
//  JYDatePickerView.h
//  DatePicker-Demo
//
//  Created by McIntosh on 2018/11/9.
//  Copyright © 2018 ray. All rights reserved.
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
+ (void)jy_datePickerWithStyle:(JYDatePickerComponentsStyle)style configuration:(void (^)(JYDatePickerView * datePickerView)) configuration resultDateBlock:(void (^)(NSDate *date))resultDateBlock;
- (void)show;

@property (nonatomic, assign) JYDatePickerComponentsStyle style;
@property (nonatomic, strong) NSDate *minLimitDate;
@property (nonatomic, strong) NSDate *maxLimitDate;
@property (nonatomic, strong) NSDate *selectDate;

@end
NS_ASSUME_NONNULL_END
