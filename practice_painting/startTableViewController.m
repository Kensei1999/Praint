//
//  startTableViewController.m
//  praint
//
//  Created by 石井　建世 on 2014/09/26.
//  Copyright (c) 2014年 石井　建世. All rights reserved.
//

#import "startTableViewController.h"

@interface startTableViewController ()

@end

@implementation startTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // ステータスバーの表示/非表示メソッド呼び出し
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7以降
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 7未満
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
