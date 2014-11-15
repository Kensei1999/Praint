//
//  SettingViewController.h
//  practice_painting
//
//  Created by 石井　建世 on 2014/05/04.
//  Copyright (c) 2014年 石井　建世. All rights reserved.
//

float redlineNumber ;  //線の赤
float greenlineNumber ;//線の緑
float bluelineNumber ; //線の青

float futosaNumber ;   //太さの値
float opacityNumber ; //透明度の値

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController{
    
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

@property (weak, nonatomic) IBOutlet UIImageView *brushPreview;

-(IBAction)back ;

@end
