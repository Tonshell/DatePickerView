//
//  ViewController.m
//  SLDatePickerView_Dome
//
//  Created by 不佟 on 2018/1/14.
//  Copyright © 2018年 不佟. All rights reserved.
//

#import "ViewController.h"
#import "GDDateAndTimePickerView.h"

@interface ViewController () <GDDateAndTimePickerViewDelegate>

@property(nonatomic, strong) GDDateAndTimePickerView *dateAndTimePickerVirew;
@property(nonatomic, strong) UILabel *displayLbl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpUI];
    
}
#pragma mark - PrivateMethod

- (void) setUpUI {
    
    [self.view addSubview:self.dateAndTimePickerVirew];
    
    NSArray *btnTitleArray = @[@"DateAndTime",@"Date",@"Time"];
    CGFloat btnWidth = self.view.frame.size.width / btnTitleArray.count;
    for (int i = 0; i < btnTitleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnWidth, 128, btnWidth, 60);
        btn.tag = 1000+i;
        [btn setBackgroundColor:[UIColor grayColor]];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeFormartterAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }

    
    [self.view addSubview:self.displayLbl];
    
}


#pragma mark - Event

- (void)changeFormartterAction:(UIButton *)btn {

    
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btnView = (UIButton*)subView;
            btnView.selected = NO;
        }
    }
    
    btn.selected = YES;
    switch (btn.tag - 1000) {
        case 0:
            [self.dateAndTimePickerVirew changeDateState:gd_dateAndTime];
            break;
            
        case 1:
            [self.dateAndTimePickerVirew changeDateState:gd_date];
            break;
            
        case 2:
            [self.dateAndTimePickerVirew changeDateState:gd_time];
            break;
            
        default:
            break;
    }
    
}


#pragma mark - Delegate


- (void)gd_datePickeViewResulteString:(NSString *)dateString withView:(UIView *)view {
    
    self.displayLbl.text = dateString;
}


#pragma mark - Getter


- (UILabel *)displayLbl {
    
    if (_displayLbl == nil) {
        _displayLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 80)];
        _displayLbl.font = [UIFont systemFontOfSize:18];
        _displayLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _displayLbl;
}


- (GDDateAndTimePickerView *)dateAndTimePickerVirew {
    
    if (_dateAndTimePickerVirew == nil) {
        _dateAndTimePickerVirew = [GDDateAndTimePickerView createDataAndTimePickerViewWithFrame:CGRectMake(0, 568, self.view.frame.size.width, 300)];
        _dateAndTimePickerVirew.delegate = self;
//        _dateAndTimePickerVirew.maxYear = 2048;
//        _dateAndTimePickerVirew.minYear = 2018;
    }
    return _dateAndTimePickerVirew;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
