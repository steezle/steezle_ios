//
//  ProductImageCell.h
//  Steezle
//
//  Created by Ryan Smith on 2018-05-24.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *ImagesScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControlForImages;


@end
