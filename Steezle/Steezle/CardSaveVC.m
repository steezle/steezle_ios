//
//  CardSaveVC.m
//  Steezle
//
//  Created by Aecor Digital on 15/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "CardSaveVC.h"

@interface CardSaveVC ()
{
    UITextField *activeField;
}
@end

@implementation CardSaveVC


-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField
{
        activeField = textField;
        return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        if(textField==_FullNameTxtField)
        {
            [_FullNameTxtField resignFirstResponder];
            [_cardNumberTxtField becomeFirstResponder];
        }
        
        if(textField==_cardNumberTxtField)
        {
            [_cardNumberTxtField resignFirstResponder];
            [_ExpiryDateTxtField becomeFirstResponder];

        }
        if(textField==_ExpiryDateTxtField)
        {
            [_ExpiryDateTxtField resignFirstResponder];
            [_CVCTxtField becomeFirstResponder];

        }
        if(textField==_CVCTxtField)
        {
            [_CVCTxtField resignFirstResponder];
            //[self actionLogin:self];
        
        }
     return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _FullNameTxtField.leftView = [self PaddingView];
//    self.FullNameTxtField.leftViewMode = UITextFieldViewModeAlways;
//    self.cardNumberTxtField.leftView = [self PaddingView];
//    self.cardNumberTxtField.leftViewMode = UITextFieldViewModeAlways;
//    self.ExpiryDateTxtField.leftView = [self PaddingView];
//    self.ExpiryDateTxtField.leftViewMode = UITextFieldViewModeAlways;
//    self.CVCTxtField.leftView = [self PaddingView];
//    self.CVCTxtField.leftViewMode = UITextFieldViewModeAlways;
    [self customTextViewMethod];

    
    UIGestureRecognizer *gestureRecognizer = [[UIGestureRecognizer alloc] init];
    gestureRecognizer.delegate = self;
    [self.scrollSubView addGestureRecognizer:gestureRecognizer];
}
-(void)customTextViewMethod
{
    _FullNameTxtField.delegate=self;
    _ExpiryDateTxtField.delegate=self;
    _CVCTxtField.delegate=self;
    _cardNumberTxtField.delegate=self;
    
   CGRect frame=CGRectMake(0,0,20, 20);
    [self setAttributesForTextField:_FullNameTxtField withPlaceholder:@"Full Name" nadImage:@"" andFrame:frame];
    
    frame=CGRectMake(0,0,20, 20);
    [self setAttributesForTextField:_cardNumberTxtField withPlaceholder:@"Card Number" nadImage:@"" andFrame:frame];
    
    frame=CGRectMake(0,0,20, 20);
    [self setAttributesForTextField:_ExpiryDateTxtField withPlaceholder:@"Expiry MM/YY" nadImage:@"" andFrame:frame];
    
    frame=CGRectMake(0,0,20, 20);
    
    [self setAttributesForTextField:_CVCTxtField withPlaceholder:@"CVC" nadImage:@"" andFrame:frame];
}
-(void)setAttributesForTextField:(UITextField *)textField withPlaceholder:(NSString *)placeholder nadImage:(NSString *)img andFrame:(CGRect)frame
{
    
//    CALayer *bottomBorder = [CALayer layer];
//    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 0.5, self.view.frame.size.width, 0.5);
    
//    bottomBorder.backgroundColor = [[UIColor colorWithRed:60.0/255 green:69.0/255 blue:79.0/255 alpha:1.0] CGColor];
//
//    //    bottomBorder.borderWidth=0.5;
//    [textField.layer addSublayer:bottomBorder];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:placeholder attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"Arial" size:15.0] }];
    textField.attributedPlaceholder = str;
    
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



- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if (textField == self.FullNameTxtField)
    {
        [self.cardNumberTxtField becomeFirstResponder];
    }
    else if (textField == self.cardNumberTxtField)
    {
        //[self.view endEditing:YES];
        [self.ExpiryDateTxtField becomeFirstResponder];
    }
    else if (textField == self.ExpiryDateTxtField)
    {
        [self.CVCTxtField becomeFirstResponder];
    }
    else if (textField == self.CVCTxtField)
    {
        [self.view endEditing:YES];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)signUpBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
//    if (self.emailTxtField.text.length >0 && self.passwordTxtField.text.length >0 && self.confirmTxtField.text.length >0 ) {
//        if ([_confirmTxtField.text isEqualToString:_passwordTxtField.text]) {
//            if([Utils isNetworkAvailable] ==YES){
//                [SVProgressHUD show];
//                NSDictionary *params = @{@"email": self.emailTxtField.text,@"password":self.passwordTxtField.text,@"contactNumber":@"54325"};
//                //NSDictionary *params = @{@"email": @"spatel@aecrodigital.com",@"password":@"sanjay1!" ,@"tournament_id":@"1",@"first_name":@"sanjay",@"sur_name":@"patel" };
//                //Configure your session with common header fields like authorization etc
//                NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//                NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//                NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Registration ];
//                //NSString *url =@"https://manager.gimbal.com/api/v2/places";
//                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
//                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//                NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil]; //TODO handle error
//                [request setHTTPMethod:@"POST"];
//                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//                [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//                [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
//                [request setHTTPBody: requestData];
//                NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//                                                  {
//                                                      if (error) {
//                                                          NSLog(@"data%@",data);
//                                                          NSLog(@"response%@",error);
//                                                          [SVProgressHUD dismiss];
//                                                      } else{
//                                                          [SVProgressHUD dismiss];
//                                                          NSError *parseError = nil;
//                                                          NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//                                                          NSLog(@"%@",responseDictionary);
//                                                          NSString *message = [responseDictionary valueForKey:@"message"];
//                                                          
//                                                          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Steezle" message:message preferredStyle:UIAlertControllerStyleAlert];
//                                                          UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                              LoginVC *myVC = (LoginVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
//                                                              [self.navigationController pushViewController:myVC animated:YES];
//                                                              //[self.navigationController popViewControllerAnimated:TRUE];
//                                                          }];
//                                                          [alertController addAction:ok];
//                                                          [self presentViewController:alertController animated:YES completion:nil];
//                                                          //                                                          data =     {
//                                                          //                                                              "user_id" = 14;
//                                                          //                                                          };
//                                                          //                                                          message = "User successfully registed.";
//                                                          //                                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                                          //
//                                                          //
//                                                          //                                                          });
//                                                      }
//                                                  }];
//                [dataTask resume];
//            }else{
//                
//            }
//        }else{
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Passwords do not match" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                
//            }];
//            [alertController addAction:ok];
//            [self presentViewController:alertController animated:YES completion:nil];
//            //            self.passwordAlertView.hidden = FALSE;
//            //            self.passwordAlertTitle.text = @"Euro-Sportring";
//            //            self.passwordAlertSubTitle.text = NSLocalizedString(@"The passwords entered do not match", @"");
//        }
//    }
}

- (IBAction)BackBTNAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
@end
