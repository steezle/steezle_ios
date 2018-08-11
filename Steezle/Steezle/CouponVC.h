//
//  CouponVC.h
//  Steezle
//
//  Created by Ryan Smith on 2018-01-27.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APTextField.h"
@protocol CouponCodeDelegate <NSObject>

@required
- (void)dataFromCoupon:(NSMutableArray *)data;
@end

@interface CouponVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backAct;
@property (nonatomic, weak) id<CouponCodeDelegate> delegate;
- (IBAction)Act_Back:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet APTextField *CouponCodeTF;
- (IBAction)Act_Apply:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Top_h;

@end
