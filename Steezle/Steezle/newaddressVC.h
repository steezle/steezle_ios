//
//  newaddressVC.h
//  Steezle
//
//  Created by webmachanics on 10/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APTextField.h"
#import <CZPicker.h>

@interface newaddressVC : UIViewController<CZPickerViewDataSource,CZPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)ActBack:(id)sender;
@property (weak, nonatomic) IBOutlet APTextField *BNameTF;
@property (weak, nonatomic) IBOutlet APTextField *Baddress1TF;

@property (weak, nonatomic) IBOutlet APTextField *Baddress2;
@property (weak, nonatomic) IBOutlet APTextField *BphoneTF;
@property (weak, nonatomic) IBOutlet APTextField *BcountryTF;
@property (weak, nonatomic) IBOutlet APTextField *BstateTF;
@property (weak, nonatomic) IBOutlet APTextField *BcityTF;
@property (weak, nonatomic) IBOutlet APTextField *BpostTF;
- (IBAction)BcountryAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BcountryBTN;
- (IBAction)BStateAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BStateBTN;

@property (weak, nonatomic) IBOutlet APTextField *SnameTF;
@property (weak, nonatomic) IBOutlet APTextField *Saddress1;
@property (weak, nonatomic) IBOutlet APTextField *SAddress2;
@property (weak, nonatomic) IBOutlet APTextField *ScountryTF;
@property (weak, nonatomic) IBOutlet APTextField *SstateTF;

- (IBAction)SStateAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SStateBTN;
- (IBAction)SCountryAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ScountryBTN;
@property (weak, nonatomic) IBOutlet APTextField *SCityTF;
@property (weak, nonatomic) IBOutlet APTextField *SPostTF;
- (IBAction)ActionSaveAddress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SaveBTN;
@property (weak, nonatomic) IBOutlet UISwitch *switchbtn;
@property (nonatomic, retain) NSMutableArray *ArrayPassdetails;
@property (weak, nonatomic) IBOutlet UILabel *TitleLBL;
@property (nonatomic, assign) BOOL FromPaymentPage;
- (IBAction)ActEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BTNEdit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TOP_H;


@end
