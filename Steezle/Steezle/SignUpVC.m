//
//  SignUpVC.m
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "SignUpVC.h"
#import <AFNetworking/AFNetworking.h>
#import "Utils.h"
#import "Globals.h"
#import "LoginVC.h"
#import "SVProgressHUD.h"
#import "InviteReferrals.h"

@interface SignUpVC ()<UIScrollViewDelegate>
{
    NSString *genderStr;
    UITextField *activeField;
}
@end

@implementation SignUpVC

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    
}

-(UIView *)PaddingView
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initaildata];
    [self settingUpTextField];
    
    UIGestureRecognizer *gestureRecognizer = [[UIGestureRecognizer alloc] init];
    gestureRecognizer.delegate = self;
    [self.scroll addGestureRecognizer:gestureRecognizer];
    
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    
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
            _loho_height.constant=60;
            _logo_width.constant=60;
            _emailHeight.constant=40;
            _conPassHeight.constant=40;
            _passHeight.constant=40;
            _signUPHeight.constant=40;
            _genderViewHeight.constant=40;
            _femalewidth.constant=(_genderView.frame.size.width/3)-2;
            _MH.constant=30;
            _MW.constant=20;
            _FH.constant=30;
            _FW.constant=20;
            _UH.constant=30;
            _UW.constant=20;
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
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
-(void)initaildata
{
    self.genderView.layer.borderWidth=1;
    self.genderView.layer.borderColor=[UIColor whiteColor].CGColor;
    genderStr=[[NSString alloc] init];
    //    self.emailTxtField.leftView = [self PaddingView];
    //    self.emailTxtField.leftViewMode = UITextFieldViewModeAlways;
    //    self.passwordTxtField.leftView = [self PaddingView];
    //    self.passwordTxtField.leftViewMode = UITextFieldViewModeAlways;
    //    self.confirmTxtField.leftView = [self PaddingView];
    //    self.confirmTxtField.leftViewMode = UITextFieldViewModeAlways;
    
    UIColor *color = [UIColor whiteColor];
    
    self.emailTxtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Email Address", @"") attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTxtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", @"") attributes:@{NSForegroundColorAttributeName: color}];
    self.confirmTxtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Confirm Password", @"") attributes:@{NSForegroundColorAttributeName: color}];
    
    
    UITapGestureRecognizer *tapGestureMale = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MaleMethod)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGestureMale.cancelsTouchesInView = NO;
    
    [_g_male addGestureRecognizer:tapGestureMale];
    
    UITapGestureRecognizer *tapGestureFemale = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FemaleMethod)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGestureFemale.cancelsTouchesInView = NO;
    
    [_g_female addGestureRecognizer:tapGestureFemale];
    
    UITapGestureRecognizer *tapGestureUnisex = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UnisexMethod)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGestureUnisex.cancelsTouchesInView = NO;
    
    [_g_unisex addGestureRecognizer:tapGestureUnisex];
    
}

-(void)settingUpTextField{
    
    self.emailTxtField.enableMaterialPlaceHolder = YES;
    self.emailTxtField.placeholder = @"Email Address";
    self.emailTxtField.errorColor = [UIColor whiteColor];
    self.emailTxtField.lineColor = [UIColor whiteColor];
    self.emailTxtField.delegate=self;
    self.emailTxtField.tag=1;
    
    
    self.passwordTxtField.enableMaterialPlaceHolder = YES;
    self.passwordTxtField.placeholder = @"Password";
    self.passwordTxtField.errorColor = [UIColor whiteColor];
    self.passwordTxtField.lineColor = [UIColor whiteColor];
    self.passwordTxtField.delegate=self;
    self.passwordTxtField.tag=2;
    
    self.confirmTxtField.enableMaterialPlaceHolder = YES;
    self.confirmTxtField.placeholder = @"Confirm password";
    self.confirmTxtField.errorColor = [UIColor whiteColor];
    self.confirmTxtField.lineColor = [UIColor whiteColor];
    self.confirmTxtField.delegate=self;
    self.confirmTxtField.tag=3;
    
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
    _scroll.contentInset = contentInsets;
    _scroll.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height+5;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [self.scroll scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scroll.contentInset = contentInsets;
    _scroll.scrollIndicatorInsets = contentInsets;
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
    if(textField==_emailTxtField)
    {
        [_emailTxtField resignFirstResponder];
        [_passwordTxtField becomeFirstResponder];
    }
    if(textField==_passwordTxtField)
    {
        [_passwordTxtField resignFirstResponder];
        [_confirmTxtField becomeFirstResponder];
        
    }
    if(textField==_confirmTxtField)
    {
        [_confirmTxtField resignFirstResponder];
        
    }
    
    return YES;
    
}

-(void)MaleMethod
{
    NSLog(@"MALE");
    genderStr=@"M";
    _g_male.backgroundColor = [UIColor clearColor];
    _g_male.alpha = 0.5;
    _g_female.backgroundColor = [UIColor clearColor];
    _g_female.alpha = 1;
    _g_unisex.backgroundColor = [UIColor clearColor];
    _g_unisex.alpha = 1;
    
}
-(void)FemaleMethod
{
    NSLog(@"FEMALE");
    genderStr=@"F";
    _g_male.backgroundColor = [UIColor clearColor];
    _g_male.alpha = 1;
    _g_female.backgroundColor = [UIColor clearColor];
    _g_female.alpha = 0.5;
    _g_unisex.backgroundColor = [UIColor clearColor];
    _g_unisex.alpha = 1;
    
    
}
-(void)UnisexMethod
{
    NSLog(@"UNISEX");
    genderStr=@"U";
    _g_male.backgroundColor = [UIColor clearColor];
    _g_male.alpha = 1;
    _g_female.backgroundColor = [UIColor clearColor];
    _g_female.alpha = 1;
    _g_unisex.backgroundColor = [UIColor clearColor];
    _g_unisex.alpha = 0.5;
    
}

-(void)setAttributesForTextField:(UITextField *)textField withPlaceholder:(NSString *)placeholder andImage:(NSString *)img andFrame:(CGRect)frame
{
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 0.5, self.view.frame.size.width, 0.5);
    
    bottomBorder.backgroundColor = [[UIColor colorWithRed:60.0/255.0 green:69.0/255.0 blue:79.0/255.0 alpha:1.0] CGColor];
    
    [textField.layer addSublayer:bottomBorder];
    
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    UIImageView * iconImageView11 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
    iconImageView11.frame = frame;
    iconImageView11.contentMode = UIViewContentModeScaleAspectFit;
    
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    textField.leftView = iconImageView11;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpBtnClick:(id)sender
{
    
    if([self validateFields])
    {
        if([_passwordTxtField.text isEqualToString: _confirmTxtField.text])
        {
            if([Utils isNetworkAvailable] ==YES)
            {
                [SVProgressHUD show];
               
                NSString *email=[NSString stringWithFormat:@"%@",self.emailTxtField.text];
                NSString *password=[NSString stringWithFormat:@"%@",self.passwordTxtField.text];
                
                NSDictionary *params = @{@"email": email,@"password":password,@"gender":genderStr,@"deviceToken":[self getDeviceToken],@"deviceType":@"IOS",@"contactNumber":@"123456789"};
                
                //NSDictionary *params = @{@"email": @"spatel@aecrodigital.com",@"password":@"sanjay1!" ,@"tournament_id":@"1",@"first_name":@"sanjay",@"sur_name":@"patel" };
                //Configure your session with common header fields like authorization etc
                NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
                NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Registration ];
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
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                   [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                   });
                             }
                             else if([status isEqualToString:@"S"])
                             {
                                
                dispatch_async(dispatch_get_main_queue(), ^{
               
                    NSDictionary *userDetailDic=[NSDictionary new];
                        userDetailDic=[responseDictionary valueForKey:@"data"];
               
                    NSString *user_id=[NSString stringWithFormat:@"%@",[userDetailDic valueForKey:@"user_id"]];
                    NSString *email=[NSString stringWithFormat:@"%@",[userDetailDic valueForKey:@"user_email"]];
                    
                    [InviteReferrals tracking:@"register" orderID:user_id purchaseValue:@"999" email:email mobile:nil name:nil referCode:nil uniqueCode:nil isDebugMode:NO
                       ComplitionHandler:^(NSMutableDictionary * irtrackingResponse)
                     {
                         NSLog(@"Tracking Response callback json will come here i.e. = %@",irtrackingResponse);
                         UIAlertController * alert=[UIAlertController
                                                         alertControllerWithTitle:@"Steezle"
                                                         message:message
                                                preferredStyle:UIAlertControllerStyleAlert];
                   
                         UIAlertAction* ok = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action)
                          {
                                 LoginVC *home = (LoginVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self.navigationController pushViewController:home animated:YES];
                          }];
                           [alert addAction:ok];
                           [self presentViewController:alert animated:YES completion:nil];
                       }];
               
               
                                               
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
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Password does not match"];
            });
            
        }
    }
    
}


//validation
-(BOOL)validateFields
{
    if(_emailTxtField.text.length==0)
    {
        
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your email address"];
        [_emailTxtField becomeFirstResponder];
        
        return NO;
    }
    if(![self validateEmailWithString:_emailTxtField.text])
    {
        return NO;
    }
    if(_passwordTxtField.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your password"];
        [_passwordTxtField becomeFirstResponder];
        return NO;
    }
    else
    {
        if (![self isValidPassword:_passwordTxtField.text])
        {
            return NO;
        }
    }
    if(_confirmTxtField.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your confirm password"];
        [_confirmTxtField becomeFirstResponder];
        return NO;
    }
//    else
//    {
//        if (![self isValidPassword:_confirmTxtField.text])
//        {
//            return NO;
//        }
//    }
    //    if(_confirmTxtField.text!=_passwordTxtField.text)
    //    {
    //        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Confirm Password do not match"];
    //        [_confirmTxtField becomeFirstResponder];
    //        return NO;
    //    }
    
//    if ([[NSString stringWithFormat:@"%@",genderStr] isEqualToString:@""])
//    {
//        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please choose gender"];
//        return NO;
//    }
  
    
    return YES;
}

// "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$" --> (Minimum 8 characters at least 1 Alphabet and 1 Number)
// "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,16}$" --> (Minimum 8 and Maximum 16 characters at least 1 Alphabet, 1 Number and 1 Special Character)
// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number)
// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)
// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,10}" --> (Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)

-(BOOL)isValidPassword:(NSString *)passwordString
{
//    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}";
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$";
    NSPredicate *passwordTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    
//    if (self.passwordTxtField.text == NULL)
//    {
//        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please Enter Password"];
//
//    }
//    else if (self.confirmTxtField.text == NULL)
//    {
//        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please Enter Confirm Password"];
//    }
//    else if (self.passwordTxtField.text == NULL && self.confirmTxtField.text == NULL)
//    {
//        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Password & Confirm Password is null"];
//    }
//    if (self.passwordTxtField.text != self.confirmTxtField.text)
//    {
//        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Password not matched"];
//    }
    
    if(![passwordTest evaluateWithObject:passwordString])
    {
        
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Password must contain at least 8  characters including 1 Uppercase Alphabet,Lowercase Alphabet,Number"];
        //[_email becomeFirstResponder];
        return NO;
    }
    
    
    return YES;
}
//validate Email With String
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if(![emailTest evaluateWithObject:email])
    {
        [_emailTxtField becomeFirstResponder];
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Email should be like: Example@gmail.com"];
        return NO;
    }
    return YES;
}
-(void)showWarningAlertWithTitle:(NSString*)title andMessage:(NSString*)msg
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
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
    });
}

- (IBAction)Act_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:TRUE];
    
}

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
@end

