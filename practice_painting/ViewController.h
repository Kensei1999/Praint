//
//  ViewController.h
//  practice_painting
//
//  Created by 石井　建世 on 2014/05/03.
//  Copyright (c) 2014年 石井　建世. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GoogleMobileAds/GADInterstitial.h"
@import GoogleMobileAds ;

@interface ViewController : UIViewController<GADInterstitialDelegate> {
    
    float redlineNumber ;
    float greenlineNumber ;
    float bluelineNumber ;
    float futosaNumber ;
    float opacityNumber ;
    int i ;
            
    UIImageView *canvas ;
    //お絵描きしていくキャンバス（画用紙）を準備します
    
    UIImageView *haikeigazou ;
    //背景画像を表示する
    
    UIImage *tweetpic ;
    //tweetする画像
    
    CGPoint touchPoint ;
    //お絵描きに使う座標を準備します
    
    UIImage *capture ; //作った絵を一時的に保管するUIImage型のcaptureという名前の箱を準備
    
    NSUserDefaults *savecanvas ;
    
    NSUserDefaults *savered ;
    
    NSUserDefaults *savegreen ;

    NSUserDefaults *saveblue ;
    
    NSUserDefaults *savefutosa ;
    
    NSUserDefaults *saveopacity ;

    IBOutlet UISwitch *eraser ;
    
    IBOutlet UILabel *eraserLabel ;
    
    int rgb ;//ペンの色
        
    int actionNum ;
    
    int settingNum ;
    
    BOOL mouseSwiped;

    
    IBOutlet UIView *hideView;
    
    IBOutlet UIView *settingView ;
    
    IBOutlet UISlider *redlineSlider ;
    
    IBOutlet UISlider *greenlineSlider ;
    
    IBOutlet UISlider *bluelineSlider ;
    
    IBOutlet UILabel *redlinelabel ;
    
    IBOutlet UILabel *greenlinelabel ;
    
    IBOutlet UILabel *bluelinelabel ;
    
    IBOutlet UISlider *futosaSlider ;
    
    IBOutlet UILabel *futosaLabel ;
    
    IBOutlet UISlider* opacitySlider ;
    
    IBOutlet UILabel *opacityLabel ;
}


-(IBAction)reset:(id)sender ; //リセットボタン

-(void)png ; //画像をpng形式にする

-(IBAction)eraser ;

-(IBAction)setting ;

-(IBAction)jiman:(id)sender ;

@property (weak, nonatomic) IBOutlet UIImageView *brushPreview;


@end
