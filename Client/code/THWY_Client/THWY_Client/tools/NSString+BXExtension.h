//
//  NSString+BXExtension.h
//  BXInsurenceBroker
//
//  Created by 史秀泽 on 16/5/10.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BXExtension)
/**
 *手机号码验证 MODIFIED BY HELENSONG
 */
- (BOOL) isValidateMobile;
///**
// *身份证验证
// */
//- (BOOL)validateIdentityCard;
/**
 * 判断字段是否包含空格
 */
- (BOOL)validateContainsSpace;

- (BOOL)checkPassword;

/**
 *  根据生日返回年龄
 */
- (NSString *)ageFromBirthday;

/**
 *  根据身份证返回岁数
 */
- (NSString *)ageFromIDCard;

/**
 *  根据身份证返回生日
 */
- (NSString*)birthdayFromIDCard;

/**
 *  根据身份证返回性别
 */
- (NSString*)sexFromIDCard;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *)stringWithMoneyAmount:(double)amount;

+ (NSString *)stringIntervalFrom:(NSDate *)start to:(NSDate *)end;

//邮箱
+ (BOOL)validateEmail:(NSString *)email;

- (BOOL)isEmptyString;

//获得到指定时间的时间差字符串,传入目标时间字符串和格式
+(NSString*)stringNowToDate:(NSString*)toDate formater:(NSString*)formatStr;

//获得到指定时间的时间差字符串,格式在此方法内返回前自己根据需要格式化
+(NSString*)stringNowToDate:(NSDate*)toDate;

//根据时间差返回距现在的时间
+ (NSString *)stringDateFromTimeInterval:(long long)timeInterval withFormat:(NSString *)format;

//保留两位小数点
+ (NSString *)stringConvertFloatString:(NSString *)string addEndString:(NSString *)endString;
@end
