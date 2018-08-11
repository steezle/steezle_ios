//
//  ForgotPasswordVC.m
//  ESR
//
//  Created by Aecor Digital on 22/06/17.
//  Copyright © 2017 Aecor Digital. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "Globals.h"
#import "Utils.h"
#import "SVProgressHUD.h"
#import "userdefaultArrayCall.h"
//#import "UIColor+fromHex.h"
@interface ForgotPasswordVC ()
{
    NSString *status;
    UITextField *activeField;
    
}
@end

@implementation ForgotPasswordVC

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
            //            smallFonts = true;
        } else if (screenHeight == 568)
        {
            NSLog(@"iPhone 5/5S/SE");
            _logo_h.constant=60;
            _logo_w.constant=60;
            _subH.constant=40;
            _emailH.constant=40;
            
            
            //            smallFonts = true;
        } else if (screenHeight == 667)
        {
            NSLog(@"iPhone 6/6S");
        }
        else if (screenHeight == 736)
        {
            NSLog(@"iPhone 6+, 6S+");
        }
        else
        {
            NSLog(@"Others");
        }
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingUpTextField];
    
    UIColor *color = [UIColor whiteColor];
    self.emailTxt.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    tapGesture.cancelsTouchesInView = NO;
    
    [_scrollView addGestureRecognizer:tapGesture];
    
}
#pragma mark- keyboard related methods
-(void) keyboardWasShown: (NSNotification *)infoi
{
    NSDictionary* info = [infoi userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [_scrollView setContentOffset:scrollPoint animated:YES];
        
    }
    
}
-(void)keyboardWillBeHidden: (NSNotification *)notif

{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
// method to hide keyboard when user taps on a scrollview
-(void)hideKeyboard
{
    [_scrollView endEditing: YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    activeField=textField;
    if(textField==_emailTxt)
    {
        [_emailTxt resignFirstResponder];
        [self ActSubmit:self];
        
    }
    
    return YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if(![emailTest evaluateWithObject:email])
    {
        [_emailTxt becomeFirstResponder];
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Email should be like: Example@mail.com"];
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}



-(BOOL)validateFields
{
    if(_emailTxt.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your email address"];
        [_emailTxt becomeFirstResponder];
        
        return NO;
    }
    
    if(![self validateEmailWithString:_emailTxt.text])
    {
        return NO;
    }
    
    return YES;
}
//validate Email With String

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


-(void)settingUpTextField
{
    
    self.emailTxt.enableMaterialPlaceHolder = YES;
    self.emailTxt.placeholder = @"Email Address";
    self.emailTxt.errorColor = [UIColor whiteColor];
    self.emailTxt.lineColor = [UIColor whiteColor];
    self.emailTxt.delegate=self;
    self.emailTxt.tag=1;
    
}

- (IBAction)ActBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)ActSubmit:(id)sender {
    if([self validateFields])
    {
        if([Utils isNetworkAvailable] ==YES)
        {
            [SVProgressHUD show];
            NSDictionary *params = @{@"user_id":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]],@"email":self.emailTxt.text};
            //NSDictionary *params = @{@"email": @"spatel@aecrodigital.com",@"password":@"sanjay1!" ,@"tournament_id":@"1",@"first_name":@"sanjay",@"sur_name":@"patel" };
            //Configure your session with common header fields like authorization etc
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
            NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Forgotpassword ];
            //NSString *url =@"https://manager.gimbal.com/api/v2/places";
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil]; //TODO handle error
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody: requestData];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
         {
                  [SVProgressHUD dismiss];
                  if (error)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^(void)
                      {
                              NSLog(@"response%@",error);
                              [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                       });
                  }
                 else
                 {
                                                      
                           NSError *parseError = nil;
                           NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                           NSLog(@"%@",responseDictionary);
                           NSString *message = [responseDictionary valueForKey:@"message"];
                           status=[responseDictionary valueForKey:@"status"];
                           if([status isEqualToString:@"F"])
                           {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                 UIAlertController *alertController = [UIAlertController
                                  alertControllerWithTitle:@"Steezle" message:message preferredStyle:UIAlertControllerStyleAlert];
                                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                 }];
                                [alertController addAction:ok];
                                [self presentViewController:alertController animated:YES     completion:nil];
                             });
                            }
                            else if ([status isEqualToString:@"S"])
                            {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                   UIAlertController *alertController = [UIAlertController
                                    alertControllerWithTitle:@"Steezle" message:message preferredStyle:UIAlertControllerStyleAlert];
                                                                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                                                       {
                                                                                           [self.navigationController popViewControllerAnimated:TRUE];
                                                                                       }];
                                                                  [alertController addAction:ok];
                                                                  [self presentViewController:alertController animated:YES     completion:nil];
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
    
}
@end

