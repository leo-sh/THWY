//
//  ServicesManager.h
//  THWY_Client
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UDManager.h"
#import "UserVO.h"
#import "PointHistoryVO.h"
#import "FeedBackTypeVO.h"
#import "FeedBackVO.h"
#import "ComplaintStateVO.h"
#import "ComplaintTypeVO.h"
#import "ComplaintVO.h"
#import "NoteVO.h"
#import "MerchantTypeVO.h"

@interface ServicesManager : NSObject

/**
 *  单例
 *
 *  @return API调用实例对象
 */
+(ServicesManager *)getAPI;

#pragma mark 环境参数判定函数
/**
 *  判断是否已登陆
 *
 *  @return 是否登陆
 */
-(BOOL)isLogin;

#pragma mark 用户相关API
/**
 *  登陆
 *
 *  @param userName   用户名
 *  @param password   密码
 *  @param onComplete 登陆完成回调block
 */
-(void)login:(NSString *)userName
    password:(NSString *)password
  onComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete;

/**
 *  手动获取用户信息
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getUserInfoOnComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete;

/**
 *  修改用户信息(非必填参数如不填，传nil即可)
 *
 *  @param phoneNum    手机号码(必填)
 *  @param carNumber   车牌号(非必填)
 *  @param newUserName 新登陆账号(非必填)
 *  @param newPassWord 新密码(非必填)
 *  @param onComplete  修改完成回调block
 */
-(void)editUserInfo:(NSString *)phoneNum
          carNumber:(NSString *)carNumber
        newUserName:(NSString *)newUserName
        newPassWord:(NSString *)newPassWord
         onComplete:(void (^)(NSString *errorMsg))onComplete;

/**
 *  上传用户头像
 *
 *  @param image      头像图片
 *  @param onComplete 上传完成回调block
 */
-(void)upLoadAvatar:(UIImage *)image OnComplete:(void (^)(NSString *errorMsg, NSString *avatar))onComplete;

/**
 *  查询用户积分
 *
 *  @param onComplete 查询完成回调block
 */
-(void)getUserPoints:(void (^)(NSString *errorMsg,NSString *point))onComplete;

/**
 *  查询用户积分历史
 *
 *  @param pageNum    页数
 *  @param onComplete 查询完成回调block
 */
-(void)getUserPointsHistory:(int)pageNum onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

#pragma mark 反馈相关API
/**
 *  获取反馈类型
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getFeedBackTypes:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取反馈列表
 *
 *  @param type       反馈类型
 *  @param onComplete 获取完成回调block
 */
-(void)getFeedBackList:(int)type onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  添加反馈
 *
 *  @param type       反馈类型
 *  @param content    反馈内容
 *  @param onComplete 反馈完成回调block
 */
-(void)addFeedBack:(int)type content:(NSString *)content onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 投诉相关API
/**
 *  获取投诉状态
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getComplaintStates:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取投诉类型
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getComplaintTypes:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取投诉列表
 *
 *  @param page       页数
 *  @param onComplete 获取完成回调block
 */
-(void)getComplaints:(int)page onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取单个投诉
 *
 *  @param complaintId 投诉Id
 *  @param onComplete  获取完成回调block
 */
-(void)getAComplaint:(NSString *)complaintId onComplete:(void (^)(NSString *errorMsg,ComplaintVO *complaint))onComplete;

/**
 *  添加投诉
 *
 *  @param complaint  投诉实例对象
 *  @param onComplete 添加完成回调block
 */
-(void)addComplaint:(ComplaintVO *)complaint onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 业主公告相关API
/**
 *  获取业主公告
 *
 *  @param page       页数
 *  @param onComplete 获取完成回调block
 */
-(void)getNotes:(int)page onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取一条公告
 *
 *  @param noteId     公告Id
 *  @param onComplete 获取完成回调block
 */
-(void)getANote:(NSString *)noteId onComplete:(void (^)(NSString *errorMsg,NoteVO *complaint))onComplete;

#pragma mark -商家相关API
/**
 *  获取商家类型
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getMerchantTypes:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

#pragma mark 测试用函数
-(void)test;
@end
