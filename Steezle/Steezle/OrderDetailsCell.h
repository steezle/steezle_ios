//
//  OrderDetailsCell.h
//  Steezle
//
//  Created by webmachanics on 14/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ProduImage;
@property (weak, nonatomic) IBOutlet UILabel *NameLBL;
@property (weak, nonatomic) IBOutlet UILabel *BrandNameLBL;
@property (weak, nonatomic) IBOutlet UILabel *ColorLBL;
@property (weak, nonatomic) IBOutlet UILabel *SizeLBL;
@property (weak, nonatomic) IBOutlet UILabel *PriceLBL;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UILabel *dotLBL;
@property (weak, nonatomic) IBOutlet UILabel *qtyLBL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorWidthLayout;

@end
