//
//  AppDelegate.m
//  NotificationTest
//
//  Created by xyh on 2019/9/19.
//  Copyright © 2019 xyh. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self registerLocalNotification];
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = (id)self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //用户点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                //用户点击不允许
                NSLog(@"注册失败");
            }
        }];
    } else {
        // Fallback on earlier versions
    }
   
    return YES;
}


-(void)registerLocalNotification{
    
    if (@available(iOS 10.0, *))
    {
        UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
        center.delegate=self;
        
        UNNotificationAction *action1=[UNNotificationAction actionWithIdentifier:kNotificationActionIdentifileStar title:@"赞" options:UNNotificationActionOptionAuthenticationRequired];
        
    
        UNTextInputNotificationAction *action2=[UNTextInputNotificationAction actionWithIdentifier:kNotificationActionIdentifileComment title:@"评论一下吧" options:UNNotificationActionOptionForeground textInputButtonTitle:@"评论" textInputPlaceholder:@"请输入评论"];
        
        UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:kNotificationActionIdentifile actions:@[action1,action2] intentIdentifiers:@[kNotificationActionIdentifileStar,kNotificationActionIdentifileComment] options:UNNotificationCategoryOptionNone];
        
        [center setNotificationCategories:[NSSet setWithObject:category]];
        
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted)
            {
                //用户点击允许
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@",settings);
                }];
            }
            else
            {
                 NSLog(@"注册失败");
            }
        }];
        
    }
    else
    {
        // Fallback on earlier versions
        UIMutableUserNotificationAction *action1=[[UIMutableUserNotificationAction alloc]init];
        action1.identifier=kNotificationActionIdentifileStar;
        action1.title=@"赞";
        action1.activationMode=UIUserNotificationActivationModeForeground;
        action1.authenticationRequired=YES;
        action1.destructive=NO;
        
        
        UIMutableUserNotificationAction *action2=[[UIMutableUserNotificationAction alloc]init];
        action2.identifier=kNotificationActionIdentifileComment;
        action2.title=@"评论";
        action2.activationMode=UIUserNotificationActivationModeBackground;
        action2.behavior=UIUserNotificationActionBehaviorTextInput;
        
        action2.parameters=@{UIUserNotificationTextInputActionButtonTitleKey:@"评论"};
        
        UIMutableUserNotificationCategory *category=[[UIMutableUserNotificationCategory alloc]init];
        category.identifier=kNotificationActionIdentifile;
        [category setActions:@[action1,action2] forContext:UIUserNotificationActionContextMinimal];
        
        UIUserNotificationSettings *uns=[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObject:category]];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }
}


#pragma mark  ios10 接收推送的两个方法
//接收到通知的事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0))
{
    NSDictionary *userInfo=notification.request.content.userInfo;
    UNNotificationRequest *request=notification.request;
    UNNotificationContent *content=request.content;
    NSNumber *badge=content.badge;
    NSString *body=content.body;
    NSString *title=content.title;
    NSString *subTitle=content.subtitle;
    UNNotificationSound *sound=content.sound;
    

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        NSLog(@"ios10 前台收到远程通知%@",userInfo);
    }
    else
    {
        NSLog(@"iOS10 应用在前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}", body, title, subTitle, badge, sound, userInfo);
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}


//通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
API_AVAILABLE(ios(10.0))
{
    NSDictionary *userInfo=response.notification.request.content.userInfo;
    UNNotificationRequest *request=response.notification.request;
    UNNotificationContent *content=request.content;
    NSNumber *badge=content.badge;
    NSString *body=content.body;
    NSString *title=content.title;
    NSString *subTitle=content.subtitle;
    UNNotificationSound *sound=content.sound;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        NSLog(@"ios10 前台收到远程通知 ：%@",userInfo);
    }
    else
    {
        //本地通知
        NSLog(@"iOS10 应用在后台点击推送消息收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}", body, title, subTitle, badge, sound, userInfo);
    }
    
    NSString *actionIdentifile=response.actionIdentifier;
    
    if([actionIdentifile isEqualToString:kNotificationActionIdentifileStar])
    {
        [self showAlertView:@"点了赞"];
    }
    else if([actionIdentifile isEqualToString:kNotificationActionIdentifileComment])
    {
        [self showAlertView:[(UNTextInputNotificationResponse *)response userText]];
    }
    else
    {
        
    }
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge);
}



#pragma mark - ios9  及之前方法
// (iOS9及之前)本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"%@",notification.userInfo);

    [self showAlertView:@"用户没点击按钮 直接点推送消息 / 或者在app 前台时收到的推送消息"];

    NSInteger badge=[UIApplication sharedApplication].applicationIconBadgeNumber;
    badge -= notification.applicationIconBadgeNumber;
    badge = badge>=0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber=badge;
}

//在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler
{
    if ([identifier isEqualToString:kNotificationActionIdentifileStar])
    {
        [self showAlertView:@"点了赞"];
    }
    else
    {
        [self showAlertView:[NSString stringWithFormat:@"用户评论为：%@",responseInfo[UIUserNotificationActionResponseTypedTextKey]]];
    }
    completionHandler();
}


- (void)showAlertView:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self.window.rootViewController showDetailViewController:alert sender:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
