//
//  ExplainViewController.m
//  practice_painting
//
//  Created by 石井　建世 on 2014/05/05.
//  Copyright (c) 2014年 石井　建世. All rights reserved.
//

#import "ExplainViewController.h"
#import "ICETutorialController.h"
#import "ICETutorialPage.h"
#import "ICETutorialStyle.h"
#import "ViewController.h"

@import GoogleMobileAds ;


@interface ExplainViewController ()

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation ExplainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createAndLoadInterstitial];

    
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

-(void)viewWillAppear:(BOOL)animated{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithTitle:@"praintへようこそ！"
                                                            subTitle:@"これから操作説明を行います"
                                                         pictureName:@"説明0.png"
                                                            duration:3.0];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithTitle:@"1.ペンと消しゴム"
                                                            subTitle:@"ペン・消しゴムボタンではペンと消しゴムを切り替えられます"
                                                         pictureName:@"説明1.png"
                                                            duration:3.0];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithTitle:@"2.全消し"
                                                            subTitle:@"ゴミ箱のボタンでは今まで自分が描いていた全てを削除します"
                                                         pictureName:@"説明2.png"
                                                            duration:3.0];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithTitle:@"3.背景画像の変更"
                                                            subTitle:@"写真のボタンでは自分の描きたい画像を変更できます"
                                                         pictureName:@"説明3.png"
                                                            duration:3.0];
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithTitle:@"4.シェア"
                                                            subTitle:@"共有ボタンでは自分の描いた絵を保存したり、twitterやlineなどで自慢できます"
                                                         pictureName:@"説明5.png"
                                                            duration:3.0];
    ICETutorialPage *layer6 = [[ICETutorialPage alloc] initWithTitle:@"5.設定"
                                                            subTitle:@"パレットボタンでは、ペンの太さや色などを自分好みに設定できます"
                                                         pictureName:@"説明4.png"
                                                            duration:3.0];
    ICETutorialPage *layer7 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@"それでは、お絵描きを楽しんでください！"
                                                         pictureName:@"説明0.png"
                                                            duration:3.0];
    ICETutorialPage *layer8 = [[ICETutorialPage alloc] initWithTitle:@""
                                                            subTitle:@""
                                                         pictureName:@"板目２（元）.png"
                                                            duration:3.0];
    
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5,layer6,layer7,layer8];
    
    // Set the common style for the title.
    ICETutorialLabelStyle *titleStyle = [[ICETutorialLabelStyle alloc] init];
    [titleStyle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    [titleStyle setTextColor:[UIColor whiteColor]];
    [titleStyle setLinesNumber:1];
    [titleStyle setOffset:180];
    [[ICETutorialStyle sharedInstance] setTitleStyle:titleStyle];
    
    // Set the subTitles style with few properties and let the others by default.
    [[ICETutorialStyle sharedInstance] setSubTitleColor:[UIColor whiteColor]];
    [[ICETutorialStyle sharedInstance] setSubTitleOffset:150];
    
    // Init tutorial.
    self.TutorialViewController = [[ICETutorialController alloc] initWithPages:tutorialLayers
                                                                      delegate:self];
    
    // Run it.
    [self.TutorialViewController startScrolling];
    
    self.window.rootViewController = self.TutorialViewController;
    [self.window makeKeyAndVisible];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ICETutorialController delegate
- (void)tutorialController:(ICETutorialController *)tutorialController scrollingFromPageIndex:(NSUInteger)fromIndex toPageIndex:(NSUInteger)toIndex {
    NSLog(@"Scrolling from page %lu to page %lu.", (unsigned long)fromIndex, (unsigned long)toIndex);
    
}

- (void)tutorialControllerDidReachLastPage:(ICETutorialController *)tutorialController {
    NSLog(@"Tutorial reached the last page.");
        [self.TutorialViewController stopScrolling];

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil] ;
    //    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil] ;
    
    [self.interstitial presentFromRootViewController:self.presentingViewController];

    
    
    //    [self.interstitial presentFromRootViewController:self];
    
    
    
}

//- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnLeftButton:(UIButton *)sender {
//    NSLog(@"Button 1 pressed.");
//
//}
//
//- (void)tutorialController:(ICETutorialController *)tutorialController didClickOnRightButton:(UIButton *)sender {
//    NSLog(@"Button 2 pressed.");
//    NSLog(@"Auto-scrolling stopped.");
//
//    [self.TutorialViewController stopScrolling];
//}



@end
