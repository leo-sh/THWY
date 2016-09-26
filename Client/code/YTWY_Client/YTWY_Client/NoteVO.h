//
//  NoteVO.h
//  YTWY_Client
//
//  Created by 史秀泽 on 2016/7/27.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileVO.h"

@interface NoteVO : NSObject

@property (nonatomic , copy) NSString              * content_app;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * ctime;
@property (nonatomic , copy) NSString              * estate_id;
@property (nonatomic , copy) NSString              * Id;
@property (nonatomic , copy) NSString              * note_txt_type_id;
@property (nonatomic , copy) NSString              * title;
@property NSMutableArray<FileVO *> * files;

@property BOOL is_index;

-(NoteVO* )initWithJSON:(NSDictionary *)JSON;

@end
