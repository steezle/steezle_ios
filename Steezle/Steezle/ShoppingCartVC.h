//
//  ShoppingCartVC.h
//  Steezle
//
//  Created by sanjay on 01/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartVC : UIViewController
- (IBAction)backBtnClick:(id)sender;
- (IBAction)cardBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_marchandiseValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_totalOrderPrice;
- (IBAction)bagAction:(id)sender;
@property (strong,nonatomic) NSMutableArray *glableArray;

@property (weak, nonatomic) IBOutlet UIButton *payNowBTN;
@property (weak, nonatomic) IBOutlet UILabel *itemLbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl_tax;
- (IBAction)checkoutAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lbl_shopping;
@property (weak, nonatomic) IBOutlet UIView *TotalView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *_btn_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalview_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *total_p_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *total_L_h;
@property (weak, nonatomic) IBOutlet UILabel *total_lbl_order;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *both_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TOP_H;
//@property (weak, nonatomic) IBOutlet UIView *empty_view;
- (IBAction)Action_emptyShop:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *shop_now_view;

@property (weak, nonatomic) IBOutlet UIImageView *errorImage;

@end
