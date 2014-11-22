//
//  ViewController.m
//  practice_painting
//
//  Created by 石井　建世 on 2014/05/03.
//  Copyright (c) 2014年 石井　建世. All rights reserved.
//

#import "ViewController.h"
#import "SettingViewController.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    
    actionNum = 0 ;
    
    //canvas復元
    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"canvas"];
    canvas.image = [UIImage imageWithData:imageData];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myFunction)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    //背景画像用のImageViewのインスタンスを生成する
//    haikeigazou = [[UIImageView alloc] initWithImage:nil] ;
    haikeigazou.backgroundColor = [UIColor clearColor] ;
    haikeigazou.alpha = 0.5;
    [self.view insertSubview:haikeigazou atIndex:0] ;
    [self.view addSubview:haikeigazou] ;
    
    //キャンバスのインスタンスを生成します
//    canvas = [[UIImageView alloc] initWithImage:nil] ;
    canvas.backgroundColor = [UIColor clearColor] ;
    canvas.alpha = 1.0;
    [self.view insertSubview:canvas atIndex:0] ;
    [self.view addSubview:canvas];
    
    [self.view addSubview:hideView] ;
    
    [self.view bringSubviewToFront:canvas] ;
    [self.view bringSubviewToFront:hideView];    // hideView を最前面に移動

    
    rgb = 0 ; //OFFになると変数rgbを元の0（黒ペン）に戻す
    
    eraserLabel.text = [NSString stringWithFormat:@"消しゴムOFF"] ;
    
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
    
}


-(void)myFunction{
    
    // NSUserDefaultsの取得
    savecanvas = [NSUserDefaults standardUserDefaults];
    //canvas保存
    NSData *imageData = UIImagePNGRepresentation(canvas.image);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"canvas"];
    
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
    
  if(rgb == 0){
      
      rgb = 1 ; //ONになると消しゴムを使用するために変数rgbを1（白ペン）に切り替える
      
              eraserLabel.text = [NSString stringWithFormat:@"消しゴムON"] ;
      
      [UIView beginAnimations:nil context:nil] ; //アニメーションの設定開始
      
      [UIView setAnimationDuration:2] ; //アニメーションは1秒間
      
      [UIView setAnimationDelay:0.25] ; //開始を0.２5秒送らせる
      
      eraserLabel.center = CGPointMake(400, 273) ; // x座標が244, y座標が223のところに画像を表示
      
      [UIView setAnimationCurve:UIViewAnimationCurveEaseOut] ;
      
      [UIView commitAnimations] ; //アニメーション実行！！
      

      
  }else {
      
      rgb = 0 ; //OFFになると変数rgbを元の0（黒ペン）に戻す
      
      eraserLabel.text = [NSString stringWithFormat:@"消しゴムOFF"] ;
      
      [UIView beginAnimations:nil context:nil] ; //アニメーションの設定開始
      
      [UIView setAnimationDuration:2] ; //アニメーションは1秒間
      
      [UIView setAnimationDelay:0.25] ; //開始を0.２5秒送らせる
      
      eraserLabel.center = CGPointMake(-200, 273) ; // x座標が244, y座標が223のところに画像を表示
      
      [UIView setAnimationCurve:UIViewAnimationCurveEaseOut] ;
      
      [UIView commitAnimations] ; //アニメーション実行！！
      
  }
    
}



//画面に指をタッチしたときの処理
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    
    
//    //タッチ開始座標を先ほど宣言したtouchPointという変数に入れる
    UITouch *touch = [touches anyObject] ;
    touchPoint = [touch locationInView:canvas] ;
    
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
            
            
        }
            else {
        
                
            CGRect basketBottomFrame = hideView.frame ;
            basketBottomFrame.origin.y = 510 ;
        
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



//なぞる画像を変更
-(IBAction)changepic{
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init] ;
    [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary] ;
    [ipc setDelegate:self] ;
    [ipc setAllowsEditing:YES] ;
    [self presentViewController:ipc animated:YES completion:nil] ;
    
    [self.view bringSubviewToFront:canvas] ;
    [self.view bringSubviewToFront:hideView];
    
}

//フォトライブラリで、画像が選ばれたときの処理
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    [haikeigazou setImage:[info objectForKey:UIImagePickerControllerEditedImage]] ;
    [self dismissViewControllerAnimated:YES completion:nil] ;
    
    canvas.backgroundColor = [UIColor clearColor] ;
    canvas.image = nil;
    
    [self.view bringSubviewToFront:canvas];    // canvas を最前面に移動
    
    [self.view bringSubviewToFront:hideView];    // hideView を最前面に移動
    
        
        [self dismissViewControllerAnimated:YES completion:nil] ;

    
}

//真っ白に戻す
- (IBAction)reset:(id)sender {
    
    actionNum = 0 ;
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"全消し"
                                                             delegate:self
                                                    cancelButtonTitle:@"しない"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"する", nil];
    [actionSheet showInView:canvas];
//    [actionSheet showInView:toumeicanvas] ;
    
    
}

-(IBAction)setting {

    sendredlineNumber = redlineNumber ;
    sendgreenlineNumber = greenlineNumber ;
    sendbluelineNumber = bluelineNumber ;
    sendfutosaNumber = futosaNumber ;
    sendopacityNumber = opacityNumber ;

    
}


#pragma mark - 自慢兼画像の保存

- (IBAction)jiman:(id)sender {
    
    actionNum = 1 ;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"キャンセル"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"カメラロールに保存する", @"ツイッターで自慢する",@"facebookで自慢する",@"lineで自慢する", nil];
    [actionSheet showInView:self.view];
}


//-(void)postToTwitter:(id)delegate text:(NSString *)text imageName:(NSString *)imageName url:(NSString *)url
//{
////    UIImage *tweet =canvas ;
//    tweetpic = canvas.image ;
//    SLComposeViewController *slc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//    [slc setInitialText:@"こんな絵が描けました！"];
//    [slc addImage:[UIImage imageNamed:tweetpic]];
//    [slc addURL:[NSURL URLWithString:@""]];
//    [delegate presentViewController:slc animated:YES completion:nil];
//}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (actionNum == 1){
    
      if (buttonIndex == 1){//ツイートをする
        
        
        [self png] ;
        [self.view bringSubviewToFront:canvas];    // canvas を最前面に移動
        
        haikeigazou.alpha = 0.0;
        hideView.alpha = 0.0 ;
        //描写領域の設定
        CGSize size = CGSizeMake(canvas.frame.size.width ,canvas.frame.size.height);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()] ;
        UIImage *twiImg = UIGraphicsGetImageFromCurrentImageContext() ;
        
        
        /*
        
        //グラフィックスコンテキスト取得
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //コンテキストの位置の切り取り開始位置に合わせる
        CGPoint point = canvas.frame.origin;
        CGAffineTransform affineMoveLeftTop = CGAffineTransformMakeTranslation(
                                                                               -(int)point.x,
                                                                               -(int)point.y);
        CGContextConcatCTM(context, affineMoveLeftTop);
        
        //Viewから切り取る
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        */
        
        UIGraphicsEndImageContext() ;
        SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);

        [self.view bringSubviewToFront:hideView];    // hideView を最前面に移動
        haikeigazou.alpha = 0.5;
        hideView.alpha = 1.0 ;
        
        
//        tweetpic = canvas.image ;
//        UIImage *img = [UIImage imageNamed:@"スタートボタン.png"];
        
//        [self postToTwitter:self text:@"こんな絵が描けました！" imageName:tweetpic url:@""] ;
        
            NSString *serviceType = SLServiceTypeTwitter;
            if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
                
                [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
                    if (result == SLComposeViewControllerResultDone) {
                        //投稿成功時の処理
                        NSLog(@"%@での投稿に成功しました", serviceType);
                    }
                }];
                
                
                NSString *string = [NSString stringWithFormat:@"こんな絵が描けました！"];
                [controller setInitialText:string];
                [controller addImage:twiImg];
                
                [self presentViewController:controller
                                   animated:NO
                                 completion:NULL];
            }
        
        
        
    }else if(buttonIndex == 0) {//画像保存
        
        [self png] ;
        
        [self.view bringSubviewToFront:canvas];    // canvas を最前面に移動
        
        haikeigazou.alpha = 0.0;
        hideView.alpha = 0.0 ;
        
        //範囲
        CGRect rect = CGRectMake(0, 0, 320, 568) ;
        
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
        
        
        
        
    }else if (buttonIndex == 2){//facebookに投稿
        
        [self png] ;
        [self.view bringSubviewToFront:canvas];    // canvas を最前面に移動
        
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
            
            
            NSString *string = [NSString stringWithFormat:@"こんな絵が描けました！"];
            [controller setInitialText:string];
            [controller addImage:FaceImg];
            
            [self presentViewController:controller
                               animated:NO
                             completion:NULL];
            
            
        
        
        }else if (buttonIndex == 3){//lineに投稿
            
            [self png] ;
            [self.view bringSubviewToFront:canvas];    // canvas を最前面に移動
            
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
        
    }
    }else if (actionNum == 0){
        
        if(buttonIndex == 0){
        
        canvas.image = nil;
        
        }
    }
}


































@end
