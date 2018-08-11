//
//  TopVC.m
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "TopVC.h"
#import "FilterCollectionCell.h"
#import "CatergoriesListVC.h"
#import "Globals.h"
#import "Utils.h"
#import "SVProgressHUD.h"
#import "catergoriesClass.h"
#import "AppDelegate.h"
#import "ProductListCell.h"
#import "ProductDetail_VC.h"
#import "userdefaultArrayCall.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "ProductClass.h"
#import "ShoppingCartVC.h"
#import <CoreText/CTStringAttributes.h>
#import "HomeView.h"
#import "LoginVC.h"

@interface TopVC ()
{
    NSMutableArray *glableArray;
    NSMutableArray *detailsArray;
    UIRefreshControl *refreshControl;
    UIImageView *InternetImage;
    UIImageView *serverImage;
    BOOL refresh;
}
@end

@implementation TopVC
@synthesize errorImage;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    errorImage.alpha=0;
    BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
    if (!skipUser)
    {
        _CartCountLBL.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
        [self refreshView];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
                 message:@"Sign in or Sign Up to go to My Steez"preferredStyle:UIAlertControllerStyleAlert];
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableveiw.delegate=self;
    self.tableveiw.dataSource=self;
    self.AlertView.hidden=YES;
    self.SubAlertView.hidden=YES;
    
    glableArray =[NSMutableArray new];
    detailsArray =[NSMutableArray new];
    
    refresh=NO;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    [self.tableveiw addSubview:refreshControl];
    self.tableveiw.alwaysBounceVertical = YES;
    
}

-(void)refreshView
{
    refresh=YES;
    [self getCategories];
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    [refreshControl endRefreshing];
    //    });
    
}
-(void)getCategories
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        self.tableveiw.userInteractionEnabled=NO;
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        NSDictionary *params = @{@"user_id":user_id};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,GetFavorite ];
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
                            self.tableveiw.userInteractionEnabled=YES;
                            [SVProgressHUD dismiss];
                           [self serverError];
//                            [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                       });
                      }
                     else
                     {
                     
                            NSError *parseError = nil;
                            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                            NSLog(@"%@",responseDictionary);
                            NSString *message = [responseDictionary valueForKey:@"message"];
                            NSString *status=[responseDictionary valueForKey:@"status"];
                            // NSString *total_cart=[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"total_cart"]];
                             glableArray=[NSMutableArray new];
                             detailsArray=[NSMutableArray new];
                             glableArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
                             [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                            [self removeImage];
                            if([status isEqualToString:@"W"])
                            {
                                                      
                               dispatch_async(dispatch_get_main_queue(), ^(void)
                               {
                                   
                                      self.tableveiw.userInteractionEnabled=YES;
                                      glableArray=[NSMutableArray new];
                                      // [self.tableveiw reloadData];
                                      // detailsArray=[NSMutableArray new];
                                      UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.tableveiw.frame.origin.x, self.tableveiw.frame.origin.y, self.tableveiw.frame.size.height, self.tableveiw.frame.size.width)];
                                      imageView.contentMode = UIViewContentModeScaleAspectFit;
                                      self.tableveiw.backgroundColor=[UIColor whiteColor];
                                      imageView.image =[UIImage imageNamed:@"emptywishlist.jpg"];
                                      self.tableveiw.backgroundView = imageView;
                                      self.tableveiw.separatorStyle = UITableViewCellSeparatorStyleNone;
                                      self.tableveiw.separatorColor=[UIColor clearColor];
                                      self.tableveiw.scrollEnabled=NO;
                                      self.tableveiw.userInteractionEnabled=YES;
                                      [self.tableveiw reloadData];
                                      [SVProgressHUD dismiss];
                                      //[self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                  });
                                  //glableArray=[NSMutableArray new];
                                  //[self.tableveiw reloadData];
                               }
                              else if ([status isEqualToString:@"S"])
                              {
                                   for (int i = 0 ; i<glableArray.count; i++)
                                   {
                                       NSDictionary *dic = [glableArray objectAtIndex:i];
                                          ProductClass *product_calss=[[ProductClass alloc]init];
                                          product_calss.fav_list_added_date = [NSString stringWithFormat:@"%@", [dic valueForKey:@"fav_list_added_date"]];
                                          product_calss.product_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_id"]];
                                          product_calss.product_name = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_name"]];
                                          product_calss.product_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_price"]];
                                          product_calss.product_regular_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_regular_price"]];
                                          product_calss.product_sale_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_sale_price"]];
                                          product_calss.product_stock_status = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_stock_status"]];
                                          product_calss.product_type = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_type"]];
                                          product_calss.brandName = [NSString stringWithFormat:@"%@", [dic valueForKey:@"brand"]];
                                          //    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[dic valueForKey:@"product_image"] ]];
                                          product_calss.product_image = [NSString stringWithFormat:@"%@",[dic valueForKey:@"product_image"]];
                                         [detailsArray addObject:product_calss];
                                 if(detailsArray.count==glableArray.count)
                                 {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                                  
                                      
                                       //_CartCountLBL.text=total_cart;
                                      [[NSUserDefaults standardUserDefaults] removeObjectForKey:WISHPRODUCTLIST];
                                      self.tableveiw.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                                      self.tableveiw.backgroundColor=[UIColor whiteColor];
                                      self.tableveiw.backgroundView=nil;
                                      self.tableveiw.opaque = NO;
                                      self.tableveiw.scrollEnabled=YES;
                                      [self.tableveiw reloadData];
                                      self.tableveiw.userInteractionEnabled=YES;
                                      [SVProgressHUD dismiss];
                                 });
                                 //[_tableview reloadData];
                                }
                              }
                        }
                       else
                       {
                         dispatch_async(dispatch_get_main_queue(), ^{
                                self.tableveiw.userInteractionEnabled=YES;
                                [SVProgressHUD dismiss];
                              [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
                             
                         });
                       }
                 }
           }];
        [dataTask resume];
        //   }
        
    }
    else
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            self.tableveiw.userInteractionEnabled=YES;
            [self Interneterror];
//            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
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
            _btn_h.constant=40;
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
                
                
            } else {
                
            }
        }
        else
        {
            NSLog(@"Others");
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        ProductClass *pro_class = nil;
        pro_class = [detailsArray objectAtIndex:indexPath.row];
        NSString *pro_id=[NSString stringWithFormat:@"%@",pro_class.product_id];
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
                   message:@"Do you want to remove this item?"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                        [self apiremoveFavoriteMethodProduct_id:pro_id];
                                        
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
}
//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//    {
//        ProductClass *pro_class = nil;
//        pro_class = [detailsArray objectAtIndex:indexPath.row];
//        NSString *pro_id=[NSString stringWithFormat:@"%@",pro_class.product_id];
//
//
//        [self apiremoveFavoriteMethodProduct_id:pro_id];
//
//    }];
//
//    deleteAction.backgroundColor = [UIColor redColor];
//
//    return @[deleteAction];
//
//}
-(void)calldetailsPagewehenVariation:(NSInteger)index
{
    ProductClass *pro_class = nil;
    pro_class = [detailsArray objectAtIndex:index];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ProductDetail_VC *myVC = (ProductDetail_VC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductDetailVC"];
    NSString *index1=[NSString stringWithFormat:@"%@",pro_class.product_id];
    myVC.productId=index1;
//    //    [self presentViewController:myVC animated:NO
    //                     completion:nil];
    [self.navigationController pushViewController:myVC animated:YES];
}
-(void)callapiForAddProductIntoCart:(NSString *)pro_ID andvariationType:(NSString *)variation andIndex:(NSInteger)ind
{
    if([Utils isNetworkAvailable] ==YES)
    {
        
        [SVProgressHUD show];
        NSError *error = nil;
        NSData *jsonData2;
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        if([variation isEqualToString:@"variable"])
        {
            [SVProgressHUD dismiss];
            [self calldetailsPagewehenVariation:ind];
        }
        else
        {
            NSDictionary *firstJsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 pro_ID, @"product_id",
                                                 @"1", @"qty",
                                                 nil];
            
            [arr addObject:firstJsonDictionary];
            
            jsonData2 = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
            
            NSLog(@"jsonData as string:\n%@", jsonString);
            
            //        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
            
            NSDictionary *params = @{@"cart_products":jsonString,@"user_id":userId};
            
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
            NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,AddCart ];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
            //TODO handle error
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
                                [self serverError];
//                                [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
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
                       if([status isEqualToString:@"F"])
                       {
                         
                         dispatch_async(dispatch_get_main_queue(), ^(void)
                         {
                                 [SVProgressHUD dismiss];
                                 [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                                                             
                         });
                        }
                        else if ([status isEqualToString:@"S"])
                        {
                               [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"card_flag"];
                               [[NSUserDefaults standardUserDefaults] synchronize];
                               dispatch_async(dispatch_get_main_queue(), ^{
                               NSLog(@"%@",status);
                               self.AlertView.hidden=NO;
                               self.SubAlertView.hidden=NO;
                               double delayInSeconds = 1;
                               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                               dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                               {
                                   self.AlertView.hidden=YES;
                                   self.SubAlertView.hidden=YES;
                                   [self refreshView];
                                   
                                });
                              });
                             }
                          else
                          {
                           dispatch_async(dispatch_get_main_queue(), ^{
                                    [SVProgressHUD dismiss];
                                   [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
                            });
                          }
                       }
                  }];
            [dataTask resume];
            
        }
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self Interneterror];
//            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
    }
}
-(void)apiremoveFavoriteMethodProduct_id:(NSString *)pro_id
{
    
    if([Utils isNetworkAvailable] ==YES)
    {
        
        [SVProgressHUD show];
        self.tableveiw.userInteractionEnabled=NO;
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
        
        NSDictionary *params = @{@"user_id":user_id,@"product_id":pro_id};
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,RemoveFavorite ];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        //TODO handle error
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
                       self.tableveiw.userInteractionEnabled=YES;
                       [SVProgressHUD dismiss];
                       [self serverError];
                       //[self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
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
                //glableArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
                if([status isEqualToString:@"F"])
                {
                    
                     dispatch_async(dispatch_get_main_queue(), ^(void){
                         [SVProgressHUD dismiss];
                      [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                      self.tableveiw.userInteractionEnabled=YES;
                 });
                }
                else if ([status isEqualToString:@"S"])
                {
                      dispatch_async(dispatch_get_main_queue(), ^(void){
                      [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                       [self refreshView];
                       // [self.tableveiw reloadData];
                       //  [SVProgressHUD dismiss];
                       });
                 }
                 else
                 {
                          dispatch_async(dispatch_get_main_queue(), ^(void){
                             [SVProgressHUD dismiss];
                             self.tableveiw.userInteractionEnabled=NO;
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
            self.tableveiw.userInteractionEnabled=NO;
            [self Interneterror];
//            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120 ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return detailsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProductListCell *cell = (ProductListCell*)[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    
    ProductClass *pro_class = nil;
    pro_class = [detailsArray objectAtIndex:indexPath.row];
    [cell.image sd_setShowActivityIndicatorView:YES];
    [cell.image sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.image.contentMode = UIViewContentModeScaleAspectFit;
    [cell.image sd_setImageWithURL:[NSURL URLWithString:pro_class.product_image]
                  placeholderImage:[UIImage imageNamed:@"catergories-placeholder.png"]
                           options:SDWebImageRefreshCached];
    
    cell.AddToBagBTN.layer.borderWidth=1;
    cell.AddToBagBTN.layer.borderColor=[UIColor blackColor].CGColor;
    cell.AddToBagBTN.tag = indexPath.row;
    [cell.AddToBagBTN addTarget:self action:@selector(AddToBagClicked:) forControlEvents:UIControlEventTouchUpInside];
 
    cell.lbl_price.text=[@"$ " stringByAppendingString:[NSString stringWithFormat:@"%@",pro_class.product_price]];
    cell.lbl_toro.text=[NSString stringWithFormat:@"%@",pro_class.product_name];
    //    cell.lbl_price.text=[NSString stringWithFormat:@"%@",pro_class.product_price];
    cell.lbl_tshart.text=[NSString stringWithFormat:@"%@",pro_class.brandName];
    
    if ([cell.lbl_tshart.text isEqualToString:@"Yung2"]) {
        NSMutableAttributedString *carbonDioxide = [[NSMutableAttributedString alloc] initWithString:@"Yung2"];
        [carbonDioxide addAttribute:(NSString *)kCTSuperscriptAttributeName value:@+1 range:NSMakeRange(4,1)];
        cell.lbl_tshart.attributedText=carbonDioxide;
    }
    
    //    cell.image.image = [UIImage imageNamed: [image_array objectAtIndex:indexPath.row]];
    //    cell.lbl.text = [label_array objectAtIndex:indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    catergoriesClass *catergories_calss = nil;
    //    catergories_calss = [_detailsArray objectAtIndex:indexPath.row];
    //    NSString *product_id=[NSString stringWithFormat:@"%@",catergories_calss.cater_id];
    //
    ProductClass *pro_class = nil;
    pro_class = [detailsArray objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ProductDetail_VC *myVC = (ProductDetail_VC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductDetailVC"];
    NSString *index=[NSString stringWithFormat:@"%@",pro_class.product_id];
    myVC.productId=index;
    myVC.isFromMySteeze = YES;
    //[self presentViewController:myVC animated:NO completion:nil];
    
    [self.navigationController pushViewController:myVC animated:YES];
}
- (void)AddToBagClicked:(UIButton *)sender{
    
    NSInteger num = [sender tag];
    
    ProductClass *pro_class = nil;
    pro_class = [detailsArray objectAtIndex:num];
    NSString *pro_id=[NSString stringWithFormat:@"%@",pro_class.product_id];
    NSString *variation=[NSString stringWithFormat:@"%@",pro_class.product_type];
    
    [self callapiForAddProductIntoCart:pro_id andvariationType:variation andIndex:num];
    
    //    if(![variation isEqualToString:@"variable"])
    //    {
    //          [detailsArray removeObjectAtIndex:num];
    //    }
    
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
- (IBAction)ActionShoppingBag:(id)sender
{

    ShoppingCartVC *myVC = (ShoppingCartVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ShoppingCartVC"];
    [self.navigationController pushViewController:myVC animated:YES];

    
}

-(void)updateTotalcount:(NSString *)total_bag andSteez:(NSString *)total_steez
{
    [[NSUserDefaults standardUserDefaults]setObject:total_bag forKey:Total_Cart];
    [[NSUserDefaults standardUserDefaults]setObject:total_steez forKey:Total_Steez];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //        _badge_lbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Steez]];
        _CartCountLBL.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
    });
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
        if((indexPath.row)==0)
            cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_normal.PNG"]]; //set image for cell 0
    
        if (indexPath.row==1)
            cell.backgroundColor = [UIColor colorWithRed:.8 green:.6 blue:.6 alpha:1]; //set color for cell 1
        if(detailsArray.count==0)
        _tableveiw.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"Empty-wishlist"]]; //set image for UITableView
        _tableveiw.scrollEnabled=YES;
    
    
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
///
