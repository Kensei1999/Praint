//
//  colorViewController.m
//  practice_painting
//
//  Created by 石井　建世 on 2014/05/06.
//  Copyright (c) 2014年 石井　建世. All rights reserved.
//

#import "colorViewController.h"
#import "SettingViewController.h"

@interface colorViewController ()

@end

@implementation colorViewController

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

-(IBAction)back {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil] ;
    //↑この数だけ戻る
    
}

@end
