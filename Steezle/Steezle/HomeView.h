//
//  HomeView.h
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeView : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *startBrowsingBTN;

- (IBAction)emailBtnClick:(id)sender;

- (IBAction)ActionFacebook:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *facebookBTN;
- (IBAction)Act_SignUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
- (IBAction)Act_signIn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *signIn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logowidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logotextHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signINHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signUPHeight;
- (IBAction)Act_skip:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SkipBTN;


@end
