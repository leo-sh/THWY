//
//  WantRepairTableViewDelegate.h
//  YTWY_Client
//
//  Created by wei on 16/8/5.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WantRepairTableViewDelegate <NSObject>

- (void)commitComplete:(NSString *)errorMsg;

- (void)tableViewDidScroll;

@end
