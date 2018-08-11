//
//  HomePageVC.h
//  Steezle
//
//  Created by Aecor Digital on 01/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageVC : UIViewController<UIPageViewControllerDataSource>{
    
}
@property (nonatomic,strong) NSArray *viewControllersArray;
@property (nonatomic,strong) UIPageViewController *PageViewController;

@end
