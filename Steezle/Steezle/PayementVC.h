//
//  PayementVC.h
//  Steezle
//
//  Created by webmachanics on 14/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APTextField.h"
@interface PayementVC : UIViewController
- (IBAction)ActBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)ActionCheckMark:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *CheckMarkBTN;
@property (weak, nonatomic) IBOutlet UIButton *PayNowBTN;
- (IBAction)ActPayNow:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *PayementView;
@property (weak, nonatomic) IBOutlet UIView *PayCreaditView;
@property (weak, nonatomic) IBOutlet UIView *PayInteracView;

@property (weak, nonatomic) IBOutlet APTextField *emailTF;

@property (weak, nonatomic) IBOutlet APTextField *CardNameTF;
@property (weak, nonatomic) IBOutlet UIImageView *cardTypeImage;
@property (weak, nonatomic) IBOutlet APTextField *CardNumberTF;
@property (weak, nonatomic) IBOutlet APTextField *ExpMTF;
@property (weak, nonatomic) IBOutlet APTextField *ExpYTF;
@property (weak, nonatomic) IBOutlet UILabel *ceditLbl;
@property (weak, nonatomic) IBOutlet UILabel *InteracLbl;
@property (weak, nonatomic) IBOutlet APTextField *CVVTF;

@property (weak, nonatomic) IBOutlet UIView *popupmainview;
@property (weak, nonatomic) IBOutlet UIView *popupsubview;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *marchndLBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingLBL;
@property (weak, nonatomic) IBOutlet UILabel *TaxLBL;
@property (weak, nonatomic) IBOutlet UILabel *TotalLBL;
@property (weak, nonatomic) IBOutlet UILabel *iteamLBL;
//float total_p=[total_price_str floatValue];
//_lbl_totalOrderPrice.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_p]];
@property (nonatomic, retain) NSMutableArray *SaveCardWithPayDetArr;

@property (weak, nonatomic) IBOutlet UIImageView *payImage;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLBL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payment_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *email_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *card_na_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *card_bo_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cvv_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *check_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yy_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *details_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pay_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *save_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pay_y;
@property (nonatomic, assign) BOOL FromApply;
//- (IBAction)Act_MM:(id)sender;
//- (IBAction)Act_YY:(id)sender;

//@property (weak, nonatomic) IBOutlet UIButton *MMButton;
//@property (weak, nonatomic) IBOutlet UIButton *YYButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TOP_H;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UILabel *CouponValue;
@property (weak, nonatomic) IBOutlet UIImageView *NC_image;
@property (weak, nonatomic) IBOutlet UIImageView *errorImage;

@end

