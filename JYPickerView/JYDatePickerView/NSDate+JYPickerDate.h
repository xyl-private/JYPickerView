//
//  NSDate+JYPickerDate.h
//  JYPickerView
//
//  Created by McIntosh on 2018/11/9.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (JYPickerDate)
+ (NSCalendar *)currentCalendar;
+ (NSDate *)dateWithStr:(NSString *)datestr format:(NSString *)format;

- (BOOL)isEarlierThanDate:(NSDate *)aDate;
- (BOOL)isLaterThanDate:(NSDate *)aDate;

@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger seconds;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger week;
@property (nonatomic, readonly) NSInteger weekday;
@property (nonatomic, readonly) NSInteger nthWeekday;
@property (nonatomic, readonly) NSInteger year;

@end

NS_ASSUME_NONNULL_END
