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
        self.Id = JSON[@"id"];
        self.oname = JSON[@"oname"];
        self.real_name = JSON[@"real_name"];
        self.id_card = JSON[@"id_card"];
        self.gender = JSON[@"gender"];
        self.cellphone = JSON[@"cellphone"];
        self.car_number = JSON[@"car_number"];
        if ([JSON[@"avatar"] isKindOfClass:[NSString class]] && [JSON[@"avatar"] length] > 0) {
            if ([JSON[@"avatar"] rangeOfString:@"http"].location != NSNotFound) {
                self.avatar = JSON[@"avatar"];
            }else
            {
                self.avatar = [NSString stringWithFormat:@"%@%@",API_Prefix,JSON[@"avatar"]];
            }
        }
        
        self.points = JSON[@"points"];
        self.estate = JSON[@"estate"];
        
        NSMutableArray<HouseVO *>* housesArr = [[NSMutableArray alloc]init];
        for (NSDictionary* houseDic in JSON[@"houses"]) {
            HouseVO* house = [[HouseVO alloc]initWithJSON:houseDic];
            [housesArr addObject:house];
        }
        self.houses = housesArr;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.Id forKey:@"Id"];
    [encoder encodeObject:self.oname forKey:@"oname"];
    [encoder encodeObject:self.real_name forKey:@"real_name"];
    [encoder encodeObject:self.id_card forKey:@"id_card"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.cellphone forKey:@"cellphone"];
    [encoder encodeObject:self.car_number forKey:@"car_number"];
    [encoder encodeObject:self.points forKey:@"points"];
    [encoder encodeObject:self.estate forKey:@"estate"];
    [encoder encodeObject:self.houses forKey:@"houses"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.Id = [decoder decodeObjectForKey:@"Id"];
        self.oname = [decoder decodeObjectForKey:@"oname"];
        self.real_name = [decoder decodeObjectForKey:@"real_name"];
        self.id_card = [decoder decodeObjectForKey:@"id_card"];
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
        self.cellphone = [decoder decodeObjectForKey:@"cellphone"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        self.car_number = [decoder decodeObjectForKey:@"car_number"];
        self.estate = [decoder decodeObjectForKey:@"estate"];
        self.houses = [decoder decodeObjectForKey:@"houses"];
        self.points = [decoder decodeObjectForKey:@"points"];
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
