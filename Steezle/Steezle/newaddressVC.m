//
//  newaddressVC.m
//  Steezle
//
//  Created by webmachanics on 10/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "newaddressVC.h"
#import "Globals.h"
#import "Utils.h"
#import "SVProgressHUD.h"
#import "userdefaultArrayCall.h"
#import "PayementVC.h"

#define FONTNAME_REG   @"HelveticaNeue"
#define FONTNAME_BOLD   @"Helvetica-Bold"
#define LFONT_10       [UIFont fontWithName:FONTNAME_BOLD size:17]
#define MAX_LENGTHPhone 10
#define MAX_LENGTHName 20
#define MAX_LENGTHPostCode 7


@interface newaddressVC ()<UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSArray *Scountry_array,*Bcountry_array;
    NSMutableArray *Sstate_array,*Bstate_array;
    int flag;
    UITextField *activeField;
    NSMutableArray *BCountry_name_array,*BState_name_array,*BState_Code_array,*BCountry_Code_array;
    NSMutableArray *SCountry_name_array,*SState_name_array,*SState_Code_array,*SCountry_Code_array;
    
    NSInteger index;
    NSString *country_Code;
    NSMutableDictionary *addressBillingDic,*addressShippingDic;
    NSMutableArray *newarray;
    UIView *viewlbl;
    
}
@end

@implementation newaddressVC
@synthesize FromPaymentPage,ArrayPassdetails;


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
            _btn_h.constant=40;
            _TitleLBL.font=LFONT_10;
            
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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    if(FromPaymentPage)
    {
        _TitleLBL.text=@"Confirm Address";
        [_SaveBTN setTitle:@"CONTINUE" forState:UIControlStateNormal];
        
        NSLog(@"%@",ArrayPassdetails);
        // newarray=[NSMutableArray new];
        // newarray=[ArrayPassdetails mutableCopy];
    }
    
    UIGestureRecognizer *gestureRecognizer = [[UIGestureRecognizer alloc] init];
    gestureRecognizer.delegate = self;
    [self.scrollView addGestureRecognizer:gestureRecognizer];
    
    //    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //    tapRecognizer.cancelsTouchesInView = NO;
    //    [self.view addGestureRecognizer:tapRecognizer];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tapGesture];
    
    [self settingUpTextField];
    
    [_switchbtn addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    [self.switchbtn setOn:NO];
    [self Get_address_ApiMethod];
    
    
    
}

-(void)hideKeyboard
{
    [_scrollView endEditing: YES];
    //    [activeField resignFirstResponder];
    
}
//- (void)handleSingleTap:(UITapGestureRecognizer *) sender
//{
//    [self.view endEditing:YES];
//}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self get_country_ApiMethod];
    
    flag=1;
    
    
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
    //    NSDictionary* info = [aNotification userInfo];
    //    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 258, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= 258;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y - (258-15));
        [_scrollView setContentOffset:scrollPoint animated:YES];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    int allowedLength = 60;
    //    viewlbl.hidden=NO;
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //
    switch(textField.tag)
    {
        case 1:
            allowedLength = MAX_LENGTHName;   // triggered for input fields with tag = 2
            break;
        case 4:
            allowedLength = MAX_LENGTHPhone;  // triggered for input fields with tag = 1
            break;
        case 8:
            allowedLength = MAX_LENGTHPostCode;  // triggered for input fields with tag = 1
            break;
        case 9:
            allowedLength = MAX_LENGTHName;  // triggered for input fields with tag = 1
            break;
        case 15:
            allowedLength = MAX_LENGTHPostCode;  // triggered for input fields with tag = 1
            break;
            
    }
    //    if(textField==_BphoneTF)
    //    {
    //        if ([str isEqualToString:@""])
    //        {
    //            viewlbl.hidden=YES;
    //            _BphoneTF.text=@"";
    //            return NO;
    //        }
    //    }
    if (textField.text.length >= allowedLength && range.length == 0)
    {
        if(textField==_BNameTF)
        {
            //[_CardNameTF resignFirstResponder];
            [_Baddress1TF becomeFirstResponder];
            
        }
        if(textField==_BphoneTF)
        {
            //[_CardNameTF resignFirstResponder];
            viewlbl.hidden=NO;
        }
        
        if(textField==_SnameTF)
        {
            //[_CardNameTF resignFirstResponder];
            [_Saddress1 becomeFirstResponder];
            
        }
        if(textField==_BpostTF)
        {
            //[_CardNameTF resignFirstResponder];
            
        }
        
        return NO;
        // Change not allowed
    }
    
    else
    {
        if ( _BphoneTF.text.length<=MAX_LENGTHPhone && _BNameTF.text.length<=MAX_LENGTHName && _BNameTF.text.length<=MAX_LENGTHName)
        {
            // return NO;
            
            if(textField==_BphoneTF)
            {
                viewlbl.hidden=NO;
                if ([str isEqualToString:@""])
                {
                    viewlbl.hidden=YES;
                    _BphoneTF.text=@"";
                    return NO;
                }
            }
            
            if (textField==_BpostTF )
            {
                if ([self range:range ContainsLocation:3]) {
                    _BpostTF.text = [self formatPhoneString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
                    return NO;
                }
                
            }
            if (textField==_SPostTF )
            {
                if ([self range:range ContainsLocation:3]) {
                    _SPostTF.text = [self formatPhoneString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
                    return NO;
                }
                
            }
        }
        
        return YES;
    }
    
    
}

-(NSString*) formatPhoneString:(NSString*) preFormatted
{
    //delegate only allows numbers to be entered, so '-' is the only non-legal char.
    NSString* workingString = [preFormatted stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //insert first '-'
    if(workingString.length > 3)
    {
        workingString = [workingString stringByReplacingCharactersInRange:NSMakeRange(3, 0) withString:@" "];
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
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    CGPoint newOffset = CGPointMake(0, textField.frame.origin.y);
//    [self.scrollView setContentOffset: newOffset animated: YES];
//}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    activeField = nil;
//}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    activeField=textField;
//    if(textField==_BNameTF)
//    {
//        [_BNameTF resignFirstResponder];
//        [_Baddress1TF becomeFirstResponder];
//    }
//    if(textField==_Baddress1TF)
//    {
//        [_Baddress1TF resignFirstResponder];
//        [_Baddress2 becomeFirstResponder];
//    }
//    if(textField==_Baddress2)
//    {
//        [_Baddress2 resignFirstResponder];
//        [_BphoneTF becomeFirstResponder];
//
//    }
//    if(textField==_BphoneTF)
//    {
//        [_BphoneTF resignFirstResponder];
//        [self BcountryAction:self];
//    }
//    if(textField==_BcityTF)
//    {
//        [_BcityTF resignFirstResponder];
//        [_BpostTF becomeFirstResponder];
//    }
//    if(textField==_BpostTF)
//    {
//        [_BpostTF resignFirstResponder];
//
//    }
//    if(textField==_SnameTF)
//    {
//        [_SnameTF resignFirstResponder];
//        [_Saddress1 becomeFirstResponder];
//    }
//    if(textField==_Saddress1)
//    {
//        [_Saddress1 resignFirstResponder];
//        [_SAddress2 becomeFirstResponder];
//    }
//    if(textField==_SAddress2)
//    {
//        [_SAddress2 resignFirstResponder];
//        [self SCountryAction:self];
//
//    }
//    if(textField==_SCityTF)
//    {
//        [_SCityTF resignFirstResponder];
//        [_SPostTF becomeFirstResponder];
//    }
//    if(textField==_SPostTF)
//    {
//        [_SPostTF resignFirstResponder];
//
//    }
//    return YES;
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)settingUpTextField
{
    
    self.BNameTF.enableMaterialPlaceHolder = YES;
    self.BNameTF.placeholder = @"Name";
    self.BNameTF.errorColor = [UIColor blackColor];
    self.BNameTF.lineColor = [UIColor grayColor];
    self.BNameTF.delegate=self;
    self.BNameTF.tag=1;
    
    self.Baddress1TF.enableMaterialPlaceHolder = YES;
    self.Baddress1TF.placeholder = @"Address Line1";
    self.Baddress1TF.errorColor = [UIColor blackColor];
    self.Baddress1TF.lineColor = [UIColor grayColor];
    self.Baddress1TF.delegate=self;
    self.Baddress1TF.tag=2;
    
    self.Baddress2.enableMaterialPlaceHolder = YES;
    self.Baddress2.placeholder = @"Address Line2";
    self.Baddress2.errorColor = [UIColor blackColor];
    self.Baddress2.lineColor = [UIColor grayColor];
    self.Baddress2.delegate=self;
    self.Baddress2.tag=3;
    
    
    viewlbl =[[UIView alloc] initWithFrame:CGRectMake(0,0,25,self.BphoneTF.frame.size.height)];
    UILabel *strLBl=[[UILabel alloc]initWithFrame:viewlbl.frame];
    strLBl.text=@"+1 ";
    [viewlbl addSubview:strLBl];
    
    self.BphoneTF.leftView=viewlbl;
    self.BphoneTF.leftViewMode=UITextFieldViewModeAlways;
    
    self.BphoneTF.enableMaterialPlaceHolder = YES;
    self.BphoneTF.placeholder = @"Phone Number";
    self.BphoneTF.errorColor = [UIColor blackColor];
    self.BphoneTF.lineColor = [UIColor grayColor];
    self.BphoneTF.delegate=self;
    self.BphoneTF.tag=4;
    
    self.BcountryTF.enableMaterialPlaceHolder = YES;
    self.BcountryTF.placeholder = @"Country";
    self.BcountryTF.errorColor = [UIColor blackColor];
    self.BcountryTF.lineColor = [UIColor grayColor];
    self.BcountryTF.delegate=self;
    self.BcountryTF.tag=5;
    
    self.BstateTF.enableMaterialPlaceHolder = YES;
    self.BstateTF.placeholder = @"State";
    self.BstateTF.errorColor = [UIColor blackColor];
    self.BstateTF.lineColor = [UIColor grayColor];
    self.BstateTF.delegate=self;
    self.BstateTF.tag=6;
    
    self.BcityTF.enableMaterialPlaceHolder = YES;
    self.BcityTF.placeholder = @"City";
    self.BcityTF.errorColor = [UIColor blackColor];
    self.BcityTF.lineColor = [UIColor grayColor];
    self.BcityTF.delegate=self;
    self.BcityTF.tag=7;
    
    self.BpostTF.enableMaterialPlaceHolder = YES;
    self.BpostTF.placeholder = @"Zip / Postal Code";
    self.BpostTF.errorColor = [UIColor blackColor];
    self.BpostTF.lineColor = [UIColor grayColor];
    self.BpostTF.delegate=self;
    self.BpostTF.tag=8;
    
    
    self.SnameTF.enableMaterialPlaceHolder = YES;
    self.SnameTF.placeholder = @"Name";
    self.SnameTF.errorColor = [UIColor blackColor];
    self.SnameTF.lineColor = [UIColor grayColor];
    self.SnameTF.delegate=self;
    self.SnameTF.tag=9;
    
    self.Saddress1.enableMaterialPlaceHolder = YES;
    self.Saddress1.placeholder = @"Address Line1";
    self.Saddress1.errorColor = [UIColor blackColor];
    self.Saddress1.lineColor = [UIColor grayColor];
    self.Saddress1.delegate=self;
    self.Saddress1.tag=10;
    
    self.SAddress2.enableMaterialPlaceHolder = YES;
    self.SAddress2.placeholder = @"Address Line2";
    self.SAddress2.errorColor = [UIColor blackColor];
    self.SAddress2.lineColor = [UIColor grayColor];
    self.SAddress2.delegate=self;
    self.SAddress2.tag=11;
    
    
    
    
    self.ScountryTF.enableMaterialPlaceHolder = YES;
    self.ScountryTF.placeholder = @"Country";
    self.ScountryTF.errorColor = [UIColor blackColor];
    self.ScountryTF.lineColor = [UIColor grayColor];
    self.ScountryTF.delegate=self;
    self.ScountryTF.tag=12;
    
    self.SstateTF.enableMaterialPlaceHolder = YES;
    self.SstateTF.placeholder = @"State";
    self.SstateTF.errorColor = [UIColor blackColor];
    self.SstateTF.lineColor = [UIColor grayColor];
    self.SstateTF.delegate=self;
    self.SstateTF.tag=13;
    
    self.SCityTF.enableMaterialPlaceHolder = YES;
    self.SCityTF.placeholder = @"City";
    self.SCityTF.errorColor = [UIColor blackColor];
    self.SCityTF.lineColor = [UIColor grayColor];
    self.SCityTF.delegate=self;
    self.SCityTF.tag=14;
    
    self.SPostTF.enableMaterialPlaceHolder = YES;
    self.SPostTF.placeholder = @"Zip / Postal Code";
    self.SPostTF.errorColor = [UIColor blackColor];
    self.SPostTF.lineColor = [UIColor grayColor];
    self.SPostTF.delegate=self;
    self.SPostTF.tag=15;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    viewlbl.hidden=NO;
//
//    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//    if(textField==_BphoneTF)
//      {
//          if ([str isEqualToString:@""])
//          {
//              viewlbl.hidden=YES;
//              _BphoneTF.text=@"";
//              return NO;
//          }
//     }
//    return YES;
//}
- (IBAction)ActBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

/* comment out this method to allow
 CZPickerView:titleForRow: to work.
 */
- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
               attributedTitleForRow:(NSInteger)row{
    NSAttributedString *att;
    
    if(flag==1)
    {
        if(index==1)
        {
            att = [[NSAttributedString alloc]
                   initWithString:BCountry_name_array[row]
                   attributes:@{
                                NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
                                }];
        }
        else
        {
            att = [[NSAttributedString alloc]
                   initWithString:BState_name_array[row]
                   attributes:@{
                                NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
                                }];
        }
    }
    else
    {
        if(index==1)
        {
            att = [[NSAttributedString alloc]
                   initWithString:SCountry_name_array[row]
                   attributes:@{
                                NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
                                }];
        }
        else
        {
            att = [[NSAttributedString alloc]
                   initWithString:SState_name_array[row]
                   attributes:@{
                                NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:15.0]
                                }];
        }
    }
    
    return att;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row
{
    if(flag==1)
    {
        if(index==1)
            return BCountry_name_array[row];//name is NsMutable Array
        else
            return BState_name_array[row];//name2 is NsMutable Array
    }
    else
    {
        if(index==1)
            return SCountry_name_array[row];//name is NsMutable Array
        else
            return SState_name_array[row];//name2 is NsMutable Array
    }
    
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    if(flag==1)
    {
        if(index==1)
            return BCountry_name_array.count;//name is NsMutable Array
        else
            return BState_name_array.count;//name2 is NsMutable Array
    }
    else
    {
        if(index==1)
            return SCountry_name_array.count;//name is NsMutable Array
        else
            return SState_name_array.count;//name2 is NsMutable Array
    }
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row
{
    
    if(flag==1)
    {
        if(index==1)
        {
            NSLog(@"%@ is chosen!", BCountry_name_array[row]);
            _BcountryTF.text=[NSString stringWithFormat:@"%@",BCountry_name_array[row]];
            [self get_state_ApiMethod:[NSString stringWithFormat:@"%@",BCountry_Code_array[row]]];
        }
        else
        {
            NSLog(@"%@ is chosen!", BState_name_array[row]);
            _BstateTF.text=[NSString stringWithFormat:@"%@",BState_name_array[row]];
            
        }
    }
    else
    {
        if(index==1)
        {
            NSLog(@"%@ is chosen!", SCountry_name_array[row]);
            _ScountryTF.text=[NSString stringWithFormat:@"%@",SCountry_name_array[row]];
            [self get_state_ApiMethod:[NSString stringWithFormat:@"%@",SCountry_Code_array[row]]];
        }
        else
        {
            NSLog(@"%@ is chosen!", SState_name_array[row]);
            _SstateTF.text=[NSString stringWithFormat:@"%@",SState_name_array[row]];
            
        }
    }
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows
{
    
    
    for (NSNumber *n in rows)
    {
        NSInteger row = [n integerValue];
        if(flag==1)
        {
            if(index==1)
            {
                NSLog(@"%@ is chosen!", BCountry_name_array[row]);
            }
            else
            {
                NSLog(@"%@ is chosen!", BState_name_array[row]);
            }
        }
        else
        {
            if(index==1)
            {
                NSLog(@"%@ is chosen!", SCountry_name_array[row]);
            }
            else
            {
                NSLog(@"%@ is chosen!", SState_name_array[row]);
            }
        }
        
    }
}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView
{
    [self.navigationController setNavigationBarHidden:YES];
    
    NSLog(@"Canceled.");
}

- (void)czpickerViewWillDisplay:(CZPickerView *)pickerView
{
    NSLog(@"Picker will display.");
}

- (void)czpickerViewDidDisplay:(CZPickerView *)pickerView
{
    NSLog(@"Picker did display.");
}

- (void)czpickerViewWillDismiss:(CZPickerView *)pickerView
{
    NSLog(@"Picker will dismiss.");
}

- (void)czpickerViewDidDismiss:(CZPickerView *)pickerView
{
    NSLog(@"Picker did dismiss.");
}


-(void)get_country_ApiMethod
{
    
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        NSDictionary *params = @{@"user_id":user_id};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,GetCountry ];
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
                             [SVProgressHUD dismiss];
                             [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                       });
                  }
                  else
                  {
                     NSError *parseError = nil;
                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                     if(flag==1)
                     {
                            Bcountry_array=[NSMutableArray new];
                            Bcountry_array =[responseDictionary[@"data"] mutableCopy];
                            NSLog(@"%@",Bcountry_array);
                            BCountry_name_array=[NSMutableArray new];
                            BCountry_Code_array=[NSMutableArray new];
                            //
                            Scountry_array=[NSMutableArray new];
                            Scountry_array =[responseDictionary[@"data"] mutableCopy];
                            NSLog(@"%@",Scountry_array);
                            SCountry_name_array=[NSMutableArray new];
                            SCountry_Code_array=[NSMutableArray new];
                            for(int i=0;i<Bcountry_array.count;i++)
                            {
                                  NSDictionary *dic = [Bcountry_array objectAtIndex:i];
                                  if([[dic valueForKey:@"code"] isEqualToString:@"US"] || [[dic valueForKey:@"code"] isEqualToString:@"CA"])
                                  {
                                       [BCountry_name_array addObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]]];
                                        [BCountry_Code_array addObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"code"]]];
                                                              
                                       [SCountry_name_array addObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]]];
                                       [SCountry_Code_array addObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"code"]]];
                                   }
                                   if(Bcountry_array.count==BCountry_Code_array.count)
                                   {
                                           [SVProgressHUD dismiss];
                                   }
                              }
                             [SVProgressHUD dismiss];
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

-(void)get_state_ApiMethod:(NSString *)countryCode
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        NSDictionary *params = @{@"user_id":user_id,@"country_code": countryCode};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,GetState ];
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
                                                  dispatch_async(dispatch_get_main_queue(), ^{
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
                                                      
                                              
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^(void){
                                                          
                                                          if([message isEqualToString:@"state not found"])
                                                          {
                                                              if(flag==1)
                                                              {
                                                                  
                                                                  self.BStateBTN.hidden=YES;
                                                                  self.BstateTF.hidden=YES;
                                                              }
                                                              else
                                                              {
                                                                  self.SStateBTN.hidden=YES;
                                                                  self.SstateTF.hidden=YES;
                                                              }
                                                              
                                                              
                                                          }
                                                         [SVProgressHUD dismiss];
                                                          
                                                      });
                                                  }
                                                  else
                                                  {
                                                      if(flag==1)
                                                      {
                                                          Bstate_array=[NSMutableArray new];
                                                          Bstate_array =[responseDictionary[@"data"] mutableCopy];
                                                          NSLog(@"%@",Bstate_array);
                                                          BState_name_array=[NSMutableArray new];
                                                          BState_Code_array=[NSMutableArray new];
                                                          for(int i=0;i<Bstate_array.count;i++)
                                                          {
                                                              NSDictionary *dic = [Bstate_array objectAtIndex:i];
                                                              [BState_name_array addObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]]];
                                                              [BState_Code_array addObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"code"]]];
                                                              
                                                              if(Bstate_array.count==BState_Code_array.count)
                                                              {
                                                                  dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                      
                                                                      self.BStateBTN.hidden=NO;
                                                                      self.BstateTF.hidden=NO;
                                                                  });
                                                                  
                                                                  [SVProgressHUD dismiss];
                                                              }
                                                          }
                                                      }
                                                      else
                                                      {
                                                          Sstate_array=[NSMutableArray new];
                                                          Sstate_array =[responseDictionary[@"data"] mutableCopy];
                                                          NSLog(@"%@",Sstate_array);
                                                          SState_name_array=[NSMutableArray new];
                                                          SState_Code_array=[NSMutableArray new];
                                                          for(int i=0;i<Sstate_array.count;i++)
                                                          {
                                                              NSDictionary *dic = [Sstate_array objectAtIndex:i];
                                                              
                                                              
                                                              [SState_name_array addObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]]];
                                                              [SState_Code_array addObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"code"]]];
                                                              
                                                              if(Sstate_array.count==SState_Code_array.count)
                                                              {
                                                                  
                                                                  dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                      self.SStateBTN.hidden=NO;
                                                                      self.SstateTF.hidden=NO;
                                                                  });
                                                                  [SVProgressHUD dismiss];
                                                              }
                                                          }
                                                      }
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
                     NSMutableArray *arraymut=[NSMutableArray new];
                     arraymut=[[responseDictionary valueForKey:@"data"] mutableCopy];
                     if([status isEqualToString:@"S"])
                     {
                        
                         dispatch_async(dispatch_get_main_queue(), ^(void)
                                        {
                                            NSDictionary *dicbilling=[NSDictionary new];
                                            dicbilling=[arraymut valueForKey:@"billing"];
                                            NSString *str=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"name"]];
                                            if(![str isEqualToString:@""])
                                            {
                                                _BNameTF.text=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"name"]];
                                                _BphoneTF.text=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"phone"]];
                                                _Baddress1TF.text=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"address_1"]];
                                                _Baddress2.text=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"address_2"]];
                                                _BcountryTF.text=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"country"]];
                                                _BstateTF.text=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"state"]];
                                                _BcityTF.text=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"city"]];
                                                _BpostTF.text=[NSString stringWithFormat:@"%@",[dicbilling valueForKey:@"postcode"]];
                                            }
                                            NSDictionary *dicshipping=[NSDictionary new];
                                            dicshipping=[arraymut valueForKey:@"shipping"];
                                            NSString *str1=[NSString stringWithFormat:@"%@",[dicshipping valueForKey:@"name"]];
                                            if(![str1 isEqualToString:@""])
                                            {
                                                _SnameTF.text=[NSString stringWithFormat:@"%@",[dicshipping valueForKey:@"name"]];
                                                _Saddress1.text=[NSString stringWithFormat:@"%@",[dicshipping valueForKey:@"address_1"]];
                                                _SAddress2.text=[NSString stringWithFormat:@"%@",[dicshipping valueForKey:@"address_2"]];
                                                _ScountryTF.text=[NSString stringWithFormat:@"%@",[dicshipping valueForKey:@"country"]];
                                                _SstateTF.text=[NSString stringWithFormat:@"%@",[dicshipping valueForKey:@"state"]];
                                                _SCityTF.text=[NSString stringWithFormat:@"%@",[dicshipping valueForKey:@"city"]];
                                                _SPostTF.text=[NSString stringWithFormat:@"%@",[dicshipping valueForKey:@"postcode"]];
                                            }
                                            [SVProgressHUD dismiss];
                                        });
                     }
                     else if([status isEqualToString:@"F"])
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

//validation
-(BOOL)validateFields
{
    
    if(_BNameTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your name"];
        [_BNameTF becomeFirstResponder];
        return NO;
        
    }
    
    if(_Baddress1TF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your address line1"];
        [_Baddress1TF becomeFirstResponder];
        return NO;
        
    }
    if(_Baddress2.text.length==0)
    {
            [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your address line2"];
            [_Baddress2 becomeFirstResponder];
            return NO;
    
    }
    if(_BphoneTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your phone number"];
        [_BphoneTF becomeFirstResponder];
        return NO;
        
    }
    else
    {
        if (![self validatePhone:_BphoneTF.text])
        {
            return NO;
        }
    }
    
    
    if(_BcountryTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please select country"];
        //        [_BcountryTF becomeFirstResponder];
        return NO;
        
    }
    if(_BstateTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please select state"];
        //        [_BstateTF becomeFirstResponder];
        return NO;
        
    }
    if(_BcityTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter city"];
        [_BcityTF becomeFirstResponder];
        return NO;
        
    }
    if(_BpostTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter Postal Code"];        [_BpostTF becomeFirstResponder];
        return NO;
        
    }
    else
    {
//        if (![self validateZipB:_BpostTF.text])
//        {
//            return NO;
//        }
    }
    if(_SnameTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your name"];
        [_SnameTF becomeFirstResponder];
        return NO;
        
    }
    
    if(_Saddress1.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your address line1"];
        [_Saddress1 becomeFirstResponder];
        return NO;
        
    }
        if(_SAddress2.text.length==0)
        {
            [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter your address line2"];
            [_SAddress2 becomeFirstResponder];
            return NO;
    
        }
    
    if(_ScountryTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please select country"];
        //        [_ScountryTF becomeFirstResponder];
        return NO;
        
    }
    if(_SstateTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please select state"];
        //        [_SstateTF becomeFirstResponder];
        return NO;
        
    }
    if(_SCityTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter city"];
        [_SCityTF becomeFirstResponder];
        return NO;
        
    }
    if(_SPostTF.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter Postal Code"];
        [_SPostTF becomeFirstResponder];
        return NO;
        
    }
    else
    {
//        if (![self validateZipS:_SPostTF.text])
//        {
//            return NO;
//        }
    }
    return YES;
    
}
- (BOOL)validateZipB:(NSString *)candidate {
    
    NSString *emailRegex = @"(^[a-zA-Z][0-9][a-zA-Z][- ]*[0-9][a-zA-Z][0-9]$)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if(![emailTest evaluateWithObject:candidate])
    {
        [_BphoneTF becomeFirstResponder];
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter a valid Postal Code"];
        return NO;
    }
   return YES;
}
- (BOOL)validateZipS:(NSString *)candidate {
    
    NSString *emailRegex = @"(^[a-zA-Z][0-9][a-zA-Z][- ]*[0-9][a-zA-Z][0-9]$)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if(![emailTest evaluateWithObject:candidate])
    {
        [_SPostTF becomeFirstResponder];
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter a valid Postal Code"];
        return NO;
    }
    return YES;
}
- (BOOL)validatePhone:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"\\+?[0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    //return [phoneTest evaluateWithObject:phoneNumber];
    
    if(![phoneTest evaluateWithObject:phoneNumber])
    {
        [_BphoneTF becomeFirstResponder];
        
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please enter a valid phone number"];
        
        return NO;
        
    }
    return YES;
}

//validate Email With String
//- (BOOL)validateEmailWithString:(NSString*)email
//{
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    if(![emailTest evaluateWithObject:email])
//    {
//        //        [_emailTxtField becomeFirstResponder];
//        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Email should be like: Example@mail.com"];
//        return NO;
//
//    }
//    return YES;
//
//}

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
//                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self.navigationController popViewControllerAnimated:YES];
                            // [self.navigationController popToRootViewControllerAnimated:YES];

                             
                         }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)SStateAction:(id)sender
{
    if (SState_name_array==nil || SState_name_array.count==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please select country"];
        
    }
    else
    {
        flag=2;
        index=2;
        CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"State" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
        picker.delegate = self;
        picker.dataSource = self;
        picker.needFooterView = YES;
        [picker show];
    }
   
}
- (IBAction)SCountryAction:(id)sender {
    
    flag=2;
    index=1;
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Country" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    [picker show];
}
- (IBAction)BcountryAction:(id)sender {
    
    flag=1;
    index=1;
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Country" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    [picker show];
}
- (IBAction)BStateAction:(id)sender {
    
    if (BState_name_array==nil || BState_name_array.count==0)
    {
        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Please select country"];
    }
    else
    {
        flag=1;
        index=2;
        CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"State" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Select"];
        picker.delegate = self;
        picker.dataSource = self;
        picker.needFooterView = YES;
        [picker show];
    }
    
}
- (IBAction)ActionSaveAddress:(id)sender
{
    if([self validateFields])
    {
        NSString *email=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USEREMAIL]];
        
        addressBillingDic = [NSMutableDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%@",_BNameTF.text],@"name",[NSString stringWithFormat:@"%@",_Baddress1TF.text], @"address1",[NSString stringWithFormat:@"%@",_Baddress2.text],@"address2",[NSString stringWithFormat:@"%@",_BphoneTF.text], @"phone",[NSString stringWithFormat:@"%@",_BcountryTF.text],@"country",[NSString stringWithFormat:@"%@",_BstateTF.text], @"state",[NSString stringWithFormat:@"%@",_BcityTF.text],@"city",[NSString stringWithFormat:@"%@",_BpostTF.text], @"postcode",email,@"email",nil];
        
        addressShippingDic = [NSMutableDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%@",_SnameTF.text],@"name",[NSString stringWithFormat:@"%@",_Saddress1.text], @"address1",[NSString stringWithFormat:@"%@",_SAddress2.text],@"address2",[NSString stringWithFormat:@"%@",_ScountryTF.text],@"country",[NSString stringWithFormat:@"%@",_SstateTF.text], @"state",[NSString stringWithFormat:@"%@",_SCityTF.text],@"city",[NSString stringWithFormat:@"%@",_SPostTF.text], @"postcode",nil];
        
        
        [self Set_address_apicalling];
        
    }
}

- (void) switchToggled:(id)sender
{
    if ([_switchbtn isOn])
    {
        NSLog(@"its on!");
        _SnameTF.text=[NSString stringWithFormat:@"%@",_BNameTF.text];
        _Saddress1.text=[NSString stringWithFormat:@"%@",_Baddress1TF.text];
        _SAddress2.text=[NSString stringWithFormat:@"%@",_Baddress2.text];
        _ScountryTF.text=[NSString stringWithFormat:@"%@",_BcountryTF.text];
        _SstateTF.text=[NSString stringWithFormat:@"%@",_BstateTF.text];
        _SCityTF.text=[NSString stringWithFormat:@"%@",_BcityTF.text];
        _SPostTF.text=[NSString stringWithFormat:@"%@",_BpostTF.text];
    }
    else
    {
        NSLog(@"its off!");
        _SnameTF.text=nil;
        _Saddress1.text=nil;
        _SAddress2.text=nil;
        _ScountryTF.text=nil;
        _SstateTF.text=nil;
        _SCityTF.text=nil;
        _SPostTF.text=nil;
    }
}
-(void)Set_address_apicalling
{
    if([Utils isNetworkAvailable] ==YES)
    {
        
        NSError *error=nil;
        
        [SVProgressHUD show];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:addressBillingDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:addressShippingDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString1 = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
        
        
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        
        NSDictionary *params = @{@"user_id":user_id,@"billing":jsonString,@"shipping":jsonString1};
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,SetAddress ];
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
                                                  
                        NSError *parseError = nil;
                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                        NSLog(@"%@",responseDictionary);
                       NSString *message = [responseDictionary valueForKey:@"message"];
                        NSString *status=[responseDictionary valueForKey:@"status"];
                      if([status isEqualToString:@"S"])
                      {
                               dispatch_async(dispatch_get_main_queue(), ^(void){
                                                          
                                  NSString *addstr=[NSString stringWithFormat:@"%@,\n%@, %@, %@, %@, %@, %@",[addressShippingDic valueForKey:@"name"],[addressShippingDic valueForKey:@"address1"],[addressShippingDic valueForKey:@"address2"],[addressShippingDic valueForKey:@"city"],[addressShippingDic valueForKey:@"state"],[addressShippingDic valueForKey:@"country"],[addressShippingDic valueForKey:@"postcode"]];
                                                          
                                 [[NSUserDefaults standardUserDefaults] setObject:addstr forKey:@"Address_shiping"];
                                 [[NSUserDefaults standardUserDefaults]synchronize];
                                                          
                                 if(FromPaymentPage)
                                 {
                                    [SVProgressHUD dismiss];
                                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                     PayementVC *paymentpagevc = (PayementVC *)[storyboard instantiateViewControllerWithIdentifier:@"PayementVC"];
                                     paymentpagevc.SaveCardWithPayDetArr= ArrayPassdetails.mutableCopy;
                                     [self.navigationController pushViewController:paymentpagevc animated:YES];
                                  }
                                 else
                                 {
                                      [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                       [SVProgressHUD dismiss];
                                 }
                             });
                      }
                      else if([status isEqualToString:@"F"])
                      {
                          dispatch_async(dispatch_get_main_queue(), ^(void){
                              [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                              [SVProgressHUD dismiss];
                          });
                      }
                      else
                      {
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
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [SVProgressHUD dismiss];
            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
    }
}

- (IBAction)ActEdit:(id)sender
{
    
    _BNameTF.text=nil;
    _Baddress1TF.text=nil;
    _Baddress2.text=nil;
    _BcountryTF.text=nil;
    _BstateTF.text=nil;
    _BcityTF.text=nil;
    _BpostTF.text=nil;
    _BphoneTF.text=nil;
    viewlbl.hidden=YES;
    
    
    _SnameTF.text=nil;
    _Saddress1.text=nil;
    _SAddress2.text=nil;
    _ScountryTF.text=nil;
    _SstateTF.text=nil;
    _SCityTF.text=nil;
    _SPostTF.text=nil;
    
}

@end

