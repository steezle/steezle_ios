//
//  ProfileVC.m
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.

#import "ProfileVC.h"
#import <QuartzCore/QuartzCore.h>
#import "userdefaultArrayCall.h"
#import "SVProgressHUD.h"
#import "Utils.h"
#import "Globals.h"
#import "AFNetworking.h"
//#import "AFHTTPRequestOperation.h"
//#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "newCardVC.h"
#import "newaddressVC.h"
#import <Google/SignIn.h>
#import "HomeView.h"
#import "SCardCell.h"
#import "Setting&privacyVC.h"
#import "LoginVC.h"
#define FONTNAME_REG   @"HelveticaNeue"
#define LFONT_10         [UIFont fontWithName:FONTNAME_REG size:13]

#define MAX_LENGTH 5

@interface ProfileVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *gender;
    NSString *mea_gender;
    UITextField *activeField;
    BOOL keyboardVisible;
    CGPoint offset;
    NSMutableArray *addressArray,*cardSaveArray;
    NSInteger index;
    NSMutableDictionary *DicMeasurement;
    //    NSMutableArray *ArrShoulder,*ArrChest,*ArrWaist,*ArrInseam,*ArrNeck,*ArrArm;
    //    NSString *Str_shoulder,*Str_Chest,*Str_Waist,*Str_Inseam,*Str_Neck,*Str_Arm;
    
    UIButton *_acceptButton;
    UIScrollView *_scrollView1;
    UIView *_baseView;
    UIImageView *_stencilView;
    UIImageView *_imageView;
    UIView *_specialEffectsView;
    UILabel *_infoLabel;
    UIView *topview;
    NSString *addressSave,*billingSaveadd;
    
}
@end

@implementation ProfileVC
@synthesize errorImage;
-(UIView *)PaddingView
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //Check which iPhone it is
    double screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        NSLog(@"All iPads");
    } else if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
    {
        if(screenHeight == 480)
        {
            NSLog(@"iPhone 4/4S");
            // smallFonts = true;
        } else if (screenHeight == 568)
        {
            NSLog(@"iPhone 5/5S/SE");
            _genderViewHeight.constant=40;
            _femalewidth.constant=(_genderView.frame.size.width/3)-2;
            _MH.constant=30;
            _MW.constant=20;
            _FH.constant=30;
            _FW.constant=20;
            _UH.constant=30;
            _UW.constant=20;
            
            _name_H.constant=40;
            _Pass_H.constant=40;
            _update_h.constant=40;
            _logout_h.constant=40;
            
            _Setting_h.constant=40;
            //          _Measur_h.constant=(_settingView.frame.size.width/4)-2;
            //          _address_h.constant=35;
            
            _addcard_h.constant=40;
            _card_image_h.constant=50;
            _card_image_w.constant=60;
            _add_image_h.constant=60;
            _add_image_w.constant=59;
            _address_btn_h.constant=40;
            
            _Mes_gen_View_h.constant=30;
            _Mes_f_W.constant=(_Mea_genderView.frame.size.width/3)-2;
            _save_masur_h.constant=40;
            _MUH.constant=20;
            _MUW.constant=20;
            _MFH.constant=20;
            _MFW.constant=20;
            _MMH.constant=20;
            _MMW.constant=20;
            _a_h.constant=(_settingView.frame.size.width/3)+1;
            _p_h.constant=2*(_settingView.frame.size.width/3);
            _profilrLbl.font=LFONT_10;
            _measurementLbl.font=LFONT_10;
            _AddressLbl.font=LFONT_10;
            _paymentLbl.font=LFONT_10;
            _lbl_Address.font=LFONT_10;
            _emailBillingLBL.font=LFONT_10;
            _phoneBillingLbl.font=LFONT_10;
            _lbl_Address.font=LFONT_10;
            _Billing_TV.font=LFONT_10;
            
        } else if (screenHeight == 667)
        {
            NSLog(@"iPhone 6/6S");
        }
        else if (screenHeight == 736)
        {
            NSLog(@"iPhone 6+, 6S+");
        }
        else if (screenHeight == 812)
        {
            if (@available(iOS 11, *))
            {
                UIView *parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
                parentView.backgroundColor=[UIColor whiteColor];
                [self.view addSubview:parentView];
                _TOP_H.constant=40;
                
            }
            else
            {
                
            }
        }
        else
        {
            NSLog(@"Others");
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    
    [super viewWillAppear:animated];
    self.errorImage.alpha=0;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionEditBTN:)];
    tapGesture1.cancelsTouchesInView = NO;
    [_profileImage addGestureRecognizer:tapGesture1];
    
    BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
    if (!skipUser)
    {
        [self fillDetailsInPage];
        //[self pageviewProfile];
        [self ActionProfile];
        [self Get_address_ApiMethod];
    }
    else
    {
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
                                                                      message:@"Sign in or Sign Up to go to Profile Page"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Continue"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                        LoginVC *home = (LoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                                        [self.navigationController pushViewController:home animated:YES];
                                    }];
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Not now"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
//        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Not now"
//                                                           style:UIAlertActionStyleDefault
//                                                         handler:^(UIAlertAction * action)
//                                   {
//
//                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.shopping_addView.layer.cornerRadius = 5;
    self.shopping_addView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.shopping_addView.layer.shadowOffset = CGSizeMake(0.5, 4.0); //Here your control your spread
    self.shopping_addView.layer.shadowOpacity = 0.5;
    self.shopping_addView.layer.shadowRadius = 5.0;
    
    self.billingView_new.layer.cornerRadius = 5;
    self.billingView_new.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.billingView_new.layer.shadowOffset = CGSizeMake(0.5, 4.0); //Here your control your spread
    self.billingView_new.layer.shadowOpacity = 0.5;
    self.billingView_new.layer.shadowRadius = 5.0;
    
    self.addNewView.alpha=0;
    //    self.add_empty_pageview.alpha=0;
    self.cardTableveiw.delegate=self;
    self.cardTableveiw.dataSource=self;
    self.cardTableveiw.alpha=0;
    self.empty_paymentView.alpha=0;
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:SocialType] isEqualToString:@"SYSTEM"])
    {
        _passwordTF.userInteractionEnabled=YES;
    }
    else
    {
        _passwordTF.userInteractionEnabled=NO;
    }
    
    self.add_empty_pageview.hidden=NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;
    
    [_scrollview addGestureRecognizer:tapGesture];
    
    
    UITapGestureRecognizer *tapGesturemeasu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesturemeasu.cancelsTouchesInView = NO;
    
    [_MeasurementScrollView addGestureRecognizer:tapGesturemeasu];
    
    self.pageMeasurementView.hidden=YES;
    self.PageAddressView.hidden=YES;
    self.PagePayementView.hidden=YES;
    self.NameTF.delegate=self;
    self.passwordTF.delegate=self;
    
    [self delegateWithInitialDetailsInTxtLbl];
    [self initailViewDesign];
    [self settingUpTextField];
    [self imageload];
    
    UITapGestureRecognizer *tapaddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newaddressMethod)];
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapaddress.cancelsTouchesInView = NO;
    
    [_addNewView addGestureRecognizer:tapaddress];
    
    //    ArrShoulder=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    //    ArrChest=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    //    ArrWaist=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    //    ArrInseam=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    //    ArrNeck=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    //    ArrArm=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    switch(textField.tag)
    {
        case 3:
            if(![self ValidationOntextField:textField andRamge:range replacementString:string])
            {
                //                NSString* newText;
                //
                //                newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
                //
                //                return [newText intValue] < 1000;
                return NO;
            }
            if (textField.text.length >= MAX_LENGTH && range.length == 0)
            {
                return NO;
            }
            
            break;
        case 4:
            if(![self ValidationOntextField:textField andRamge:range replacementString:string])
            {
                return NO;
            }
            if (textField.text.length >= MAX_LENGTH && range.length == 0)
            {
                return NO;
            }
            
            break;
        case 5:
            if(![self ValidationOntextField:textField andRamge:range replacementString:string])
            {
                return NO;
            }
            if (textField.text.length >= MAX_LENGTH && range.length == 0)
            {
                return NO;
            }
            
            break;
        case 6:
            if(![self ValidationOntextField:textField andRamge:range replacementString:string])
            {
                return NO;
            }
            if (textField.text.length >= MAX_LENGTH && range.length == 0)
            {
                return NO;
            }
            
            
            break;
        case 7:
            if(![self ValidationOntextField:textField andRamge:range replacementString:string])
            {
                return NO;
            }
            if (textField.text.length >= MAX_LENGTH && range.length == 0)
            {
                return NO;
            }
            
            break;
        case 8:
            if(![self ValidationOntextField:textField andRamge:range replacementString:string])
            {
                return NO;
            }
            if (textField.text.length >= MAX_LENGTH && range.length == 0)
            {
                return NO;
            }
            
            break;
    }
    return YES;
}
-(BOOL)ValidationOntextField:(UITextField *)textField andRamge:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                        options:0
                                                          range:NSMakeRange(0, [newString length])];
    if (numberOfMatches == 0)
        return NO;
    else
        return YES;
    
    //    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //    NSArray *sep = [newString componentsSeparatedByString:@"."];
    //    if([sep count] >= 2)
    //    {
    //        NSString *sepStr=[NSString stringWithFormat:@"%@",[sep objectAtIndex:1]];
    //        if (!([sepStr length]>2))
    //        {
    //            if ([sepStr length]==2 && [string isEqualToString:@"."])
    //            {
    //                return NO;
    //            }
    //            return YES;
    //        }
    //        else{
    //            return NO;
    //        }
    //    }
    //    return YES;
}
-(void)pageviewProfile
{
    //    self.tableview.hidden=YES;
    self.scrollview.scrollEnabled = YES;
    self.pageMeasurementView.hidden=YES;
    self.PageAddressView.hidden=YES;
    self.PagePayementView.hidden=YES;
}

-(void)pageviewMeasurement
{
    //    self.tableview.hidden=YES;
    //    self.add_empty_pageview.hidden=YES;
    [activeField resignFirstResponder];
    self.scrollview.scrollEnabled = NO;
    self.pageMeasurementView.hidden=NO;
    self.PageAddressView.hidden=YES;
    self.PagePayementView.hidden=YES;
    [self textfieldinitalValue];
    [self fillDetailsOnMeasurment];
    [self initailForMeasurment];
}

-(void)pageviewAddress
{
    [activeField resignFirstResponder];
    
    if (![addressSave isEqualToString:@""])
    {
        self.addNewView.alpha=1;
        self.add_empty_pageview.hidden=YES;
    }
    else
    {
        self.addNewView.alpha=0;
        self.add_empty_pageview.hidden=NO;
    }
    
    self.scrollview.scrollEnabled = NO;
    self.pageMeasurementView.hidden=YES;
    self.PageAddressView.hidden=NO;
    self.PagePayementView.hidden=YES;
    
}

-(void)pageviewPayement
{
    [activeField resignFirstResponder];
    [self getSaveCardAPI];
    // self.tableview.hidden=YES;
    // self.add_empty_pageview.hidden=YES;
    
    self.scrollview.scrollEnabled = NO;
    self.pageMeasurementView.hidden=YES;
    self.PageAddressView.hidden=YES;
    self.PagePayementView.hidden=NO;
}
-(void)textfieldinitalValue
{
    self.MShoulderTF.delegate=self;
    self.MchestTF.delegate=self;
    self.MArmTF.delegate=self;
    self.MnectTF.delegate=self;
    self.MwaistTF.delegate=self;
    self.MinseamTF.delegate=self;
    
    self.MShoulderTF.enableMaterialPlaceHolder = YES;
    self.MShoulderTF.placeholder = @"Shoulder(cm)";
    self.MShoulderTF.errorColor = [UIColor blackColor];
    self.MShoulderTF.lineColor = [UIColor grayColor];
    self.MShoulderTF.delegate=self;
    self.MShoulderTF.tag=3;
    
    self.MchestTF.enableMaterialPlaceHolder = YES;
    self.MchestTF.placeholder = @"Chest(cm)";
    self.MchestTF.errorColor = [UIColor blackColor];
    self.MchestTF.lineColor = [UIColor grayColor];
    self.MchestTF.delegate=self;
    self.MchestTF.tag=4;
    
    
    
    self.MwaistTF.enableMaterialPlaceHolder = YES;
    self.MwaistTF.placeholder = @"Waist(cm)";
    self.MwaistTF.errorColor = [UIColor blackColor];
    self.MwaistTF.lineColor = [UIColor grayColor];
    self.MwaistTF.delegate=self;
    self.MwaistTF.tag=5;
    
    
    self.MinseamTF.enableMaterialPlaceHolder = YES;
    self.MinseamTF.placeholder = @"Inseam(cm)";
    self.MinseamTF.errorColor = [UIColor blackColor];
    self.MinseamTF.lineColor = [UIColor grayColor];
    self.MinseamTF.delegate=self;
    self.MinseamTF.tag=6;
    
    self.MnectTF.enableMaterialPlaceHolder = YES;
    self.MnectTF.placeholder = @"Neck(cm)";
    self.MnectTF.errorColor = [UIColor blackColor];
    self.MnectTF.lineColor = [UIColor grayColor];
    self.MnectTF.delegate=self;
    self.MnectTF.tag=7;
    
    self.MArmTF.enableMaterialPlaceHolder = YES;
    self.MArmTF.placeholder = @"Arm(cm)";
    self.MArmTF.errorColor = [UIColor blackColor];
    self.MArmTF.lineColor = [UIColor grayColor];
    self.MArmTF.delegate=self;
    self.MArmTF.tag=8;
}
-(void)settingUpTextField
{
    self.NameTF.enableMaterialPlaceHolder = YES;
    self.NameTF.placeholder = @"Email";
    self.NameTF.errorColor = [UIColor blackColor];
    self.NameTF.lineColor = [UIColor grayColor];
    self.NameTF.delegate=self;
    self.NameTF.tag=1;
    
    self.FullNameTF.enableMaterialPlaceHolder = YES;
    self.FullNameTF.placeholder = @"Full Name";
    self.FullNameTF.errorColor = [UIColor blackColor];
    self.FullNameTF.lineColor = [UIColor grayColor];
    self.FullNameTF.delegate=self;
    self.FullNameTF.tag=10;
    
    self.passwordTF.enableMaterialPlaceHolder = YES;
    self.passwordTF.placeholder = @"Password";
    self.passwordTF.errorColor = [UIColor blackColor];
    self.passwordTF.lineColor = [UIColor grayColor];
    self.passwordTF.delegate=self;
    self.passwordTF.tag=2;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [self fillDetailsInPage];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector (keyboardDidShow:)
     name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector (keyboardDidHide:)
     name: UIKeyboardDidHideNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark- keyboard related methods

-(void) keyboardDidShow: (NSNotification *)notif
{
    if (keyboardVisible)
    {
        return;
        
    }
    NSDictionary* info = [notif userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    offset = _scrollview.contentOffset;
    CGRect viewFrame = _scrollview.frame;
    viewFrame.size.height -= keyboardSize.height+10;
    _scrollview.frame = viewFrame;
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 10;
    [_scrollview scrollRectToVisible:textFieldRect animated:YES];
    keyboardVisible = YES;
    
}
-(void) keyboardDidHide: (NSNotification *)notif
{
    // Is the keyboard already shown
    if (!keyboardVisible)
    {
        return;
        
    }
    keyboardVisible = NO;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField

{
    activeField = textField;
    
    return YES;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
// method to hide keyboard when user taps on a scrollview
-(void)hideKeyboard
{
    
    [_scrollview endEditing: YES];
    [_MeasurementScrollView endEditing:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    activeField=textField;
    
    //    if(textField==_NameTF)
    //    {
    //        [_NameTF resignFirstResponder];
    //        [_passwordTF becomeFirstResponder];
    //    }
    if(textField==_passwordTF)
    {
        [_passwordTF resignFirstResponder];
    }
    if(textField==_MShoulderTF)
    {
        [_MShoulderTF resignFirstResponder];
        [_MchestTF becomeFirstResponder];
    }
    if(textField==_MchestTF)
    {
        [_MchestTF resignFirstResponder];
        [_MwaistTF becomeFirstResponder];
    }
    if(textField==_MwaistTF)
    {
        [_MwaistTF resignFirstResponder];
        [_MinseamTF becomeFirstResponder];
    }
    if(textField==_MinseamTF)
    {
        [_MinseamTF resignFirstResponder];
        [_MnectTF becomeFirstResponder];
    }
    if(textField==_MnectTF)
    {
        [_MnectTF resignFirstResponder];
        [_MArmTF becomeFirstResponder];
    }
    if(textField==_MArmTF)
    {
        [_MArmTF resignFirstResponder];
        [self Save:self];
    }
    
    return YES;
}

-(void)initailForMeasurment
{
    _Mea_genderView.layer.borderWidth=1;
    _Mea_genderView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    _Mea_Mimage.image=[UIImage imageNamed:@"s_sel_male"];
    _Mea_FemaleImage.image=[UIImage imageNamed:@"s_unsel_feamle"];
    _Mea_UnisexImage.image=[UIImage imageNamed:@"s_unsel_unisex"];
    
    _Mea_MaleLBL.textColor=[UIColor blackColor];
    _Mea_FemaleLBL.textColor=[UIColor lightGrayColor];
    _Mea_UnisexLBL.textColor=[UIColor lightGrayColor];
    
    
    UITapGestureRecognizer *tapmale = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Action_meaMale)];
    tapmale.cancelsTouchesInView = NO;
    [_Mea_MaleView addGestureRecognizer:tapmale];
    
    UITapGestureRecognizer *tapfemale = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Action_meaFemale)];
    tapfemale.cancelsTouchesInView = NO;
    [_Mea_FemaleView addGestureRecognizer:tapfemale];
    
    UITapGestureRecognizer *tapunisex = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Action_meaUnisex)];
    tapunisex.cancelsTouchesInView = NO;
    [_Mea_UnisexView addGestureRecognizer:tapunisex];
    
}
-(void)initailViewDesign
{
    
    _logoutBTN.layer.borderWidth=1;
    _logoutBTN.layer.borderColor=[UIColor blackColor].CGColor;
    
    _settingView.layer.borderWidth=1;
    _settingView.layer.borderColor=[UIColor blackColor].CGColor;
    
    _genderView.layer.borderWidth=1;
    _genderView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    _profilrView.backgroundColor=[UIColor blackColor];
    _MeasurementView.backgroundColor=[UIColor whiteColor];
    _AddressView.backgroundColor=[UIColor whiteColor];
    _PaymentView.backgroundColor=[UIColor whiteColor];
    
    _profilrLbl.textColor=[UIColor whiteColor];
    _measurementLbl.textColor=[UIColor blackColor];
    _AddressLbl.textColor=[UIColor blackColor];
    _paymentLbl.textColor=[UIColor blackColor];
    
    UITapGestureRecognizer *tapProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionProfile)];
    tapProfile.cancelsTouchesInView = NO;
    [_profilrView addGestureRecognizer:tapProfile];
    
    UITapGestureRecognizer *tapMeasu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionMeasu)];
    tapMeasu.cancelsTouchesInView = NO;
    [_MeasurementView addGestureRecognizer:tapMeasu];
    
    UITapGestureRecognizer *tapAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionAddress)];
    tapAddress.cancelsTouchesInView = NO;
    [_AddressView addGestureRecognizer:tapAddress];
    
    UITapGestureRecognizer *tapPayement = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionPayement)];
    tapPayement.cancelsTouchesInView = NO;
    [_PaymentView addGestureRecognizer:tapPayement];
    
    
    _Mimage.image=[UIImage imageNamed:@"s_sel_male"];
    _Fimage.image=[UIImage imageNamed:@"s_unsel_feamle"];
    _Uimage.image=[UIImage imageNamed:@"s_unsel_unisex"];
    
    _mlbl.textColor=[UIColor blackColor];
    _flbl.textColor=[UIColor lightGrayColor];
    _ulbl.textColor=[UIColor lightGrayColor];
    
    
    UITapGestureRecognizer *tapmale = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionMale)];
    tapmale.cancelsTouchesInView = NO;
    [_maleView addGestureRecognizer:tapmale];
    
    UITapGestureRecognizer *tapfemale = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionFemale)];
    tapfemale.cancelsTouchesInView = NO;
    [_FemaleView addGestureRecognizer:tapfemale];
    
    UITapGestureRecognizer *tapunisex = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionUnisex)];
    tapunisex.cancelsTouchesInView = NO;
    [_UnisexView addGestureRecognizer:tapunisex];
    
    
    
}
-(void)ActionMale
{
    
    _Mimage.image=[UIImage imageNamed:@"s_sel_male"];
    _Fimage.image=[UIImage imageNamed:@"s_unsel_feamle"];
    _Uimage.image=[UIImage imageNamed:@"s_unsel_unisex"];
    
    _mlbl.textColor=[UIColor blackColor];
    _flbl.textColor=[UIColor lightGrayColor];
    _ulbl.textColor=[UIColor lightGrayColor];
    
    gender=@"M";
    NSLog(@"Male");
}
-(void)ActionFemale
{
    _Mimage.image=[UIImage imageNamed:@"s_unsel_male"];
    _Fimage.image=[UIImage imageNamed:@"s_sel_female"];
    _Uimage.image=[UIImage imageNamed:@"s_unsel_unisex"];
    
    _mlbl.textColor=[UIColor lightGrayColor];
    _flbl.textColor=[UIColor blackColor];
    _ulbl.textColor=[UIColor lightGrayColor];
    gender=@"F";
    NSLog(@"Famale");
    
}
-(void)ActionUnisex
{
    
    _Mimage.image=[UIImage imageNamed:@"s_unsel_male"];
    _Fimage.image=[UIImage imageNamed:@"s_unsel_feamle"];
    _Uimage.image=[UIImage imageNamed:@"s_sel_unisex"];
    
    _mlbl.textColor=[UIColor lightGrayColor];
    _flbl.textColor=[UIColor lightGrayColor];
    _ulbl.textColor=[UIColor blackColor];
    gender=@"U";
    NSLog(@"Unisex");
}

-(void)Action_meaMale
{
    
    _Mea_Mimage.image=[UIImage imageNamed:@"s_sel_male"];
    _Mea_FemaleImage.image=[UIImage imageNamed:@"s_unsel_feamle"];
    _Mea_UnisexImage.image=[UIImage imageNamed:@"s_unsel_unisex"];
    
    _Mea_MaleLBL.textColor=[UIColor blackColor];
    _Mea_FemaleLBL.textColor=[UIColor lightGrayColor];
    _Mea_UnisexLBL.textColor=[UIColor lightGrayColor];
    
    
    mea_gender=@"M";
    NSLog(@"Male");
}
-(void)Action_meaFemale
{
    _Mea_Mimage.image=[UIImage imageNamed:@"s_unsel_male"];
    _Mea_FemaleImage.image=[UIImage imageNamed:@"s_sel_female"];
    _Mea_UnisexImage.image=[UIImage imageNamed:@"s_unsel_unisex"];
    
    _Mea_MaleLBL.textColor=[UIColor lightGrayColor];
    _Mea_FemaleLBL.textColor=[UIColor blackColor];
    _Mea_UnisexLBL.textColor=[UIColor lightGrayColor];
    mea_gender=@"F";
    NSLog(@"Famale");
    
}
-(void)Action_meaUnisex
{
    
    _Mea_Mimage.image=[UIImage imageNamed:@"s_unsel_male"];
    _Mea_FemaleImage.image=[UIImage imageNamed:@"s_unsel_feamle"];
    _Mea_UnisexImage.image=[UIImage imageNamed:@"s_sel_unisex"];
    
    _Mea_MaleLBL.textColor=[UIColor lightGrayColor];
    _Mea_FemaleLBL.textColor=[UIColor lightGrayColor];
    _Mea_UnisexLBL.textColor=[UIColor blackColor];
    mea_gender=@"U";
    NSLog(@"Unisex");
}
-(void)ActionProfile
{
    [self pageviewProfile];
    
    _profilrView.backgroundColor=[UIColor blackColor];
    _MeasurementView.backgroundColor=[UIColor whiteColor];
    _AddressView.backgroundColor=[UIColor whiteColor];
    _PaymentView.backgroundColor=[UIColor whiteColor];
    
    _profilrLbl.textColor=[UIColor whiteColor];
    _measurementLbl.textColor=[UIColor blackColor];
    _AddressLbl.textColor=[UIColor blackColor];
    _paymentLbl.textColor=[UIColor blackColor];
}
-(void)ActionMeasu
{
    [self pageviewMeasurement];
    _profilrView.backgroundColor=[UIColor whiteColor];
    _MeasurementView.backgroundColor=[UIColor blackColor];
    _AddressView.backgroundColor=[UIColor whiteColor];
    _PaymentView.backgroundColor=[UIColor whiteColor];
    
    _profilrLbl.textColor=[UIColor blackColor];
    _measurementLbl.textColor=[UIColor whiteColor];
    _AddressLbl.textColor=[UIColor blackColor];
    _paymentLbl.textColor=[UIColor blackColor];
    
}-(void)ActionAddress
{
    [self pageviewAddress];
    _profilrView.backgroundColor=[UIColor whiteColor];
    _MeasurementView.backgroundColor=[UIColor whiteColor];
    _AddressView.backgroundColor=[UIColor blackColor];
    _PaymentView.backgroundColor=[UIColor whiteColor];
    
    _profilrLbl.textColor=[UIColor blackColor];
    _measurementLbl.textColor=[UIColor blackColor];
    _AddressLbl.textColor=[UIColor whiteColor];
    _paymentLbl.textColor=[UIColor blackColor];
}
-(void)ActionPayement
{
    [self pageviewPayement];
    _profilrView.backgroundColor=[UIColor whiteColor];
    _MeasurementView.backgroundColor=[UIColor whiteColor];
    _AddressView.backgroundColor=[UIColor whiteColor];
    _PaymentView.backgroundColor=[UIColor blackColor];
    
    _profilrLbl.textColor=[UIColor blackColor];
    _measurementLbl.textColor=[UIColor blackColor];
    _AddressLbl.textColor=[UIColor blackColor];
    _paymentLbl.textColor=[UIColor whiteColor];
}
-(void)delegateWithInitialDetailsInTxtLbl
{
    gender=@"M";
    _profileView.layer.borderWidth=1;
    _profileView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
}
-(void)fillDetailsOnMeasurment
{
    _MShoulderTF.text=[[NSUserDefaults standardUserDefaults] valueForKey:SHOULDER];
    _MwaistTF.text=[[NSUserDefaults standardUserDefaults] valueForKey:WAIST];
    _MnectTF.text=[[NSUserDefaults standardUserDefaults] valueForKey:NECK];
    _MchestTF.text=[[NSUserDefaults standardUserDefaults] valueForKey:CHEST];
    _MinseamTF.text=[[NSUserDefaults standardUserDefaults] valueForKey:INSEAM];
    _MArmTF.text=[[NSUserDefaults standardUserDefaults] valueForKey:ARM];
}
-(void)imageload
{
    [_profileImage sd_setShowActivityIndicatorView:YES];
    [_profileImage sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [_profileImage sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:PROFILEIMAGE]]
                     placeholderImage:[UIImage imageNamed:@"user_default"]
                              options:SDWebImageRefreshCached];
    
}
-(void)fillDetailsInPage
{
    
    NSString *Email=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL]];
    
    NSString *Fullname=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:FIRSTNAME]];
    if (![Fullname isEqualToString:@"(null)"])
    {
        _FullNameTF.text=Fullname;
    }
    _NameTF.text=Email;
    
    NSLog(@"%@",_NameTF.text);
    gender=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:GENDER]];
    
    if([gender isEqualToString:@"M"])
    {
        [self ActionMale];
    }
    else if([gender isEqualToString:@"F"])
    {
        [self ActionFemale];
    }
    else
    {
        [self ActionUnisex];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ActionBack:(id)sender
{
    
    //    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)ActionEditBTN:(id)sender
{
    
    UIAlertController *action = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionTakePhoto = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [pickerController setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
        [pickerController setCameraDevice:UIImagePickerControllerCameraDeviceRear];
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *actionGallery = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    
    [action addAction:actionTakePhoto];
    [action addAction:actionGallery];
    [action addAction:actionCancel];
    
    [self presentViewController:action animated:YES completion:nil];
    
    
}


//validation
-(BOOL)validateFields
{
    if(_NameTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your name"];
        [_NameTF becomeFirstResponder];
        return NO;
        
    }
    
    //    if(_passwordTF.text.length==0)
    //    {
    //        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter your Password"];
    //        [_passwordTF becomeFirstResponder];
    //        return NO;
    //
    //    }
    
    return YES;
    
}
-(void)imageuploadAPIMethod
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSString *stringUrl =[[NSString alloc]initWithFormat:@"%@%@", BaseURL,EditProfile ];
        NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:USERID];
        
        NSDictionary *parameters  = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",_FullNameTF.text,@"name",_passwordTF.text,@"password",gender,@"gender",@"",@"contact_number" ,nil];
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:stringUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
        {
                                            
            [formData appendPartWithFileData:[self convertImageIntoDataFromImage:_profileImage.image] name:@"profile_pic" fileName:@"img.jpeg" mimeType:@"image/jpeg"]; // you file to upload
            
        } error:nil];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress)
    {
    // This is not called back on the main queue.
    // You are responsible for dispatching to the main queue for UI updates
    dispatch_async(dispatch_get_main_queue(), ^{
    //Update the progress view
    //                              [progressView setProgress:uploadProgress.fractionCompleted];
    });
    }
          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
              if (error)
              {
                  dispatch_async(dispatch_get_main_queue(), ^(void)
                                 {
                                     
                                     [SVProgressHUD dismiss];
                                     [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                                 });
              }
              else
              {
                  NSLog(@"%@ %@", response, responseObject);
                  NSString *message = [responseObject valueForKey:@"message"];
                  NSString *status=[responseObject valueForKey:@"status"];
                  
                  if ([status isEqualToString:@"S"])
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          [self removeImage];
                          NSDictionary *userDetailDic=[NSDictionary new];
                          userDetailDic=[responseObject valueForKey:@"data"];
                          //[[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"user_id"] forKey:USERID];
                          [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"name"] forKey:FIRSTNAME];
                          [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"gender"] forKey:GENDER];
                          [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"contact_number"] forKey:CONTACT];
                          [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"profile_pic"] forKey:PROFILEIMAGE];
                          [[NSUserDefaults standardUserDefaults] synchronize];
                          [SVProgressHUD dismiss];
                          NSLog(@"%@",status);
                          [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                          
                      });
                  }
                  else if ([status isEqualToString:@"F"])
                  {
                      dispatch_async(dispatch_get_main_queue(), ^(void)
                                     {
                                         [SVProgressHUD dismiss];
                                         [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                     });
                  }
                  else
                  {
                      dispatch_async(dispatch_get_main_queue(), ^(void)
                                     {
                                         [SVProgressHUD dismiss];
                                         [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
                                     });
                  }
              }
          }];
        
        [uploadTask resume];
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self Interneterror];
            //            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
    }
    
    
    
    
    //    if([Utils isNetworkAvailable] ==YES)
    //    {
    //        [SVProgressHUD show];
    //        NSString *stringUrl =[[NSString alloc]initWithFormat:@"%@%@", BaseURL,EditProfile ];
    //        NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:USERID];
    //
    //        NSDictionary *parameters  = [NSDictionary dictionaryWithObjectsAndKeys:user_id,@"user_id",_FullNameTF.text,@"name",_passwordTF.text,@"password",gender,@"gender",@"",@"contact_number" ,nil];
    //
    //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //
    //        [manager POST:stringUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    //         {
    //             [formData appendPartWithFileData:[self convertImageIntoDataFromImage:_profileImage.image] name:@"profile_pic" fileName:@"img.jpeg" mimeType:@"image/jpeg"];
    //             //here userfile is a paramiter for your image
    //         }
    //              success:^(AFHTTPRequestOperation *operation, id responseObject)
    //         {
    //             //         NSLog(@"%@",[responseObject valueForKey:@"data"]);
    //             NSString *message = [responseObject valueForKey:@"message"];
    //             NSString *status=[responseObject valueForKey:@"status"];
    //
    //             if ([status isEqualToString:@"S"])
    //             {
    //                 dispatch_async(dispatch_get_main_queue(), ^{
    //
    //                     [self removeImage];
    //                     NSDictionary *userDetailDic=[NSDictionary new];
    //                     userDetailDic=[responseObject valueForKey:@"data"];
    //                     //[[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"user_id"] forKey:USERID];
    //                     [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"name"] forKey:FIRSTNAME];
    //                     [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"gender"] forKey:GENDER];
    //                     [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"contact_number"] forKey:CONTACT];
    //                     [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"profile_pic"] forKey:PROFILEIMAGE];
    //                     [[NSUserDefaults standardUserDefaults] synchronize];
    //                     [SVProgressHUD dismiss];
    //                     NSLog(@"%@",status);
    //                     [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
    //
    //                 });
    //
    //             }
    //             else if ([status isEqualToString:@"F"])
    //             {
    //                dispatch_async(dispatch_get_main_queue(), ^(void)
    //                {
    //                     [SVProgressHUD dismiss];
    //                     [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
    //                });
    //
    //             }
    //             else
    //             {
    //                 dispatch_async(dispatch_get_main_queue(), ^(void)
    //                 {
    //                           [SVProgressHUD dismiss];
    //                            [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
    //                  });
    //
    //             }
    //
    //         }
    //              failure:^(AFHTTPRequestOperation *operation, NSError *error)
    //         {
    //             dispatch_async(dispatch_get_main_queue(), ^(void)
    //                            {
    //
    //                                [SVProgressHUD dismiss];
    //                                [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
    //                            });
    //
    //         }];
    //    }
    //    else
    //    {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [SVProgressHUD dismiss];
    //            [self Interneterror];
    ////            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
    //        });
    //    }
}

- (IBAction)ActionUpdate:(id)sender
{
    
    if([self validateFields])
    {
        [self imageuploadAPIMethod];
        
    }
    
}
-(BOOL)MethodForValidationCheck:(UITextField *)textField
{
    
    //    NSArray *arr;
    //    switch(textField.tag)
    //        {
    //            case 3:
    //                arr = [[NSArray alloc]initWithObjects:@"20",@"21",@"22",@"23",@"24",@"25", nil];
    //
    //                break;
    //            case 4:
    //                arr = [[NSArray alloc]initWithObjects:@"20",@"21",@"22",@"23",@"24",@"25", nil];
    //
    //                break;
    //            case 5:
    //                arr = [[NSArray alloc]initWithObjects:@"20",@"21",@"22",@"23",@"24",@"25", nil];
    //
    //                break;
    //            case 6:
    //                arr = [[NSArray alloc]initWithObjects:@"20",@"21",@"22",@"23",@"24",@"25", nil];
    //
    //                break;
    //            case 7:
    //                arr = [[NSArray alloc]initWithObjects:@"20",@"21",@"22",@"23",@"24",@"25", nil];
    //
    //                break;
    //            case 8:
    //                arr = [[NSArray alloc]initWithObjects:@"20",@"21",@"22",@"23",@"24",@"25", nil];
    //
    //                break;
    //            default:
    //
    //                break;
    //        }
    
    NSString *stringValue = textField.text;
    float integer = [stringValue floatValue];
    if (integer <10 || integer > 100)
        // You can make the text red here for example
        return NO;
    else
        return YES;
    //    if ([arr containsObject:textField.text])
    //    {
    //        return YES;
    //    }
    //    return NO;
}

#pragma mark UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    
    _profileImage.image =[self image:image];
    _profileImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (UIImage *)image:(UIImage*)originalImage
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, _profileImage.frame.size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(_profileImage.frame.size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, _profileImage.frame.size.width, _profileImage.frame.size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}
-(void)updateProfileApiCallMethod
{
    
    //    if([Utils isNetworkAvailable] ==YES)
    //    {
    //        [SVProgressHUD show];
    //        NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:USERID];
    //
    //        NSError *error;
    //        NSDictionary *params = @{@"user_id":user_id,@"first_name":_txt_firstName.text,@"last_name":_txt_lastName.text,@"gender":gender,@"contact_number":_txt_phone.text};
    //        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    //        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,EditProfile ];
    //
    //        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    //      {
    //
    //           [formData appendPartWithFileData:[self convertImageIntoDataFromImage:_profileImage.image] name:@"profile_pic" fileName:@"img.jpeg" mimeType:@"image/jpeg"];
    //          NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:formData];
    //
    //        } error:&error];
    //
    //
    //
    //        [task resume];
    //    }
    //    else
    //    {
    //        [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
    //
    //    }
}

//Convert image into NSDATA
-(NSData*)convertImageIntoDataFromImage:(UIImage*)image
{
    NSData *dataImage = [[NSData alloc] init];
    dataImage = UIImageJPEGRepresentation(image, 0.5);
    return dataImage;
    
}


-(BOOL)validateFieldsForMeasurment
{
    if(_MShoulderTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter shoulder"];
        [_MShoulderTF becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_MShoulderTF])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Shoulder field"];
        [_MShoulderTF becomeFirstResponder];
        return NO;
    }
    if(_MchestTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter Chest"];
        [_MchestTF becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_MchestTF])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Chest field"];
        [_MchestTF becomeFirstResponder];
        return NO;
    }
    if(_MwaistTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter waist"];
        [_MwaistTF becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_MwaistTF])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Waist field"];
        [_MwaistTF becomeFirstResponder];
        return NO;
    }
    if(_MinseamTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter inseam"];
        [_MinseamTF becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_MinseamTF])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Inseam field"];
        [_MinseamTF becomeFirstResponder];
        return NO;
    }
    if(_MnectTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter neck"];
        [_MnectTF becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_MnectTF])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Neck field"];
        [_MnectTF becomeFirstResponder];
        return NO;
    }
    
    if(_MArmTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter Arm"];
        [_MArmTF becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_MArmTF])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Arm field"];
        [_MArmTF becomeFirstResponder];
        return NO;
    }
    
    return YES;
    
}
-(void)showWarningAlertWithTitle:(NSString*)title andMessage:(NSString*)msg{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"OK", @"OK")
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
//                             [alert dismissViewControllerAnimated:YES completion:nil];
//                             [self.navigationController popToRootViewControllerAnimated:YES];
                         }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)ActLOGOUT:(id)sender
{
    
    //    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
    //                                                                  message:@"Are you sure want to logout?"preferredStyle:UIAlertControllerStyleAlert];
    //
    //    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
    //                                                        style:UIAlertActionStyleDefault
    //                                                      handler:^(UIAlertAction * action)
    //    {
    //        [self logoutAPIcallingMethod];
    //    }];
    //
    //    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Cancel"
    //                                                       style:UIAlertActionStyleDefault
    //                                                     handler:^(UIAlertAction * action)
    //    {
    //
    //    }];
    //
    //    [alert addAction:yesButton];
    //    [alert addAction:noButton];
    //
    //    [self presentViewController:alert animated:YES completion:nil];
    //
}
-(void)logoutAPIcallingMethod
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:USERID];
        NSDictionary *params = @{@"user_id":user_id};
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,LOGOUT];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil]; //TODO handle error
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
         {
                   if (error)
                   {
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                        {
                            NSLog(@"data%@",data);
                            NSLog(@"response%@",error);
                            [SVProgressHUD dismiss];
                        });
                       
                    }
                   else
                   {
                             NSError *parseError = nil;
                             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                             NSLog(@"%@",responseDictionary);
                             NSString *message = [responseDictionary valueForKey:@"message"];
                             NSString *status=[responseDictionary valueForKey:@"status"];
                             if([status isEqualToString:@"S"])
                             {
                                
                                 dispatch_async(dispatch_get_main_queue(), ^(void)
                                 {
                                                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                                    [defaults removeObjectForKey:USERID];
                                                    [defaults removeObjectForKey:FIRSTNAME];
                                                    [defaults removeObjectForKey:LASTNAME];
                                                    [defaults removeObjectForKey:PROFILEIMAGE];
                                                    [defaults removeObjectForKey:GENDER];
                                                    [defaults removeObjectForKey:CONTACT];
                                                    [defaults removeObjectForKey:PROFILEIMAGE];
                                                    [defaults removeObjectForKey:USEREMAIL];
                                                    [defaults removeObjectForKey:WISHPRODUCTLIST];
                                                    [defaults removeObjectForKey:SHOULDER];
                                                    [defaults removeObjectForKey:CHEST];
                                                    [defaults removeObjectForKey:WAIST];
                                                    [defaults removeObjectForKey:INSEAM];
                                                    [defaults removeObjectForKey:NECK];
                                                    [defaults removeObjectForKey:ARM];
                                                    [defaults removeObjectForKey:@"Address_shiping"];
                                                    [defaults removeObjectForKey:SEASRCHDATA];
                                                    [defaults removeObjectForKey:Total_Cart];
                                                    [defaults removeObjectForKey:Total_Steez];
                                                    [[GIDSignIn sharedInstance] signOut];
                                                    [defaults setBool:NO forKey:LOGGED_IN];
                                                    //[defaults setBool:NO forKey:];
                                                    [defaults synchronize];
                                                    [SVProgressHUD dismiss];
                                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                    LoginVC *home = (LoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                                                    
                                                    [self.navigationController pushViewController:home animated:YES];
                                });
                                 
                             }
                             else if ([status isEqualToString:@"F"])
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^(void)
                                                {
                                                    [SVProgressHUD dismiss];
                                                    [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                                });
                             }
                             else
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^(void)
                                                {
                                                    [SVProgressHUD dismiss];
                                                     [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
                                                });
                             }
                      }
                  }];
        [dataTask resume];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
    }
    
    
}
- (IBAction)Save:(id)sender
{
//    if([self validateFieldsForMeasurment])
//    {
//        [self MeasurementAPICalling];
//    }
    
}

-(void)MeasurementAPICalling
{
    
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:USERID];
        NSDictionary *params = @{@"user_id":user_id,@"shoulder":_MShoulderTF.text
                                 ,@"chest":_MchestTF.text,@"waist":_MwaistTF.text,@"inseam":_MinseamTF.text,@"neck":_MnectTF.text,@"arm":_MArmTF.text};
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Measurment];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil]; //TODO handle error
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              if (error)
                                              {
                                                  dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                 {
                                                                     NSLog(@"response%@",error);
                                                                     [SVProgressHUD dismiss];
                                                                     [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                                                                 });
                                              }
                                              else
                                              {
                                                  [SVProgressHUD dismiss];
                                                  NSError *parseError = nil;
                                                  NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                  NSLog(@"%@",responseDictionary);
                                                  NSString *message = [responseDictionary valueForKey:@"message"];
                                                  NSString *status=[responseDictionary valueForKey:@"status"];
                                                  if([status isEqualToString:@"F"])
                                                  {
                                                      [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                                      
                                                  }
                                                  else
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                     {
                                                                         NSDictionary *userDetailDic=[NSDictionary new];
                                                                         userDetailDic=[responseDictionary valueForKey:@"data"];
                                                                         
                                                                         [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"arm"] forKey:ARM];
                                                                         [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"chest"] forKey:CHEST];
                                                                         [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"inseam"] forKey:INSEAM];
                                                                         [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"neck"] forKey:NECK];
                                                                         [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"shoulder"] forKey:SHOULDER];
                                                                         [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"waist"] forKey:WAIST];
                                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                                         
                                                                         [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                                                         
                                                                     });
                                                      
                                                  }
                                              }
                                          }];
        [dataTask resume];
    }
    else
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
        
    }
    
    
}
- (IBAction)ActionAddressADD:(id)sender {
    
    newaddressVC *address = (newaddressVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"newaddressVC"];
    
    [self.navigationController pushViewController:address animated:YES];
}
- (IBAction)ActionAddCard:(id)sender {
    
    newCardVC *card = (newCardVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"newCardVC"];
    
    [self.navigationController pushViewController:card animated:YES];
}

//Measurment
- (IBAction)Action_Shoulder:(id)sender
{
    //    index=1;
    //    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Shoulder" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
    //    picker.delegate = self;
    //    picker.dataSource = self;
    //    picker.needFooterView = YES;
    //    [picker show];
    
}

- (IBAction)Action_Chest:(id)sender
{
    //    index=2;
    //    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Chest" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
    //    picker.delegate = self;
    //    picker.dataSource = self;
    //    picker.needFooterView = YES;
    //    [picker show];
}
- (IBAction)Action_Waist:(id)sender
{
    //    index=3;
    //    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Waist" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
    //    picker.delegate = self;
    //    picker.dataSource = self;
    //    picker.needFooterView = YES;
    //    [picker show];
}
- (IBAction)Action_Inseam:(id)sender
{
    //    index=4;
    //    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Inseam" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
    //    picker.delegate = self;
    //    picker.dataSource = self;
    //    picker.needFooterView = YES;
    //    [picker show];
}
- (IBAction)Action_Neck:(id)sender
{
    //    index=5;
    //    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Neck" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
    //    picker.delegate = self;
    //    picker.dataSource = self;
    //    picker.needFooterView = YES;
    //    [picker show];
}
- (IBAction)Action_Arm:(id)sender
{
    //    index=6;
    //    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Arm" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
    //    picker.delegate = self;
    //    picker.dataSource = self;
    //    picker.needFooterView = YES;
    //    [picker show];
}

//CZPICKER

/* comment out this method to allow
 CZPickerView:titleForRow: to work.
 */
//- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
//               attributedTitleForRow:(NSInteger)row{
//    NSAttributedString *att;
//
//    if(index==1)
//    {
//        att = [[NSAttributedString alloc]
//               initWithString:ArrShoulder[row]
//               attributes:@{
//                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
//                            }];
//    }
//    else if(index==2)
//    {
//        att = [[NSAttributedString alloc]
//               initWithString:ArrChest[row]
//               attributes:@{
//                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
//                            }];
//    }
//    else if(index==3)
//    {
//        att = [[NSAttributedString alloc]
//               initWithString:ArrWaist[row]
//               attributes:@{
//                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
//                            }];
//    }
//    else if(index==4)
//    {
//        att = [[NSAttributedString alloc]
//               initWithString:ArrInseam[row]
//               attributes:@{
//                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
//                            }];
//    }
//    else if(index==5)
//    {
//        att = [[NSAttributedString alloc]
//               initWithString:ArrNeck[row]
//               attributes:@{
//                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
//                            }];
//    }
//    else if(index==6)
//    {
//        att = [[NSAttributedString alloc]
//               initWithString:ArrArm[row]
//               attributes:@{
//                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
//                            }];
//    }
//
//    return att;
//}
//
//- (NSString *)czpickerView:(CZPickerView *)pickerView
//               titleForRow:(NSInteger)row
//{
//
//    if(index==1)
//    {
//        return ArrShoulder[row];
//    }
//    else if (index==2)
//    {
//        return ArrChest[row];
//    }
//    else if (index==3)
//    {
//        return ArrWaist[row];
//    }
//    else if (index==2)
//    {
//        return ArrInseam[row];
//    }
//    else if (index==3)
//    {
//
//        return ArrNeck[row];
//    }
//    else
//        return ArrArm[row];//name2 is NsMutable Array
//
//}
//
//- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
//{
//    switch(index)
//    {
//        case 1:
//            return ArrShoulder.count;
//            break;
//        case 2:
//            return ArrChest.count;
//            break;
//        case 3:
//            return ArrWaist.count;
//            break;
//
//        case 4:
//            return ArrInseam.count;
//            break;
//        case 5:
//            return ArrNeck.count;
//            break;
//        default:
//            return ArrArm.count;
//            break;
//    }
//
//
//}
//
//- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row
//{
//    switch(index)
//    {
//        case 1:
//            Str_shoulder=[NSString stringWithFormat:@"%@",ArrShoulder[row]];
//            _MShoulderTF.text=Str_shoulder;
//
//            break;
//        case 2:
//            Str_Chest=[NSString stringWithFormat:@"%@",ArrChest[row]];
//            _MchestTF.text=Str_Chest;
//
//            break;
//        case 3:
//
//            Str_Waist=[NSString stringWithFormat:@"%@",ArrWaist[row]];
//
//            _MwaistTF.text=Str_Waist;
//            break;
//
//        case 4:
//            Str_Inseam=[NSString stringWithFormat:@"%@",ArrInseam[row]];
//
//            _MinseamTF.text=Str_Inseam;
//            break;
//        case 5:
//
//            Str_Neck=[NSString stringWithFormat:@"%@",ArrNeck[row]];
//
//            _MnectTF.text=Str_Neck;
//            break;
//        default:
//             Str_Arm=[NSString stringWithFormat:@"%@",ArrArm[row]];
//            _MArmTF.text=Str_Arm;
//            break;
//    }
//
//    [self.navigationController setNavigationBarHidden:YES];
//}
//
//- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows
//{
//
//    for (NSNumber *n in rows)
//    {
//        NSInteger row = [n integerValue];
//
//        switch(index)
//        {
//            case 1:
//                Str_shoulder=[NSString stringWithFormat:@"%@",ArrShoulder[row]];
//                NSLog(@"%@",Str_shoulder);
//                break;
//            case 2:
//                Str_Chest=[NSString stringWithFormat:@"%@",ArrChest[row]];
//                NSLog(@"%@",Str_Chest);
//                break;
//            case 3:
//                Str_Waist=[NSString stringWithFormat:@"%@",ArrWaist[row]];
//                NSLog(@"%@",Str_Waist);
//                break;
//
//            case 4:
//                Str_Inseam=[NSString stringWithFormat:@"%@",ArrInseam[row]];
//                NSLog(@"%@",Str_Inseam);
//                break;
//            case 5:
//                Str_Neck=[NSString stringWithFormat:@"%@",ArrNeck[row]];
//                NSLog(@"%@",Str_Neck);
//                break;
//            default:
//                Str_Arm=[NSString stringWithFormat:@"%@",ArrArm[row]];
//                NSLog(@"%@",Str_Arm);
//                break;
//        }
//
//
//    }
//}
//
//- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView
//{
//    [self.navigationController setNavigationBarHidden:YES];
//
//    NSLog(@"Canceled.");
//}
//
//- (void)czpickerViewWillDisplay:(CZPickerView *)pickerView
//{
//    NSLog(@"Picker will display.");
//}
//
//- (void)czpickerViewDidDisplay:(CZPickerView *)pickerView
//{
//    NSLog(@"Picker did display.");
//}
//
//- (void)czpickerViewWillDismiss:(CZPickerView *)pickerView
//{
//    NSLog(@"Picker will dismiss.");
//}
//
//- (void)czpickerViewDidDismiss:(CZPickerView *)pickerView
//{
//    NSLog(@"Picker did dismiss.");
//}

//change image on click

//NSData *data1 = UIImagePNGRepresentation(_MBTN.currentBackgroundImage);
//NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"radio_sel"]);
//
//if ([data1 isEqual:data2])
//{
//
//}
//else
//{
//
//    gender=@"M";
//
//    [_MBTN setBackgroundImage:[UIImage imageNamed:@"radio_sel"] forState:UIControlStateNormal];
//    [_FBTN setBackgroundImage:[UIImage imageNamed:@"radio_unsel"] forState:UIControlStateNormal];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cardSaveArray.count;
    
    //    return addressArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SCardCell *cell = (SCardCell*)[tableView dequeueReusableCellWithIdentifier:@"SCardCell"];
    
    //        UIView* shadowView = [cell viewWithTag:99];
    cell.View.backgroundColor=[UIColor whiteColor];
    [cell.View.layer setCornerRadius:5.0f];
    [cell.View.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.View.layer setBorderWidth:0.2f];
    [cell.View.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
    [cell.View.layer setShadowOpacity:1.0];
    [cell.View.layer setShadowRadius:2.0];
    [cell.View.layer setShadowOffset:CGSizeMake(1.0f, 1.0f)];
    
    cell.View.layer.cornerRadius=4;
    
    cell.cardLbl.text=[NSString stringWithFormat:@"%@",cardSaveArray[indexPath.row][@"card_string"]];
    
    return cell;
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld",(long)indexPath.row);
    
    
}
- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
                   message:@"Are you sure you want to remove this credit card?"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [self apiforremovecard:cardSaveArray[indexPath.row][@"token"]];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
-(void)getSaveCardAPI
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:USERID];
        NSDictionary *params = @{@"user_id":user_id};
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,GetSaveCard];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil]; //TODO handle error
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
              if (error)
              {
                     dispatch_async(dispatch_get_main_queue(), ^(void)
                     {
                            NSLog(@"response%@",error);
                            [SVProgressHUD dismiss];
                         [self serverError];
//                           [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                      });
              }
             else
             {
                 
                  NSError *parseError = nil;
                  NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                  NSLog(@"%@",responseDictionary);
//                  NSString *message = [responseDictionary valueForKey:@"message"];
                  NSString *status=[responseDictionary valueForKey:@"status"];
                 [self removeImage];
                  if([status isEqualToString:@"S"])
                  {
                     dispatch_async(dispatch_get_main_queue(), ^(void)
                        {
                                cardSaveArray=[NSMutableArray new];
                                cardSaveArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
                                if (cardSaveArray.count>0 )
                                {
                                     self.cardTableveiw.alpha=1;
                                     _empty_paymentView.alpha=0;
                                     _addCardBtn.alpha=1;
                                     [self.cardTableveiw reloadData];
                                 }
                                else
                                {
                                     self.cardTableveiw.alpha=0;
                                     _empty_paymentView.alpha=1;
                                     _addCardBtn.alpha=0;
                                 }
                                 [SVProgressHUD dismiss];
                             });
                       }
                      else  if([status isEqualToString:@"F"])
                     {
                        dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               
                                   self.cardTableveiw.alpha=0;
                                   _empty_paymentView.alpha=1;
                                   _addCardBtn.alpha=0;
                                    [SVProgressHUD dismiss];
                            });
                      }
                     else
                    {
                      dispatch_async(dispatch_get_main_queue(), ^(void)
                     {
                           [SVProgressHUD dismiss];
                           self.cardTableveiw.alpha=0;
                           _empty_paymentView.alpha=1;
                           _addCardBtn.alpha=0;
                           [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
                     });
                    }
              }
         }];
        [dataTask resume];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           [SVProgressHUD dismiss];
                           [self Interneterror];
//                           [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
                       });
        
        
        
    }
}
-(void)apiforremovecard:(NSString *)token
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:USERID];
        NSDictionary *params = @{@"user_id":user_id,@"token":token};
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,RemoveSaveCard];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil]; //TODO handle error
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
                  if (error)
                  {
                          dispatch_async(dispatch_get_main_queue(), ^(void)
                          {
                           NSLog(@"response%@",error);
                           [SVProgressHUD dismiss];
                              [self serverError];
//                            [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                           });
                   }
                   else
                  {
                      
                            NSError *parseError = nil;
                            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                            NSLog(@"%@",responseDictionary);
                            NSString *message = [responseDictionary valueForKey:@"message"];
                            NSString *status=[responseDictionary valueForKey:@"status"];
                            [self removeImage];
                            if([status isEqualToString:@"S"])
                            {
                                dispatch_async(dispatch_get_main_queue(), ^(void)
                                  {
                                   
                                      cardSaveArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
                                      if (cardSaveArray.count>0)
                                      {
                                           self.cardTableveiw.alpha=1;
                                           _empty_paymentView.alpha=0;
                                           _addCardBtn.alpha=1;
                                           [self.cardTableveiw reloadData];
                                       }
                                       else
                                      {
                                         self.cardTableveiw.alpha=0;
                                         _empty_paymentView.alpha=1;
                                         _addCardBtn.alpha=0;
                                       }
                                        [SVProgressHUD dismiss];
                                      
                                     });
                              }
                              else  if([status isEqualToString:@"F"])
                              {
                                      dispatch_async(dispatch_get_main_queue(), ^(void)
                                         {
                                               [SVProgressHUD dismiss];
                                                 [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                          });
                              }
                              else
                              {
                                         dispatch_async(dispatch_get_main_queue(), ^(void)
                                         {
                                              [SVProgressHUD dismiss];
                                              [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
                                          });
                              }
                        }
                  }];
        [dataTask resume];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           [SVProgressHUD dismiss];
                           [self Interneterror];
//                           [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
                       });
        
        
    }
}
-(void)Get_address_ApiMethod
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        
        NSDictionary *params = @{@"user_id":user_id};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,GetAddress ];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil]; //TODO handle error
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
             if (error)
             {
                   dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                        NSLog(@"response%@",error);
                        [SVProgressHUD dismiss];
                       [self serverError];
//                        [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                    });
             }
             else
             {
                                                  
                   NSError *parseError = nil;
                   NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                   NSLog(@"%@",responseDictionary);
                   NSString *message = [responseDictionary valueForKey:@"message"];
                   NSString *status=[responseDictionary valueForKey:@"status"];
                   NSMutableArray *arraymut=[NSMutableArray new];
                   arraymut=[[responseDictionary valueForKey:@"data"] mutableCopy];
                    [self removeImage];
                   if([status isEqualToString:@"S"])
                   {
                       
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                                      {
                                          
                                          NSDictionary *dicshipping=[NSDictionary new];
                                          NSDictionary *dicbilling=[NSDictionary new];
                                          dicshipping=[arraymut valueForKey:@"shipping"];
                                          dicbilling=[arraymut valueForKey:@"billing"];
                                          NSString *str1=[NSString stringWithFormat:@"%@",[dicshipping valueForKey:@"name"]];
                                          NSString *str2=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"name"]];
                                          if(![str1 isEqualToString:@""])
                                          {
                                              addressSave=[NSString stringWithFormat:@"%@ \n%@, %@, %@, %@, %@, %@",[dicshipping valueForKey:@"name"],[dicshipping valueForKey:@"address_1"],[dicshipping valueForKey:@"address_2"],[dicshipping valueForKey:@"city"],[dicshipping valueForKey:@"state"],[dicshipping valueForKey:@"country"],[dicshipping valueForKey:@"postcode"]];
                                              _lbl_Address.text=addressSave;
                                              if (![str2 isEqualToString:@""])
                                              {
                                                  billingSaveadd=[NSString stringWithFormat:@"%@ \n%@, %@, %@, %@, %@, %@",[dicbilling valueForKey:@"name"],[dicbilling valueForKey:@"address_1"],[dicbilling valueForKey:@"address_2"],[dicbilling valueForKey:@"city"],[dicbilling valueForKey:@"state"],[dicbilling valueForKey:@"country"],[dicbilling valueForKey:@"postcode"]];
                                                  _Billing_TV.text=billingSaveadd;
                                                  _emailBillingLBL.text=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"email"]];
                                                  _phoneBillingLbl.text=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"phone"]];
                                              }
                                          }
                                          else
                                          {
                                              addressSave=@"";
                                          }
                                          [SVProgressHUD dismiss];
                                      });
                       
                    }
                 else if ([status isEqualToString:@"F"])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^(void)
                                    {
                                        [SVProgressHUD dismiss];
                                        [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                    });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^(void)
                                    {
                                        [SVProgressHUD dismiss];
                                         [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
                                    });
                 }
              }
        }];
        [dataTask resume];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           [SVProgressHUD dismiss];
                           [self Interneterror];
//                           [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
                       });
    }
    
}
-(void)newaddressMethod
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    newaddressVC *add = (newaddressVC *)[storyboard instantiateViewControllerWithIdentifier:@"newaddressVC"];
    [self.navigationController pushViewController:add animated:YES];
}
- (IBAction)ActAddCard:(id)sender {
    
    [self ActionAddCard:self];
}
- (IBAction)ActNewSetting:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Setting_privacyVC *sett = (Setting_privacyVC *)[storyboard instantiateViewControllerWithIdentifier:@"Setting_privacyVC"];
    [self.navigationController pushViewController:sett animated:YES];
}
-(void)removeImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        errorImage.alpha=0;
        errorImage.image=nil;
       
    });
    
}
-(void)serverError
{
    
    errorImage.alpha=1;
    errorImage.image=[UIImage imageNamed:@"Server-error"];
    
    
}
-(void)Interneterror
{
    errorImage.alpha=1;
    errorImage.image=[UIImage imageNamed:@"no-internet"];
    
}
@end

