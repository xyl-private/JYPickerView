//
//  ViewController.m
//  JYPickerView
//
//  Created by McIntosh on 2018/11/9.
//  Copyright © 2018 xyanl. All rights reserved.
//

#import "ViewController.h"
#import "JYDatePickerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)datePickerAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [JYDatePickerView jy_datePickerWithStyle:kJYDatePickerComponentsStyleYMD configuration:^(JYDatePickerView *datePickerView) {
        NSDateFormatter * df = [[NSDateFormatter alloc] init ];
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        datePickerView.minLimitDate = [df dateFromString:@"2018-2-9 12:12"];
        NSString * date = @"2019-8-9 12:12";
        datePickerView.maxLimitDate = [df dateFromString:date];

        datePickerView.selectDate = [df dateFromString:weakSelf.dateLabel.text];
    } resultDateBlock:^(NSDate *date) {
        NSLog(@"resultModelBlock => %@",date);
        NSDateFormatter * df = [[NSDateFormatter alloc] init ];
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        weakSelf.dateLabel.text = [df stringFromDate:date];
    }];
}

@end
