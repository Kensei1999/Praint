//
//  ExplainViewController.h
//  practice_painting
//
//  Created by 石井　建世 on 2014/05/05.
//  Copyright (c) 2014年 石井　建世. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICETutorialController.h"

@interface ExplainViewController : UIViewController<ICETutorialControllerDelegate>{
    
}


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet ICETutorialController *TutorialViewController;

@end
