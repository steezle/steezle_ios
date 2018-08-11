//
//  CardSaveVC.h
//  Steezle
//
//  Created by Aecor Digital on 15/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardSaveVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *FullNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberTxtField;
@property (weak, nonatomic) IBOutlet UITextField *ExpiryDateTxtField;
@property (weak, nonatomic) IBOutlet UITextField *CVCTxtField;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *scrollSubView;
- (IBAction)signUpBtnClick:(id)sender;
- (IBAction)BackBTNAction:(id)sender;


@end
