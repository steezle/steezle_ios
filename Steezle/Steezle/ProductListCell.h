//
//  ProductListCell.h
//  Steezle
//
//  Created by webmachanics on 23/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_tshart;
@property (weak, nonatomic) IBOutlet UILabel *lbl_toro;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sizevalue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_colorValue;

@property (weak, nonatomic) IBOutlet UISwitch *product_Switch;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;
- (IBAction)ActAddToBag:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *AddToBagBTN;
@property (weak, nonatomic) IBOutlet UIButton *ActDelete;
@property (weak, nonatomic) IBOutlet UIButton *DeleteBTN;

@end
