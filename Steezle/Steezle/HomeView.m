//
//  HomeView.m
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "HomeView.h"
#import "LoginVC.h"
#import "SignUpVC.h"
#import "HomeTabBar.h"
#import "HomeTabBar.h"
#import "userdefaultArrayCall.h"


@interface HomeView ()
{
    NSMutableArray *social_data_array;
}
@end

@implementation HomeView

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
            _logoHeight.constant = 60;
            _logowidth.constant=60;
            _logotextHeight.constant=30;
            _signINHeight.constant=40;
            _signUPHeight.constant=40;
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
            if (@available(iOS 11.0, *))
            {
                self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;            }
            else
            {
                // Fallback on earlier versions
            }
            if (@available(iOS 11.0, *))
            {
                self.navigationController.navigationBar.prefersLargeTitles = YES;
                self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
            } else {
                // Fallback on earlier versions
            }
        }
        
        else
        {
            NSLog(@"Others");
        }
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    social_data_array =[NSMutableArray new];

    
    _signIn.layer.borderWidth=1;
    _signIn.layer.borderColor=[UIColor whiteColor].CGColor;
  
//    _SkipBTN.layer.borderWidth=1;
//    _SkipBTN.layer.borderColor=[UIColor whiteColor].CGColor;
    
//    _startBrowsingBTN.layer.borderWidth=0.5;
//    _startBrowsingBTN.layer.borderColor=[UIColor whiteColor].CGColor;
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    //push you secondview controller on GCD with delay

}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)emailBtnClick:(id)sender {
    
    
  
}

- (IBAction)ActionFacebook:(id)sender {
    
   
  
  
}

//code
//UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//
//tapGesture.cancelsTouchesInView = NO;
//
//[_scrollview addGestureRecognizer:tapGesture];


//CGRect frame=CGRectMake(0,0,40, 20);
//[self setAttributesForTextField:_nameTF withPlaceholder:@"Name" andImage:@"name" andFrame:frame];


//-(void)setAttributesForTextField:(UITextField *)textField withPlaceholder:(NSString *)placeholder andImage:(NSString *)img andFrame:(CGRect)frame
//{
//
//    CALayer *bottomBorder = [CALayer layer];
//
//    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 0.5, self.view.frame.size.width, 0.5);
//
//    bottomBorder.backgroundColor = [[UIColor colorWithRed:60.0/255.0 green:69.0/255.0 blue:79.0/255.0 alpha:1.0] CGColor];
//
//    [textField.layer addSublayer:bottomBorder];
//
//    [textField setValue:[UIColor colorWithRed:60.0/255.0 green:69.0/255.0 blue:79.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
//
//
//    UIImageView * iconImageView11 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
//    iconImageView11.frame = frame;
//    iconImageView11.contentMode = UIViewContentModeScaleAspectFit;

//        [textField setLeftViewMode:UITextFieldViewModeAlways];
//        textField.leftView = iconImageView11;

//
//}

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


- (IBAction)Act_SignUp:(id)sender {
    
    SignUpVC *myVC = (SignUpVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    //    [self presentViewController:myVC animated:NO completion:nil];
    [self.navigationController pushViewController:myVC animated:YES];
    
}
- (IBAction)Act_signIn:(id)sender
{
    LoginVC *myVC = (LoginVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    // [self presentViewController:myVC animated:NO completion:nil];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

- (IBAction)Act_skip:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SKIPUSER];
    [[NSUserDefaults standardUserDefaults]synchronize];
    HomeTabBar *home = (HomeTabBar *)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
    [self.navigationController pushViewController:home animated:YES];
    
}
@end
