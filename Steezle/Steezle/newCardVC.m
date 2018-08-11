//
//  newCardVC.m
//  Steezle
//
//  Created by webmachanics on 10/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "newCardVC.h"
#import "AFNetworking.h"
#import "Globals.h"
#import "Utils.h"
#import "userdefaultArrayCall.h"
#import "SVProgressHUD.h"
#import "HomeTabBar.h"
#import <UIKit/UIKit.h>
@import Stripe;


#define STRIPE_TEST_PUBLIC_KEY @"pk_live_ZG4KImX0bCskmlkf2tT5q6q4"
//#define STRIPE_TEST_PUBLIC_KEY @"pk_test_uVBDZ0wJcJBrI8LGxY0BdKSH"

#define STRIPE_TEST_POST_URL
#define MAX_LENGTHCardName 40
#define MAX_LENGTHCardNumber 19
#define MAX_LENGTHCardNumber_US 18

#define MAX_LENGTHCardMonth 2
#define MAX_LENGTHCardYear 2
#define MAX_LENGTHCardCVV 3
#define MAX_LENGTHCardCVV_US 4

#define MAX_LENGTHEmail 64
#define FONTNAME_REG   @"HelveticaNeue"
#define LFONT_10         [UIFont fontWithName:FONTNAME_REG size:12]

@interface newCardVC ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITextField *activeField;
    NSString *flag;
    NSString *new_token;
    NSString *textStr;
    NSMutableArray *yearArray;
    NSArray *pickerData;
    UIPickerView *pickerDemo,*picker;
    UIToolbar *toolBar,*toolBar2;
    STPCardParams *cardParams;
}
@property (strong, nonatomic) STPCardParams* stripeCard;
@end

@implementation newCardVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    flag=@"0";
    new_token=@"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
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
    
    picker.dataSource = self;
    picker.delegate = self;
    
    pickerDemo.dataSource = self;
    pickerDemo.delegate = self;
    
    
    //    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    //    [toolBar setBarStyle:UIBarStyleDefault];
    //    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
    //                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(changeDateFromLabel:)];
    //    toolBar.items = @[barButtonDone];
    //    toolBar.tag=1;
    //    barButtonDone.tintColor=[UIColor blackColor];
    
    _ExpMTF.inputView = pickerDemo;
    _ExpMTF.inputAccessoryView = toolBar;
    
    
    //    toolBar2= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    //    [toolBar2 setBarStyle:UIBarStyleDefault];
    //    UIBarButtonItem *barButtonDone1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
    //                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(changeDateFromLabel1:)];
    //    toolBar2.items = @[barButtonDone1];
    //    toolBar2.tag=2;
    //    barButtonDone.tintColor=[UIColor blackColor];
    _ExpYearTF.inputView=picker;
    _ExpYearTF.inputAccessoryView = toolBar2;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tapGesture];
    
    [self settingUpTextField];
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
        [_ExpYearTF becomeFirstResponder];
        
    }
    if(textField==_ExpYearTF)
    {
        [_ExpYearTF resignFirstResponder];
        
        
    }
    
    
    return YES;
    
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
-(void)hideKeyboard
{
    
    [_scrollView endEditing: YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingUpTextField
{
    self.CardNameTF.delegate=self;
    self.CardNumberTF.delegate=self;
    self.ExpMTF.delegate=self;
    self.ExpYearTF.delegate=self;
    self.cvvTXT.delegate=self;
    
    self.CardNameTF.enableMaterialPlaceHolder = YES;
    self.CardNameTF.placeholder = @"Card Name";
    self.CardNameTF.errorColor = [UIColor blackColor];
    self.CardNameTF.lineColor = [UIColor grayColor];
    self.CardNameTF.delegate=self;
    self.CardNameTF.tag=1;
    
    self.CardNumberTF.enableMaterialPlaceHolder = YES;
    self.CardNumberTF.placeholder = @"Card #";
    self.CardNumberTF.errorColor = [UIColor blackColor];
    self.CardNumberTF.lineColor = [UIColor grayColor];
    self.CardNumberTF.delegate=self;
    self.CardNumberTF.tag=2;
    
    self.ExpMTF.enableMaterialPlaceHolder = YES;
    self.ExpMTF.placeholder = @"MM";
    self.ExpMTF.errorColor = [UIColor blackColor];
    self.ExpMTF.lineColor = [UIColor grayColor];
    self.ExpMTF.delegate=self;
    self.ExpMTF.tag=3;
    
    self.ExpYearTF.enableMaterialPlaceHolder = YES;
    self.ExpYearTF.placeholder = @"YYYY";
    self.ExpYearTF.errorColor = [UIColor blackColor];
    self.ExpYearTF.lineColor = [UIColor grayColor];
    self.ExpYearTF.delegate=self;
    self.ExpYearTF.tag=4;
    
    self.cvvTXT.enableMaterialPlaceHolder = YES;
    self.cvvTXT.placeholder = @"CVC";
    self.cvvTXT.errorColor = [UIColor blackColor];
    self.cvvTXT.lineColor = [UIColor grayColor];
    self.cvvTXT.delegate=self;
    self.cvvTXT.tag=5;
    
    
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
            _ExpYearTF.text = textStr;
            [_ExpYearTF resignFirstResponder];
        }
 
        
    }
    
}


- (void)postStripeToken
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:USERID]];
        NSDictionary *params = @{@"user_id":user_id,@"token":new_token};
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Save_Card];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
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
                 
                         NSError *parseError = nil;
                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                         NSLog(@"%@",responseDictionary);
                         NSString *message = [responseDictionary valueForKey:@"message"];
                         NSString *result=[responseDictionary valueForKey:@"status"];
                         if ([result isEqualToString:@"S"])
                         {
                           dispatch_async(dispatch_get_main_queue(), ^(void){
                               [SVProgressHUD dismiss];
                               [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                               _CardNameTF.text=nil;
                               _CardNumberTF.text=nil;
                               _ExpMTF.text=nil;
                               _ExpYearTF.text=nil;
                               _cvvTXT.text=nil;
                            });
                          }
                        if([result isEqualToString:@"F"])
                        {
                            //Background Thread success  failure
                            dispatch_async(dispatch_get_main_queue(), ^(void){
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
                           [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
                       });
        
        
    }
    
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
            if (_CardNumberTF.text.length < 18)
            {
                allowedLength = MAX_LENGTHCardCVV_US;   // triggered for input fields with tag = 2

            } else {
                allowedLength = MAX_LENGTHCardCVV;   // triggered for input fields with tag = 2

            }
//            allowedLength = MAX_LENGTHCardCVV;   // triggered for input fields with tag = 2
            break;
            
    }
    
    if (textField.text.length >= allowedLength && range.length == 0)
    {
        if(textField==_CardNameTF)
        {
            //            [_CardNameTF resignFirstResponder];
            [_CardNumberTF becomeFirstResponder];
            
        }
        if(textField==_CardNumberTF)
        {
            //            [_CardNameTF resignFirstResponder];
            //            [_ExpMTF becomeFirstResponder];
            
        }
        if(textField==_ExpMTF)
        {
            //            [_CardNameTF resignFirstResponder];
            [_ExpYearTF becomeFirstResponder];
            
        }
        if(textField==_ExpYearTF)
        {
            //            [_CardNameTF resignFirstResponder];
            [_cvvTXT becomeFirstResponder];
            
        }
        if(textField==_cvvTXT)
        {
            
        }
        return NO;
        
    }
    
    else
    {
        if (/*textField==_CVVTF && textField.text.length == allowedLength-1 && _CardNameTF.text.length<=MAX_LENGTHCardName &&*/ _CardNumberTF.text.length<=MAX_LENGTHCardNumber || _CardNameTF.text.length<=MAX_LENGTHCardName/*&& _ExpMTF.text.length==MAX_LENGTHCardMonth && _ExpYTF.text.length==MAX_LENGTHCardYear &&  _emailTF.text.length<=MAX_LENGTHEmail*/)
        {
            
            if (textField==_CardNumberTF )
            {
                if ([self range:range ContainsLocation:4] || [self range:range ContainsLocation:9] || [self range:range ContainsLocation:14])
                {
                    _CardNumberTF.text =[self formatPhoneString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
                    return NO;
                }
                
            }
            
            
            //            _PayNowBTN.backgroundColor=[UIColor blackColor];
            //            _PayNowBTN.enabled=YES;
            //            fillAll=YES;
        }
        else
        {
            //            _PayNowBTN.enabled=NO;
            //            _PayNowBTN.backgroundColor=[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.5f];
        }
        return YES;
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
                             //[self.navigationController popToRootViewControllerAnimated:YES];
                         }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)performStripeOperation
{
    [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken *token, NSError *error)
     {
         if (token == nil || error != nil)
         {
             [SVProgressHUD dismiss];
             NSString *cards=[NSString stringWithFormat:@"%@",[error localizedDescription]];
             if ([cards isEqualToString:@"Your card's number is invalid"])
                 [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter a valid credit card number"];
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
             //  [SVProgressHUD dismiss];
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
             flag=@"1";
             [self postStripeToken];
             
         }
         
     }];
    
}
- (IBAction)ActionBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (BOOL)validateCustomerInfo
{
    
    //1. Validate name & email
    if (self.CardNameTF.text.length == 0 ||
        self.CardNumberTF.text.length == 0 || self.ExpMTF.text.length == 0 || self.ExpYearTF.text.length == 0  || self.cvvTXT.text.length == 0)
    {
        [SVProgressHUD dismiss];
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter all required information"];
        return NO;
    }
    
    
    return YES;
}

- (IBAction)ActionSaveCard:(id)sender {
    
    
    [SVProgressHUD show];
    NSString *month=[NSString stringWithFormat:@"%@",_ExpMTF.text];
    NSString *year=[NSString stringWithFormat:@"%@",_ExpYearTF.text];
    
    cardParams = [[STPCardParams alloc] init];
    NSString *Number = _CardNumberTF.text;
    
    NSString *cardNumber = [Number stringByReplacingOccurrencesOfString:@" " withString:@""];
    cardParams.number = cardNumber;
    cardParams.expMonth = [month integerValue];
    cardParams.expYear = [year integerValue];
    cardParams.cvc = _cvvTXT.text;
    
    if ([self validateCustomerInfo])
    {
        [self performStripeOperation];
    }
    
    
}
@end

