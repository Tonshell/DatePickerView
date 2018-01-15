//
//  GDDateAndTimePickerView.h
//  SLPickerView
//
//  Created by tongshanli on 2017/10/18.
//  Copyright © 2017年 tongshanli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum GDDateState {
    gd_dateAndTime = 0,
    gd_date,
    gd_time
}gd_dateState ;
@protocol GDDateAndTimePickerViewDelegate <NSObject>

- (void) gd_dateAndTimeWithResultDate:(NSDate*)date withView:(UIView*)view;
- (void) gd_datePickeViewResulteString:(NSString *)dateString withView:(UIView *)view;

@end

@interface GDDateAndTimePickerView : UIView
+ (instancetype)createDataAndTimePickerViewWithFrame:(CGRect)frame;
@property(nonatomic, weak) id <GDDateAndTimePickerViewDelegate> delegate;




/*
 * 最大的年份
 */
@property(nonatomic,assign)NSInteger maxYear;

/*
 * 最小的年份
 */
@property(nonatomic, assign)NSInteger minYear;

/*
 *  改变时间格式
 */
- (void) changeDateState:(gd_dateState)dateState;


@end
