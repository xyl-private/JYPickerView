//
//  JYLevelPickerViewModel.h
//  JYPickerView
//
//  Created by McIntosh on 2018/11/13.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYLevelPickerViewModel : NSObject
+ (NSMutableArray *) jy_getAllAddressInfoWithSubAddrs:(NSArray *)array sqliteName:(NSString *)sqliteName;

+ (NSMutableArray *) jy_getAddressInfoWithSqliteName:(NSString *)sqliteName code:(NSString*)code conditional:(NSString *)conditional;
@end

NS_ASSUME_NONNULL_END
