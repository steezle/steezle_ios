//
//  ForgotPasswordVC.h
//  ESR
//
//  Created by Aecor Digital on 22/06/17.
//  Copyright © 2017 Aecor Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRFloatTextField.h"


@interface ForgotPasswordVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *tap;
    UITapGestureRecognizer *tap1;
}
- (IBAction)ActBack:(id)sender;

@property (weak, nonatomic) IBOutlet DRFloatTextField *emailTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)ActSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitBTN;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logo_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logo_w;

@end
