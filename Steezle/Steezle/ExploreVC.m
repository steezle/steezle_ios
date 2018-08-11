//
//  ExploreVC.m
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "ExploreVC.h"
#import "FilterCollectionCell.h"
#import "CatergoriesListVC.h"
#import "Globals.h"
#import "Utils.h"
#import "ordercellview.h"
#import "SVProgressHUD.h"
#import "catergoriesClass.h"
#import "PayementOrderDetailsVC.h"
#import "userdefaultArrayCall.h"
#import "DateUTC.h"
#import "HomeView.h"
#import "LoginVC.h"

@interface ExploreVC ()
{
    NSMutableArray *glableArray;
}
@end

@implementation ExploreVC
@synthesize errorImage;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    errorImage.alpha=0;
    glableArray=[NSMutableArray new];
    
    BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
    if (!skipUser)
    {
        [self getCategories];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
             message:@"SignIn/SignUp in steezle and ready to swipe, shop and explore."preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Continue"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                        LoginVC *home = (LoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                                        [self.navigationController pushViewController:home animated:YES];
                                    }];
        
     
        
        [alert addAction:yesButton];
    
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    
    glableArray=[NSMutableArray new];
    
    BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
    if (!skipUser)
    {
        [self getCategories];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
             message:@"Sign in or Sign Up to Place an Order"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Continue"
                   style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                   {
                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                        LoginVC *home = (LoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                                        [self.navigationController pushViewController:home animated:YES];
                                    }];
        
  
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Not now"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
        [alert addAction:yesButton];
        [alert addAction:noButton];

        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
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
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
}
-(void)cancelledApi:(NSString *)order_id
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        self.tableview.userInteractionEnabled=NO;
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        
        NSDictionary *params = @{@"usre_id":user_id,@"order_id":order_id};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,OrderCencelled];
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
                          self.tableview.userInteractionEnabled=YES;
                          [SVProgressHUD dismiss];
                      [self serverError];
//                          [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                   });
            }
            else
            {
                    NSError *parseError = nil;
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    NSLog(@"%@",responseDictionary);
                    NSString *message = [responseDictionary valueForKey:@"message"];
                    NSString *status=[responseDictionary valueForKey:@"status"];
                [self removeImage];
                    if([status isEqualToString:@"S"])
                    {
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                            [SVProgressHUD dismiss];
                            UIAlertController * alert=   [UIAlertController
                             alertControllerWithTitle:@"Steezle"
                             message:message
                             preferredStyle:UIAlertControllerStyleAlert];
                             UIAlertAction* ok = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK")
                                   style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                 {
                                         [self getCategories];
                                 }];
                              [alert addAction:ok];
                             [self presentViewController:alert animated:YES completion:nil];
                          });
                       }
                       else if ([status isEqualToString:@"F"])
                       {
                           dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                                [_tableview reloadData];
                                 [SVProgressHUD dismiss];
                                 self.tableview.userInteractionEnabled=YES;
                                 [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                           });
                       }
                      else
                      {
                            dispatch_async(dispatch_get_main_queue(), ^(void)
                            {
                                  [SVProgressHUD dismiss];
                                  self.tableview.userInteractionEnabled=YES;
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
                           self.tableview.userInteractionEnabled=YES;
                           [self Interneterror];
//                           [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
                       });
        
    }
    
}
-(void)getCategories
{
    if([Utils isNetworkAvailable] ==YES)
    {
        
         [SVProgressHUD show];
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        self.tableview.userInteractionEnabled=NO;
        
        NSDictionary *params = @{@"user_id":user_id};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,OrderHistory];
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
                         self.tableview.userInteractionEnabled=YES;
                         [SVProgressHUD dismiss];
                           [self serverError];
//                         [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                        });
            }
            else
            {
           
                  NSError *parseError = nil;
                  NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                  NSLog(@"%@",responseDictionary);
                  NSString *message = [responseDictionary valueForKey:@"message"];
                  NSString *status=[responseDictionary valueForKey:@"status"];
                  glableArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
                    [self removeImage];
                  if([status isEqualToString:@"W"])
                  {
                      
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                          {
                              self.tableview.userInteractionEnabled=YES;
                                 UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.tableview.frame.origin.x, self.tableview.frame.origin.y, self.tableview.frame.size.height, self.tableview.frame.size.width)];
                                  imageView.contentMode = UIViewContentModeScaleAspectFit;
                                  self.tableview.backgroundColor=[UIColor whiteColor];
                                  imageView.image =[UIImage imageNamed:@"empty_orderList"];
                                  self.tableview.backgroundView = imageView;
                                  self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
                                  self.tableview.separatorColor=[UIColor clearColor];
                                  self.tableview.scrollEnabled=NO;
                                 [SVProgressHUD dismiss];
                              
                            });
                        }
                       else if ([status isEqualToString:@"S"])
                       {
                            dispatch_async(dispatch_get_main_queue(), ^(void)
                             {
                                      [_tableview reloadData];
                                      self.tableview.userInteractionEnabled=YES;
                                      self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                      self.tableview.backgroundColor=[UIColor whiteColor];
                                      self.tableview.backgroundView=nil;
                                      self.tableview.opaque = NO;
                                      self.tableview.scrollEnabled=YES;
                                      [self.tableview reloadData];
                                      [SVProgressHUD dismiss];
                                 
                               });
                         }
                else if ([status isEqualToString:@"F"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^(void)
                    {
                                       [SVProgressHUD dismiss];
                                       self.tableview.userInteractionEnabled=YES;
                                       [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                     });
                }
                else
               {
                              dispatch_async(dispatch_get_main_queue(), ^(void)
                              {
                                   [SVProgressHUD dismiss];
                                   self.tableview.userInteractionEnabled=YES;
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
                    self.tableview.userInteractionEnabled=YES;
                    [self Interneterror];
//                    [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
      
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90 ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return glableArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    UILabel *typeLbl = (UILabel *)[self.view viewWithTag:100];
    //    UIButton *buttonsample = (UIButton *)[self.view viewWithTag:101];
    //   // buttonsample.tag = 102+indexPath.row;
    //    [buttonsample addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    typeLbl.text = @"testddsj";
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ordercellview *cell = (ordercellview*)[tableView dequeueReusableCellWithIdentifier:@"ordercell"];
    NSDictionary *dic=[NSDictionary new];
    dic=[glableArray objectAtIndex:indexPath.row];
    
    //    NSString *strStatus=[dic valueForKey:@"status"];
    //        [btn setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
    [cell.cancelledBTN addTarget:self action:@selector(SelectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //    cell.cancelledBTN.backgroundColor=[UIColor redColor];
    cell.order_status.layer.masksToBounds = YES;
    cell.order_status.layer.cornerRadius=5;
    cell.cancelledBTN.tag = indexPath.row;
    cell.order_status.text=[self capitalizeFirstLetterOnlyOfString:[dic valueForKey:@"status"] ];
    
    if ([[dic valueForKey:@"status"] isEqualToString:@"completed"])
    {
        cell.status_image.backgroundColor=[UIColor colorWithRed:17/255.0 green:100/255.0 blue:5/255.0 alpha:1.0f];
        //        cell.order_status.text=[self capitalizeFirstLetterOnlyOfString:[dic valueForKey:@"status"] ];
        cell.order_status.backgroundColor=[UIColor colorWithRed:17/255.0 green:100/255.0 blue:5/255.0 alpha:1.0f];
        //        [cell.order_status setTextColor:[UIColor colorWithRed:17/255.0 green:100/255.0 blue:5/255.0 alpha:1.0f]];
        cell.cancelledBTN.alpha=1;
        
    }
    else if ([[dic valueForKey:@"status"] isEqualToString:@"cancelled"])
    {
        
        cell.status_image.backgroundColor=[UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1.0f];
        cell.cancelledBTN.alpha=0;
        //        cell.order_status.text=[self capitalizeFirstLetterOnlyOfString:[dic valueForKey:@"status"] ];
        cell.order_status.backgroundColor=[UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1.0f];
        //        [cell.order_status setTextColor:[UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1.0f]];
        
    }
    //    else if ([strStatus isEqualToString:@"failed"])
    //    {
    //        cell.status_image.backgroundColor=[UIColor redColor];
    //    }
    else
    {
        cell.status_image.backgroundColor=[UIColor colorWithRed:17/255.0 green:100/255.0 blue:5/255.0 alpha:1.0f];
    }
    
    cell.order_idLBL.text=[NSString stringWithFormat:@"#%@",[dic valueForKey:@"order_number"]];
    NSString *datestring= [DateUTC ChangeDateInUTC:[dic valueForKey:@"created_at"]];
    cell.Order_Date.text=datestring;
    //    cell.Order_Date.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"created_at"]];
    NSString *items=[NSString stringWithFormat:@"%@",[dic valueForKey:@"total_items"]];
    cell.Total_iteams.text=[NSString stringWithFormat:@"%@ items",items];
    if ([items isEqualToString:@"1"])
    {
        cell.Total_iteams.text=[NSString stringWithFormat:@"%@ item",items];
    }
    
    cell.Total_PriceLBL.text=[NSString stringWithFormat:@"$%@",[dic valueForKey:@"total"]];
    
    
    return cell;
    
}
- (NSString *)capitalizeFirstLetterOnlyOfString:(NSString *)string
{
    NSMutableString *result = [string lowercaseString].mutableCopy;
    [result replaceCharactersInRange:NSMakeRange(0, 1) withString:[[result substringToIndex:1] capitalizedString]];
    
    return result;
}
- (void)SelectButtonTapped:(UIButton *)button
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
                                                                  message:@"Are you sure to Cancel this order?"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    NSInteger buttonIndex = button.tag;
                                    NSLog(@"%ld",(long)buttonIndex);
                                    NSDictionary *dic=[NSDictionary new];
                                    dic=[glableArray objectAtIndex:button.tag];
                                    NSString *orderID=[NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
                                    
                                    [self cancelledApi:orderID];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"%ld",(long)indexPath.row);
    NSDictionary *dic=[NSDictionary new];
    dic=[glableArray objectAtIndex:indexPath.row];
    NSString *orderID=[NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
    NSLog(@"Order ID:%@",orderID);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PayementOrderDetailsVC *payementOrder = (PayementOrderDetailsVC *)[storyboard instantiateViewControllerWithIdentifier:@"PayementOrderDetailsVC"];
    payementOrder.Order_Id=orderID;
    [self.navigationController pushViewController:payementOrder animated:YES];
    
}
//Alert message
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)removeImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        errorImage.alpha=0;
        errorImage.image=nil;
        
    });
    
}
-(void)serverError
{
    errorImage.alpha=1;
    errorImage.image=[UIImage imageNamed:@"Server-error"];
    
}
-(void)Interneterror
{
    errorImage.alpha=1;
    errorImage.image=[UIImage imageNamed:@"no-internet"];
    
}

@end

