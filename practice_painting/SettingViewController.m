//
//  SettingViewController.m
//  practice_painting
//
//  Created by 石井　建世 on 2014/05/04.
//  Copyright (c) 2014年 石井　建世. All rights reserved.
//

#import "SettingViewController.h"
#import "ViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

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
    
    redlinelabel.text = [NSString stringWithFormat:@"R:0.0"] ;
    greenlinelabel.text = [NSString stringWithFormat:@"R:0.0"] ;
    bluelinelabel.text = [NSString stringWithFormat:@"R:0.0"] ;
    
    futosaLabel.text = [NSString stringWithFormat:@"%f",futosaNumber] ;

    opacityLabel.text = [NSString stringWithFormat:@"%f",opacityNumber] ;
    
    
    sendredlineNumber = redlineNumber ;
    sendgreenlineNumber = greenlineNumber ;
    sendbluelineNumber = bluelineNumber ;
    sendfutosaNumber = futosaNumber ;
    sendopacityNumber = opacityNumber ;
    
    futosaSlider.value = sendfutosaNumber ;
    redlineSlider.value = sendredlineNumber ;
    greenlineSlider.value = sendgreenlineNumber ;
    bluelineSlider.value = sendbluelineNumber ;
    opacitySlider.value = sendopacityNumber ;
    
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
    
    futosaSlider.value = sendfutosaNumber ;
    redlineSlider.value = sendredlineNumber ;
    greenlineSlider.value = sendgreenlineNumber ;
    bluelineSlider.value = sendbluelineNumber ;
    opacitySlider.value = sendopacityNumber ;
    
    
    
    redlinelabel.text = [NSString stringWithFormat:@"R:%.2f",redlineSlider.value] ;
    greenlinelabel.text = [NSString stringWithFormat:@"G:%.2f",greenlineSlider.value] ;
    bluelinelabel.text = [NSString stringWithFormat:@"B:%.2f",bluelineSlider.value] ;
    futosaLabel.text = [NSString stringWithFormat:@"%.2f",futosaSlider.value] ;
    opacityLabel.text = [NSString stringWithFormat:@"%.1f",opacitySlider.value] ;

    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),sendfutosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), sendredlineNumber, sendgreenlineNumber, sendbluelineNumber, sendopacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)changered {
    
    sendredlineNumber = redlineSlider.value;
    
    sendgreenlineNumber = greenlineSlider.value;
    
    sendbluelineNumber = bluelineSlider.value;
    
    redlinelabel.text = [NSString stringWithFormat:@"R:%.2f",redlineSlider.value] ;
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),sendfutosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), sendredlineNumber, sendgreenlineNumber, sendbluelineNumber, sendopacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),sendfutosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), sendredlineNumber, sendgreenlineNumber, sendbluelineNumber, sendopacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

-(IBAction)changegreen {
    
    sendredlineNumber = redlineSlider.value;
    
    sendgreenlineNumber = greenlineSlider.value;
    
    sendbluelineNumber = bluelineSlider.value;
    
    greenlinelabel.text = [NSString stringWithFormat:@"G:%.2f",greenlineSlider.value] ;
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),sendfutosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), sendredlineNumber, sendgreenlineNumber, sendbluelineNumber, sendopacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

-(IBAction)changeblue {
    
    sendredlineNumber = redlineSlider.value;
    
    sendgreenlineNumber = greenlineSlider.value;
    
    sendbluelineNumber = bluelineSlider.value;
    
    bluelinelabel.text = [NSString stringWithFormat:@"B:%.2f",bluelineSlider.value] ;
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),sendfutosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), sendredlineNumber, sendgreenlineNumber, sendbluelineNumber, sendopacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

-(IBAction)changefutosa{
    
    sendfutosaNumber = futosaSlider.value;
    
    futosaLabel.text = [NSString stringWithFormat:@"%.2f",futosaSlider.value] ;
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),sendfutosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), sendredlineNumber, sendgreenlineNumber, sendbluelineNumber, sendopacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

-(IBAction)changeopacity {
    
    
    sendopacityNumber = opacitySlider.value;
    
    opacityLabel.text = [NSString stringWithFormat:@"%.1f",opacitySlider.value] ;
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),sendfutosaNumber);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), sendredlineNumber, sendgreenlineNumber, sendbluelineNumber, sendopacityNumber);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
}

-(IBAction)back{
    
    redlineNumber = redlineSlider.value ;
    greenlineNumber = greenlineSlider.value ;
    bluelineNumber = bluelineSlider.value ;
    futosaNumber = futosaSlider.value ;
    opacityNumber = opacitySlider.value ;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil] ;
    //↑この数だけ戻る
    
}























@end
