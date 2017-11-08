//
//  JRCountDown.m
//  JRCountDown-Demo-OC
//
//  Created by Johnson Rey on 2017/11/8.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

#import "JRCountDown.h"
#import "AFNetworking.h"


#define date_url @"http://api.k780.com:88/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json"

@interface JRCountDown ()
{
    dispatch_source_t _timer;
    
    UITableView * _tableView;
    NSArray * _dataSource;
    NSInteger _less;
}

@end

@implementation JRCountDown

- (instancetype)initWithTableView:(UITableView *)tableView dataSource:(NSArray *)dataSource {
    
    if (self = [super init]) {
        _tableView = tableView;
        _dataSource = dataSource;
        
        [self setupInit];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupInit) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;
}

- (void)setupInit {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager POST:date_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * webCurrentTimeStr = responseObject[@"result"][@"timestamp"];
        NSInteger webCurrentTime = webCurrentTimeStr.longLongValue;
        NSDate * date = [NSDate date];
        NSInteger nowInteger = [date timeIntervalSince1970];
        _less = nowInteger - webCurrentTime;
        
        NSLog(@" --  与服务器时间的差值 -- %zd",_less);

        if (_dataSource) {
            [self destoryTimer];
            [self wh_countDownWithTableView:_tableView dataSource:_dataSource];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)wh_countDownWithTableView:(UITableView *)tableView dataSource:(NSArray *)dataSource {
    
    if (!_timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
        
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray * cells = tableView.visibleCells;
                
                for (UITableViewCell * cell in cells) {
                    
                    NSDate * mobileDate = [NSDate date];
                    NSInteger mobileInteger = [mobileDate timeIntervalSince1970];
                    
                    NSString * tempEndTime;
                    if ([dataSource[0] isKindOfClass:[NSArray class]]) {
                        NSInteger section = cell.tag / 1000;
                        NSInteger row = cell.tag % 1000;
                        tempEndTime = dataSource[section][row];
                    } else {
                        tempEndTime = dataSource[cell.tag];
                    }
                    
                    for (UIView * subView in cell.contentView.subviews) {
                        if (subView.tag == 1314) {
                            UILabel * textLabel = (UILabel *)subView;
                            NSInteger endTime = tempEndTime.longLongValue + _less;
                            textLabel.text = [self getNowTimeWithString:endTime startTime:mobileInteger];
                        }
                    }
                }
                
            });
        });
        
        dispatch_resume(_timer);
    }
}

- (NSString *)wh_countDownWithIndexPath:(NSIndexPath *)indexPath {
    
    NSDate * mobileDate = [NSDate date];
    NSInteger mobileInteger = [mobileDate timeIntervalSince1970];
    
    NSString * tempEndTime;
    
    if ([_dataSource[0] isKindOfClass:[NSArray class]]) {
        tempEndTime = _dataSource[indexPath.section][indexPath.row];
    } else {
        tempEndTime = _dataSource[indexPath.row];
    }
    NSInteger endTime = tempEndTime.longLongValue + _less;
    return [self getNowTimeWithString:endTime startTime:mobileInteger];
}

- (NSString *)getNowTimeWithString:(NSInteger)aTimeString startTime:(NSInteger)startTime {
    NSTimeInterval timeInterval = aTimeString - startTime;
    
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval - days*24*3600)/3600);
    int minutes = (int)((timeInterval - days*24*3600 - hours*3600)/60);
    int seconds = (int)(timeInterval - days*24*3600 - hours*3600 - minutes*60);
    
//    NSString * dayString = [NSString stringWithFormat:@"%d",days];
//    NSString * hourString = [NSString stringWithFormat:@"%d",hours];
//    NSString * minuteString = minutes > 10 ? [NSString stringWithFormat:@"%d",minutes] : [NSString stringWithFormat:@"0%d",minutes];
//    NSString * secondString = seconds > 10 ? [NSString stringWithFormat:@"%d",seconds] : [NSString stringWithFormat:@"0%d",seconds];
    
    if (_isPlusTime) {
        
        if (hours >= 0 && minutes >= 0 && seconds >= 0) {
            return @"活动未开始";
        }
        hours = -hours;
        minutes = -minutes;
        seconds = -seconds;
        
    } else {
        if (hours <= 0 && minutes <= 0 && seconds <= 0) {
            return @"活动已经结束！";
        }
    }
    
    if (days) {
        return [NSString stringWithFormat:@"%d天 %d时 %d分 %d秒",days,hours,minutes,seconds];
    }
    
     return [NSString stringWithFormat:@"%d时 %d分 %d秒",hours,minutes,seconds];
}

- (void)destoryTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

@end
