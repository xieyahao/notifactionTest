//
//  ViewController.m
//  NotificationTest
//
//  Created by xyh on 2019/9/19.
//  Copyright © 2019 xyh. All rights reserved.
//

#import "ViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define kLocalNotificationKey @"kLocalNotificationKey"

@interface ViewController ()<UNUserNotificationCenterDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}



- (IBAction)sendLocalNotification:(id)sender {
    [self sendLocalNotification];
}

-(void)sendLocalNotification{
    if (@available(iOS 10.0, *))
    {
        UNMutableNotificationContent *content=[[UNMutableNotificationContent alloc]init];
        content.body=@"body: 我是消息body" ;
        content.badge=@(1);
        content.title=@"title:我是消息title";
        content.subtitle=@"subtitle:我是消息中的subtitle";
        content.categoryIdentifier=kNotificationActionIdentifile;
        
        content.userInfo=@{kLocalNotificationKey:@"ios10推送"};
        
        NSString *path=[[NSBundle mainBundle]pathForResource:@"0" ofType:@"mp4"];
        NSError *error=nil;
        UNNotificationAttachment *attachment=[UNNotificationAttachment attachmentWithIdentifier:@"AttachmentIdentifile" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
        content.attachments=@[attachment];
        
        UNTimeIntervalNotificationTrigger *trigger=[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
        
        UNNotificationRequest *request=[UNNotificationRequest requestWithIdentifier:@"Test" content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"ios10 发送推送，error:%@",error);
        }];
    }
    else
    {
        UI
    }
   
    
    
}


-(void)registerIos8LocalNotification{
    
}

@end
