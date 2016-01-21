//
//  ViewController.m
//  TouchID
//
//  Created by Pengfei_Luo on 16/1/21.
//  Copyright © 2016年 骆朋飞. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

#import "TBStockTouchIDManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[TBStockTouchIDManager shareInstance] isSupportTouchID];
    
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)touchIDClicked:(id)sender {
    if (![[TBStockTouchIDManager shareInstance] isSupportTouchID]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持 or 没有设置 Touch ID" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    [[TBStockTouchIDManager shareInstance] touchIdReply:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"成功");
        }
        else {
            NSLog(@"%@",error.debugDescription);
            switch (error.code) {
                case LAErrorUserCancel:
                case LAErrorSystemCancel:
                case LAErrorAppCancel/*AVAILABLE iOS9.0*/:
                    NSLog(@"取消");
                    break;
                case LAErrorAuthenticationFailed:
                    NSLog(@"认证失败");
                    break;
                case LAErrorUserFallback:
                    NSLog(@"用户选择输入密码");
                    break;
                case LAErrorTouchIDLockout/*AVAILABLE iOS9.0*/:
                    NSLog(@"用户输入多次TouchID，错误需求输入密码，系统做处理");
                    break;
                default:
                    break;
            }
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
