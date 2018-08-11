//
//  HomeTabBar.m
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "HomeTabBar.h"

@interface HomeTabBar ()

@end

@implementation HomeTabBar

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setAlpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
