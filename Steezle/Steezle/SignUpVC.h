//
//  SignUpVC.h
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRFloatTextField.h"

@interface SignUpVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet DRFloatTextField *emailTxtField;
@property (weak, nonatomic) IBOutlet DRFloatTextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet DRFloatTextField *confirmTxtField;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
//@property (weak, nonatomic) IBOutlet UIView *scrollSubView;
- (IBAction)signUpBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *genderView;
- (IBAction)Act_back:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *g_male;
@property (weak, nonatomic) IBOutlet UIView *g_female;
@property (weak, nonatomic) IBOutlet UIView *g_unisex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loho_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logo_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conPassHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUPHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *genderViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *femalewidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *UH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *UW;

@end
