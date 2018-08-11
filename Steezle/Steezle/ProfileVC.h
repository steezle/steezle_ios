//
//  ProfileVC.h
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APTextField.h"
//#import <CZPicker.h>
@interface ProfileVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate>

//,CZPickerViewDataSource,CZPickerViewDelegate
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIView *profileView;
- (IBAction)ActionUpdate:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *updateBTN;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (nonatomic, assign) BOOL fromProduct;
@property (weak, nonatomic) IBOutlet APTextField *FullNameTF;

//new
@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UIView *profilrView;
@property (weak, nonatomic) IBOutlet UIView *MeasurementView;
@property (weak, nonatomic) IBOutlet UIView *AddressView;
@property (weak, nonatomic) IBOutlet UIView *PaymentView;
@property (weak, nonatomic) IBOutlet UILabel *profilrLbl;
@property (weak, nonatomic) IBOutlet UILabel *measurementLbl;
@property (weak, nonatomic) IBOutlet UILabel *AddressLbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentLbl;

@property (weak, nonatomic) IBOutlet UIView *genderView;
@property (weak, nonatomic) IBOutlet UIView *maleView;
@property (weak, nonatomic) IBOutlet UIView *FemaleView;
@property (weak, nonatomic) IBOutlet UIView *UnisexView;
@property (weak, nonatomic) IBOutlet UIImageView *Mimage;
@property (weak, nonatomic) IBOutlet UILabel *mlbl;
@property (weak, nonatomic) IBOutlet UIImageView *Fimage;
@property (weak, nonatomic) IBOutlet UILabel *flbl;
@property (weak, nonatomic) IBOutlet UIImageView *Uimage;
@property (weak, nonatomic) IBOutlet UILabel *ulbl;
- (IBAction)ActLOGOUT:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutBTN;
@property (weak, nonatomic) IBOutlet APTextField *NameTF;
@property (weak, nonatomic) IBOutlet APTextField *passwordTF;

//measurement
@property (weak, nonatomic) IBOutlet UIView *pageMeasurementView;
@property (weak, nonatomic) IBOutlet UIScrollView *MeasurementScrollView;
- (IBAction)Save:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *measSaveBTN;
@property (weak, nonatomic) IBOutlet APTextField *MShoulderTF;
@property (weak, nonatomic) IBOutlet APTextField *MchestTF;
@property (weak, nonatomic) IBOutlet APTextField *MwaistTF;
@property (weak, nonatomic) IBOutlet APTextField *MinseamTF;
@property (weak, nonatomic) IBOutlet APTextField *MnectTF;
@property (weak, nonatomic) IBOutlet APTextField *MArmTF;

//Address
@property (weak, nonatomic) IBOutlet UIView *PageAddressView;
- (IBAction)ActionAddressADD:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ADDaddressBTN;



//Payement
@property (weak, nonatomic) IBOutlet UIView *PagePayementView;
- (IBAction)ActionAddCard:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *AddCardBTN;

- (IBAction)Action_Shoulder:(id)sender;
- (IBAction)Action_Chest:(id)sender;
- (IBAction)Action_Waist:(id)sender;
- (IBAction)Action_Inseam:(id)sender;
- (IBAction)Action_Neck:(id)sender;
- (IBAction)Action_Arm:(id)sender;


//measurment
@property (weak, nonatomic) IBOutlet UIView *Mea_genderView;
@property (weak, nonatomic) IBOutlet UIView *Mea_MaleView;
@property (weak, nonatomic) IBOutlet UIView *Mea_FemaleView;
@property (weak, nonatomic) IBOutlet UIView *Mea_UnisexView;
@property (weak, nonatomic) IBOutlet UIImageView *Mea_Mimage;
@property (weak, nonatomic) IBOutlet UILabel *Mea_MaleLBL;
@property (weak, nonatomic) IBOutlet UIImageView *Mea_FemaleImage;
@property (weak, nonatomic) IBOutlet UILabel *Mea_FemaleLBL;
@property (weak, nonatomic) IBOutlet UIImageView *Mea_UnisexImage;
@property (weak, nonatomic) IBOutlet UILabel *Mea_UnisexLBL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *name_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Pass_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *update_h;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logout_h;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *genderViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *femalewidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *UH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *UW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Setting_h;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *p_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *a_h;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addcard_h;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *card_image_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *card_image_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *add_image_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *add_image_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *address_btn_h;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Mes_gen_View_h;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Mes_f_W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *save_masur_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MUH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MUW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MFH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MFW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MMH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MMW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TOP_H;



@property (weak, nonatomic) IBOutlet UIView *add_empty_pageview;

@property (weak, nonatomic) IBOutlet UITableView *cardTableveiw;
@property (weak, nonatomic) IBOutlet UIView *empty_paymentView;
- (IBAction)ActAddCard:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addCardBtn;
- (IBAction)ActNewSetting:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *addNewView;
@property (weak, nonatomic) IBOutlet UIView *shopping_addView;
@property (weak, nonatomic) IBOutlet UITextView *lbl_Address;
@property (weak, nonatomic) IBOutlet UIView *billingView_new;
@property (weak, nonatomic) IBOutlet UITextView *Billing_TV;
@property (weak, nonatomic) IBOutlet UILabel *emailBillingLBL;
@property (weak, nonatomic) IBOutlet UILabel *phoneBillingLbl;

@property (weak, nonatomic) IBOutlet UIImageView *errorImage;


@end
