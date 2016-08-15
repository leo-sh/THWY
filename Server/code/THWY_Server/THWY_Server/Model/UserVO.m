//
//  UserVO.m
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import "UserVO.h"

@implementation UserVO

-(UserVO* )initWithJSON:(NSDictionary *)JSON
{
    if (self = [super init]) {
        self.admin_id = JSON[@"admin_id"];
        self.admin_group_id = JSON[@"admin_group_id"];
        self.admin_name = JSON[@"admin_name"];
        self.admin_acl = JSON[@"admin_acl"];
        self.login_count = JSON[@"login_count"];
        self.ctime = JSON[@"ctime"];
        self.status = JSON[@"status"];
        self.work_st = JSON[@"work_st"];
        self.estate_id = JSON[@"estate_id"];
        self.estate_ids = JSON[@"estate_ids"];
        self.is_serviceman = JSON[@"is_serviceman"];
        self.is_cashier = JSON[@"is_cashier"];
        self.real_name = JSON[@"real_name"];
        self.cellphone = JSON[@"cellphone"];
        self.photo = JSON[@"photo"];
        self.up_group = [[GroupVO alloc]initWithJSON:JSON[@"up_group"]];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.admin_id forKey:@"admin_id"];
    [encoder encodeObject:self.admin_group_id forKey:@"admin_group_id"];
    [encoder encodeObject:self.admin_name forKey:@"admin_name"];
    [encoder encodeObject:self.admin_acl forKey:@"admin_acl"];
    [encoder encodeObject:self.login_count forKey:@"login_count"];
    [encoder encodeObject:self.ctime forKey:@"ctime"];
    [encoder encodeObject:self.work_st forKey:@"work_st"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.estate_id forKey:@"estate_id"];
    [encoder encodeObject:self.estate_ids forKey:@"estate_ids"];
    [encoder encodeObject:self.is_serviceman forKey:@"is_serviceman"];
    [encoder encodeObject:self.is_cashier forKey:@"is_cashier"];
    [encoder encodeObject:self.real_name forKey:@"real_name"];
    [encoder encodeObject:self.cellphone forKey:@"cellphone"];
    [encoder encodeObject:self.photo forKey:@"photo"];
    [encoder encodeObject:self.up_group forKey:@"up_group"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.up_group = [decoder decodeObjectForKey:@"up_group"];
        self.photo = [decoder decodeObjectForKey:@"photo"];
        self.cellphone = [decoder decodeObjectForKey:@"cellphone"];
        self.real_name = [decoder decodeObjectForKey:@"real_name"];
        self.is_cashier = [decoder decodeObjectForKey:@"is_cashier"];
        self.is_serviceman = [decoder decodeObjectForKey:@"is_serviceman"];
        self.estate_ids = [decoder decodeObjectForKey:@"estate_ids"];
        self.estate_id = [decoder decodeObjectForKey:@"estate_id"];
        self.work_st = [decoder decodeObjectForKey:@"work_st"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.ctime = [decoder decodeObjectForKey:@"ctime"];
        self.login_count = [decoder decodeObjectForKey:@"login_count"];
        self.admin_acl = [decoder decodeObjectForKey:@"admin_acl"];
        self.admin_name = [decoder decodeObjectForKey:@"admin_name"];
        self.admin_group_id = [decoder decodeObjectForKey:@"admin_group_id"];
        self.admin_id = [decoder decodeObjectForKey:@"admin_id"];
    }
    return self;
}

+(UserVO *)fromCodingObject{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *encodedData = [ud objectForKey:THWY_USER];
    if (encodedData == nil) {
        return nil;
    }
    UserVO *user = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    return user;
}

-(void)saveToUD{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [ud setObject:encodedObject forKey:THWY_USER];
    [ud synchronize];
}
@end
