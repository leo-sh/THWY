//
//  FileVO.h
//  YTWY_Server
//
//  Created by Mr.S on 16/9/1.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileVO : NSObject

@property NSString                 * file_name;
@property NSString                 * file_path;
@property NSString                 * file_size;
@property NSString                 * file_type;
@property NSString                 * Id;
@property NSString                 * ctime;
@property NSString                 * note_txt_id;

-(FileVO* )initWithJSON:(NSDictionary *)JSON;

-(void)showInVC:(UIViewController *)vc;
@end
