//
//  LoginVC.h
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRFloatTextField.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet DRFloatTextField *email;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet DRFloatTextField *password;


@property (weak, nonatomic) IBOutlet UIView *scrollSubView;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction)forgotPasswordBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)Act_google:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *googleBTN;
- (IBAction)Act_facebook:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *facebookBTN;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logo_h;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logo_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passBTNH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signINH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GFH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoY;
- (IBAction)Act_skip:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SkipBTN;
@end
