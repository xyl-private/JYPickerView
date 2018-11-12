//
//  ViewController.m
//  JYPickerView
//
//  Created by xyanl on 2018/11/9.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import "ViewController.h"
#import "JYDatePickerView.h"
#import "JYPickerToolBarView.h"

#import <YYModel.h>
#import "JYLevelPickerModel.h"
#import "JYLevelPickerView.h"
#import "JYLevelPickerTestModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrCodeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)datePickerAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [JYDatePickerView jy_datePickerWithStyle:kJYDatePickerComponentsStyleYM configuration:^(JYDatePickerView *datePickerView) {
        NSDateFormatter * df = [[NSDateFormatter alloc] init ];
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        datePickerView.minLimitDate = [df dateFromString:@"2018-2-9 12:12"];
        NSString * date = @"2019-8-9 12:12";
        datePickerView.maxLimitDate = [df dateFromString:date];

        datePickerView.selectDate = [df dateFromString:weakSelf.dateLabel.text];

        datePickerView.pickerToolBarView.titleText = @"时间选择器";
    } resultDateBlock:^(NSDate *date) {
        NSLog(@"resultModelBlock => %@",date);
        NSDateFormatter * df = [[NSDateFormatter alloc] init ];
        df.dateFormat = @"yyyy-MM";
        weakSelf.dateLabel.text = [df stringFromDate:date];
    }];
}

- (IBAction)levelPickerAction:(UIButton *)sender {

    NSArray * res = [NSArray yy_modelArrayWithClass:[JYLevelPickerTestModel class] json:[JYLevelPickerTestModel threeLevelDataSource]];

    [JYLevelPickerView jy_initPickviewWithDataSourcesArray:res level:JYLevelPickerViewLevelThree configuration:^(JYLevelPickerView * _Nonnull pickerView) {
        pickerView.defaultCode = self.addrCodeLabel.text;
        pickerView.titleText = @"地址选择器";
    } resultModelBlock:^(JYLevelPickerModel * _Nonnull resultModel, JYLevelPickerModel * _Nonnull lastModel) {
        self.addrLabel.text = [NSString stringWithFormat:@"%@ -> %@ -> %@",resultModel.dataName,resultModel.selectedChildModel.dataName,resultModel.selectedChildModel.selectedChildModel.dataName];
        self.addrCodeLabel.text = lastModel.dataCode;
    }];


}

@end
