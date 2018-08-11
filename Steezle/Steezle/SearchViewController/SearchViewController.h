//
//  SearchViewController.h
//  DesignBook
//
//  Created by 陈行 on 16-1-9.
//  Copyright (c) 2016年 陈行. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchViewController;

@protocol SearchViewControllerDelegate <NSObject>

@optional
- (void)searchViewControllerSearchButtonClicked:(SearchViewController *)controller andSearchValue:(NSString *)searchValue;

@optional
- (void)searchViewControllerCancleButtonClicked:(SearchViewController *)controller;

@end

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top_h;
@property (nonatomic , weak)id<SearchViewControllerDelegate> delegate;

@end
