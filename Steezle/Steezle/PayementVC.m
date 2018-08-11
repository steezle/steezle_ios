//
//  PayementVC.m
//  Steezle
//
//  Created by webmachanics on 14/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "PayementVC.h"
#import "AFNetworking.h"
#import "SavecardCell.h"
#import "Globals.h"
#import "Utils.h"
#import "userdefaultArrayCall.h"
#import "SVProgressHUD.h"
#import "CouponVC.h"
//#import "ExploreVC.h"
#import "HomeTabBar.h"
#import "ShoppingCartVC.h"
//#import "SLPickerView.h"
#import <UIKit/UIKit.h>
@import Stripe;

#define STRIPE_TEST_PUBLIC_KEY @"pk_live_ZG4KImX0bCskmlkf2tT5q6q4"
//#define STRIPE_TEST_PUBLIC_KEY @"pk_test_uVBDZ0wJcJBrI8LGxY0BdKSH"

#define STRIPE_TEST_POST_URL
#define MAX_LENGTHCardName 40
#define MAX_LENGTHCardNumber 19
#define MAX_LENGTHCardMonth 2
#define MAX_LENGTHCardYear 2
#define MAX_LENGTHCardCVV 3
#define MAX_LENGTHEmail 64
#define FONTNAME_REG   @"HelveticaNeue"
#define LFONT_10         [UIFont fontWithName:FONTNAME_REG size:12]

@interface PayementVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,CouponCodeDelegate>
{
    NSString *flag;
    BOOL selcted,fillAll,Success,current_flag,couponApple;
    int rowselect;
    NSString *old_Token,*new_token;
    NSString *totalIteam;
    NSDictionary *cardTotalDic;
    NSMutableArray *SaveCardDic,*yearArray;
    NSString *Tokenstr;
    UITextField *activeField;
    STPCardParams *cardParams;
    NSArray *pickerData;
    NSString *textStr;
    UIPickerView *pickerDemo,*picker;
    NSMutableArray *couponArrayData;
    UIToolbar *toolBar,*toolBar2;
    
}
@property (strong, nonatomic) STPCardParams* stripeCard;
@end
@implementation PayementVC
@synthesize SaveCardWithPayDetArr,errorImage;

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
            _payment_h.constant=31;
            _email_h.constant=30;
            _card_na_h.constant=30;
            _card_bo_h.constant=30;
            _m_h.constant=30;
            _cvv_h.constant=30;
            //          _check_h.constant=30;
            _yy_h.constant=30;
            //            _details_h.constant=180;
            _pay_y.constant=2;
            _pay_h.constant=35;
            _save_h.constant=_PayementView.frame.size.width/2;
            //            _emailTF.font=LFONT_10;
            //            _CardNumberTF.font=LFONT_10;
            //            _CardNameTF.font=LFONT_10;
            //            _ExpMTF.font=LFONT_10;
            //            _ExpYTF.font=LFONT_10;
            //            _CVVTF.font=LFONT_10;
            //            UIColor *color = [UIColor grayColor];
            //            _CardNameTF.attributedPlaceholder =
            //            [[NSAttributedString alloc] initWithString:@"Card Name"
            //                                            attributes:@{
            //                                                         NSForegroundColorAttributeName: color,
            //                                                         NSFontAttributeName : LFONT_10
            //                                                         }
            //             ];
            //            _CardNumberTF.attributedPlaceholder =
            //            [[NSAttributedString alloc] initWithString:@"Card #"
            //                                            attributes:@{
            //                                                         NSForegroundColorAttributeName: color,
            //                                                         NSFontAttributeName : LFONT_10
            //                                                         }
            //             ];
            //            _ExpMTF.attributedPlaceholder =
            //            [[NSAttributedString alloc] initWithString:@"MM"
            //                                            attributes:@{
            //                                                         NSForegroundColorAttributeName: color,
            //                                                         NSFontAttributeName : LFONT_10
            //                                                         }
            //             ];
            //            _ExpYTF.attributedPlaceholder =
            //            [[NSAttributedString alloc] initWithString:@"YYYY"
            //                                            attributes:@{
            //                                                         NSForegroundColorAttributeName: color,
            //                                                         NSFontAttributeName : LFONT_10
            //                                                         }
            //             ];
            //
            //            _CVVTF.attributedPlaceholder =
            //            [[NSAttributedString alloc] initWithString:@"CVV"
            //                                            attributes:@{
            //                                                         NSForegroundColorAttributeName: color,
            //                                                         NSFontAttributeName : LFONT_10
            //                                                         }
            //  ];
            
        } else if (screenHeight == 667)
        {
            NSLog(@"iPhone 6/6S");
            _popupsubview.layer.cornerRadius=self.popupsubview.frame.size.width/2;
            _popupsubview.layer.masksToBounds=YES;
        }
        else if (screenHeight == 736)
        {
            NSLog(@"iPhone 6+, 6S+");
            _popupsubview.layer.cornerRadius=self.popupsubview.frame.size.width/2;
            _popupsubview.layer.masksToBounds=YES;
        }
        else if (screenHeight == 812)
        {
            if (@available(iOS 11, *))
            {
                UIView *parentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
                parentView.backgroundColor=[UIColor whiteColor];
                [self.view addSubview:parentView];
                _TOP_H.constant=40;
                _popupsubview.layer.cornerRadius=self.popupsubview.frame.size.width/2;
                _popupsubview.layer.masksToBounds=YES;
                
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popupview)];
    [self.popupsubview addGestureRecognizer:gestureRecognizer];
    
    self.popupsubview.userInteractionEnabled = YES;
    gestureRecognizer.cancelsTouchesInView = NO;
    
    
    UITapGestureRecognizer *gestureRecognizerMain = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popupview)];
    [self.popupmainview addGestureRecognizer:gestureRecognizerMain];
    
    self.popupmainview.userInteractionEnabled = YES;
    gestureRecognizerMain.cancelsTouchesInView = NO;
    
   
    [self PagedetailsValueFill];
    
}



-(UIView *)PaddingView
{
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    
}
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height+5;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) )
    {
        [_scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    activeField=textField;
    if(textField==_emailTF)
    {
        [_emailTF resignFirstResponder];
        [_CardNameTF becomeFirstResponder];
    }
    if(textField==_CardNameTF)
    {
        [_CardNameTF resignFirstResponder];
        [_CardNumberTF becomeFirstResponder];
    }
    if(textField==_CardNumberTF)
    {
        [_CardNumberTF resignFirstResponder];
        [_ExpMTF becomeFirstResponder];
        
    }
    if(textField==_ExpMTF)
    {
        [_ExpMTF resignFirstResponder];
        [_ExpYTF becomeFirstResponder];
        
    }
    if(textField==_ExpYTF)
    {
        [_ExpYTF resignFirstResponder];
        [_CVVTF becomeFirstResponder];
        
    }
    if(textField==_CVVTF)
    {
        [_CVVTF resignFirstResponder];
        //        [self callmethodforstripetoagteTpken];
        
    }
    
    return YES;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    errorImage.alpha=0;
    couponApple=NO;
    flag=@"0";
    current_flag=NO;
    old_Token=@"";
    new_token=@"";
    
    _popupsubview.layer.cornerRadius=self.popupsubview.frame.size.width/2;
    _popupsubview.layer.masksToBounds=YES;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    self.couponView.backgroundColor=[UIColor whiteColor];
    [self.couponView.layer setCornerRadius:5.0f];
    [self.couponView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.couponView.layer setBorderWidth:0.2f];
    [self.couponView.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
    [self.couponView.layer setShadowOpacity:1.0];
    [self.couponView.layer setShadowRadius:2.0];
    [self.couponView.layer setShadowOffset:CGSizeMake(1.0f, 1.0f)];
    self.couponView.layer.cornerRadius=4;
    
    //    _couponView.layer.borderWidth=1;
    //    _couponView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    //    _couponView.layer.backgroundColor=[UIColor lightGrayColor].CGColor;
    UITapGestureRecognizer *tap;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CouponGesture:)];
    [_couponView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapOncouponImage;
    tapOncouponImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage)];
    [_NC_image addGestureRecognizer:tapOncouponImage];
    
    yearArray=[[NSMutableArray alloc]init];
    [yearArray addObject:@"YYYY"];
    for (int i=0; i<60; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",[yearString intValue]+i]];
    }
    pickerData = @[@"MM",@"01", @"02" , @"03", @"04",@"05", @"06" , @"07", @"08",@"09", @"10" , @"11", @"12"];
    pickerDemo = [[UIPickerView alloc]init];
    pickerDemo.backgroundColor=[UIColor whiteColor];
    pickerDemo.tag=1;
    
    picker = [[UIPickerView alloc]init];
    picker.backgroundColor=[UIColor whiteColor];
    picker.tag=2;
    //This is how you manually SET(!!) a selection!
    //    [picker selectRow:0 inComponent:0 animated:YES];
    //    [pickerDemo selectRow:0 inComponent:0 animated:YES];
    picker.dataSource = self;
    picker.delegate = self;
    
    pickerDemo.dataSource = self;
    pickerDemo.delegate = self;
    
    
    //    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    //    [toolBar setBarStyle:UIBarStyleDefault];
    //    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
    //                                                                style:UIBarButtonItemStyleDone target:self action:@selector(changeDateFromLabel:)];
    //    toolBar.items = @[barButtonDone];
    //    toolBar.tag=1;
    //    barButtonDone.tintColor=[UIColor blackColor];
    
    _ExpMTF.inputView = pickerDemo;
    _ExpMTF.inputAccessoryView = toolBar;
    
    
    //    toolBar2= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    //    [toolBar2 setBarStyle:UIBarStyleDefault];
    //    UIBarButtonItem *barButtonDone1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
    //                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(changeDateFromLabel1:)];
    //    toolBar2.items = @[barButtonDone1];
    //    toolBar2.tag=2;
    //    barButtonDone.tintColor=[UIColor blackColor];
    _ExpYTF.inputView=picker;
    _ExpYTF.inputAccessoryView = toolBar2;
    
    Success=NO;
    _emailTF.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL]];
    
    selcted=NO;
    _popupmainview.hidden=YES;
    _popupsubview.hidden=YES;
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.hidden=YES;
    
    //    _PayNowBTN.enabled=NO;
    //    _PayNowBTN.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.5f];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tapGesture];
    
    [self settingUpTextField];
    
    
    [_CheckMarkBTN setBackgroundImage:[UIImage imageNamed:@"check_marks_unsel"] forState:UIControlStateNormal];
    _CheckMarkBTN.layer.borderWidth=0.5;
    _CheckMarkBTN.layer.borderColor=[UIColor grayColor].CGColor;
     [self payementSegementMethod];
}
-(void)tapOnImage
{
    
    if ([[UIImage imageNamed:@"s_right"] isEqual:_NC_image.image])
    {
        
        CouponVC *Coupon = (CouponVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"CouponVC"];
        Coupon.delegate=self;
        [self.navigationController pushViewController:Coupon animated:YES];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
                                                                      message:@"Are you sure want to remove coupon code?"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        NSLog(@"calling api for delete coupon code");
                                        _NC_image.image=[UIImage imageNamed:@"s_right"];
                                        _CouponValue.text=nil;
                                        _FromApply=NO;
                                        couponApple=NO;
                                        
                                         [self couponcodeDeleteAPICallMethod];
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
}
-(void)couponcodeDeleteAPICallMethod
{
    
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:USERID]];
        
        NSDictionary *params = @{@"user_id": user_id};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Coupon_code_delete];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];//TODO handle error
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
//                                        [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                             });
                    }
                    else
                   {
                             NSError *parseError = nil;
                             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                             NSLog(@"%@",responseDictionary);
                             NSString *message = [responseDictionary valueForKey:@"message"];
                             NSString *result=[responseDictionary valueForKey:@"status"];
                            [self removeImage];
                             if([result isEqualToString:@"S"])
                             {
                                cardTotalDic=[NSDictionary new];
                                dispatch_async(dispatch_get_main_queue(), ^(void)
                                {
                                    cardTotalDic=[[responseDictionary valueForKey:@"data"] mutableCopy];
                                    float total_M=[[cardTotalDic valueForKey:@"cart_subtotal"] floatValue];
                                    float total_T=[[cardTotalDic valueForKey:@"cart_total"] floatValue];
                                    float total_Tax=[[cardTotalDic valueForKey:@"tax"] floatValue];
                                    float total_Sh=[[cardTotalDic valueForKey:@"shipping"] floatValue];
                                    //    _lbl_totalOrderPrice.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_p]];
                                    _marchndLBL.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_M]];
                                    _TotalLBL.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_T]];
                                    _ShippingLBL.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_Sh]];
                                    _TaxLBL.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_Tax]];
                                    
                                    totalIteam=[NSString stringWithFormat:@"%@",[cardTotalDic valueForKey:@"total_cart_item"]];
                                    _iteamLBL.text=totalIteam;
                                    couponApple=NO;
//                                     _couponView.userInteractionEnabled=YES;
                                    [SVProgressHUD dismiss];
                                });
                             }
                             else if ([result isEqualToString:@"F"])
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
-(void)PagedetailsValueFill
{
    NSLog(@"%@",SaveCardWithPayDetArr);
    cardTotalDic=[NSDictionary new];
    SaveCardDic=[NSMutableArray new];
    cardTotalDic=[SaveCardWithPayDetArr valueForKey:@"cart_totals"];
    SaveCardDic=[[SaveCardWithPayDetArr valueForKey:@"saved_card_data"] mutableCopy];
    
    if(SaveCardDic.count==0)
    {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.height, self.tableView.frame.size.width)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.tableView.backgroundColor=[UIColor whiteColor];
        imageView.image =[UIImage imageNamed:@"savecardEmpty"];
        
        self.tableView.backgroundView = imageView;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor=[UIColor clearColor];
        self.tableView.scrollEnabled=NO;
    }
    
    if (_FromApply==YES)
    {
        cardTotalDic=[couponArrayData mutableCopy];
        float discount=[[cardTotalDic valueForKey:@"discount"] floatValue];
        _CouponValue.text=[@"-$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",discount]];
        _NC_image.image=[UIImage imageNamed:@"s_black_sel"];
        couponApple=YES;
//        _couponView.userInteractionEnabled=NO;
        
    }
    
    float total_M=[[cardTotalDic valueForKey:@"cart_subtotal"] floatValue];
    float total_T=[[cardTotalDic valueForKey:@"cart_total"] floatValue];
    float total_Tax=[[cardTotalDic valueForKey:@"tax"] floatValue];
    float total_Sh=[[cardTotalDic valueForKey:@"shipping"] floatValue];
    //    _lbl_totalOrderPrice.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_p]];
    _marchndLBL.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_M]];
    _TotalLBL.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_T]];
    _ShippingLBL.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_Sh]];
    _TaxLBL.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_Tax]];
    
    totalIteam=[NSString stringWithFormat:@"%@",[cardTotalDic valueForKey:@"total_cart_item"]];
    _iteamLBL.text=totalIteam;
    
}
-(void)popupview
{
    _popupmainview.hidden=YES;
    _popupsubview.hidden=YES;
    
    if (Success)
    {
        UIStoryboard  *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        HomeTabBar *paymentOrder = (HomeTabBar *)[storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
        paymentOrder.selectedIndex=2;
        [self.navigationController pushViewController:paymentOrder animated:YES];
        
    }
    else
    {
        UIStoryboard  *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ShoppingCartVC *shopping = (ShoppingCartVC *)[storyboard instantiateViewControllerWithIdentifier:@"ShoppingCartVC"];
        [self.navigationController pushViewController:shopping animated:YES];
    }
    
    
}
-(void)payementSegementMethod
{
    UITapGestureRecognizer *tapGesturecredit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CreditAction)];
    tapGesturecredit.cancelsTouchesInView = NO;
    [_PayCreaditView addGestureRecognizer:tapGesturecredit];
    
    
    UITapGestureRecognizer *tapGestureIn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(InteracAction)];
    tapGestureIn.cancelsTouchesInView = NO;
    [_PayInteracView addGestureRecognizer:tapGestureIn];
    
    
    _PayementView.layer.borderWidth=1;
    _PayementView.layer.borderColor=[UIColor blackColor].CGColor;
    
    _PayCreaditView.backgroundColor=[UIColor blackColor];
    _PayInteracView.backgroundColor=[UIColor whiteColor];
    [_ceditLbl setTextColor:[UIColor whiteColor]];
    [_InteracLbl setTextColor:[UIColor blackColor]];
    
    
}
-(void)CreditAction
{

    selcted=NO;
    current_flag=NO;
    //    if(!fillAll)
    //    {
    //        _PayNowBTN.enabled=NO;
    //        _PayNowBTN.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.5f];
    //    }
    
    
    old_Token=@"";
    self.tableView.hidden=YES;
    _PayCreaditView.backgroundColor=[UIColor blackColor];
    _PayInteracView.backgroundColor=[UIColor whiteColor];
    [_ceditLbl setTextColor:[UIColor whiteColor]];
    [_InteracLbl setTextColor:[UIColor blackColor]];
}
-(void)InteracAction
{
    
    selcted=NO;
    current_flag=YES;
  
    //    _PayNowBTN.enabled=NO;
    //    _PayNowBTN.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.5f];
    self.tableView.hidden=NO;
    
    _PayCreaditView.backgroundColor=[UIColor whiteColor];
    _PayInteracView.backgroundColor=[UIColor blackColor];
    [_ceditLbl setTextColor:[UIColor blackColor]];
    [_InteracLbl setTextColor:[UIColor whiteColor]];
}
-(void)hideKeyboard
{
    
    [_scrollView endEditing: YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)settingUpTextField
{
    self.CardNameTF.delegate=self;
    self.CardNumberTF.delegate=self;
    self.ExpMTF.delegate=self;
    self.ExpYTF.delegate=self;
    self.emailTF.delegate=self;
    
    self.emailTF.enableMaterialPlaceHolder = YES;
    self.emailTF.placeholder = @"Email Address";
    //    self.CardNameTF.text=@"WebmobiTechnologies";
    self.emailTF.errorColor = [UIColor blackColor];
    self.emailTF.lineColor = [UIColor grayColor];
    self.emailTF.delegate=self;
    self.emailTF.tag=6;
    
    self.CardNameTF.enableMaterialPlaceHolder = YES;
    self.CardNameTF.placeholder = @"Card Name";
    //    self.CardNameTF.text=@"WebmobiTechnologies";
    self.CardNameTF.errorColor = [UIColor blackColor];
    self.CardNameTF.lineColor = [UIColor grayColor];
    self.CardNameTF.delegate=self;
    self.CardNameTF.tag=1;
    
    self.CardNumberTF.enableMaterialPlaceHolder = YES;
    self.CardNumberTF.placeholder = @"Card #";
    //    self.CardNumberTF.text=@"4242424242424242";
    self.CardNumberTF.errorColor = [UIColor blackColor];
    self.CardNumberTF.lineColor = [UIColor grayColor];
    self.CardNumberTF.delegate=self;
    self.CardNumberTF.tag=2;
    
    self.ExpMTF.enableMaterialPlaceHolder = YES;
    self.ExpMTF.placeholder = @"MM";
    //    self.ExpMTF.text=@"12";
    self.ExpMTF.errorColor = [UIColor blackColor];
    self.ExpMTF.lineColor = [UIColor grayColor];
    self.ExpMTF.delegate=self;
    self.ExpMTF.tag=3;
    
    
    self.ExpYTF.enableMaterialPlaceHolder = YES;
    self.ExpYTF.placeholder = @"YYYY";
    //    self.ExpYTF.text=@"22";
    self.ExpYTF.errorColor = [UIColor blackColor];
    self.ExpYTF.lineColor = [UIColor grayColor];
    self.ExpYTF.delegate=self;
    self.ExpYTF.tag=4;
    
    self.CVVTF.enableMaterialPlaceHolder = YES;
    self.CVVTF.placeholder = @"CVC";
    //    self.CVVTF.text=@"688";
    self.CVVTF.errorColor = [UIColor blackColor];
    self.CVVTF.lineColor = [UIColor grayColor];
    self.CVVTF.delegate=self;
    self.CVVTF.tag=5;
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    int allowedLength = 0;
    switch(textField.tag)
    {
        case 1:
            allowedLength = MAX_LENGTHCardName;  // triggered for input fields with tag = 1
            break;
        case 2:
            allowedLength = MAX_LENGTHCardNumber;  // triggered for input fields with tag = 1
            break;
        case 3:
            allowedLength = MAX_LENGTHCardMonth;   // triggered for input fields with tag = 2
            break;
        case 4:
            allowedLength = MAX_LENGTHCardYear;  // triggered for input fields with tag = 1
            break;
        case 5:
            allowedLength = MAX_LENGTHCardCVV;   // triggered for input fields with tag = 2
            break;
        case 6:
            allowedLength = MAX_LENGTHEmail;  // triggered for input fields with tag = 1
            break;
    }
    
    if (textField.text.length >= allowedLength && range.length == 0)
    {
        if(textField==_emailTF)
        {
            //            [_CardNameTF resignFirstResponder];
            [_CardNameTF becomeFirstResponder];
            
        }
        if(textField==_CardNameTF)
        {
            //            [_CardNameTF resignFirstResponder];
            [_CardNumberTF becomeFirstResponder];
            
        }
        if(textField==_CardNumberTF)
        {
            // [_CardNameTF resignFirstResponder];
            // [_ExpMTF becomeFirstResponder];
            
        }
        if(textField==_ExpMTF)
        {
            //[_CardNameTF resignFirstResponder];
            [_ExpYTF becomeFirstResponder];
            
        }
        if(textField==_ExpYTF)
        {
            //[_CardNameTF resignFirstResponder];
            [_CVVTF becomeFirstResponder];
            
        }
        if(textField==_CVVTF)
        {
            
            //            _PayNowBTN.backgroundColor=[UIColor blackColor];
            //            _PayNowBTN.enabled=YES;
            
        }
        return NO;
        // Change not allowed
    }
    
    else
    {
        if (/*textField==_CVVTF && textField.text.length == allowedLength-1 && _CardNameTF.text.length<=MAX_LENGTHCardName &&*/ _CardNumberTF.text.length<=MAX_LENGTHCardNumber /*&& _ExpMTF.text.length==MAX_LENGTHCardMonth && _ExpYTF.text.length==MAX_LENGTHCardYear &&  _emailTF.text.length<=MAX_LENGTHEmail*/)
        {
            _PayNowBTN.backgroundColor=[UIColor blackColor];
            _PayNowBTN.enabled=YES;
            fillAll=YES;
            
            if (textField==_CardNumberTF )
            {
                if ([self range:range ContainsLocation:4] || [self range:range ContainsLocation:9] || [self range:range ContainsLocation:14])
                {
                    _CardNumberTF.text =[self formatPhoneString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
                    return NO;
                }
                
            }
        }
        else
        {
            //            _PayNowBTN.enabled=NO;
            //            _PayNowBTN.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.5f];
        }
        return YES;
    }
    
    
}
-(NSString*) formatPhoneString:(NSString*) preFormatted
{
    //delegate only allows numbers to be entered, so '-' is the only non-legal char.
    NSString* workingString = [preFormatted stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //insert first '-'
    if(workingString.length > 4)
    {
        workingString = [workingString stringByReplacingCharactersInRange:NSMakeRange(4, 0) withString:@" "];
    }
    if(workingString.length > 9)
    {
        workingString = [workingString stringByReplacingCharactersInRange:NSMakeRange(9, 0) withString:@" "];
    }
    if(workingString.length > 14)
    {
        workingString = [workingString stringByReplacingCharactersInRange:NSMakeRange(14, 0) withString:@" "];
    }
    return workingString;
    
}

-(bool) range:(NSRange) range ContainsLocation:(NSInteger) location
{
    if(range.location <= location && range.location+range.length >= location)
    {
        return true;
    }
    
    return false;
}
- (IBAction)ActBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)ActionCheckMark:(id)sender
{
    
    NSData *data1 = UIImagePNGRepresentation(_CheckMarkBTN.currentBackgroundImage);
    NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"check_marks_unsel"]);
    
    if ([data1 isEqual:data2])
    {
        flag=@"1";
        [_CheckMarkBTN setBackgroundImage:[UIImage imageNamed:@"check_marks_sel"] forState:UIControlStateNormal];
    }
    else
    {
        flag=@"0";
        [_CheckMarkBTN setBackgroundImage:[UIImage imageNamed:@"check_marks_unsel"] forState:UIControlStateNormal];
        
    }
    
}

- (void)performStripeOperation
{
    [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken *token, NSError *error)
     {
         if (token == nil || error != nil)
         {
             [SVProgressHUD dismiss];
             //             [self showWarningAlertWithTitle:@"Steezle" andMessage:[error localizedDescription]];
             NSString *cards=[NSString stringWithFormat:@"%@",[error localizedDescription]];
             if ([cards isEqualToString:@"Your card's number is invalid"])
                 [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Your Credit Card number is invalid"];
             else
                 [self showWarningAlertWithTitle:@"Steezle" andMessage:cards];
             
             return;
         }
         if (error)
         {
             [SVProgressHUD dismiss];
             [self showWarningAlertWithTitle:@"Steezle" andMessage:[error localizedDescription]];
         }
         
         else
         {
             NSLog(@"%@",token.tokenId);
             //                    [SVProgressHUD dismiss];
             //                     _popupsubview.layer.borderWidth=1;
             //                     _popupsubview.layer.borderColor=[UIColor whiteColor].CGColor;
             //
             //                     [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
             //                         // animate it to the identity transform (100% scale)
             //                         //        view.transform = CGAffineTransformIdentity;
             //
             //                         _popupmainview.hidden=NO;
             //                         _popupsubview.hidden=NO;
             //
             //                     } completion:^(BOOL finished)
             //                      {
             //
             //                          // if you want to do something once the animation finishes, put it here
             //                      }];
             new_token=[NSString stringWithFormat:@"%@",token.tokenId];
             [self postStripeToken];
             
         }
         
     }];
    
}

- (IBAction)ActPayNow:(id)sender
{
    if([old_Token isEqualToString:@""])
    {
        [SVProgressHUD show];
        NSString *month=[NSString stringWithFormat:@"%@",_ExpMTF.text];
        NSString *year=[NSString stringWithFormat:@"%@",_ExpYTF.text];
        
        cardParams = [[STPCardParams alloc] init];
        NSString *Number = _CardNumberTF.text;
        
        NSString *cardNumber = [Number stringByReplacingOccurrencesOfString:@" " withString:@""];
        cardParams.number = cardNumber;
        cardParams.expMonth = [month integerValue];
        cardParams.expYear = [year integerValue];
        cardParams.cvc = _CVVTF.text;
        
        
        if ([self validateCustomerInfo])
        {
            [self performStripeOperation];
        }
    }
    else
    {
        [self postStripeToken];
    }
    //
    //        _popupsubview.layer.borderWidth=1;
    //        _popupsubview.layer.borderColor=[UIColor whiteColor].CGColor;
    //
    //        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //            // animate it to the identity transform (100% scale)
    //            //        view.transform = CGAffineTransformIdentity;
    //
    //            _popupmainview.hidden=NO;
    //            _popupsubview.hidden=NO;
    //
    //        } completion:^(BOOL finished)
    //         {
    //
    //             // if you want to do something once the animation finishes, put it here
    //         }];
    
    
    
    
}
- (BOOL)validateCustomerInfo
{
    
    //1. Validate name & email
    if (self.CardNameTF.text.length == 0 ||
        self.CardNumberTF.text.length == 0 || self.CVVTF.text.length == 0 || self.ExpMTF.text.length == 0 || self.ExpYTF.text.length == 0 )
    {
        [SVProgressHUD dismiss];
        if (current_flag==YES)
        {
            [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please select credit card"];
        }
        else
        {
            [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter all required information"];
        }
        
        return NO;
    }
    if(![self validateEmailWithString:_emailTF.text])
    {
        return NO;
    }
    
    return YES;
}

//- (BOOL)validateCustomerInfo
//{
//
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
//                                                     message:@"Please enter all required information"
//                                                    delegate:nil
//                                           cancelButtonTitle:@"OK"
//                                           otherButtonTitles:nil];
//
//    //1. Validate name & email
//    if (self.CardNameTF.text.length == 0 ||
//        self.CardNumberTF.text.length == 0)
//    {
//
//        [alert show];
//        return NO;
//    }
//
//    //2. Validate card number, CVC, expMonth, expYear
//    NSError* error = nil;
//    [_stripeCard validateCardReturningError:&error];
//
//    //3
//    if (error)
//    {
//        alert.message = [error localizedDescription];
//        [alert show];
//        return NO;
//    }
//
//    return YES;
//}


- (void)handleStripeError:(NSError *) error {
    
    //1
    if ([error.domain isEqualToString:@"StripeDomain"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //2
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    self.PayNowBTN.enabled = YES;
}

- (void)chargeDidSucceed {
    //1
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"Please enjoy your new pup."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    //    RWCheckoutCart* checkoutCart = [RWCheckoutCart sharedInstance];
    //    [checkoutCart clearCart];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)chargeDidNotSuceed
{
    //2
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment not successful"
                                                    message:@"Please try again later."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

//tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50 ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SaveCardDic.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SavecardCell *cell = (SavecardCell*)[tableView dequeueReusableCellWithIdentifier:@"savecell"];
    NSDictionary *dic1=[NSDictionary new];
    dic1=[[SaveCardDic objectAtIndex:indexPath.row] mutableCopy];
    //    NSLog(@"%@",SaveCardDic);
    cell.labledetails.text=[NSString stringWithFormat:@"%@",[dic1 valueForKey:@"card_string"]];
    
    if (rowselect==indexPath.row && selcted)
    {
        
        if([cell.switchBTN isOn])
        {
            [cell.switchBTN setOn:NO];
            //            _PayNowBTN.enabled=NO;
            //            _PayNowBTN.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.5f];
            old_Token=@"";
        }
        else
        {
            [cell.switchBTN setOn:YES];
            _PayNowBTN.backgroundColor=[UIColor blackColor];
            _PayNowBTN.enabled=YES;
            old_Token=[NSString stringWithFormat:@"%@",[dic1 valueForKey:@"token"]];
        }
        //        old_Token=[NSString stringWithFormat:@"%@",[dic1 valueForKey:@"token"]];
        
    }
    else
    {
        [cell.switchBTN setOn:NO];
        //        old_Token=@"";
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    NSString *number=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    rowselect= (int)[number integerValue];
    selcted=YES;
    NSDictionary *dic1=[NSDictionary new];
    dic1=[[SaveCardDic objectAtIndex:indexPath.row] mutableCopy];
    old_Token=[NSString stringWithFormat:@"%@",[dic1 valueForKey:@"token"]];
    [tableView reloadData];
    _PayNowBTN.enabled=YES;
}

- (void)postStripeToken
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:USERID]];
        
       NSDictionary *params = @{@"user_id": user_id,@"old_token":old_Token,@"new_token":new_token,@"saved":flag};
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,PaymentConfirmStripe];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];//TODO handle error
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
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
                          //[self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                      });
                   }
                   else
                  {
                       NSError *parseError = nil;
                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                       NSLog(@"%@",responseDictionary);
                       NSString *message = [responseDictionary valueForKey:@"message"];
                       NSString *result=[responseDictionary valueForKey:@"result"];
                       [self removeImage];
                       if([result isEqualToString:@"failure"])
                      {
                                                     
                                 Success=NO;
                                 [SVProgressHUD dismiss];
                            
                                 dispatch_async(dispatch_get_main_queue(), ^(void){
                                 if (message==nil)
                                 {
                                  _payImage.image=[UIImage imageNamed:@"paymentUnAccepted"];
                                  _payStatusLBL.text=@"failed";
                                  _popupsubview.layer.borderWidth=1;
                                  _popupsubview.layer.borderColor=[UIColor whiteColor].CGColor;
                                  [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                  // animate it to the identity transform (100% scale)
                                  //view.transform = CGAffineTransformIdentity;
                                      [self dismissViewControllerAnimated:YES completion:nil];
                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                  _popupmainview.hidden=NO;
                                  _popupsubview.hidden=NO;
                                 } completion:^(BOOL finished)
                                  {
                                  }];
                               }
                            else
                            {
                                  [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                            }
                        });
                       }
                      else if ([result isEqualToString:@"success"])
                      {
                             Success=YES;
                             [SVProgressHUD dismiss];
                             dispatch_async(dispatch_get_main_queue(), ^(void){
                               _popupsubview.layer.borderWidth=1;
                               _popupsubview.layer.borderColor=[UIColor whiteColor].CGColor;
                               [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                               
                               //animate it to the identity transform (100% scale)
                               //view.transform = CGAffineTransformIdentity;
                                   
                               _popupmainview.hidden=NO;
                               _popupsubview.hidden=NO;
                                   
                       } completion:^(BOOL finished)
                      {
                       }];
                                                          
                      });
                   }
                   else
                   {
                         dispatch_async(dispatch_get_main_queue(), ^(void)
                         {
                                    [SVProgressHUD dismiss];
                                    [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                    [SVProgressHUD dismiss];
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

-(void)showWarningAlertWithTitle:(NSString*)title andMessage:(NSString*)msg
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
//Device id
-(NSString*)getUDID
{
    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    // IOS 6+
    NSLog(@"Device UDID is : %@", Identifier);
    return Identifier;
}
//Device Token
-(NSString*)getDeviceToken
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *device_token=[defaults objectForKey:@"device_token"];
    NSLog(@"device_token is : %@", device_token);
    if(device_token == nil)
        device_token=@"";
    return device_token;
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if(![emailTest evaluateWithObject:email])
    {
        
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Email should be like: Example@gmail.com"];
        //        [_email becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count;
    if (pickerView.tag==1)
    {
        count=pickerData.count;
    }
    else
    {
        count=yearArray.count;
    }
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *title;
    if (pickerView.tag==1)
    {
        title= [pickerData objectAtIndex:row];
    }
    else
    {
        title= [yearArray objectAtIndex:row];
    }
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView.tag==1)
    {
//        textStr = [pickerData objectAtIndex:row];
//        if(textStr ==nil)
//        {
//            _ExpMTF.text = [pickerData objectAtIndex:0];
//            [_ExpMTF resignFirstResponder];
//        }
//        else
//        {
//            _ExpMTF.text = textStr;
//            [_ExpMTF resignFirstResponder];
//        }
        textStr = [pickerData objectAtIndex:row];
        if([textStr isEqualToString:[pickerData objectAtIndex:0]])
        {
            
        }
        else
        {
            _ExpMTF.text = textStr;
            [_ExpMTF resignFirstResponder];
        }
        
    }
    else
    {
        textStr = [yearArray objectAtIndex:row];
        if([textStr isEqualToString:[yearArray objectAtIndex:0]])
        {
            
        }
        else
        {
            _ExpYTF.text = textStr;
            [_ExpYTF resignFirstResponder];
        }
        
        
    }
    
}
- (void)changeDateFromLabel:(id)sender
{
    
    
}
- (void)changeDateFromLabel1:(id)sender
{
    NSLog(@"DONE");
    
    
    
}
- (void) CouponGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if(couponApple==NO)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CouponVC *Coupon = (CouponVC *)[storyboard instantiateViewControllerWithIdentifier:@"CouponVC"];
        Coupon.delegate=self;
        [self.navigationController pushViewController:Coupon animated:YES];
    }
   
    
}
- (void)dataFromCoupon:(NSMutableArray *)data
{
    NSLog(@"%@",data);
    couponArrayData=[NSMutableArray new];
    couponArrayData=[data mutableCopy];
    _FromApply=YES;
    
    //    ProductlistArray= [data mutableCopy];
    //    FromFilterApi=YES;
    //    [self setvalueWhensearchingFromCategory];
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


//UIImage *image = [UIImage imageNamed:@"test.png"];
//UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//
//// Add image view on top of table view
//[self.tableView addSubview:imageView];
//
//// Set the background view of the table view
//self.tableView.backgroundView = imageView;

