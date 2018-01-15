//
//  GDDateAndTimePickerView.m
//  SLPickerView
//
//  Created by tongshanli on 2017/10/18.
//  Copyright © 2017年 tongshanli. All rights reserved.
//

#import "GDDateAndTimePickerView.h"

#import "NSDate+Category.h"
#define currentMonth [currentMonthString integerValue]
#define DateAndTime @"dateAndTime"
#define Date @"date"
#define Time @"time"
#define Multiple 10 // 用于轮滑


@interface GDDateAndTimePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    NSArray *amPmArray;
    NSArray *hoursArray;
    NSMutableArray *minutesArray;
    
    NSString *currentMonthString;
    NSString *currentyearString;
    NSString *currentDateString;
    NSString *currentHourString;
    NSString *currentMinutesString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    NSInteger selectedHourRow;
    NSInteger selectedMinuteRow;
    
    NSString *dateStateString;
    NSString *selectTimeString;
    
    NSString *currentTime;
    BOOL firstTimeLoad;
    
    
}

@property(nonatomic, strong) NSDate *date;
@property(nonatomic, copy) NSString *timeString;
@property(nonatomic, strong) NSString *formatterString;
@property(nonatomic, strong) UIButton *pickerButton;
@property(nonatomic, strong)UIPickerView *pickerView;
@property(nonatomic, strong) UIToolbar *toolBar;
@property(nonatomic, strong) UIBarButtonItem *cancelButtonItem;
@property(nonatomic, strong) UIBarButtonItem *sureButtonItem;

@property (nullable, copy, nonatomic) NSArray *leftItems;
@property (nullable, copy, nonatomic) NSArray *rightItems;

@property(nonatomic,assign) BOOL selectedPicker_DateAndTime;
@property(nonatomic,assign) BOOL selectedPicker_Date;
@property(nonatomic,assign) BOOL selectedPicker_Time;

@property (strong, nonatomic, readwrite) UIBarButtonItem *flexibleSpaceItem;

@property (strong, nonatomic) UIView *line;

@end

@implementation GDDateAndTimePickerView


+ (instancetype)createDataAndTimePickerViewWithFrame:(CGRect)frame {
    
    GDDateAndTimePickerView *gd_pickerView = [[GDDateAndTimePickerView alloc]initWithFrame:frame];
    
    gd_pickerView.backgroundColor = [UIColor whiteColor];
    [gd_pickerView addSubview:gd_pickerView.toolBar];
    [gd_pickerView addSubview:gd_pickerView.pickerView];
    gd_pickerView.maxYear = 2023;
    gd_pickerView.minYear = 1970;
    [gd_pickerView  initDateAndTimeData];
    [gd_pickerView addSubview:gd_pickerView.pickerButton];
    gd_pickerView.formatterString = @"yyyy-MM-dd HH:mm";
    gd_pickerView.selectedPicker_DateAndTime  = NO;
    gd_pickerView.selectedPicker_Date  = NO;
    gd_pickerView.selectedPicker_Time  = NO;
    
    [gd_pickerView defalutDate];
    
    return gd_pickerView;
}


#pragma mark - Event


- (void)pickAction:(UIButton *)btn {
    
        if ([dateStateString isEqualToString:Date] && !self.selectedPicker_Date) {
            selectTimeString = [NSString stringWithFormat:@"%@-%@-%@  ",currentyearString,currentMonthString,currentDateString];
        }
        if ([dateStateString isEqualToString:DateAndTime] && !self.selectedPicker_DateAndTime) {
            selectTimeString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@  ",currentyearString,currentMonthString,currentDateString,currentHourString,currentMinutesString];
            
        }
        if ([dateStateString isEqualToString:Time] && !self.selectedPicker_Time) {
            selectTimeString = [NSString stringWithFormat:@"%@:%@",currentHourString,currentMinutesString];
        }
        
//        [self forMatterDateWithDateString:selectTimeString];
    
    
    
    if ([self.delegate respondsToSelector:@selector(gd_datePickeViewResulteString:withView:)]) {
        [self.delegate gd_datePickeViewResulteString:selectTimeString withView:self];
    } else {
        NSLog(@"没有实现GDDateAndTimePickerViewDelegate");
    }
    
}

#pragma mark - PrivateMethod

- (void)defalutDate {
    dateStateString = DateAndTime;
    [self currentPickerDateAndTime];
}

- (void)resetToolbar{
    
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObject:self.flexibleSpaceItem];
    
    if (self.rightItems.count>0) {
        [items addObjectsFromArray:self.rightItems];
    }
    
    [self.toolBar setItems:items];
}


- (void) forMatterDateWithDateString:(NSString *)dateString {
    self.timeString = dateStateString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:self.formatterString];
    self.date = [formatter dateFromString:dateString];
}

- (void)changeDateState:( gd_dateState )dateState {
    
    if (dateState == gd_dateAndTime) {
        dateStateString = DateAndTime;
        self.formatterString = @"yyyy-MM-dd HH:mm";
    }
    
    if (dateState == gd_date) {
        dateStateString = Date;
        self.formatterString = @"yyyy-MM-dd";
    }
    
    if (dateState == gd_time) {
        dateStateString = Time;
        self.formatterString = @"HH:mm";
    }
    [self.pickerView reloadAllComponents];
    [self currentPickerDateAndTime];
    [self.pickerView reloadAllComponents];
    
}

- (void)initDateAndTimeData {
    // PickerView -  Years data
    
    yearArray = [[NSMutableArray alloc]init];
    for (NSInteger i = self.minYear; i <= self.maxYear ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    
    // PickerView -  Months data
    monthArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    
    // PickerView -  Hours data
    hoursArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"00"];
    
    // PickerView -  Hours data
    minutesArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 60; i++)
    {
        [minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    
    // PickerView -  days data
    [self relushDaysArray:31];
    
}

- (void )relushDaysArray:(NSInteger)daysNum {
    
    DaysArray = [[NSMutableArray alloc]init];
    for (int i = 1; i <= daysNum; i++)
    {
        if (i < 10 && i >=1) {
            [DaysArray addObject:[NSString stringWithFormat:@"0%d",i]];
        } else {
            [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
}

- (void)currentPickerDateAndTime {
    
    firstTimeLoad = YES;
    
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    currentyearString = [NSString stringWithFormat:@"%@",
                         [formatter stringFromDate:date]];
    
    
    
    [formatter setDateFormat:@"MM"];

     currentMonthString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    [formatter setDateFormat:@"dd"];
    currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    
    [formatter setDateFormat:@"HH"];
    currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    
    [formatter setDateFormat:@"mm"];
    currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    
    
    if ([dateStateString isEqualToString:DateAndTime]) {
        
        selectedMonthRow =   [monthArray indexOfObject:currentMonthString];
        selectedDayRow = [DaysArray indexOfObject:currentDateString];
        selectedYearRow = [yearArray indexOfObject:currentyearString];
        selectedHourRow = [hoursArray indexOfObject:currentHourString];
        selectedMinuteRow = [minutesArray indexOfObject:currentMinutesString];
        
        [self.pickerView selectRow:selectedYearRow inComponent:0 animated:YES];
        [self.pickerView selectRow:selectedMonthRow inComponent:1 animated:YES];
        [self.pickerView selectRow:selectedDayRow inComponent:2 animated:YES];
        [self.pickerView selectRow:selectedHourRow inComponent:3 animated:YES];
        [self.pickerView selectRow:selectedMinuteRow inComponent:4 animated:YES];
    }
    
    if ([dateStateString isEqualToString:Date]) {
        selectedMonthRow =   [monthArray indexOfObject:currentMonthString];
        selectedDayRow = [DaysArray indexOfObject:currentDateString];
        selectedYearRow = [yearArray indexOfObject:currentyearString];
        
        [self.pickerView selectRow:selectedYearRow inComponent:0 animated:YES];
        [self.pickerView selectRow:selectedMonthRow inComponent:1 animated:YES];
        [self.pickerView selectRow:selectedDayRow inComponent:2 animated:YES];
    }
    
    if ([dateStateString isEqualToString:Time]) {
        selectedHourRow = [hoursArray indexOfObject:currentHourString];
        selectedMinuteRow = [minutesArray indexOfObject:currentMinutesString];
        
        [self.pickerView selectRow:selectedHourRow inComponent:0 animated:YES];
        [self.pickerView selectRow:selectedMinuteRow inComponent:1 animated:YES];
    }
    
    
}

#pragma mark - UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    firstTimeLoad = NO;
    
    switch (component) {
        case 0:
            selectedYearRow = row % yearArray.count;
            break;
        case 1:
            selectedMonthRow = row % monthArray.count;
            break;
        case 2:
            selectedDayRow = row % DaysArray.count;
            break;
            
        default:
            break;
    }
    
    [self.pickerView reloadAllComponents];
    
    
    if ([dateStateString isEqualToString:Date]) {
        self.selectedPicker_Date = true;
        self.selectedPicker_Time = false;
        self.selectedPicker_DateAndTime = false;
        
        NSInteger yearIndex = [self.pickerView selectedRowInComponent:0] % yearArray.count;
        NSInteger monthIndex = [self.pickerView selectedRowInComponent:1] % monthArray.count;
        NSInteger dayIndex = [self.pickerView selectedRowInComponent:2] % DaysArray.count;
        
        selectTimeString  = [NSString stringWithFormat:@"%@-%@-%@",[yearArray objectAtIndex:yearIndex],[monthArray objectAtIndex:monthIndex],[DaysArray objectAtIndex:dayIndex]];
        
    }
    
    if ([dateStateString isEqualToString:DateAndTime]) {
        
        self.selectedPicker_Date = false;
        self.selectedPicker_Time = false;
        self.selectedPicker_DateAndTime = true;
        NSInteger yearIndex = [self.pickerView selectedRowInComponent:0] % yearArray.count;
        NSInteger monthIndex = [self.pickerView selectedRowInComponent:1] % monthArray.count;
        NSInteger dayIndex = [self.pickerView selectedRowInComponent:2] % DaysArray.count;
        NSInteger hourIndex = [self.pickerView selectedRowInComponent:3] % hoursArray.count;
        NSInteger minuteIndex = [self.pickerView selectedRowInComponent:4] % minutesArray .count;
        // 默认初始值就是DateAndTime类型的
        selectTimeString  = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",[yearArray objectAtIndex:yearIndex],[monthArray objectAtIndex:monthIndex],[DaysArray objectAtIndex:dayIndex],[hoursArray objectAtIndex:hourIndex],[minutesArray objectAtIndex:minuteIndex]];
        [self forMatterDateWithDateString:selectTimeString];
        
    }
    
    if ([dateStateString isEqualToString:Time]) {
        self.selectedPicker_Date = false;
        self.selectedPicker_Time = true;
        self.selectedPicker_DateAndTime = false;
        
        NSInteger hourIndex = [self.pickerView selectedRowInComponent:0] % hoursArray.count;
        NSInteger minuteIndex = [self.pickerView selectedRowInComponent:1] % minutesArray .count;
        selectTimeString = [NSString stringWithFormat:@"%@:%@",[hoursArray objectAtIndex:hourIndex],[minutesArray objectAtIndex:minuteIndex]];
    }
    
    [self forMatterDateWithDateString:selectTimeString];
    
    
}



#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0]];
        pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
        pickerLabel.textColor = [UIColor blackColor];
        
    }
    
    
    if (component == 0)
    {
        if ([dateStateString isEqualToString:DateAndTime] ||[dateStateString isEqualToString: Date]) {
            pickerLabel.text =  [yearArray objectAtIndex:row % yearArray.count ]; // Year
        }
        if ([dateStateString isEqualToString:Time]) {
            pickerLabel.text =  [hoursArray objectAtIndex:row % hoursArray.count]; // Year
        }
        
    }
    else if (component == 1)
    {       if ([dateStateString isEqualToString:DateAndTime] ||[dateStateString isEqualToString: Date]) {
        pickerLabel.text =  [monthArray objectAtIndex:row % monthArray.count];  // Month
    }
        if ([dateStateString isEqualToString:Time]) {
            pickerLabel.text =  [minutesArray objectAtIndex:row % minutesArray.count]; // Mins
        }
        
    }
    else if (component == 2)
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row % DaysArray.count]; // Date
        
    }
    else if (component == 3)
    {
        pickerLabel.text =  [hoursArray objectAtIndex:row % hoursArray.count]; // Hours
    }
    else if (component == 4)
    {
        pickerLabel.text =  [minutesArray objectAtIndex:row % minutesArray.count]; // Mins
    }
    else
    {
        pickerLabel.text =  [amPmArray objectAtIndex:row]; // AM/PM
    }
    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    if ([dateStateString isEqualToString:DateAndTime]) {
        
        return 5;
    }
    
    if ([dateStateString isEqualToString:Date]) {
        return 3;
    }
    
    return 2;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [yearArray count] * Multiple;
        
    }
    else if (component == 1)
    {
        return [monthArray count] * Multiple;
    }
    else if (component == 2)
    { // day
        
        if (firstTimeLoad)
        {
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
            {
                [self relushDaysArray:31];
                return 31 * Multiple;
            }
            else if (currentMonth == 2)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    [self relushDaysArray:29];
                    return 29 * Multiple;
                }
                else
                {
                    [self relushDaysArray:28];
                    return 28 * Multiple; // or return 29
                }
                
            }
            else
            {
                [self relushDaysArray:30];
                return 30 * Multiple;
            }
            
        }
        else
        {
            
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                [self relushDaysArray:31];
                return 31 * Multiple;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    [self relushDaysArray:29];
                    return 29 * Multiple;
                }
                else
                {
                    [self relushDaysArray:28];
                    return 28 * Multiple; // or return 29
                }
                
            }
            else
            {
                [self relushDaysArray:30];
                return 30 * Multiple;
            }
        }
    }
    else if (component == 3)
    { // hour
        
        return 24 * Multiple;
        
    }
    else if (component == 4)
    { // min
        return 60 * Multiple;
    }
    
    else
        return 0;
}


#pragma mark - setter


- (void)setMaxYear:(NSInteger)maxYear {
    
    _maxYear = maxYear;
    if (yearArray.count > 0) {
        [yearArray removeAllObjects];
        for (NSInteger i = self.minYear; i <= self.maxYear ; i++)
        {
            [yearArray addObject:[NSString stringWithFormat:@"%ld",i]];
        }
    }

    [self currentPickerDateAndTime];
    [self.pickerView reloadComponent:0];

}

- (void)setMinYear:(NSInteger)minYear {
    _minYear = minYear;
    
    if (yearArray.count > 0) {
        [yearArray removeAllObjects];
        for (NSInteger i = self.minYear; i <= self.maxYear ; i++)
        {
            [yearArray addObject:[NSString stringWithFormat:@"%ld",i]];
        }
        
    }
    
    [self currentPickerDateAndTime];
    [self.pickerView reloadComponent:1];

}



#pragma mark - Getter


- (void)setLeftItems:(NSArray *)leftItems {
    _leftItems = [leftItems copy];
    [self resetToolbar];
}

- (void)setRightItems:(NSArray *)rightItems {
    _rightItems = rightItems;
    [self resetToolbar];
}


- (UIBarButtonItem *)flexibleSpaceItem {
    if (!_flexibleSpaceItem) {
        _flexibleSpaceItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                      target:self
                                                      action:nil];
    }
    
    return _flexibleSpaceItem;
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        _toolBar.translucent = NO;
        
        self.rightItems = @[self.sureButtonItem];
        [self resetToolbar];
        
        [_toolBar addSubview:self.line];
    }
    return _toolBar;
}


- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, 320, 0.5)];
        _line.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    }
    return _line;
}

- (UIBarButtonItem *)sureButtonItem {
    
    
    if (_sureButtonItem == nil) {
        _sureButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.pickerButton];
        
    }
    return _sureButtonItem;
}


- (UIButton *)pickerButton {
    
    if (_pickerButton == nil) {
        
        _pickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _pickerButton.frame = [Utils fit:CGRectMake(self.frame.size.width - 40, 5 , 40, 40)];
        _pickerButton.frame = CGRectMake(0, 5 , 40, 40);
        [_pickerButton addTarget:self action:@selector(pickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_pickerButton setTitle:@"确定" forState:UIControlStateNormal];
        _pickerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_pickerButton setTitleColor:[UIColor colorWithRed:255/255.0 green:62/255.0 blue:0 alpha:1]  forState:UIControlStateNormal];
        
    }
    return _pickerButton;
}

- (UIPickerView *)pickerView {
    
    if (_pickerView == nil) {
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, self.frame.size.width, 260)];
        _pickerView.delegate = self; // 让这个pickerView 的父亲视图 做他的代理方法
        _pickerView.dataSource = self;
    }
    return _pickerView;
}



@end
