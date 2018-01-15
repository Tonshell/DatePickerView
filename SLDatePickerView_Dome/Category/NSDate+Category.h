//
//  NSDate+Category.h
//  SLDatePickerView_Dome
//
//  Created by 不佟 on 2018/1/14.
//  Copyright © 2018年 不佟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

+ (NSDate *)localDateWithDate:(NSDate *)date;

- (NSDate *) dateFromString:(NSString *)dateString withFormatterString:(NSString *)formatterString;

- (NSString *) stringWithFormatterString:(NSString *)formatterString;


@end
