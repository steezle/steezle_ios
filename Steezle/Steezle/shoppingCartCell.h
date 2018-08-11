//
//  shoppingCartCell.h
//  Steezle
//
//  Created by webmachanics on 23/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shoppingCartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_tshart;
@property (weak, nonatomic) IBOutlet UILabel *lbl_toro;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sizevalue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_colorValue;

@property (weak, nonatomic) IBOutlet UISwitch *product_Switch;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;

- (IBAction)ActionPlus:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *PlusBTN;
- (IBAction)ActionSub:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *SubBTN;
@property (weak, nonatomic) IBOutlet UILabel *LblCount;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *dotLBL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorWidthLayout;
@end
