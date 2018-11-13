//
//  ViewController.m
//  JYPickerView
//
//  Created by xyanl on 2018/11/9.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import "ViewController.h"
#import "JYDatePickerView.h"

#import <YYModel.h>
#import "JYLevelPickerModel.h"
#import "JYLevelPickerView.h"
#import "JYLevelAddrPickerModel.h"

#import "JYLevelPickerViewModel.h"
#import "FMDB.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (copy, nonatomic) NSString * addrCode;

/** Description */
@property (nonatomic, strong) NSDictionary * optionToUnitDic;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)addrAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    NSArray * arr = [JYLevelPickerViewModel jy_getAllAddressDataSourceWithSqliteName:@"jyAddress"];
    NSArray * models = [NSArray yy_modelArrayWithClass:[JYLevelAddrPickerModel class] json:arr];
    [JYLevelPickerView jy_initPickviewWithDataSourcesArray:models level:JYLevelPickerViewLevelThree configuration:^(JYLevelPickerView * _Nonnull pickerView) {
        pickerView.defaultCode = self.addrCode;
        pickerView.pickerToolBarView.titleText = @"地址选择器";
    } resultModelBlock:^(JYLevelPickerModel * _Nonnull resultModel, JYLevelPickerModel * _Nonnull lastModel) {
        weakSelf.addrLabel.text = [NSString stringWithFormat:@"%@ -> %@ -> %@  -> code:%@",resultModel.dataName,resultModel.selectedChildModel.dataName,resultModel.selectedChildModel.selectedChildModel.dataName,lastModel.dataCode];
        weakSelf.addrCode = lastModel.dataCode;
    }];
}


- (IBAction)datePickerAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [JYDatePickerView jy_datePickerWithStyle:kJYDatePickerComponentsStyleYMDHMS configuration:^(JYDatePickerView *datePickerView) {
        NSDateFormatter * df = [[NSDateFormatter alloc] init ];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        datePickerView.minLimitDate = [df dateFromString:@"2017-11-12 12:12:34"];
        NSString * date = @"2028-11-12 1:22:59";
        datePickerView.maxLimitDate = [df dateFromString:date];
        NSDate * seleDate = [df dateFromString:@"2018-11-12 11:16:58"];
        datePickerView.selectDate = seleDate;
        datePickerView.isShowUnit = NO;

        datePickerView.pickerToolBarView.titleText = @"时间选择器";
        datePickerView.pickerToolBarView.isShowLine = YES;
    } resultDateBlock:^(NSDate *date) {
        NSDateFormatter * df = [[NSDateFormatter alloc] init ];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        weakSelf.dateLabel.text = [df stringFromDate:date];
    }];
}

- (IBAction)levelPickerAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    NSArray * res = [NSArray yy_modelArrayWithClass:[JYLevelPickerModel class] json:[JYLevelPickerModel dataSource]];
    [JYLevelPickerView jy_initPickviewWithDataSourcesArray:res level:JYLevelPickerViewLevelTwo configuration:^(JYLevelPickerView * _Nonnull pickerView) {
        pickerView.defaultCode = weakSelf.addrCode;
        pickerView.pickerToolBarView.titleText = @"地址选择器";
        pickerView.pickerToolBarView.isShowLine = YES;
        pickerView.pickerToolBarView.lineViewColor = [UIColor redColor];
    } resultModelBlock:^(JYLevelPickerModel * _Nonnull resultModel, JYLevelPickerModel * _Nonnull lastModel) {
        self.addrLabel.text = [NSString stringWithFormat:@"%@ -> %@  -> code:%@",resultModel.dataName,resultModel.selectedChildModel.dataName,lastModel.dataCode];
        weakSelf.addrCode = lastModel.dataCode;
    }];
}

@end
