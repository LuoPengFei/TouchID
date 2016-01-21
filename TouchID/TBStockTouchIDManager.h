//
//  TBStockTouchIDManager.h
//  TouchID
//
//  Created by Pengfei_Luo on 16/1/21.
//  Copyright © 2016年 骆朋飞. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  touch id manager
 */

static NSString *RESULT_STRING                                                        = @"验证Touch ID";


typedef void(^TouchIDReply)(BOOL success, NSError *error);

@interface TBStockTouchIDManager : NSObject
+(id)shareInstance;
/**
 *  是否支持touch id
 *  未录入touch id 返回 NO
 */
-(BOOL)isSupportTouchID;



-(void)touchIdReply:(TouchIDReply)reply;


@end
