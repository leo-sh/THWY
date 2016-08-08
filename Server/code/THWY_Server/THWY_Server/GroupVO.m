//
//  GroupVO.m
//  THWY_Server
//
//  Created by 史秀泽 on 2016/7/28.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "GroupVO.h"

@implementation GroupVO

-(GroupVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        if (JSON[@"sector"]) {
            self.sector = JSON[@"sector"];
        }else if (JSON[@"9"]){
            self.sector = JSON[@"9"];
        }
        
        if (JSON[@"project"]) {
            self.project = JSON[@"project"];
        }else if (JSON[@"10"]){
            self.project = JSON[@"10"];
        }
        
        if (JSON[@"group"]) {
            self.group = JSON[@"group"];
        }else if (JSON[@"33"]){
            self.group = JSON[@"33"];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.sector forKey:@"sector"];
    [encoder encodeObject:self.project forKey:@"project"];
    [encoder encodeObject:self.group forKey:@"group"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.sector = [decoder decodeObjectForKey:@"sector"];
        self.project = [decoder decodeObjectForKey:@"project"];
        self.group = [decoder decodeObjectForKey:@"group"];
    }
    return self;
}
@end
