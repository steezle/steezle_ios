//
//  measurementsVC.h
//  Steezle
//
//  Created by webmachanics on 08/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APTextField.h"
//#import <CZPicker.h>


@interface measurementsVC : UIViewController

@property (weak, nonatomic) IBOutlet APTextField *shoulderTXT;
@property (weak, nonatomic) IBOutlet APTextField *chestTXT;
@property (weak, nonatomic) IBOutlet APTextField *waistTXT;
@property (weak, nonatomic) IBOutlet APTextField *InseamTXT;
@property (weak, nonatomic) IBOutlet APTextField *NeckTXT;
@property (weak, nonatomic) IBOutlet APTextField *ArmTXT;

- (IBAction)ActSaveCont:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SaveCont;
- (IBAction)ActSaveLeter:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *saveLaterBTN;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *WW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *laterH;

@end
