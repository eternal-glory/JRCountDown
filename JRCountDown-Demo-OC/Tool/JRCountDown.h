//
//  JRCountDown.h
//  JRCountDown-Demo-OC
//
//  Created by Johnson Rey on 2017/11/8.
//  Copyright © 2017年 Johnson Rey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JRCountDown : NSObject

@property (assign, nonatomic) BOOL isPlusTime;

- (NSString *)wh_countDownWithIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithTableView:(UITableView *)tableView dataSource:(NSArray *)dataSource;

- (void)destoryTimer;

@end
