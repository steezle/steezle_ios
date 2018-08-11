//
//  SearchViewController.m
//  DesignBook
//
//  Created by 陈行 on 16-1-9.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomSearchView.h"

@interface SearchViewController ()<CustomSearchViewDelegate>



@end

@implementation SearchViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    CustomSearchView * searchView=[[CustomSearchView alloc]initWithFrame:self.view.bounds];
    searchView.delegate=self;
    [self.view addSubview:searchView];
    
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //Check which iPhone it is
    double screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        NSLog(@"All iPads");
    } else if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
    {
        if(screenHeight == 480)
        {
            NSLog(@"iPhone 4/4S");
            // smallFonts = true;
        } else if (screenHeight == 568)
        {
            
        } else if (screenHeight == 667)
        {
            NSLog(@"iPhone 6/6S");
        }
        else if (screenHeight == 736)
        {
            NSLog(@"iPhone 6+, 6S+");
        }
        else if (screenHeight == 812)
        {
            if (@available(iOS 11, *))
            {
                UIView *parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
                parentView.backgroundColor=[UIColor whiteColor];
                [self.view addSubview:parentView];
                _Top_h.constant=40;
                
                
            } else {
                
            }
        }
        else
        {
            NSLog(@"Others");
        }
    }
}
- (void)customSearchBar:(CustomSearchView *)searchView andCancleBtn:(UIButton *)cancleBtn{
    if([self.delegate respondsToSelector:@selector(searchViewControllerCancleButtonClicked:)]){
        [self.delegate searchViewControllerCancleButtonClicked:self];
    }
}

- (void)customSearchBar:(CustomSearchView *)searchView andSearchValue:(NSString *)searchValue{
    if([self.delegate respondsToSelector:@selector(searchViewControllerSearchButtonClicked:andSearchValue:)]){
        [self.delegate searchViewControllerSearchButtonClicked:self andSearchValue:searchValue];
    }
}


#pragma mark - 系统协议方法
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=YES;
}

@end
