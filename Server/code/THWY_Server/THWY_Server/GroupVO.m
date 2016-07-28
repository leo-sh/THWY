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
        self.sector = JSON[@"sector"];
        self.project = JSON[@"project"];
        self.group = JSON[@"group"];
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
