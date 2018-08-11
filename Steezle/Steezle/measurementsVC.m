 //
//  measurementsVC.m
//  Steezle
//
//  Created by webmachanics on 08/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "measurementsVC.h"
#import "HomeTabBar.h"
#import "Globals.h"
#import "Utils.h"
#import "SVProgressHUD.h"
#import "userdefaultArrayCall.h"
#define FONTNAME_REG   @"open-sans.regular"
#define LFONT_10         [UIFont fontWithName:FONTNAME_REG size:10]

#define MAX_LENGTH 5

@interface measurementsVC ()<UITextFieldDelegate>
{
    UITextField *activeField;
    BOOL keyboardVisible;
    CGPoint offset;
    NSInteger index;
    NSMutableDictionary *DicMeasurement;
    NSMutableArray *ArrShoulder,*ArrChest,*ArrWaist,*ArrInseam,*ArrNeck,*ArrArm;
    NSString *Str_shoulder,*Str_Chest,*Str_Waist,*Str_Inseam,*Str_Neck,*Str_Arm;
    
}
@end

@implementation measurementsVC
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
            _sH.constant=50;
            _WW.constant=50;
            _NW.constant=50;
            _AW.constant=50;
            _IW.constant=50;
            _CW.constant=50;
            _ContH.constant=40;
            _laterH.constant=40;
            
            _shoulderTXT.font=LFONT_10;
            _chestTXT.font=LFONT_10;
            _waistTXT.font=LFONT_10;
            _NeckTXT.font=LFONT_10;
            _ArmTXT.font=LFONT_10;
            _InseamTXT.font=LFONT_10;
            
           
            // smallFonts = true;
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

-(void) keyboardWillBeHidden: (NSNotification *)notif
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
    if(textField==_shoulderTXT)
    {
        [_shoulderTXT resignFirstResponder];
        [_chestTXT becomeFirstResponder];
    }
    if(textField==_chestTXT)
    {
        [_chestTXT resignFirstResponder];
        [_waistTXT becomeFirstResponder];

    }
    if(textField==_waistTXT)
    {
        [_waistTXT resignFirstResponder];
        [_InseamTXT becomeFirstResponder];
    }
    if(textField==_InseamTXT)
    {
        [_InseamTXT resignFirstResponder];
        [_NeckTXT becomeFirstResponder];
    }
    if(textField==_NeckTXT)
    {
        [_NeckTXT resignFirstResponder];
        [_ArmTXT becomeFirstResponder];
    }
    if(textField==_ArmTXT)
    {
        [_ArmTXT resignFirstResponder];
        [self ActSaveCont:self];
    }
    
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    switch(textField.tag)
    {
        case 1:
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
        case 2:
            if(![self ValidationOntextField:textField andRamge:range replacementString:string])
            {
                return NO;
            }
            if (textField.text.length >= MAX_LENGTH && range.length == 0)
            {
                return NO;
            }
            
            break;
        case 3:
            if(![self ValidationOntextField:textField andRamge:range replacementString:string])
            {
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
    }
    return YES;
}

-(BOOL)MethodForValidationCheck:(UITextField *)textField
{
    
    NSString *stringValue = textField.text;
    float integer = [stringValue floatValue];
    if (integer <10 || integer > 100)
        // You can make the text red here for example
        return NO;
    else
        return YES;
}
-(BOOL)validateFieldsForMeasurment
{
    if(_shoulderTXT.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter shoulder"];
        [_shoulderTXT becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_shoulderTXT])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Shoulder field"];
        [_shoulderTXT becomeFirstResponder];
        return NO;
    }
    if(_chestTXT.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter Chest"];
        [_chestTXT becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_chestTXT])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Chest field"];
        [_chestTXT becomeFirstResponder];
        return NO;
    }
    if(_waistTXT.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter waist"];
        [_waistTXT becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_waistTXT])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Waist field"];
        [_waistTXT becomeFirstResponder];
        return NO;
    }
    if(_InseamTXT.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter inseam"];
        [_InseamTXT becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_InseamTXT])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Inseam field"];
        [_InseamTXT becomeFirstResponder];
        return NO;
    }
    if(_NeckTXT.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter neck"];
        [_NeckTXT becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_NeckTXT])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Neck field"];
        [_NeckTXT becomeFirstResponder];
        return NO;
    }
    
    if(_ArmTXT.text.length==0)
    {
        [self showWarningAlertWithTitle:@"Empty Field" andMessage:@"Enter Arm"];
        [_ArmTXT becomeFirstResponder];
        return NO;
        
    }
    if(![self MethodForValidationCheck:_ArmTXT])
    {
        [self showWarningAlertWithTitle:@"Invalid Field" andMessage:@"Please enter valid Arm field"];
        [_ArmTXT becomeFirstResponder];
        return NO;
    }
    
    return YES;
    
}


-(BOOL)validateFields
{
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
}
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    activeField = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    DicMeasurement=[NSMutableDictionary new];
    
    self.shoulderTXT.delegate=self;
    self.chestTXT.delegate=self;
    self.waistTXT.delegate=self;
    self.InseamTXT.delegate=self;
    self.NeckTXT.delegate=self;
    self.ArmTXT.delegate=self;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    tapGesture.cancelsTouchesInView = NO;
    
    [_scrollView addGestureRecognizer:tapGesture];

   [self settingUpTextField];
    
//   ArrShoulder=[[NSMutableArray alloc]initWithObjects:@"32",@"33",@"34",@"35",@"36",@"37", nil];
//   ArrChest=[[NSMutableArray alloc]initWithObjects:@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53", nil];
//   ArrWaist=[[NSMutableArray alloc]initWithObjects:@"28",@"30",@"32",@"36", nil];
//   ArrInseam=[[NSMutableArray alloc]initWithObjects:@"30",@"32",@"34", nil];
//   ArrNeck=[[NSMutableArray alloc]initWithObjects:@"14",@"14.5",@"15",@"15.5",@"16",@"16.5",@"17",@"17.5",@"14",@"14.5",@"15",@"15.5", nil];
//   ArrArm=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    
    
    
}

-(void)settingUpTextField
{
    
    _saveLaterBTN.layer.borderWidth=1;
    _saveLaterBTN.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.shoulderTXT.enableMaterialPlaceHolder = YES;
    self.shoulderTXT.placeholder = @"Shoulder(cm)";
    self.shoulderTXT.errorColor = [UIColor blackColor];
    self.shoulderTXT.lineColor = [UIColor grayColor];
    self.shoulderTXT.delegate=self;
    self.shoulderTXT.tag=1;
    
    self.chestTXT.enableMaterialPlaceHolder = YES;
    self.chestTXT.placeholder = @"Chest(cm)";
    self.chestTXT.errorColor = [UIColor blackColor];
    self.chestTXT.lineColor = [UIColor grayColor];
    self.chestTXT.delegate=self;
    self.chestTXT.tag=2;
    
    self.waistTXT.enableMaterialPlaceHolder = YES;
    self.waistTXT.placeholder = @"Waist(cm)";
    self.waistTXT.errorColor = [UIColor blackColor];
    self.waistTXT.lineColor = [UIColor grayColor];
    self.waistTXT.delegate=self;
    self.waistTXT.tag=3;
    
    
    self.InseamTXT.enableMaterialPlaceHolder = YES;
    self.InseamTXT.placeholder = @"Inseam(cm)";
    self.InseamTXT.errorColor = [UIColor blackColor];
    self.InseamTXT.lineColor = [UIColor grayColor];
    self.InseamTXT.delegate=self;
    self.InseamTXT.tag=4;
    
    self.NeckTXT.enableMaterialPlaceHolder = YES;
    self.NeckTXT.placeholder = @"Neck(cm)";
    self.NeckTXT.errorColor = [UIColor blackColor];
    self.NeckTXT.lineColor = [UIColor grayColor];
    self.NeckTXT.delegate=self;
    self.NeckTXT.tag=5;
    
    
    self.ArmTXT.enableMaterialPlaceHolder = YES;
    self.ArmTXT.placeholder = @"Arm(cm)";
    self.ArmTXT.errorColor = [UIColor blackColor];
    self.ArmTXT.lineColor = [UIColor grayColor];
    self.ArmTXT.delegate=self;
    self.ArmTXT.tag=6;
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



- (IBAction)ActSaveCont:(id)sender
{
    if([self validateFieldsForMeasurment])
    {
        [self MeasurementAPICalling];
    }
    
   
}
- (IBAction)ActSaveLeter:(id)sender
{
        HomeTabBar *home = (HomeTabBar *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
        [self.navigationController pushViewController:home animated:YES];
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
//       return ArrWaist[row];
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
//           return ArrShoulder.count;
//            break;
//        case 2:
//            return ArrChest.count;
//            break;
//        case 3:
//           return ArrWaist.count;
//            break;
//
//        case 4:
//           return ArrInseam.count;
//            break;
//        case 5:
//           return ArrNeck.count;
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
//             _shoulderTXT.text=[NSString stringWithFormat:@"%@",ArrShoulder[row]];
//            break;
//        case 2:
//            _chestTXT.text=[NSString stringWithFormat:@"%@",ArrChest[row]];
//            break;
//        case 3:
//            _waistTXT.text=[NSString stringWithFormat:@"%@",ArrWaist[row]];
//            break;
//
//        case 4:
//            _InseamTXT.text=[NSString stringWithFormat:@"%@",ArrInseam[row]];
//            break;
//        case 5:
//            _NeckTXT.text=[NSString stringWithFormat:@"%@",ArrNeck[row]];
//            break;
//        default:
//            _ArmTXT.text=[NSString stringWithFormat:@"%@",ArrArm[row]];
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
//                NSLog(@"%@",ArrShoulder);
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
//                  NSLog(@"%@",Str_Neck);
//                break;
//            default:
//                Str_Arm=[NSString stringWithFormat:@"%@",ArrArm[row]];
//                 NSLog(@"%@",Str_Arm);
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
-(void)MeasurementAPICalling
{
   
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
   
        NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:USERID];
        NSDictionary *params = @{@"user_id":user_id,@"shoulder":_shoulderTXT.text
                                 ,@"chest":_chestTXT.text,@"waist":_waistTXT.text,@"inseam":_InseamTXT.text,@"neck":_NeckTXT.text,@"arm":_ArmTXT.text};
        
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
                             NSLog(@"data%@",data);
                             NSLog(@"response%@",error);
                             [SVProgressHUD dismiss];
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
                                      
//                                      [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                         
                                      HomeTabBar *home = (HomeTabBar *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                                      [self.navigationController pushViewController:home animated:YES];
                                      
                                  });
                        
                              }
                        }
               }];
        [dataTask resume];
    }
    else
    {
        
        [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
       
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

//end
@end
