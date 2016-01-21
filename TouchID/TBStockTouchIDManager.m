//
//  TBStockTouchIDManager.m
//  TouchID
//
//  Created by Pengfei_Luo on 16/1/21.
//  Copyright © 2016年 骆朋飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "TBStockTouchIDManager.h"

#define iOS8_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

static TBStockTouchIDManager *touchManager = nil;
@interface TBStockTouchIDManager ()
@property (nonatomic, strong) LAContext *touchIDContext;
@end

@implementation TBStockTouchIDManager

+(id)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        touchManager = [[TBStockTouchIDManager alloc] init];
    });
    
    return touchManager;
}

-(BOOL)isSupportTouchID {
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else 
    if (iOS8_LATER) {
        NSError *error = nil;
        BOOL available = [self.touchIDContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
        if (!available && error) {
            NSLog(@"%@",error.description);
            switch (error.code) {
                case LAErrorTouchIDLockout:/*AVAILABLE iOS9.0*/
                    // 用户输入多次TouchID,均错误
                    // 需要输入密码，系统已做处理
                    NSLog(@"用户多次验证TouchID错误");
                    break;
                case LAErrorTouchIDNotAvailable:
                    NSLog(@"touch id 不可用");
                    break;
                case LAErrorTouchIDNotEnrolled:
                    NSLog(@"touch id 未录入");
                    break;
                case LAErrorInvalidContext/*AVAILABLE iOS9.0*/:
                    break;
                default:
                    break;
            }

        }
        NSLog(@"%d",available);
        return available;
    }
    return NO;
#endif
}

-(void)touchIdReply:(TouchIDReply)reply {
    if (![self isSupportTouchID]) return;
    [self.touchIDContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:RESULT_STRING reply:reply];
}

-(LAContext *)touchIDContext {
    if (!_touchIDContext) {
        _touchIDContext = [LAContext new];
    }
    
    return _touchIDContext;
}

@end
