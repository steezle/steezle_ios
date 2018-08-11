//
//  CouponVC.m
//  Steezle
//
//  Created by Ryan Smith on 2018-01-27.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import "CouponVC.h"
#import "Globals.h"
#import "Utils.h"
#import "userdefaultArrayCall.h"
#import "SVProgressHUD.h"

@interface CouponVC ()<UITextFieldDelegate>

{
    UITextField *activeField;
    NSMutableArray *productArray;
}
@end

@implementation CouponVC
@synthesize delegate;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    
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
                _Top_h.constant=40;
                
                
            } else {
                
            }
        }
        else
        {
            NSLog(@"Others");
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.CouponCodeTF.delegate=self;
    
    self.CouponCodeTF.enableMaterialPlaceHolder = YES;
    self.CouponCodeTF.placeholder = @"Enter coupon code";
    self.CouponCodeTF.errorColor = [UIColor blackColor];
    self.CouponCodeTF.lineColor = [UIColor grayColor];
    self.CouponCodeTF.backgroundColor=[UIColor whiteColor];
    self.CouponCodeTF.delegate=self;
    self.CouponCodeTF.tag=1;
//    self.CouponCodeTF.layer.borderWidth=1;
//    self.CouponCodeTF.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
//    _viewTop.backgroundColor=[UIColor whiteColor];
//    [_viewTop.layer setCornerRadius:5.0f];
//    [_viewTop.layer setBorderColor:[UIColor blackColor].CGColor];
//    [_viewTop.layer setBorderWidth:0.2f];
//    [_viewTop.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
//    [_viewTop.layer setShadowOpacity:1.0];
//    [_viewTop.layer setShadowRadius:2.0];
//    [_viewTop.layer setShadowOffset:CGSizeMake(1.0f, 1.0f)];
//    _viewTop.layer.cornerRadius=4;
//
//    _viewTop.layer.borderWidth=1;
//    _viewTop.layer.borderColor=[UIColor lightTextColor].CGColor;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tapGesture];
}
-(void)hideKeyboard
{
    [_scrollView endEditing: YES];
    
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
   
    if(textField==_CouponCodeTF)
    {
        [_CouponCodeTF resignFirstResponder];
        
    }
    
    
    return YES;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (IBAction)Act_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Act_Apply:(id)sender {
    
    if ([self validateCustomerInfo])
    {
         [self ApplyCouponCode];
    }
   
}
- (BOOL)validateCustomerInfo
{
    
    //1. Validate name & email
    if (self.CouponCodeTF.text.length == 0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter coupon code"];
        return NO;
    }
    return YES;
    
}
- (void)ApplyCouponCode
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:USERID]];
        NSDictionary *params = @{@"user_id":user_id,@"code":_CouponCodeTF.text};
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Coupon_Code];
        
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
                      if([result isEqualToString:@"S"])
                      {
                          //Background Thread success  failure
                          dispatch_async(dispatch_get_main_queue(), ^(void){
                              
                              productArray =[NSMutableArray new];
                              productArray=[[responseDictionary valueForKey:@"data"]mutableCopy];
                              [SVProgressHUD dismiss];
                              [self passDataBack];
                           });
                      }
                      else if ([result isEqualToString:@"F"])
                      {
                          
                          dispatch_async(dispatch_get_main_queue(), ^(void){
                              [SVProgressHUD dismiss];
                              [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                          });
                      }
                      else
                      {
                          //Background Thread success  failure
                          dispatch_async(dispatch_get_main_queue(), ^(void){
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
- (void)passDataBack
{
    if ([delegate respondsToSelector:@selector(dataFromCoupon:)])
    {
        [delegate dataFromCoupon:productArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
