//
//  LoginVC.m
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.


#import "LoginVC.h"
#import "Globals.h"
#import <Google/SignIn.h>
#import "Utils.h"
#import "SVProgressHUD.h"
#import "HomeView.h"
//#import "measurementsVC.h"
#import "ForgotPasswordVC.h"
#import "HomeTabBar.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <QuartzCore/QuartzCore.h>
#import "userdefaultArrayCall.h"
#import "InviteReferrals.h"
#define MAX_LENGTHEMAIL 64
#define MAX_LENGTHPASSWORD 16
@interface LoginVC ()<GIDSignInDelegate,GIDSignInUIDelegate>
{
    UITextField *activeField;
    BOOL keyboardVisible;
    CGPoint offset;
    NSMutableArray *social_data_array;
    NSString *social_type;
    //    MBProgressHUD *hud;
    
    
}

@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@end

@implementation LoginVC


-(UIView *)PaddingView
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    [application setStatusBarHidden:NO];
    
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
            
            _logo_w.constant=60;
            _logo_h.constant=60;
            _emailH.constant=40;;
            _passH.constant=40;
            _passBTNH.constant=20;
            _signINH.constant=40;
            _GFH.constant=40;
            //            _logoY.constant=70;
            //  smallFonts = true;
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


#pragma mark- keyboard related methods

-(void) keyboardWasShown: (NSNotification *)infoi
{
    NSDictionary* info = [infoi userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollview.contentInset = contentInsets;
    _scrollview.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [_scrollview setContentOffset:scrollPoint animated:YES];
    }
    
}

-(void) keyboardWillBeHidden: (NSNotification *)notif
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollview.contentInset = contentInsets;
    _scrollview.scrollIndicatorInsets = contentInsets;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
// method to hide keyboard when user taps on a scrollview

-(void)hideKeyboard
{
    [_scrollview endEditing: YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    activeField=textField;
    if(textField==_email)
    {
        [_email resignFirstResponder];
        [_password becomeFirstResponder];
    }
    if(textField==_password)
    {
        [_password resignFirstResponder];
        [self loginBtnClick:self];
    }
    
    return YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectMake(0, _facebookBTN.frame.origin.y, _facebookBTN.frame.size.width, _facebookBTN.frame.size.height)];
    //
    //        [self.facebookBTN addSubview:loginButton];
    
    [SVProgressHUD setForegroundColor:[UIColor blackColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    
    
    [[GIDSignIn sharedInstance] setClientID:@"8989533889-qk0rijcliqsthdo1loajf8rfs6s4v4u2.apps.googleusercontent.com"];
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [self.signInButton addTarget:self action:@selector(onGoogleSignInClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.signInButton setStyle:kGIDSignInButtonStyleWide];

    
    social_data_array =[NSMutableArray new];
    [self settingUpTextField];
    // Do any additional setup after loading the view.
    //    self.email.leftView = [self PaddingView];
    //    self.email.leftViewMode = UITextFieldViewModeAlways;
    //    self.password.leftView = [self PaddingView];
    //    self.password.leftViewMode = UITextFieldViewModeAlways;
    UIColor *color = [UIColor whiteColor];
    self.email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    //    UIGestureRecognizer *gestureRecognizer = [[UIGestureRecognizer alloc] init];
    //    gestureRecognizer.delegate = self;
    //    [self.scrollview addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    tapGesture.cancelsTouchesInView = NO;
    
    [_scrollview addGestureRecognizer:tapGesture];
}
-(void)loginButton
{
    NSLog(@"hell");
    
}
-(void)settingUpTextField
{
    
    self.email.enableMaterialPlaceHolder = YES;
    self.email.placeholder = @"Email Address";
    self.email.errorColor = [UIColor whiteColor];
    self.email.lineColor = [UIColor whiteColor];
    self.email.delegate=self;
    self.email.tag=1;
    
    
    self.password.enableMaterialPlaceHolder = YES;
    self.password.placeholder = @"Password";
    self.password.errorColor = [UIColor whiteColor];
    self.password.lineColor = [UIColor whiteColor];
    self.password.delegate=self;
    self.password.tag=2;
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidEndEditing:(UITextField*)textField
{
    activeField = nil;
}


- (IBAction)loginBtnClick:(id)sender
{
    
    if([self validateFields])
    {
        if([Utils isNetworkAvailable] ==YES)
        {
            [SVProgressHUD show];
            //            [self showProgressBar];
            
            NSDictionary *params = @{@"email": self.email.text,@"password":self.password.text,@"social_data":@"",@"deviceType":@"IOS",@"deviceToken":[self getDeviceToken]};
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
            NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Login ];
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
                                  [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                       });
                   }
                   else
                   {
                             NSError *parseError = nil;
                             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                             NSLog(@"%@",responseDictionary);
                             NSString *message = [responseDictionary valueForKey:@"message"];
                             NSString *status=[responseDictionary valueForKey:@"status"];
                             if([status isEqualToString:@"F"])
                             {
                                   //[self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                  dispatch_async(dispatch_get_main_queue(), ^(void){
                                           [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                           [SVProgressHUD dismiss];
                                   });
                             }
                                                      else if ([status isEqualToString:@"S"])
                                                      {
                                                          
                                                          dispatch_async(dispatch_get_main_queue(), ^(void){
                                                              
                                                              NSDictionary *userDetailDic=[NSDictionary new];
                                                              userDetailDic=[responseDictionary valueForKey:@"data"];
                                                              [[NSUserDefaults standardUserDefaults] setObject:@"SYSTEM" forKey:SocialType];
                                                              [[NSUserDefaults standardUserDefaults] setObject:[userDetailDic valueForKey:@"bag_count"] forKey:Total_Cart];
                                                              [[NSUserDefaults standardUserDefaults] setObject:[userDetailDic valueForKey:@"total_steez"] forKey:Total_Steez];
                                                              
                                                              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"user_email"] forKey:USEREMAIL];
                                                              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"user_id"] forKey:USERID];
                                                              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"first_name"] forKey:FIRSTNAME];
                                                              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"last_name"] forKey:LASTNAME];
                                                              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"gender"] forKey:GENDER];
                                                              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"contact_number"] forKey:CONTACT];
                                                              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"profile_pic"] forKey:PROFILEIMAGE];
                                                              [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SKIPUSER];
                                                              [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOGGED_IN];
                                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                                              //                             [self hideProgressBar];
                                                              [SVProgressHUD dismiss];
                                                              HomeTabBar *home = (HomeTabBar *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                                                              [self.navigationController pushViewController:home animated:YES];
                                                              //                            measurementsVC *home = (measurementsVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"measurementsVC"];
                                                              //                            [self.navigationController pushViewController:home animated:YES];
                                                              
                                                              // HomeTabBar *home = (HomeTabBar *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                                                              //                            [self.navigationController pushViewController:home animated:YES];
                                                          });
                                                          
                                                      }
                                                      else
                                                      {
                                                          dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                         {
                                                                             [SVProgressHUD dismiss];
                                                                             [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
                                                                         });
                                                          // [self.navigationController pushViewController:home animated:YES];
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
    
}

- (IBAction)forgotPasswordBtnClick:(id)sender
{
    
    ForgotPasswordVC *myVC = (ForgotPasswordVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

- (IBAction)backBtnClick:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)onGoogleSignInClicked {
    [SVProgressHUD show];
}

- (IBAction)Act_google:(id)sender
{
    social_type=@"GOOGLE";
    NSLog(@"%@",[[GIDSignIn sharedInstance] currentUser]);
    [[GIDSignIn sharedInstance] signIn];
}
- (IBAction)didTapSignOut:(id)sender
{
    [[GIDSignIn sharedInstance] signOut];
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;
    // For client-side use only!
    NSString *idToken = user.authentication.idToken;
    // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    NSString *urlStr;
    social_data_array = [[NSMutableArray alloc] init];
    
    
    if (user.profile.hasImage)
    {
        NSURL *url = [user.profile imageURLWithDimension:100];
        NSLog(@"url : %@",url);
        urlStr=[url absoluteString];
    }
    
    NSLog(@"UserID %@ ",userId);
    NSLog(@"idToken %@ ",idToken);
    NSLog(@"fullName %@ ",fullName);
    NSLog(@"givenName %@ ",givenName);
    NSLog(@"familyName %@ ",familyName);
    NSLog(@"email %@ ",email);
    NSLog(@"image %@ ",urlStr);
    
    if(email==nil)
    {
        email=@"";
    }
    if(fullName==nil)
    {
        fullName=@"";
    }
    if(urlStr==nil)
    {
        urlStr=@"";
    }
    if(idToken==nil)
    {
        idToken=@"";
    }
    else
    {
        [social_data_array addObject:userId];
        [social_data_array addObject:idToken];
        [social_data_array addObject:fullName];
        [social_data_array addObject:givenName];
        [social_data_array addObject:familyName];
        [social_data_array addObject:email];
        [social_data_array addObject:urlStr];
        
        [self loginWithGoogleSignApiandemail:email andsocial_id:idToken andFirst_Name:givenName andLast_Name:familyName andGender:@"" andProfile_pic:urlStr];
    }
    
    
        //        [self callLoginWithGmailApiWithSocialId:idToken email:email userName:fullName andProfilePic:urlStr];
    
}
-(BOOL)validateFields
{
    if(_email.text.length==0 && _password.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"The username or password is empty please try again"];
        [_email becomeFirstResponder];
    }
    if(_email.text.length==0)
    {
        
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your email address"];
        [_email becomeFirstResponder];
        
        return NO;
    }
    else
    {
        if(![self validateEmailWithString:_email.text])
        {
            return NO;
        }
    }
    if(_password.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your password"];
        [_password becomeFirstResponder];
        return NO;
    }
    //    else
    //    {
    //        if (![self isValidPassword:_password.text])
    //        {
    //            return NO;
    //        }
    //    }
    
    
    
    return YES;
}



// *** Validation for Password ***

// "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$" --> (Minimum 8 characters at least 1 Alphabet and 1 Number)
// "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,16}$" --> (Minimum 8 and Maximum 16 characters at least 1 Alphabet, 1 Number and 1 Special Character)
// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number)
// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)
// "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,10}" --> (Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)

-(BOOL)isValidPassword:(NSString *)passwordString
{
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{6,}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    if(![passwordTest evaluateWithObject:passwordString])
    {
        
        [self showWarningAlertWithTitle:@"Invalid Password" andMessage:@"Password must contain at least 8  characters including 1 Uppercase Alphabet,Lowercase Alphabet,Number"];
        //[_email becomeFirstResponder];
        return NO;
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    int allowedLength = 0;
    switch(textField.tag)
    {
        case 1:
            allowedLength = MAX_LENGTHEMAIL;  // triggered for input fields with tag = 1
            break;
        case 2:
            allowedLength = MAX_LENGTHPASSWORD;   // triggered for input fields with tag = 2
            break;
            
    }
    
    if (textField.text.length >= allowedLength && range.length == 0)
    {
        return NO; // Change not allowed
    }
    
    else
    {
        return YES; // Change allowed
    }
    
    
}
//validate Email With String
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

- (IBAction)Act_facebook:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//            if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"fb://profile/1396934647119692"]])
//            {
//                  login.loginBehavior = FBSDKLoginBehaviorSystemAccount;
//                  //login.loginBehavior = FBSDKLoginBehaviorWeb;
//
//            }
    [login logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         [SVProgressHUD show];
         if (error)
         {
             [SVProgressHUD dismiss];
             NSLog(@"Unexpected login error: %@", error);
             NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
             NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
             [[[UIAlertView alloc] initWithTitle:alertTitle
                                         message:alertMessage
                                        delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil] show];
         }
         else
         {
             if(result.token)   // This means if There is current access token.
             {
                 
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                    parameters:@{@"fields": @"id,name,email,gender,first_name,last_name,picture.type(large)"}]
                  
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                  {
                      if (!error)
                      {
                          
                          NSString *fbPhotoUrl = [[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"];
                          
                          NSLog(@"%@",fbPhotoUrl);
                          
                          NSLog(@"Details user:%@",result);
                          
                          social_data_array = [[NSMutableArray alloc] init];
                          NSMutableDictionary *dic=[NSMutableDictionary new];
                          [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"email"] ] forKey:@"email"];
                          [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"first_name"] ] forKey:@"first_name"];
                          [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"gender"] ] forKey:@"gender"];
                          [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"id"] ] forKey:@"id"];
                          [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"last_name"] ] forKey:@"last_name"];
                          [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"name"] ] forKey:@"name"];
                          [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"picture"] ] forKey:@"picture"];
                          social_data_array =[dic mutableCopy];
                          
                          // [social_data_array addObject:dic];
                          // social_data_array=[result mutableCopy];
                          // [login logOut];
                          // [FBSDKProfile setCurrentProfile:nil];
                          // [FBSDKAccessToken setCurrentAccessToken:nil];
                          
                          [self loginWithFacebookApiandemail:[result valueForKey:@"email"] andsocial_id:[result valueForKey:@"id"] andFirst_Name:[result valueForKey:@"first_name"] andLast_Name:[result valueForKey:@"last_name"] andGender:[result valueForKey:@"gender"] andProfile_pic:fbPhotoUrl];
                          
                      }
                      else
                      {
                          [SVProgressHUD dismiss];
                          NSLog(@"%@", [error localizedDescription]);
                      }
                      
                  }];
             }
             else if (result.isCancelled)
             {
                 //[self facebookLoginFailed:NO];
                 [SVProgressHUD dismiss];
             }
             NSLog(@"Login Cancel");
         }
         
     }];
    
    [SVProgressHUD dismiss];
    
    //        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    //        [loginManager logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    //         {
    //            //TODO: process error or result.
    //            if (error)
    //            {
    //                NSLog(@"Process error");
    //                [self facebookLoginFailed:YES];
    //            }
    //            else if (result.isCancelled)
    //            {
    //                [self facebookLoginFailed:NO];
    //
    //            }
    //            else
    //            {
    //                [SVProgressHUD show];
    //                if ([FBSDKAccessToken currentAccessToken])
    //                {
    //                    NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
    //
    //                    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    //                    [parameters setValue:@"id,name,email,gender,first_name,last_name,picture.type(large)" forKey:@"fields"];
    //
    //                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
    //                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
    //                    {
    //                         if (!error)
    //                         {
    //                             NSString *fbPhotoUrl = [[[result objectForKey:@"picture"]objectForKey:@"data"]objectForKey:@"url"];
    //
    //                             NSLog(@"%@",fbPhotoUrl);
    //
    //                             NSLog(@"Details user:%@",result);
    //
    //                             social_data_array = [[NSMutableArray alloc] init];
    //
    //                             NSMutableDictionary *dic=[NSMutableDictionary new];
    //                             [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"email"] ] forKey:@"email"];
    //                             [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"first_name"] ] forKey:@"first_name"];
    //                             [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"gender"] ] forKey:@"gender"];
    //                             [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"id"] ] forKey:@"id"];
    //                             [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"last_name"] ] forKey:@"last_name"];
    //                             [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"name"] ] forKey:@"name"];
    //                             [dic setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"picture"] ] forKey:@"picture"];
    //
    //                             social_data_array =[dic mutableCopy];
    ////                             [social_data_array addObject:dic];
    //
    //
    ////                             social_data_array=[result mutableCopy];
    //
    //
    //                             [self loginWithFacebookApiandemail:[result valueForKey:@"email"] andsocial_id:[result valueForKey:@"id"] andFirst_Name:[result valueForKey:@"first_name"] andLast_Name:[result valueForKey:@"last_name"] andGender:[result valueForKey:@"gender"] andProfile_pic:fbPhotoUrl];
    //
    //                             [SVProgressHUD dismiss];
    //
    //                         }
    //                     }];
    //                }
    //                else {
    //                        [SVProgressHUD dismiss];
    //                    [self facebookLoginFailed:YES];
    //                }
    //            }
    //        }];
    
    
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if (!error)
    {
        if ([FBSDKAccessToken currentAccessToken])
        {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.type(large), email, name, id"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
             {
                 if (!error)
                 {
                     //Perform your logic & then logout using below code
                     FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
                     [loginManager logOut];
                 }
             }];
        }
    }
}
-(void)loginWithGoogleSignApiandemail:(NSString *)Email andsocial_id:(NSString *)Social_id andFirst_Name:(NSString *)first_name andLast_Name:(NSString *)last_name andGender:(NSString *)gender andProfile_pic:(NSString *)profile_pic
{
    social_type=@"GOOGLE";
    
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSError *error=nil;
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:social_data_array options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSDictionary *params = @{@"email":Email,@"first_name":first_name,@"profile_pic":profile_pic,@"gender":gender,@"last_name":last_name,@"socialid":Social_id,@"socialdata":jsonString,@"deviceType":@"IOS",@"social_type":social_type};
        //,@"deviceToken":[self getDeviceToken]
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,SocialLogin ];
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
                                                  
                                                  [[NSUserDefaults standardUserDefaults] setObject:[responseDictionary valueForKey:@"bag_count"] forKey:Total_Cart];
                                                  [[NSUserDefaults standardUserDefaults] setObject:[responseDictionary valueForKey:@"total_steez"] forKey:Total_Steez];
                                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                                  
                                                  if([status isEqualToString:@"F"])
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^(void){
                                                          [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                                      });
                                                      
                                                      
                                                  }
                                                  else if ([status isEqualToString:@"S"])
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^(void){
                                                          
                                                          NSDictionary *userDetailDic=[NSDictionary new];
                                                          userDetailDic=[responseDictionary valueForKey:@"data"];
                                                          
                                                          [[NSUserDefaults standardUserDefaults] setObject:social_type forKey:SocialType];
                                                          
                                                          [[NSUserDefaults standardUserDefaults] setObject:[userDetailDic valueForKey:@"bag_count"] forKey:Total_Cart];
                                                          [[NSUserDefaults standardUserDefaults] setObject:[userDetailDic valueForKey:@"total_steez"] forKey:Total_Steez];
                                                          
                                                          [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"user_email"] forKey:USEREMAIL];
                                                          [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"user_id"] forKey:USERID];
                                                          [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"first_name"] forKey:FIRSTNAME];
                                                          [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"last_name"] forKey:LASTNAME];
                                                          [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"gender"] forKey:GENDER];
                                                          
                                                          NSString *contact=[userDetailDic valueForKey:@"contact_number"];
                                                          if([contact isKindOfClass:[NSNull class]])
                                                          {
                                                              //  [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"contact_number"] forKey:CONTACT];
                                                          }
                                                          else
                                                              
                                                          {
                                                              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"contact_number"] forKey:CONTACT];
                                                          }
                                                          [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"profile_pic"] forKey:PROFILEIMAGE];
                                                          [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SKIPUSER];
                                                          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOGGED_IN];
                                                          [[NSUserDefaults standardUserDefaults] synchronize];
             NSString *user_id=[NSString stringWithFormat:@"%@",[userDetailDic valueForKey:@"user_id"]];
              NSString *email=[NSString stringWithFormat:@"%@",[userDetailDic valueForKey:@"user_email"]];
              [InviteReferrals tracking:@"register" orderID:user_id purchaseValue:@"999" email:email mobile:nil name:nil referCode:nil uniqueCode:nil isDebugMode:NO
                   ComplitionHandler:^(NSMutableDictionary * irtrackingResponse)
                  {
                     NSLog(@"Tracking Response callback json will come here i.e. = %@",irtrackingResponse);
                     [SVProgressHUD dismiss];
                      HomeTabBar *home = (HomeTabBar *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                      [self.navigationController pushViewController:home animated:YES];
                  }];
                                                          
                 [SVProgressHUD dismiss];
                                                         
                                                          //                                     measurementsVC *measurement = (measurementsVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"measurementsVC"];
                                                          //                                     [self.navigationController pushViewController:measurement animated:YES];
                                                          
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

-(void)loginWithFacebookApiandemail:(NSString *)Email andsocial_id:(NSString *)Social_id andFirst_Name:(NSString *)first_name andLast_Name:(NSString *)last_name andGender:(NSString *)gender andProfile_pic:(NSString *)profile_pic
{
    social_type=@"FACEBOOK";
    
    if([Utils isNetworkAvailable] ==YES)
    {
        
        NSError *error=nil;
        
        [SVProgressHUD show];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:social_data_array options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSDictionary *params = @{@"email":Email,@"first_name":first_name,@"profile_pic":profile_pic,@"last_name":last_name,@"socialid":Social_id,@"socialdata":jsonString,@"deviceType":@"IOS",@"social_type":social_type};
        //@"deviceToken":[self getDeviceToken]
        //@"gender":gender,
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,SocialLogin ];
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
                         [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                         
                     });
    }
    else
    {
      
      NSError *parseError = nil;
      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
      NSLog(@"%@",responseDictionary);
      NSString *message = [responseDictionary valueForKey:@"message"];
      NSString *status=[responseDictionary valueForKey:@"status"];
      
      if([status isEqualToString:@"F"])
      {
          
          dispatch_async(dispatch_get_main_queue(), ^(void)
                         {
                             [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                             [SVProgressHUD dismiss];
                         });
          
      }
      else if ([status isEqualToString:@"S"])
      {
          dispatch_async(dispatch_get_main_queue(), ^(void){
              
              NSDictionary *userDetailDic=[NSDictionary new];
              userDetailDic=[responseDictionary valueForKey:@"data"];
              
              [[NSUserDefaults standardUserDefaults] setObject:social_type forKey:SocialType];
              
              [[NSUserDefaults standardUserDefaults] setObject:[userDetailDic valueForKey:@"bag_count"] forKey:Total_Cart];
              [[NSUserDefaults standardUserDefaults] setObject:[userDetailDic valueForKey:@"total_steez"] forKey:Total_Steez];
              
              NSLog(@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:Total_Cart]);
              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"user_email"] forKey:USEREMAIL];
              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"user_id"] forKey:USERID];
              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"first_name"] forKey:FIRSTNAME];
              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"last_name"] forKey:LASTNAME];
              [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"gender"] forKey:GENDER];
              //                            NSString *first_name=[[NSUserDefaults standardUserDefaults] valueForKey:FIRSTNAME];
              //                            NSString *last_name=[[NSUserDefaults standardUserDefaults] valueForKey:LASTNAME];
              //                            NSString *full_name=[first_name stringByAppendingString:[NSString stringWithFormat:@"%@ ",last_name]];
              
              //                            [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"gender"] forKey:FULLNAME];
              
              NSString *contact=[userDetailDic valueForKey:@"contact_number"];
              if([contact isKindOfClass:[NSNull class]])
              {
                  //    [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"contact_number"] forKey:CONTACT];
                  
              }
              else
                  
              {
                  [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"contact_number"] forKey:CONTACT];
              }
              
              NSString *profile=[userDetailDic valueForKey:@"profile_pic"];
              if([profile isKindOfClass:[NSNull class]])
              {
                  
              }
              else
              {
                   [[NSUserDefaults standardUserDefaults]setObject:[userDetailDic valueForKey:@"profile_pic"] forKey:PROFILEIMAGE];
              }
             
              [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SKIPUSER];
              [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOGGED_IN];
              [[NSUserDefaults standardUserDefaults] synchronize];
                                                         
                   NSString *user_id=[NSString stringWithFormat:@"%@",[userDetailDic valueForKey:@"user_id"]];
                   NSString *email=[NSString stringWithFormat:@"%@",[userDetailDic valueForKey:@"user_email"]];
                                                          
                   [InviteReferrals tracking:@"register" orderID:user_id purchaseValue:@"999" email:email mobile:nil name:nil referCode:nil uniqueCode:nil isDebugMode:NO
                    ComplitionHandler:^(NSMutableDictionary * irtrackingResponse)
                    {
                            NSLog(@"Tracking Response callback json will come here i.e. = %@",irtrackingResponse);
                            [SVProgressHUD dismiss];
                            HomeTabBar *home = (HomeTabBar *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                            [self.navigationController pushViewController:home animated:YES];
                    }];
                                                          
                   [SVProgressHUD dismiss];
                                                          
                          //                            measurementsVC *measurement = (measurementsVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"measurementsVC"];
                          //                            [self.navigationController pushViewController:measurement animated:YES];
              
              
                      });
                  }
                  else
                  {
                      dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           [SVProgressHUD dismiss];
                           [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
                       });
                      // [self.navigationController pushViewController:home animated:YES];
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
- (void)facebookLoginFailed:(BOOL)isFBResponce{
    
    if(isFBResponce)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"pop_attention", nil) message:NSLocalizedString(@"request_error", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"pop_ok", nil) otherButtonTitles: nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"pop_attention", nil) message:NSLocalizedString(@"loginfb_cancelled", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"pop_ok", nil) otherButtonTitles: nil];
        [alert show];
    }
}

//google sign in
// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button

//- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
//{
//    [myActivityIndicator stopAnimating];
//}

// Present a view that prompts the user to sign in with Google

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    [SVProgressHUD dismiss];
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//show loading process

//-(void)showProgressBar
//{
//    hud= [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    hud.mode=MBProgressHUDModeIndeterminate;
//    hud.label.text = NSLocalizedString(@"Loading", @"Loading");
//    [hud.bezelView setBackgroundColor:[UIColor whiteColor]];
//    hud.contentColor = [UIColor blackColor];
//
//}
//
//
//-(void)hideProgressBar
//{
//    [hud hideAnimated:YES];
//
//}
- (IBAction)Act_skip:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SKIPUSER];
    [[NSUserDefaults standardUserDefaults]synchronize];
    HomeTabBar *home = (HomeTabBar *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
    [self.navigationController pushViewController:home animated:YES];
    
}

@end

