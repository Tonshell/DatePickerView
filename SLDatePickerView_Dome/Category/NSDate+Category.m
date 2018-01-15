//
//  NSDate+Category.m
//  SLDatePickerView_Dome
//
//  Created by 不佟 on 2018/1/14.
//  Copyright © 2018年 不佟. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

+ (NSDate *)localDateWithDate:(NSDate *)date {
    
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate:self];
    //    return [self dateByAddingTimeInterval:interval];
    //    NSDate *date = [NSDate date]; // 获得时间对象
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    
    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    
    return  [date dateByAddingTimeInterval:time];
    
}
- (NSString *) stringWithFormatterString:(NSString *)formatterString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    return  [formatter stringFromDate:self];
}

//
- (NSDate *) dateFromString:(NSString *)dateString withFormatterString:(NSString *)formatterString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatterString];
    return  [formatter dateFromString:dateString];
}

@end
