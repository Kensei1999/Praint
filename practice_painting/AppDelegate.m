//
//  AppDelegate.m
//  practice_painting
//
//  Created by 石井　建世 on 2014/05/03.
//  Copyright (c) 2014年 石井　建世. All rights reserved.
//

#import "AppDelegate.h"
//#import "GAI.h"



#define INTERSTITIAL_AD_UNIT_ID @"ca-app-pub-9211047756234595/7610322869"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    UIStoryboard *storyboard; // StoryBoardの型宣言
    NSString *storyBoardName; // StoryBoardの名称設定用
    
    // Google Analyticsの初期化
//    [self initializeGoogleAnalytics];
    
    return YES;
    
    // 機種の取得
    NSString *modelname = [ [ UIDevice currentDevice] model];
    
    // iPadかどうか判断する
    if ( ![modelname hasPrefix:@"iPad"] ) {
        // iPad以外
        // Windowスクリーンのサイズを取得
        CGRect r = [[UIScreen mainScreen] bounds];
        if(r.size.height == 480){
            // iPhone4
            NSLog(@"iPhone4");
            
            storyBoardName = @"Main";
            
        } else if(r.size.height == 667){
            // iPhone6
            NSLog(@"iPhone6");
            
            storyBoardName = @"Main";
            
        } else if(r.size.height == 736){
            // iPhone6 Plus
            NSLog(@"iPhone6 Plus");
            
            storyBoardName = @"Main";
            
        } else {
            // iPhone5
            NSLog(@"iPhone5");
            
            storyBoardName = @"Main";
            
        }
    } else {
        // iPad
        NSLog(@"iPad");
        
        storyBoardName = @"Storyboard-ipad";
        
    }
    

//    // 機種の取得
//    NSString *modelname = [ [UIDevice currentDevice] model];
//    // iPadかどうか判断する
//    if ( ![modelname hasPrefix:@"iPad"] ) {
//        // Windowスクリーンのサイズを取得
//        CGRect r = [[UIScreen mainScreen] bounds];
//        // 縦の長さが480の場合、古いiPhoneだと判定
//        if(r.size.height == 480){
//            // NSLog(@"Old iPhone");
//            storyBoardName = @"Storyboard-3.5Inch";
//        }else{
//            // NSLog(@"New iPhone");
//            storyBoardName = @"Main";
//        }
//    }else{
//        // NSLog(@"iPad");
//        storyBoardName = @"Storyboard-3.5Inch";
//    }
 

//    CGRect rect = [UIScreen mainScreen].bounds;
//    if(rect.size.height == 480){
//        storyBoardName = @"Storyboard-3.5Inch";
//        NSLog(@"3.5");
//    }else{
//        storyBoardName = @"Main";
//        NSLog(@"4");
//    }
// 
//    
//    
//    // StoryBoardのインスタンス化
//    storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
//    // 画面の生成
//    UIViewController *mainViewController = [storyboard instantiateInitialViewController];
//    // ルートウィンドウにひっつける
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = mainViewController;
//    [self.window makeKeyAndVisible];
//
//    
//    Class class = NSClassFromString(@"UIAlertController");
//    if(class){
//        // iOS 8の時の処理
//        NSLog(@"iOS8");
//    }else{
//        // iOS 7の時の処理
//        NSLog(@"iOS7");
//    }
//

    
    return YES;

}

//- (void)initializeGoogleAnalytics
//{
//    // トラッキングIDを設定
//    [[GAI sharedInstance] trackerWithTrackingId:@"UA-XXXX-Y"];
//    
//    // 例外を Google Analytics に送る
//    [GAI sharedInstance].trackUncaughtExceptions = YES;
//    
//}

-(void)applicationDidFinishLaunching:(UIApplication *)application{
    

    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
