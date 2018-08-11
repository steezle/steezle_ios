//
//  newCardVC.h
//  Steezle
//
//  Created by webmachanics on 10/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APTextField.h"
@interface newCardVC : UIViewController<UITextFieldDelegate>
- (IBAction)ActionBack:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet APTextField *CardNameTF;
@property (weak, nonatomic) IBOutlet UIImageView *cardTypeImage;
@property (weak, nonatomic) IBOutlet APTextField *CardNumberTF;
@property (weak, nonatomic) IBOutlet APTextField *ExpMTF;
@property (weak, nonatomic) IBOutlet APTextField *ExpYearTF;
- (IBAction)ActionSaveCard:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveBTN;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TOP_H;
@property (weak, nonatomic) IBOutlet APTextField *cvvTXT;


@end
