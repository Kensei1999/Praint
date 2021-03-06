//
//  ViewController.m
//  practice_painting
//
//  Created by 石井　建世 on 2014/05/03.
//  Copyright (c) 2014年 石井　建世. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "ALRadialMenu.h"
//#import "ALRadialButton.h"
#import "BFPaperCheckbox.h"
#import "ICETutorialController.h"
#import "ICETutorialPage.h"
#import "ICETutorialStyle.h"
#import "InfColorPicker.h"


@import GoogleMobileAds ;

@interface ViewController ()<UIActionSheetDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;
@property BFPaperCheckbox *paperCheckbox;
@property UILabel *paperCheckboxLabel;



@end

@implementation ViewController{
    UIImageView *tempDrawImage;
    CGPoint currentPoint;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createAndLoadInterstitial];
    
    // "トップ画面"が開かれたときのトラッキング情報を送る
//    [Trackingmanager sendScreenTracking:@"トップ画面"];

    DrawingNumber = 0 ;
        
    //create an instance of the radial menu and set ourselves as the delegate.
//    self.radialMenu = [[ALRadialMenu alloc] init];
//    self.radialMenu.delegate = self;
//    
    // Set up fist checkbox:
    self.paperCheckbox = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(109, 0, bfPaperCheckboxDefaultRadius * 2, bfPaperCheckboxDefaultRadius * 2)];
    self.paperCheckbox.tag = 1001;
    self.paperCheckbox.delegate = self;
    [settingView addSubview:self.paperCheckbox];
    
    // Set up checkbox label:
    self.paperCheckboxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 31)];
    self.paperCheckboxLabel.text = @"背景透明化[OFF]";
    self.paperCheckboxLabel.backgroundColor = [UIColor clearColor];
    self.paperCheckboxLabel.center = CGPointMake(self.paperCheckbox.center.x + ((2 * self.paperCheckboxLabel.frame.size.width) / 3), self.paperCheckbox.center.y);
    [settingView addSubview:self.paperCheckboxLabel];
    

    
    actionNum = 0 ;
    
    //canvas復元
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"canvas"];
    canvas.image = [UIImage imageWithData:imageData];
    
    redlineNumber = [savered floatForKey:@"redlineNumber"];  // redlineNumberの内容をfloat型として取得
    bluelineNumber = [saveblue floatForKey:@"bluelineNumber"];
    greenlineNumber = [savegreen floatForKey:@"greenlineNumber"];
    futosaNumber = [savefutosa floatForKey:@"futosaNumber"];
    opacityNumber = [saveopacity floatForKey:@"redlineNumber"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myFunction)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    //背景画像用のImageViewのインスタンスを生成する
    haikeigazou.backgroundColor = [UIColor clearColor] ;
    haikeigazou.alpha = 0.5;
    [self.view insertSubview:haikeigazou atIndex:0] ;
    [self.view addSubview:haikeigazou] ;
    
    //キャンバスのインスタンスを生成します
    canvas.backgroundColor = [UIColor clearColor] ;
    canvas.alpha = 1.0;
    [self.view insertSubview:canvas atIndex:0] ;
    [self.view addSubview:canvas];
    [self.view addSubview:hideView] ;
    
    [self.view bringSubviewToFront:canvas] ;
    
    [self.view bringSubviewToFront:hideView] ;    // hideView を最前面に移動

    
    rgb = 0 ; //OFFになると変数rgbを元の0（黒ペン）に戻す
    
    redlineNumber = 0.0f ;
    greenlineNumber = 0.0f ;
    bluelineNumber = 0.0f ;
    futosaNumber = 10.0f ;
    opacityNumber = 1.0f ;
    
    // ステータスバーの表示/非表示メソッド呼び出し
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7以降
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 7未満
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    //設定画面
    settingView.hidden = YES ;
    
    futosaSlider.minimumValue = 0.0f ;
    futosaSlider.maximumValue = 90.0f ;
    
    opacitySlider.minimumValue = 0.0f ;
    opacitySlider.maximumValue = 1.0f ;
    
    redlineSlider.minimumValue = 0.0f ;
    greenlineSlider.minimumValue = 0.0f ;
    bluelineSlider.minimumValue = 0.0f ;
    
    redlineSlider.maximumValue = 1.0f ;
    greenlineSlider.maximumValue = 1.0f ;
    bluelineSlider.maximumValue = 1.0f ;
    
    futosaSlider.value = futosaNumber ;
    redlineSlider.value = redlineNumber ;
    greenlineSlider.value = greenlineNumber ;
    bluelineSlider.value = bluelineNumber ;
    opacitySlider.value = opacityNumber ;
    
    redlinePercentage = redlineSlider.value/1.0f * 100 ;
    greenlinePercentage = greenlineSlider.value/1.0f * 100 ;
    bluelinePercentage = bluelineSlider.value/1.0f * 100 ;
    futosaPercentage = futosaSlider.value/90.0f * 100 ;
    opacityPercentage = opacitySlider.value/1.0f * 100 ;

    redlinelabel.text = [NSString stringWithFormat:@"R:%.2f%%",redlinePercentage] ;
    greenlinelabel.text = [NSString stringWithFormat:@"G:%.2f%%",greenlinePercentage] ;
    bluelinelabel.text = [NSString stringWithFormat:@"B:%.2f%%",bluelinePercentage] ;
    
    futosaLabel.text = [NSString stringWithFormat:@"%.2f%%",futosaPercentage] ;
    
    opacityLabel.text = [NSString stringWithFormat:@"%.2f%%",opacityPercentage] ;
    

    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),futosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, opacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //描画用tempImageView
    
    tempDrawImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:tempDrawImage];
    
    DrawingArray[DrawingNumber] = canvas.image ;
    
}

- (void)tapped:(UIButton *)sender
{
    BOOL animate;
    if (sender.tag == 2001) {       // animate button tag
        animate = YES;
    }
    else if (sender.tag == 2002) {  // static button tag
        animate = NO;
    }
    
    /*
     * Below are the two ways of programmatically setting the state of a checkbox.
     */
    
    // (1) Swap paperCheckbox's state with the 'switchStates...' method:
    [self.paperCheckbox switchStatesAnimated:animate];
    

}

#pragma mark - BFPaperCheckbox Delegate
- (void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox
{
        self.paperCheckboxLabel.text = self.paperCheckbox.isChecked ? @"背景透明化 [ON]" : @"背景透明化 [OFF]";
    
        haikeigazou.alpha = self.paperCheckbox.isChecked ? 0.0f : 0.5f;

}

- (void)createAndLoadInterstitial {
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.adUnitID = @"ca-app-pub-9211047756234595/4443203664";
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    
    [self.interstitial loadRequest:request];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    NSLog(@"interstitialDidDismissScreen");
    [self createAndLoadInterstitial];
}

-(void)myFunction{
    
    // NSUserDefaultsの取得
    savecanvas = [NSUserDefaults standardUserDefaults];
    savered = [NSUserDefaults standardUserDefaults] ;
    savegreen = [NSUserDefaults standardUserDefaults] ;
    saveblue = [NSUserDefaults standardUserDefaults] ;
    savefutosa = [NSUserDefaults standardUserDefaults] ;
    saveopacity = [NSUserDefaults standardUserDefaults] ;
    
    //canvas保存
    NSData *imageData = UIImagePNGRepresentation(canvas.image);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"canvas"];
    
    [savered setFloat:redlineNumber forKey:@"redline"];  // float型のredlineNumberをredlineというキーで保存
    [savegreen setFloat:greenlineNumber forKey:@"greenline"];
    
    [saveblue setFloat:bluelineNumber forKey:@"blueline"];
    
    [savefutosa setFloat:futosaNumber forKey:@"futosa"];
    
    [saveopacity setFloat:opacityNumber forKey:@"opacity"];
    
    
}


// ステータスバーの非表示
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    i = 1 ;
    
}

-(IBAction)eraser {
    
//     [Trackingmanager sendEventTracking:@"Button" action:@"Push" label:@"消しゴム切り替え" value:nil screen:@"トップ画面"];
    
  if(rgb == 0){
      
      rgb = 1 ; //ONになると消しゴムを使用するために変数rgbを1（白ペン）に切り替える

      UIImage *img = [UIImage imageNamed:@"eraser2.png"];
      [eraser setImage:img forState:UIControlStateNormal];
      
  }else {
      
      rgb = 0 ; //OFFになると変数rgbを元の0（黒ペン）に戻す
      
      UIImage *img = [UIImage imageNamed:@"brush7.png"];
      [eraser setImage:img forState:UIControlStateNormal];

  }
    
}
- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
    const CGFloat *components = CGColorGetComponents(picker.resultColor.CGColor);
    redlineNumber = components[0] ;
    greenlineNumber = components[1] ;
    bluelineNumber = components[2] ;
    
    [self dismissModalViewControllerAnimated:YES] ;
}

//画面に指をタッチしたときの処理
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    settingView.hidden = YES ;
    
    _brushPreview.userInteractionEnabled = YES;
    //タッチされたUIImageViewの判定
    if([event touchesForView:_brushPreview] != NULL)
    {
        //タッチ認識時の処理
        InfColorPickerController* picker = [ InfColorPickerController colorPickerViewController ];
        
        picker.delegate = self;
        
        [ picker presentModallyOverViewController: self ];
        
    }
    
//    //タッチ開始座標を先ほど宣言したtouchPointという変数に入れる
    UITouch *touch = [touches anyObject] ;
    touchPoint = [touch locationInView:canvas] ;
    
    mouseSwiped = NO;
    
    //メニューを隠す
    
    if(touch.view) {
        
        if (i == 1) {

            i = 2;
            
            CGRect HideFrame = hideView.frame ;
            HideFrame.origin.y = self.view.bounds.size.height ;
            
            [UIView beginAnimations:nil context:nil] ;
            [UIView setAnimationDuration:0.25] ;
            [UIView setAnimationDelay:0.1] ;
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut] ;
            
            hideView.frame = HideFrame ;
            
            [UIView commitAnimations] ;
        }else {
            CGRect basketBottomFrame = hideView.frame ;
            CGRect r = [[UIScreen mainScreen] bounds];
            if(r.size.height == 480){
                basketBottomFrame.origin.y = 430 ;
            }else{
                basketBottomFrame.origin.y = 510 ;
            }
            [UIView beginAnimations:nil context:nil] ;
            [UIView setAnimationDuration:0.25] ;
            [UIView setAnimationDelay:0.1] ;
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut] ;
        
            hideView.frame = basketBottomFrame ;
        
            [UIView commitAnimations] ;
            
            i = 1 ;
        
        }
    
    }
    
}

//画面に指がタッチされた状態で動かしているときの処理
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(rgb == 0){
    
    settingView.hidden = YES ;
    
    //現在のタッチ座標をcurrentPointという変数に入れる
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:canvas];
    
    mouseSwiped = YES;
        
    //お絵描きできる範囲をcanvasの大きさで生成
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    //キャンバスにセットされている画像（UIImage）を用意
    [tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    CGRect r = [[UIScreen mainScreen] bounds];
//    NSLog(@"大きさは...%f",r.size.height);
        
//    if(r.size.height == 480){
//        
//        //線の描画開始座標をセットする
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y-40);
//        
//        //線の描画終了座標をセットする
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y-40);
//        
//    }else if(r.size.height > 480){
//        
//        //線の描画開始座標をセットする
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
//        
//        //線の描画終了座標をセットする
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
//        
//    }else if (r.size.height < 480){
//        
//        //線の描画開始座標をセットする
//        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
//        
//        //線の描画終了座標をセットする
//        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
//
//        
//    }
        // 機種の取得
        NSString *modelname = [ [ UIDevice currentDevice] model];
        
        // iPadかどうか判断する
        if ( ![modelname hasPrefix:@"iPad"] ) {
            // iPad以外
            // Windowスクリーンのサイズを取得
            CGRect r = [[UIScreen mainScreen] bounds];
            if(r.size.height == 480){
                // iPhone4
                NSLog(@"iPhone4&4s");
                
        //線の描画開始座標をセットする
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
                
        //線の描画終了座標をセットする
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
                
            } else if(r.size.height == 667){
                // iPhone6
                NSLog(@"iPhone6");
                
        //線の描画開始座標をセットする
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
                
        //線の描画終了座標をセットする
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
                
            } else if(r.size.height == 736){
                // iPhone6 Plus
                NSLog(@"iPhone6 Plus");
                
                //線の描画開始座標をセットする
                CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
                
                //線の描画終了座標をセットする
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);

            
            } else {
                // iPhone5
                NSLog(@"iPhone5");
                
                //線の描画開始座標をセットする
                CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
                
                //線の描画終了座標をセットする
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);

                
            }
        } else {
            // iPad
            NSLog(@"iPad");
            
            //線の描画開始座標をセットする
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y-3);
            
            //線の描画終了座標をセットする
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y-3);

            
        }
    
    //線の角を丸くする
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    //太さの設定
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), futosaNumber );
    
    //色の設定
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    //線の色を指定（RGBというRed、Green、Blue、の３色の加減で様々な色を表現する）
         if(rgb == 0){
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, 1.0) ;
        }else {
    
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear) ;
        }
    
    //描画の開始〜終了まで線を引く
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    //描画領域を画像（UIImage）としてcanvasにセット
    tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [tempDrawImage setAlpha:opacityNumber];
    
    //描画領域のクリア
   UIGraphicsEndImageContext();
    

    //現在のタッチ座標を次の開始座標にバトンタッチ（受け渡す）！！
    touchPoint = currentPoint;
    
    CGRect HideFrame = hideView.frame ;
    HideFrame.origin.y = self.view.bounds.size.height ;
    
    [UIView beginAnimations:nil context:nil] ;
    [UIView setAnimationDuration:0.25] ;
    [UIView setAnimationDelay:0.1] ;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut] ;
    
    hideView.frame = HideFrame ;
    
    [UIView commitAnimations] ;
    
    i = 1 ;
    
    }else{                           //消しゴム
//        
//        settingView.hidden = YES ;
//        
//        //現在のタッチ座標をcurrentPointという変数に入れる
//        UITouch *touch = [touches anyObject];
//        currentPoint = [touch locationInView:canvas];
//        
//        mouseSwiped = YES;
//        
//        //お絵描きできる範囲をcanvasの大きさで生成
//        UIGraphicsBeginImageContext(self.view.frame.size);
//        
//        //キャンバスにセットされている画像（UIImage）を用意
//        [canvas.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        
//        CGRect r = [[UIScreen mainScreen] bounds];
//        //    NSLog(@"大きさは...%f",r.size.height);
//        if(r.size.height == 480){
//            
//            //線の描画開始座標をセットする
//            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y-40);
//            
//            //線の描画終了座標をセットする
//            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y-40);
//            
//        }else if(r.size.height > 480){
//            
//            //線の描画開始座標をセットする
//            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
//            
//            //線の描画終了座標をセットする
//            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
//            
//        }else if (r.size.height < 480){
//            
//            //線の描画開始座標をセットする
//            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
//            
//            //線の描画終了座標をセットする
//            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
//            
//            
//        }
//        
//        //線の角を丸くする
//        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//        
//        //太さの設定
//        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), futosaNumber );
//        
//        //色の設定
//        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, 1.0);
//        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
//        
//        //線の色を指定（RGBというRed、Green、Blue、の３色の加減で様々な色を表現する）
//        if(rgb == 0){
//            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 0.0) ;
//        }else {
//            
//            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear) ;
//        }
//        
//        //描画の開始〜終了まで線を引く
//        CGContextStrokePath(UIGraphicsGetCurrentContext());
//        
//        //描画領域を画像（UIImage）としてcanvasにセット
//        canvas.image = UIGraphicsGetImageFromCurrentImageContext();
//        
//        //描画領域のクリア
//        UIGraphicsEndImageContext();
//        
//        
//        //現在のタッチ座標を次の開始座標にバトンタッチ（受け渡す）！！
//        touchPoint = currentPoint;
//        
//        CGRect HideFrame = hideView.frame ;
//        HideFrame.origin.y = self.view.bounds.size.height ;
//        
//        [UIView beginAnimations:nil context:nil] ;
//        [UIView setAnimationDuration:0.25] ;
//        [UIView setAnimationDelay:0.1] ;
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut] ;
//        
//        hideView.frame = HideFrame ;
//        
//        [UIView commitAnimations] ;
//        
//        i = 1 ;
//
        
        //現在のタッチ座標をcurrentPointという変数に入れる
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:canvas];
        
        //お絵描きできる範囲をcanvasの大きさで生成
        UIGraphicsBeginImageContext(self.view.frame.size);
        
        //キャンバスにセットされている画像（UIImage）を用意
        [canvas.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        //線の描画開始座標をセットする
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
        
        //線の描画終了座標をセットする
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        
        //線の角を丸くする
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        
        //太さの設定
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), futosaNumber );
        
        //色の設定
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, opacityNumber);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        //線の色を指定（RGBというRed、Green、Blue、の３色の加減で様々な色を表現する）
        if(rgb == 0){
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, opacityNumber) ;
        }else {
            
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear) ;
            
            
            
        }
        
        //描画の開始〜終了まで線を引く
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        //描画領域を画像（UIImage）としてcanvasにセット
        canvas.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //描画領域のクリア
        UIGraphicsEndImageContext();
        
        //現在のタッチ座標を次の開始座標にバトンタッチ（受け渡す）！！
        touchPoint = currentPoint;
        
        CGRect HideFrame = hideView.frame ;
        HideFrame.origin.y = self.view.bounds.size.height ;
        
        [UIView beginAnimations:nil context:nil] ;
        [UIView setAnimationDuration:0.25] ;
        [UIView setAnimationDelay:0.1] ;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut] ;
        
        hideView.frame = HideFrame ;
        
        [UIView commitAnimations] ;
        
        i = 1 ;
        
    }
    
    mouseSwiped = NO ;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    
    if (mouseSwiped == YES) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, opacityNumber);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
    }
    
    UIGraphicsBeginImageContext(canvas.frame.size);
    [canvas.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacityNumber];
    canvas.image = UIGraphicsGetImageFromCurrentImageContext();
    tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    
    mouseSwiped = NO ;
    
    DrawingNumber += 1 ;
    DrawingArray[DrawingNumber] = canvas.image ;
    
    [self myFunction] ;
}

-(IBAction)undo:(id)sender{
    canvas.image = DrawingArray[DrawingNumber] ;
    DrawingNumber -= 1 ;
}

-(IBAction)redo:(id)sender{
    
//    if(DrawingNumber+1 == nil){
//    }
    canvas.image = DrawingArray[DrawingNumber+1] ;

}



-(void)png {
    
    //保存する範囲を指定(背景の範囲を取得している)
    CGRect rect = canvas.bounds ;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0) ;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext() ;
    
    CGContextFillRect(ctx, rect) ;
    
    [canvas.layer renderInContext:ctx] ;
    //↑スタンプから持って来た（元々はhaikei）
    
    //普通に保存するとJPEG形式で保存され荒れるのでPNG形式に変換している
    NSData *data = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext()) ;
    
    capture = [UIImage imageWithData:data] ;
    
    UIGraphicsEndImageContext() ;
    
}


//画像保存完了時のセレクタ
- (void)onCompleteCapture:(UIImage *)screenImage
 didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSString *message = @"画像を保存しました";
    if (error) message = @"画像の保存に失敗しました";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @""
                                                    message: message
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    
    [alert show];
    haikeigazou.alpha = 0.5;

}

-(IBAction)info{
    
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//    // Init the pages texts, and pictures.
//    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"praintへようこそ！"
//                                                            subTitle:@"これから操作説明を行います"
//                                                         pictureName:@"説明0.png"
//                                                            duration:3.0];
//    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"1.ペンと消しゴム"
//                                                            subTitle:@"ペン・消しゴムボタンではペンと消しゴムを切り替えられます"
//                                                         pictureName:@"説明1.png"
//                                                            duration:3.0];
//    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"2.全消し"
//                                                            subTitle:@"ゴミ箱のボタンでは今まで自分が描いていた全てを削除します"
//                                                         pictureName:@"説明2.png"
//                                                            duration:3.0];
//    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@"3.背景画像の変更"
//                                                            subTitle:@"写真のボタンでは自分の描きたい画像を変更できます"
//                                                         pictureName:@"説明3.png"
//                                                            duration:3.0];
//    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:@"4.シェア"
//                                                            subTitle:@"共有ボタンでは自分の描いた絵を保存したり、twitterやlineなどで自慢できます"
//                                                         pictureName:@"説明4.png"
//                                                            duration:3.0];
//    ICETutorialPage *layer6 = [[ICETutorialPage alloc] initWithTitle:@"5.設定"
//                                                            subTitle:@"パレットボタンでは、ペンの太さや色などを自分好みに設定できます"
//                                                         pictureName:@"説明5.png"
//                                                            duration:3.0];
//    ICETutorialPage *layer7 = [[ICETutorialPage alloc] initWithTitle:@""
//                                                            subTitle:@"それでは、お絵描きを楽しんでください！"
//                                                         pictureName:@"説明0.png"
//                                                            duration:3.0];
//    ICETutorialPage *layer8 = [[ICETutorialPage alloc] initWithTitle:@""
//                                                            subTitle:@""
//                                                         pictureName:@"板目２（元）.png"
//                                                            duration:3.0];
//    
//    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5,layer6,layer7,layer8];
//    
//    // Set the common style for the title.
//    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
//    [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
//    [titleStyle setTextColor:[UIColor whiteColor]];
//    [titleStyle setLinesNumber:1];
//    [titleStyle setOffset:180];
//    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
//    
//    // Set the subTitles style with few properties and let the others by default.
//    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
//    [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
//    
//    // Init tutorial.
//    self.TutorialViewController = [[ICETutorialController alloc] initWithPages:tutorialLayers
//                                                                      delegate:self];
//    
//    // Run it.
//    [self.TutorialViewController startScrolling];
//    
//    self.window.rootViewController = self.TutorialViewController;
//    [self.window makeKeyAndVisible];
    
}

//なぞる画像を変更
-(IBAction)changepic{
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init] ;
    [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary] ;
    [ipc setDelegate:self] ;
    [ipc setAllowsEditing:YES] ;
    ipc.allowsEditing = NO;
    [self presentViewController:ipc animated:YES completion:nil] ;
    
    [self.view bringSubviewToFront:tempDrawImage] ;
    [self.view bringSubviewToFront:hideView];
    
    
}

//フォトライブラリで、画像が選ばれたときの処理
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage] ;
    CGRect screensize = [[UIScreen mainScreen] bounds];
    
        // 取得した画像の縦サイズ、横サイズを取得する
    int imageW = image.size.width;
    int imageH = image.size.height;
    
    if(image.size.width>screensize.size.width){
    // リサイズする倍率を作成する。
//    float scaleW = (imageW > imageH ? screensize.size.width/imageH : screensize.size.width/imageW);
    
    // 比率に合わせてリサイズする。
    // ポイントはUIGraphicsXXとdrawInRectを用いて、リサイズ後のサイズで、
    // aImageを書き出し、書き出した画像を取得することで、
    // リサイズ後の画像を取得します。


    CGSize resizedSize = CGSizeMake(imageW * screensize.size.width/imageW, imageH * screensize.size.width/imageW);
    UIGraphicsBeginImageContext(resizedSize);
    [image drawInRect:CGRectMake(0, 0, imageW * screensize.size.width/imageW, imageH * screensize.size.width/imageW)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
        haikeigazou.center =  CGPointMake(screensize.size.width/2, screensize.size.height/2);
        
        CGRect rect = CGRectMake(0, 0, imageW * screensize.size.width/imageW, imageH * screensize.size.width/imageW);
        haikeigazou.frame = rect;
        
        haikeigazou.tag = 10;
        //UIImageViewのサイズを自動的にimageのサイズに合わせる
        haikeigazou.contentMode = UIViewContentModeCenter;
        [self.view addSubview:haikeigazou];
        
        [haikeigazou setImage:resizedImage] ;
        

        
    }else if (image.size.height>screensize.size.height){
        
        // リサイズする倍率を作成する。
//        float scaleH = (imageH > imageW ? screensize.size.height/imageW : screensize.size.height/imageH);
        
        // 比率に合わせてリサイズする。
        // ポイントはUIGraphicsXXとdrawInRectを用いて、リサイズ後のサイズで、
        // aImageを書き出し、書き出した画像を取得することで、
        // リサイズ後の画像を取得します。
        CGSize resizedSize = CGSizeMake(imageW * screensize.size.height/imageH, imageH * screensize.size.height/imageH);
        UIGraphicsBeginImageContext(resizedSize);
        [image drawInRect:CGRectMake(0, 0, imageW * screensize.size.height/imageH, imageH * screensize.size.height/imageH)];
        UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        haikeigazou.center =  CGPointMake(screensize.size.width/2, screensize.size.height/2);
        
        CGRect rect = CGRectMake(0, 0, imageW * screensize.size.height/imageH, imageH * screensize.size.height/imageH);
        haikeigazou.frame = rect;
        
        haikeigazou.tag = 10;
        //UIImageViewのサイズを自動的にimageのサイズに合わせる
        haikeigazou.contentMode = UIViewContentModeCenter;
        [self.view addSubview:haikeigazou];
        
        [haikeigazou setImage:resizedImage] ;
    }else{
        haikeigazou.center =  CGPointMake(screensize.size.width/2, screensize.size.height/2);
        
        haikeigazou.tag = 10;
        //UIImageViewのサイズを自動的にimageのサイズに合わせる
        haikeigazou.contentMode = UIViewContentModeCenter;
        [self.view addSubview:haikeigazou];
        
        [haikeigazou setImage:image] ;
    }

    
//    [haikeigazou setImage:[info objectForKey:UIImagePickerControllerEditedImage]] ;
//    [self dismissViewControllerAnimated:YES completion:nil] ;
    
    canvas.backgroundColor = [UIColor clearColor] ;
    canvas.image = nil;
    
    [self.view bringSubviewToFront:haikeigazou] ;    // canvas を最前面に移動
    [self.view bringSubviewToFront:canvas] ;
    [self.view bringSubviewToFront:tempDrawImage] ;
    [self.view bringSubviewToFront:hideView] ;    // hideView を最前面に移動
    
    [self dismissViewControllerAnimated:YES completion:nil] ;
    
//    [self.interstitial presentFromRootViewController:self];

    
}



-(IBAction)setting {
    
    
    [self.view addSubview:settingView] ;

    
    if(settingView.hidden == NO){

        settingView.hidden = YES ;
        
    [self.view bringSubviewToFront:tempDrawImage] ;

    [self.view bringSubviewToFront:hideView] ;
        
        
        
    }else if (settingView.hidden == YES){
        
        [self.view bringSubviewToFront:settingView] ;
        
        settingView.hidden = NO ;
        

         }
}
/*-----設定------*/
-(IBAction)changered {
    
    redlineNumber = redlineSlider.value;
    
    greenlineNumber = greenlineSlider.value;
    
    bluelineNumber = bluelineSlider.value;
    
    redlinePercentage = redlineSlider.value/1.0f * 100 ;
    greenlinePercentage = greenlineSlider.value/1.0f * 100 ;
    bluelinePercentage = bluelineSlider.value/1.0f * 100 ;
    
    redlinelabel.text = [NSString stringWithFormat:@"R:%.2f%%",redlinePercentage] ;
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),futosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, opacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

-(IBAction)changegreen {
    
    redlineNumber = redlineSlider.value;
    
    greenlineNumber = greenlineSlider.value;
    
    bluelineNumber = bluelineSlider.value;
    
    redlinePercentage = redlineSlider.value/1.0f * 100 ;
    greenlinePercentage = greenlineSlider.value/1.0f * 100 ;
    bluelinePercentage = bluelineSlider.value/1.0f * 100 ;
    
    greenlinelabel.text = [NSString stringWithFormat:@"G:%.2f%%",greenlinePercentage] ;
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),futosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, opacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

-(IBAction)changeblue {
    
    redlineNumber = redlineSlider.value;
    
    greenlineNumber = greenlineSlider.value;
    
    bluelineNumber = bluelineSlider.value;
    
    redlinePercentage = redlineSlider.value/1.0f * 100 ;
    greenlinePercentage = greenlineSlider.value/1.0f * 100 ;
    bluelinePercentage = bluelineSlider.value/1.0f * 100 ;
    
    bluelinelabel.text = [NSString stringWithFormat:@"B:%.2f%%",bluelinePercentage] ;
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),futosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, opacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

-(IBAction)changefutosa{
    
    futosaNumber = futosaSlider.value;
    
    futosaPercentage = futosaSlider.value/90.0f * 100 ;
    
    futosaLabel.text = [NSString stringWithFormat:@"%.2f%%",futosaPercentage] ;
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),futosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, opacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

-(IBAction)changeopacity {
    
    
    opacityNumber = opacitySlider.value;
    
    opacityPercentage = opacitySlider.value/1.0f * 100 ;
    
    opacityLabel.text = [NSString stringWithFormat:@"%.2f%%",opacityPercentage] ;
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),futosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), redlineNumber, greenlineNumber, bluelineNumber, opacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

/*-----設定-----*/


#pragma mark - 自慢兼画像の保存

- (IBAction)jiman:(id)sender {
    
    actionNum = 1 ;
    
    UIActionSheet *jimanactionSheet = [[UIActionSheet alloc] initWithTitle:@"自慢する"
                                                             delegate:self
                                                    cancelButtonTitle:@"キャンセル"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"カメラロールに保存する", @"ツイッターで自慢する",@"facebookで自慢する",@"lineで自慢する", nil];
    [jimanactionSheet showInView:self.view];
}

//真っ白に戻す
- (IBAction)reset:(id)sender {
    
    actionNum = 0 ;
    
    UIActionSheet *resetactionSheet = [[UIActionSheet alloc] initWithTitle:@"全消し"
                                                             delegate:self
                                                    cancelButtonTitle:@"しない"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"する", nil];
    [resetactionSheet showInView:self.view];
    
}

//アクションシート内容
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (actionNum == 1){
    
        if(buttonIndex == 0) {//画像保存
            
            [self png] ;

            [self.view bringSubviewToFront:tempDrawImage];    // tempDrawImage を最前面に移動

            haikeigazou.alpha = 0.0;
            
            hideView.alpha = 0.0 ;

            //範囲
            
            CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;

            UIGraphicsBeginImageContext(rect.size) ;

            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()] ;
            
            UIImage *capture = UIGraphicsGetImageFromCurrentImageContext() ;
            
            UIGraphicsEndImageContext() ;
            
            SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
            
            //キャプチャした画像の保存
            
            UIImageWriteToSavedPhotosAlbum(capture,self,selector,nil) ;
            
            UIGraphicsEndImageContext() ;
            
            [self.view bringSubviewToFront:hideView];    // hideView を最前面に移動

            haikeigazou.alpha = 0.5;
            
            hideView.alpha = 1.0 ;
            
        }else if (buttonIndex == 1){//ツイートをする
            
            [self png] ;
            
            [self.view bringSubviewToFront:tempDrawImage];    // tempDrawImage を最前面に移動
            
            haikeigazou.alpha = 0.0;
            
            hideView.alpha = 0.0 ;
            
            //描写領域の設定
            
            CGSize size = CGSizeMake(canvas.frame.size.width ,canvas.frame.size.height);
            
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
            
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()] ;
            
            UIImage *twiImg = UIGraphicsGetImageFromCurrentImageContext() ;
             
            UIGraphicsEndImageContext() ;
            
            SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
            
            [self.view bringSubviewToFront:hideView];    // hideView を最前面に移動
            
            haikeigazou.alpha = 0.5;
            
            hideView.alpha = 1.0 ;
            
            NSString *serviceType = SLServiceTypeTwitter;
            
            if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
                
                [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
                    
                    if (result == SLComposeViewControllerResultDone) {
                        
                        //投稿成功時の処理
                        
                        NSLog(@"%@での投稿に成功しました", serviceType);
                        
                    }
                    
                }];
                
                NSString *string = [NSString stringWithFormat:@"こんな絵が描けました！\n \n#praint"];
                
                [controller setInitialText:string];
                
                [controller addImage:twiImg];
                
                
                
                [self presentViewController:controller
                 
                                   animated:NO
                 
                                 completion:NULL];
                
            }
            
        }else if (buttonIndex == 2){//facebookに投稿
            
            
            
            [self png] ;
            
            [self.view bringSubviewToFront:tempDrawImage];    // tempDrawImage を最前面に移動
            
            
            
            haikeigazou.alpha = 0.0;
            
            hideView.alpha = 0.0 ;
            
            //描写領域の設定
            
            CGSize size = CGSizeMake(canvas.frame.size.width ,canvas.frame.size.height);
            
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
            
            
            
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()] ;
            
            UIImage *FaceImg = UIGraphicsGetImageFromCurrentImageContext() ;
            
            
            
            UIGraphicsEndImageContext() ;
            
            SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);

            [self.view bringSubviewToFront:hideView];    // hideView を最前面に移動
            
            haikeigazou.alpha = 0.5;
            
            hideView.alpha = 1.0 ;

            NSString *serviceType = SLServiceTypeFacebook;
            
            if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];

                [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
                    
                    if (result == SLComposeViewControllerResultDone) {
                        
                        //投稿成功時の処理
                        
                        NSLog(@"%@での投稿に成功しました", serviceType);
                        
                    }
                    
            }];
                
                NSString *string = [NSString stringWithFormat:@"こんな絵が描けました！\n \n#praint"];
                
                [controller setInitialText:string];
                
                [controller addImage:FaceImg];

                [self presentViewController:controller
                 
                                   animated:NO
                 
                                 completion:NULL];
                
            }
            
        }else if (buttonIndex == 3){//lineに投稿
 
                [self png] ;
                
                [self.view bringSubviewToFront:tempDrawImage];    // tempDrawImage を最前面に移動
            
                haikeigazou.alpha = 0.0;
                
                hideView.alpha = 0.0 ;
                
                //描写領域の設定
                
                CGSize size = CGSizeMake(canvas.frame.size.width ,canvas.frame.size.height);
                
                UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
            
                [self.view.layer renderInContext:UIGraphicsGetCurrentContext()] ;
                
                UIImage *lineImg = UIGraphicsGetImageFromCurrentImageContext() ;
                
                UIGraphicsEndImageContext() ;
                
                SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
            
                [self.view bringSubviewToFront:hideView];    // hideView を最前面に移動
                
                haikeigazou.alpha = 0.5;
                
                hideView.alpha = 1.0 ;
                
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                
                [pasteboard setData:UIImagePNGRepresentation(lineImg) forPasteboardType:@"public.png"];
                
                NSString *LineUrlString = [NSString stringWithFormat:@"line://msg/image/%@", pasteboard.name];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LineUrlString]];
        }
    }else if (actionNum == 0) {
        if(buttonIndex == 0){
            canvas.image = nil;

        }
    }

}

//
//
//- (IBAction)buttonPressed:(id)sender {
//    //the button that brings the items into view was pressed
//        [self.radialMenu buttonsWillAnimateFromButton:sender withFrame:self.radialbutton.frame inView:self.view];
//    
//}
//
//
//#pragma mark - radial menu delegate methods
//- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu {
//    //FIXME: dipshit, change one of these variable names
//        return 5;
//
//}
//
//
//- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu {
//        return 360;
//
//}
//
//
//- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
//        return 80;
//    
//}
//
//
//- (ALRadialButton *) radialMenu:(ALRadialMenu *)radialMenu buttonForIndex:(NSInteger)index {
//    ALRadialButton *button = [[ALRadialButton alloc] init];
//    NSLog(@"あ");
//        if (index == 1) {
//            [button setImage:[UIImage imageNamed:@"refresh21"] forState:UIControlStateNormal];
//        } else if (index == 2) {
//            [button setImage:[UIImage imageNamed:@"refresh21"] forState:UIControlStateNormal];
//        } else if (index == 3) {
//            [button setImage:[UIImage imageNamed:@"refresh21"] forState:UIControlStateNormal];
//        } else if (index == 4) {
//            [button setImage:[UIImage imageNamed:@"refresh21"] forState:UIControlStateNormal];
//        } else if (index == 5) {
//            [button setImage:[UIImage imageNamed:@"refresh21"] forState:UIControlStateNormal];
//        } else if (index == 6) {
//            [button setImage:[UIImage imageNamed:@"refresh21"] forState:UIControlStateNormal];
//        }
//    NSLog(@"い");
//    if (button.imageView.image) {
//        return button;
//        if (index == 1) {
////            [button setImage:[UIImage imageNamed:@"dribbble"] forState:UIControlStateNormal];
//        } else if (index == 2) {
////            [button setImage:[UIImage imageNamed:@"youtube"] forState:UIControlStateNormal];
//        } else if (index == 3) {
////            [button setImage:[UIImage imageNamed:@"vimeo"] forState:UIControlStateNormal];
//        } else if (index == 4) {
////            [button setImage:[UIImage imageNamed:@"pinterest"] forState:UIControlStateNormal];
//        } else if (index == 5) {
////            [button setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
//        } else if (index == 6) {
////            [button setImage:[UIImage imageNamed:@"instagram500"] forState:UIControlStateNormal];
//        }
//    }
//    NSLog(@"う");
//    return nil;
//}
//
//
//- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
//    
//    [self.radialMenu itemsWillDisapearIntoButton:self.radialbutton];
//    
//    
//}
//





@end
