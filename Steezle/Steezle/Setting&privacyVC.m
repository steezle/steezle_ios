//
//  Setting&privacyVC.m
//  Steezle
//
//  Created by Ryan Smith on 2018-02-02.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import "Setting&privacyVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <QuartzCore/QuartzCore.h>
#import "sett_Cell.h"
#import "HomeView.h"
#import "LoginVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "AboutVC.h"
#import "privacyVC.h"
#import "userdefaultArrayCall.h"
#import "SVProgressHUD.h"
#import "Utils.h"
#import "Globals.h"
#import <Google/SignIn.h>
#import  "InviteReferrals.h"
#import "ReturnPolicyVC.h"
#import "CustomerServiceVC.h"


@interface Setting_privacyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *globalArray,*imageArray;
}
@end

@implementation Setting_privacyVC
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
    
//    NSMutableAttributedString *carbonDioxide = [[NSMutableAttributedString alloc] initWithString:@"YUNG2"];
//    [carbonDioxide addAttribute:(NSString *)kCTSuperscriptAttributeName value:@+1 range:NSMakeRange(4,1)];
//    NSLog(@"%@",carbonDioxide);
//    // using...attributedText

    globalArray = [[NSMutableArray alloc] initWithObjects:@"Privacy & Security Policy",@"FAQ and Return Policy",@"About Us",@"Referral code",@"Contact Customer Service",nil];
    imageArray=[[NSMutableArray alloc]initWithObjects:@"privacy_policy_new",@"return_policy",@"About_new",@"add_referral",@"ic_contact_us", nil];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    
    _bottomView.layer.shadowRadius  = 1.5f;
    _bottomView.layer.shadowColor   = [UIColor grayColor].CGColor;
    _bottomView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    _bottomView.layer.shadowOpacity = 0.9f;
    _bottomView.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_bottomView.bounds, shadowInsets)];
    _bottomView.layer.shadowPath    = shadowPath.CGPath;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50 ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return globalArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    sett_Cell *cell = (sett_Cell*)[tableView dequeueReusableCellWithIdentifier:@"sett_Cell"];
    
    cell.nameLbl.text = [globalArray objectAtIndex:indexPath.row];
    [cell.image sd_setShowActivityIndicatorView:YES];
    [cell.image sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.image.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    cell.image.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld",(long)indexPath.row);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row==0)
    {
        
        privacyVC *privacy = (privacyVC *)[storyboard instantiateViewControllerWithIdentifier:@"privacyVC"];
        [self.navigationController pushViewController:privacy animated:YES];
    }
    //    else if (indexPath.row==1)
    //    {
    //        NSString *appName = [NSString stringWithString:[[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleName"]];
    //        NSURL *appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.com/app/%@",[appName stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    //        [[UIApplication sharedApplication] openURL:appStoreURL];
    //
    //    }
    else if (indexPath.row==1)
    {
        
        ReturnPolicyVC *returnpolicy = (ReturnPolicyVC *)[storyboard instantiateViewControllerWithIdentifier:@"ReturnPolicyVC"];
        [self.navigationController pushViewController:returnpolicy animated:YES];
    }
    else if (indexPath.row==2)
    {
        
        AboutVC *about = (AboutVC *)[storyboard instantiateViewControllerWithIdentifier:@"AboutVC"];
        [self.navigationController pushViewController:about animated:YES];
    }
    else if (indexPath.row==3)
        
    {
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
            
            NSString *email=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:USEREMAIL]];
            NSString *name=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:FIRSTNAME]];
//        [InviteReferrals launch:@"18031" Email:email mobile:nil name:name SubscriptionID:nil];
//            [InviteReferrals setupUserID:email mobile:nil name:name gender:nil shareLink:nil shareTitle:nil shareDesc:nil shareImg:nil customValue:nil campaignID:@"18043" flag:@"launch" SubscriptionID:nil];
            
            [InviteReferrals setupUserID:email mobile:nil name:name gender:nil shareLink:nil shareTitle:nil shareDesc:nil shareImg:nil customValue:nil campaignID:@"18509" flag:@"launch" SubscriptionID:nil];
        });
        
    }
    else{
        CustomerServiceVC *cust = (CustomerServiceVC *)[storyboard instantiateViewControllerWithIdentifier:@"CustVC"];
        [self.navigationController pushViewController:cust animated:YES];
    }
    
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    ProductVC *myVC = (ProductVC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductVC"];
    //
    //    [self.navigationController pushViewController:myVC animated:YES];
    
}

-(void)showWarningAlertWithTitle:(NSString*)title andMessage:(NSString*)msg{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"OK", @"OK")
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)ActBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)ActLogout:(id)sender
{
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
                  message:@"Are you sure you want to logout?"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [self logoutAPIcallingMethod];
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

-(void)logoutAPIcallingMethod
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        NSString *user_id=[[NSUserDefaults standardUserDefaults] valueForKey:USERID];
        NSDictionary *params = @{@"user_id":user_id};
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,LOGOUT];
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
                 if ([status isEqualToString:@"S"])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^(void)
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
                                        //FBSDKLoginManager *loginmanager= [[FBSDKLoginManager alloc]init];
                                        //[loginmanager logOut];
                                        //[FBSDKAccessToken setCurrentAccessToken:nil];
                                        //[FBSDKProfile setCurrentProfile:nil];
                                        //[FBSDKAppEvents setUserID:nil];
                                        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                                        [defaults removeObjectForKey:USERID];
                                        [defaults removeObjectForKey:FIRSTNAME];
                                        [defaults removeObjectForKey:LASTNAME];
                                        [defaults removeObjectForKey:PROFILEIMAGE];
                                        [defaults removeObjectForKey:GENDER];
                                        [defaults removeObjectForKey:CONTACT];
                                        [defaults removeObjectForKey:PROFILEIMAGE];
                                        [defaults removeObjectForKey:USEREMAIL];
                                        [defaults removeObjectForKey:WISHPRODUCTLIST];
                                        [defaults removeObjectForKey:SHOULDER];
                                        [defaults removeObjectForKey:CHEST];
                                        [defaults removeObjectForKey:WAIST];
                                        [defaults removeObjectForKey:INSEAM];
                                        [defaults removeObjectForKey:NECK];
                                        [defaults removeObjectForKey:ARM];
                                        [defaults removeObjectForKey:@"Address_shiping"];
                                        [defaults removeObjectForKey:SEASRCHDATA];
                                        [defaults removeObjectForKey:Total_Cart];
                                        [defaults removeObjectForKey:Total_Steez];
                                        [[GIDSignIn sharedInstance] signOut];
                                        //[loginmanager logOut];
                                        [defaults setBool:NO forKey:LOGGED_IN];
                                        //[FBSDKAccessToken setCurrentAccessToken:nil];
                                        //[defaults setBool:NO forKey:];
                                        [defaults synchronize];
                                        [SVProgressHUD dismiss];
                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                        LoginVC *home = (LoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                                        [self.navigationController pushViewController:home animated:YES];
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
        dispatch_async(dispatch_get_main_queue(), ^(void)
        {
                 [SVProgressHUD dismiss];
                 [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
    }
    
    
}
@end

