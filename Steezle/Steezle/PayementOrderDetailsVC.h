//
//  PayementOrderDetailsVC.h
//  Steezle
//
//  Created by webmachanics on 14/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayementOrderDetailsVC : UIViewController
- (IBAction)ActBack:(id)sender;

- (IBAction)ActionProcess:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ProcessBTN;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak , nonatomic)NSString *Order_Id;

@property (weak, nonatomic) IBOutlet UILabel *Order_idLBL;
@property (weak, nonatomic) IBOutlet UILabel *PlacedDateLBL;
@property (weak, nonatomic) IBOutlet UILabel *AddressLBL;

@property (weak, nonatomic) IBOutlet UILabel *PaymentTypeLBL;
@property (weak, nonatomic) IBOutlet UILabel *MarchandiseLBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingLBL;
@property (weak, nonatomic) IBOutlet UILabel *TexLBL;
@property (weak, nonatomic) IBOutlet UILabel *TotalOrderLBL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TOP_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHightLayout;
@property (weak, nonatomic) IBOutlet UILabel *discountLBl;
@property (weak, nonatomic) IBOutlet UILabel *disValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountView;

@property (weak, nonatomic) IBOutlet UIView *dicView;
@property (weak, nonatomic) IBOutlet UILabel *DiscountLBL;
@property (weak, nonatomic) IBOutlet UILabel *CouponCodeLBL;
@property (weak, nonatomic) IBOutlet UILabel *lineLBL;
@property (weak, nonatomic) IBOutlet UIImageView *errorImage;

@end
