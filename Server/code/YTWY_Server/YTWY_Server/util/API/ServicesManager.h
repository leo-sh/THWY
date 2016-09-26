//
//  ServicesManager.h
//  YTWY_Server
//
//  Created by 史秀泽 on 2016/7/26.
//  Copyright © 2016年 SXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UDManager.h"
#import "UserVO.h"
#import "IPAllowVO.h"
#import "NoticVO.h"
#import "AdVO.h"
#import "DocTypeVO.h"
#import "DocVO.h"
#import "EstateVO.h"
#import "RepairStatuVO.h"
#import "RepairClassVO.h"
#import "AddPublicRepairVO.h"
#import "AddRepairVO.h"
#import "RepairStatisticVO.h"
#import "StaffRepairStatisticVO.h"
#import "RepairVO.h"
#import "TaskVO.h"
#import "MsgVO.h"
#import "Reachability.h"
typedef enum : NSUInteger {
    Normal = 0,
    Test,
} APIMode;

@interface ServicesManager : NSObject

@property NSString* portNum;
@property APIMode mode;
@property NSDictionary* remoteNotification;

@property NetworkStatus status;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, strong) UIViewController *vc;

+(ServicesManager *)getAPI;

-(void)showFile:(NSURL *)filePath;

#pragma mark 音频播放
-(void)palySend;
-(void)palyReceive;
-(void)palyPush;

#pragma mark 环境参数判定函数
/**
 *  判断是否已登陆
 *
 *  @return 是否登陆
 */
-(BOOL)isLogin;

#pragma mark 用户相关API
/**
 *  登录API
 *
 *  @param userName   用户名
 *  @param password   密码
 *  @param onComplete 登录完成回调block
 */
-(void)login:(NSString *)userName
    password:(NSString *)password
savePassWord:(BOOL)save
  onComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete;

/**
 *  退出登录
 *
 *  @param onComplete 退出后回调block
 */
-(void)logOut:(void (^)())onComplete;

/**
 *  手动获取用户信息
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getUserInfoOnComplete:(void (^)(NSString *errorMsg,UserVO *user))onComplete;

/**
 *  上传用户头像
 *
 *  @param image      头像图片
 *  @param onComplete 上传完成回调block
 */
-(void)upLoadAvatar:(UIImage *)image OnComplete:(void (^)(NSString *errorMsg, NSString *avatar))onComplete;

/**
 *  修改用户信息(非必填参数如不填，传nil即可)
 *
 *  @param realName    姓名
 *  @param phoneNum    手机号
 *  @param newPassWord 新密码(非必填)
 *  @param image       图片(非必填)
 *  @param onComplete  修改完成回调block
 */
-(void)editUserInfo:(NSString *)realName
           phoneNum:(NSString *)phoneNum
        newPassWord:(NSString *)newPassWord
                pic:(UIImage *)image
         onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 白名单相关API
/**
 *  获取白名单列表
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getIpAllows:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  获取单个白名单
 *
 *  @param ipId       白名单ID
 *  @param onComplete 获取完成回调block
 */
-(void)getAIpAllow:(NSString *)ipId onComplete:(void (^)(NSString *errorMsg,IPAllowVO* list))onComplete;

/**
 *  增加一个白名单
 *
 *  @param ip         白名单实例对象
 *  @param onComplete 增加完成回调block
 */
-(void)addAIpAllow:(IPAllowVO *)ip onComplete:(void (^)(NSString *errorMsg))onComplete;

/**
 *  修改一个白名单
 *
 *  @param ip         白名单实例对象
 *  @param onComplete 增加完成回调block
 */
-(void)editAIpAllow:(IPAllowVO *)ip onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 好友相关API
/**
 *  获取好友列表
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getFriends:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  查找一个人(至少一个参数不为空)
 *
 *  @param phoneNum   手机号码
 *  @param name       姓名
 *  @param onComplete 查找完成回调block
 */
-(void)findFriends:(NSString* )phoneNum name:(NSString *)name onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  添加一个好友
 *
 *  @param adminId    好友adminID
 *  @param onComplete 添加完成回调block
 */
-(void)addFriend:(NSString *)adminId onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 物业公告相关API
/**
 *  获取物业公告－行政公告
 *
 *  @param page       页数
 *  @param onComplete 获取完成回调block
 */
-(void)getNotice:(int)page onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  获取物业公告－行政公告内容
 *
 *  @param noticeId   公告ID
 *  @param onComplete 获取完成回调block
 */
-(void)getANotice:(NSString *)noticeId onComplete:(void (^)(NSString *errorMsg,NoticVO *notic))onComplete;

/**
 *  获取物业公告－商圈公告
 *
 *  @param page       页数
 *  @param onComplete 获取完成回调block
 */
-(void)getAds:(int)page onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  获取物业公告－商圈公告内容
 *
 *  @param adId       公告ID
 *  @param onComplete 获取完成回调block
 */
-(void)getAnAd:(NSString *)adId onComplete:(void (^)(NSString *errorMsg,AdVO *notic))onComplete;

#pragma mark 个人日志相关API
/**
 *  获取个人日志文档分类
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getDocTypes:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  获取个人日志
 *
 *  @param page       页数
 *  @param typeId     分类ID(可选)
 *  @param isPublic   0:私人 1:公开 >1:不选
 *  @param belong     0:自己的文档 1:他人的文档 >1:不选
 *  @param onComplete 获取完成回调block
 */
-(void)getDocs:(int)page docTypeId:(NSString *)typeId public:(int)isPublic belong:(int)belong onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

/**
 *  获取日志详细
 *
 *  @param docId      日志ID
 *  @param onComplete 获取完成回调block
 */
-(void)getADoc:(NSString *)docId onComplete:(void (^)(NSString *errorMsg,DocVO* doc))onComplete;

/**
 *  增加工作日志
 *
 *  @param typeId     类型ID
 *  @param public     是否公开
 *  @param title      标题
 *  @param content    内容
 *  @param onComplete 增加完成回调block
 */
-(void)addDoc:(NSString *)typeId public:(BOOL)public title:(NSString* )title content:(NSString* )content onComplete:(void (^)(NSString *errorMsg))onComplete;

/**
 *  编辑工作日志
 *
 *  @param docId      日志ID
 *  @param typeId     类型ID
 *  @param public     是否公开
 *  @param title      标题
 *  @param content    内容
 *  @param onComplete 编辑完成回调block
 */
-(void)editDoc:(NSString* )docId typeId:(NSString *)typeId public:(BOOL)public title:(NSString* )title content:(NSString* )content onComplete:(void (^)(NSString *errorMsg))onComplete;

/**
 *  删除工作日志
 *
 *  @param docId      日志ID
 *  @param onComplete 删除完成回调block
 */
-(void)delDoc:(NSString* )docId onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 楼盘相关API
/**
 *  获取所有楼盘
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getEstates:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  根据楼盘获取楼栋
 *
 *  @param estateId   楼盘ID
 *  @param onComplete 获取完成回调block
 */
-(void)getBlock:(NSString *)estateId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  根据楼盘、楼栋获取单元
 *
 *  @param estateId   楼盘ID
 *  @param block      楼栋
 *  @param onComplete 获取完成回调block
 */
-(void)getUnit:(NSString *)estateId block:(NSString *)block onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  根据楼盘、楼栋、单元获取楼层
 *
 *  @param estateId   楼盘ID
 *  @param block      楼栋
 *  @param unit       单元
 *  @param onComplete 获取完成回调block
 */
-(void)getLayer:(NSString *)estateId block:(NSString *)block unit:(NSString *)unit onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

#pragma mark 保修相关API
/**
 *  获取公共保修类别
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getPublicRepairClasses:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取公共保修状态
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getPublicRepairStatus:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  添加公共报修
 *
 *  @param repair     报修实例对象
 *  @param onComplete 添加完成回调block
 */
-(void)addPublicRepair:(AddPublicRepairVO *)repair onComplete:(void (^)(NSString *errorMsg))onComplete;

/**
 *  获取公共保修
 *
 *  @param page          页数
 *  @param repairStatuId 保修状态ID
 *  @param onComplete    获取完成回调block
 */
-(void)getPublicRepairs:(int)page repairStatu:(NSString *)repairStatuId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取单个公共保修
 *
 *  @param repairId   保修ID
 *  @param onComplete 获取完成block
 */
-(void)getAPublicRepair:(NSString *)repairId onComplete:(void (^)(NSString *errorMsg,RepairVO *repair))onComplete;

/**
 *  获取公共保修统计
 *
 *  @param estateId   楼盘id
 *  @param onComplete 获取完成回调block
 */
-(void)getPublicRepairStatistic:(NSString *)estateId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取业主保修状态
 *
 *  @param onComplete 获取完成回调block
 */
-(void)getRepairStatus:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取业主保修统计
 *
 *  @param estateId   楼盘id
 *  @param onComplete 获取完成回调block
 */
-(void)getRepairStatistic:(NSString *)estateId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取业主保修
 *
 *  @param page          页数
 *  @param repairStatuId 保修状态
 *  @param onComplete    获取完成回调block
 */
-(void)getRepairs:(int)page repairStatu:(NSString *)repairStatuId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取单个业主保修
 *
 *  @param repairId   保修ID
 *  @param onComplete 获取完成回调block
 */
-(void)getARepair:(NSString *)repairId onComplete:(void (^)(NSString *errorMsg,RepairVO *repair))onComplete;

/**
 *  获取维修员工时效统计 - 公共报修
 *
 *  @param estateId   楼盘ID
 *  @param onComplete 获取完成回调block
 */
-(void)getStaffRepairStatistics:(NSString *)estateId onComplete:(void (^)(NSString *errorMsg,NSArray* list))onComplete;

#pragma mark 接单相关API
/**
 *  获取接单列表
 *
 *  @param type       类型
 *  @param page       页数
 *  @param onComplete 获取完成回调block
 */
-(void)getTaskList:(TaskType )type page:(int)page onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

/**
 *  获取接单详细
 *
 *  @param taskId     接单id
 *  @param isPublic   是否是公共
 *  @param onComplete 获取完成回调block
 */
-(void)getATask:(NSString *)taskId isPublic:(BOOL)isPublic onComplete:(void (^)(NSString *errorMsg,RepairVO *repair))onComplete;

/**
 *  接单
 *
 *  @param taskId     接单id
 *  @param isPublic   是否是公共
 *  @param onComplete 获取完成回调block
 */
-(void)takeTask:(NSString *)taskId isPublic:(BOOL)isPublic onComplete:(void (^)(NSString *errorMsg))onComplete;

/**
 *  结单
 *
 *  @param taskId     接单id
 *  @param isPublic   是否是公共
 *  @param onComplete 获取完成回调block
 */
-(void)endTask:(NSString *)taskId isPublic:(BOOL)isPublic onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 聊天相关API
/**
 *  发送消息
 *
 *  @param friendId   对方ID
 *  @param msg        消息内容
 *  @param onComplete 发送完成回调block
 */
-(void)sendMsg:(NSString *)friendId msg:(NSString *)msg onComplete:(void (^)(NSString *errorMsg))onComplete;

/**
 *  获取聊天内容
 *
 *  @param friendId   对方ID
 *  @param endId      聊天ID
 *  @param onComplete 获取完成回调block
 */
-(void)getMsgs:(NSString *)friendId endId:(NSString *)endId onComplete:(void (^)(NSString *errorMsg,NSArray *list))onComplete;

#pragma mark 找回密码相关API
/**
 *  发送验证码
 *
 *  @param name       登录帐号
 *  @param phoneNum   手机号码
 *  @param onComplete 发送完成回调block
 */
-(void)sendCode:(NSString *)name phoneNum:(NSString *)phoneNum onComplete:(void (^)(NSString *errorMsg))onComplete;

/**
 *  重置密码
 *
 *  @param name        登录账号
 *  @param phoneNum    手机号码
 *  @param code        短信验证码
 *  @param newPassword 新密码
 *  @param onComplete  重置完成回调
 */
-(void)setNewPassword:(NSString *)name phoneNum:(NSString *)phoneNum code:(NSString *)code newPassword:(NSString *)newPassword onComplete:(void (^)(NSString *errorMsg))onComplete;

#pragma mark 测试用函数
-(void)test;
@end
