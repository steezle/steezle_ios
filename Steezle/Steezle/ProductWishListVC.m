//
//  ProductWishListVC.m
//  Steezle
//
//  Created by webmachanics on 23/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "ProductWishListVC.h"
#import "HomeTabBar.h"
#import "ProductListCell.h"
#import "AppDelegate.h"
#import "ShoppingCartVC.h"
#import "ProductDetail_VC.h"
#import "userdefaultArrayCall.h"
#import "Globals.h"
#import "Utils.h"
#import "ProductClass.h"
#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import <CoreText/CTStringAttributes.h>
#import "HomeView.h"
#import "LoginVC.h"
//#import "HomePageVC.h"


@interface ProductWishListVC ()
{
    NSMutableArray *glableArray;
    NSMutableArray *detailsArray;
    UIRefreshControl *refreshControl;
    BOOL refresh;
}
@end

@implementation ProductWishListVC
@synthesize errorImage;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshView];
    
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
-(void)updateTotalcount:(NSString *)total_bag andSteez:(NSString *)total_steez
{
    [[NSUserDefaults standardUserDefaults]setObject:total_bag forKey:Total_Cart];
    [[NSUserDefaults standardUserDefaults]setObject:total_steez forKey:Total_Steez];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_async(dispatch_get_main_queue(), ^(void){
//        _badge_lbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Steez]];
    _cartcountLbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
    });
    
}
-(void)refreshView
{
    
//    glableArray =[NSMutableArray new];
//    detailsArray =[NSMutableArray new];
   
    refresh=YES;
    [self apicallMethodURLandreloading:YES];
    [refreshControl endRefreshing];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:refreshControl];
    self.tableview.alwaysBounceVertical = YES;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    errorImage.alpha=0;
     _cartcountLbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
    refreshControl = [[UIRefreshControl alloc] init];
    refresh=NO;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    
    _alertView.hidden=YES;
    _subAlertView.hidden=YES;
    glableArray =[NSMutableArray new];
    detailsArray =[NSMutableArray new];
    
    BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
    if (!skipUser)
    {
         [self apicallMethodURLandreloading:NO];
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
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Not now"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
       {
                                       
       }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
   

    
    //NSLog(@"your wish list :%@",glableArray);
    // Do any additional setup after loading the view.
    
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
    
    ProductListCell *cell = (ProductListCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    ProductClass *pro_class = nil;
    
    pro_class = [detailsArray objectAtIndex:indexPath.row];
    
    [cell.image sd_setShowActivityIndicatorView:YES];
    [cell.image sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.image.contentMode = UIViewContentModeScaleAspectFit;

    [cell.image sd_setImageWithURL:[NSURL URLWithString:pro_class.product_image]
                  placeholderImage:[UIImage imageNamed:@"empty_menu"]
                           options:SDWebImageRefreshCached];
    cell.AddToBagBTN.layer.borderWidth=1;
    cell.AddToBagBTN.layer.borderColor=[UIColor blackColor].CGColor;
    
    cell.AddToBagBTN.tag = indexPath.row;
    
    [cell.AddToBagBTN addTarget:self action:@selector(AddToBagClicked:) forControlEvents:UIControlEventTouchUpInside];
   
//    cell.image.image = [UIImage imageWithData:pro_class.product_image];
    cell.lbl_price.text=[@"$ " stringByAppendingString:[NSString stringWithFormat:@"%@",pro_class.product_price]];
    cell.lbl_toro.text=[NSString stringWithFormat:@"%@",pro_class.product_name];
    
    //    cell.lbl_price.text=[NSString stringWithFormat:@"%@",pro_class.product_price];
    cell.lbl_tshart.text=[NSString stringWithFormat:@"%@",pro_class.brandName];
    
    if ([cell.lbl_tshart.text isEqualToString:@"Yung2"]) {
        NSMutableAttributedString *carbonDioxide = [[NSMutableAttributedString alloc] initWithString:@"Yung2"];
        [carbonDioxide addAttribute:(NSString *)kCTSuperscriptAttributeName value:@+1 range:NSMakeRange(4,1)];
        cell.lbl_tshart.attributedText=carbonDioxide;
    }
    
    return cell;
    
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    catergoriesClass *catergories_calss = nil;
////    catergories_calss = [_detailsArray objectAtIndex:indexPath.row];
////    NSString *product_id=[NSString stringWithFormat:@"%@",catergories_calss.cater_id];
////
//    ProductClass *pro_class = nil;
//    pro_class = [detailsArray objectAtIndex:indexPath.row];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    ProductDetail_VC *myVC = (ProductDetail_VC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductDetailVC"];
//    NSString *index=[NSString stringWithFormat:@"%@",pro_class.product_id];
////    myVC.productId=index;
////    //[self presentViewController:myVC animated:NO completion:nil];
//    [self.navigationController pushViewController:myVC animated:YES];
//}
- (IBAction)ActionBack:(id)sender
{
//    [self dismissViewControllerAnimated:NO completion:nil];
      [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)ActionShoppingNow:(id)sender
{
   
//    BOOL Cart=[[NSUserDefaults standardUserDefaults] boolForKey:@"card_flag"];
////    NSString *Car1t=[[NSUserDefaults standardUserDefaults] valueForKey:CART_FLAG];
//    if(Cart)
//    {
        ShoppingCartVC *myVC = (ShoppingCartVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ShoppingCartVC"];
        [self.navigationController pushViewController:myVC animated:YES];
//    }
//    else
//    {
//        newShoppingVC *newshopp = (newShoppingVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"newShoppingVC"];
//
//        [self.navigationController pushViewController:newshopp animated:YES];
//    }
    
}
- (IBAction)ActioncheckOut:(id)sender
{
    
}
- (void)AddToBagClicked:(UIButton *)sender{
    
     NSInteger num = [sender tag];
  
    ProductClass *pro_class = nil;
    pro_class = [detailsArray objectAtIndex:num];
    NSString *pro_id=[NSString stringWithFormat:@"%@",pro_class.product_id];
    NSString *variation=[NSString stringWithFormat:@"%@",pro_class.product_type];
    
    
    [self callapiForAddProductIntoCart:pro_id andvariationType:variation andIndex:num];
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
        self.tableview.userInteractionEnabled=NO;
        NSString *numStr=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
                                                                      message:@"Do you want to remove this item?"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                       [self apiremoveFavoriteMethodProduct_id:pro_id andIndex:numStr];
                                        
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
////    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Add to cart"
////                  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
////    {
////        ProductClass *pro_class = nil;
////        pro_class = [detailsArray objectAtIndex:indexPath.row];
////        NSString *pro_id=[NSString stringWithFormat:@"%@",pro_class.product_id];
////        NSString *variation=[NSString stringWithFormat:@"%@",pro_class.product_type];
////
////
////            [self callapiForAddProductIntoCart:pro_id andvariationType:variation andIndex:indexPath.row];
////
////
////
////
//////           [self callapiForAddProductIntoCart:pro_id andvariationType:variation andIndex:indexPath.row];
//////            [detailsArray removeObjectAtIndex:indexPath.row];
//////            [tableView reloadData];
////
////
////        //insert your editAction here
////    }];
//
////     UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(self.tableview.bounds.origin.x, self.tableview.bounds.origin.y, self.tableview.bounds.size.width,self.tableview.bounds.size.height)];
////    image.image=[UIImage imageNamed:@"addcart"];
////    image.contentMode=UIViewContentModeScaleAspectFill;
//
////    editAction.backgroundColor = [UIColor colorWithPatternImage:image.image];
//
////    editAction.backgroundColor = [UIColor blueColor];
//
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//                    ProductClass *pro_class = nil;
//                    pro_class = [detailsArray objectAtIndex:indexPath.row];
//                    NSString *pro_id=[NSString stringWithFormat:@"%@",pro_class.product_id];
//
//                    //remove the deleted object from your data source.
//                    //If your data source is an NSMutableArray, do this
////                    [detailsArray removeObjectAtIndex:indexPath.row];
//                    self.tableview.userInteractionEnabled=NO;
//                    NSString *numStr=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
//                    [self apiremoveFavoriteMethodProduct_id:pro_id andIndex:numStr];
//                //        AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//                //        [appdelegate.productItemArray removeObjectAtIndex:indexPath.row];
//
//
//        //insert your deleteAction here
//    }];
//
////    UIImageView *image1=[[UIImageView alloc]initWithFrame:CGRectMake(self.tableview.bounds.origin.x, self.tableview.bounds.origin.y, self.tableview.bounds.size.width,self.tableview.bounds.size.height)];
////
////    image1.image=[UIImage imageNamed:@"delete"];
////    image1.contentMode=UIViewContentModeScaleAspectFill;
////    deleteAction.backgroundColor = [UIColor colorWithPatternImage:image1.image];
//        deleteAction.backgroundColor = [UIColor redColor];
//
//    return @[deleteAction];
//
////    if (editingStyle == UITableViewCellEditingStyleDelete)
////    {
////            ProductClass *pro_class = nil;
////            pro_class = [detailsArray objectAtIndex:indexPath.row];
////            NSString *pro_id=[NSString stringWithFormat:@"%@",pro_class.product_id];
////            //remove the deleted object from your data source.
////            //If your data source is an NSMutableArray, do this
////            [detailsArray removeObjectAtIndex:indexPath.row];
////
////            [self apiremoveFavoriteMethodProduct_id:pro_id];
////        //        AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
////        //        [appdelegate.productItemArray removeObjectAtIndex:indexPath.row];
////           [tableView reloadData];
////      // tell table to refresh now
////    }
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
    
    [self.navigationController pushViewController:myVC animated:YES];
}

-(void)callapiForAddProductIntoCart:(NSString *)pro_ID andvariationType:(NSString *)variation andIndex:(NSInteger)ind
{
    if([Utils isNetworkAvailable] ==YES)
    {
        
        [SVProgressHUD show];
        NSError *error = nil;
        NSData *jsonData2;
        NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        NSMutableArray * arr = [[NSMutableArray alloc] init];
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
//                                        [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                                    });
                 }
                 else
                 {
                    
                     NSError *parseError = nil;
                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                     NSLog(@"%@",responseDictionary);
                     NSString *message = [responseDictionary valueForKey:@"message"];
                     NSString *status=[responseDictionary valueForKey:@"status"];
                     //glableArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
                     [self removeImage];
                      if ([status isEqualToString:@"S"])
                    {
                        [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"card_flag"];
                            dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                            NSLog(@"%@",status);
                            [detailsArray removeObjectAtIndex:ind];
                             [self.tableview reloadData];
                             //           [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                             self.alertView.hidden=NO;
                             self.subAlertView.hidden=NO;
                             //  [self dismissViewControllerAnimated:NO completion:nil];
                             double delayInSeconds = 1;
                              dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                              dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                              {
                                   self.alertView.hidden=YES;
                                   self.subAlertView.hidden=YES;
                                   [self refreshView];
//                                 [self.navigationController popViewControllerAnimated:TRUE];
                             });
                             
                         });
                       }
                    else if([status isEqualToString:@"F"])
                     {
                         
                         dispatch_async(dispatch_get_main_queue(), ^(void){
                             [SVProgressHUD dismiss];
                             [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                             
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
-(void)apiremoveFavoriteMethodProduct_id:(NSString *)pro_id andIndex:(NSString *)num
{
    
    if([Utils isNetworkAvailable] ==YES)
    {
       
        [SVProgressHUD show];
        self.tableview.userInteractionEnabled=NO;

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
                                 self.tableview.userInteractionEnabled=YES;
                                 [SVProgressHUD dismiss];
                                 [self serverError];
//                                 [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                             });

          }
         else
         {
             
              NSError *parseError = nil;
              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
              NSLog(@"%@",responseDictionary);
              NSString *message = [responseDictionary valueForKey:@"message"];
              NSString *status=[responseDictionary valueForKey:@"status"];
             // glableArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
             [self removeImage];
             
             if ([status isEqualToString:@"S"])
             {
                 dispatch_async(dispatch_get_main_queue(), ^(void)
                 {
                        [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                     //  [detailsArray removeObjectAtIndex:[num integerValue]];
                     //  [_tableview reloadData];
                     [self refreshView];
                    });
              
            }
            else if([status isEqualToString:@"F"])
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self Interneterror];
//            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
    }
    
}
-(void)apicallMethodURLandreloading:(BOOL)check
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
         self.tableview.userInteractionEnabled=NO;
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
//        NSMutableArray* product_id_array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:WISHPRODUCTLIST]];
    
        NSString  *urlFavorite;
        NSDictionary *params;
//        if([product_id_array count] == 0 || check==YES)
//        {
//            check=NO;
          
            urlFavorite=[NSString stringWithFormat:@"%@",GetFavorite];
//            [SVProgressHUD dismiss];
            params = @{@"user_id":user_id};
//        }
//        else
//        {
//            urlFavorite=[NSString stringWithFormat:@"%@",AddFavorite];
//            NSError *error = nil;
//            NSDictionary *dic=[product_id_array mutableCopy];
//            NSMutableString *createJSON = [[NSMutableString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding];
//
//            //  [createJSON replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[createJSON length]}];
//            [createJSON replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[createJSON length]}];
//            //   [createJSON replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[createJSON length]}];
//            //            [createJSON stringByReplacingOccurrencesOfString:@"" withString:@""];
//            // NSString *product_str=[NSString stringWithFormat:@"%@",createJSON];
//
//            params = @{@"user_id":user_id,@"product_id":createJSON};
//
//        }

            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
            NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,urlFavorite ];
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
                                       self.tableview.userInteractionEnabled=YES;
                                       [SVProgressHUD dismiss];
                        [self serverError];
//                                       [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                    });
                    
                }
                else
                {
                    
                      NSError *parseError = nil;
                      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                      NSLog(@"%@",responseDictionary);
                     [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                    [self removeImage];
                    if (check==YES)
                    {
                        glableArray=[NSMutableArray new];
                        detailsArray=[NSMutableArray new];
                    }
                    
//                      NSString *message = [responseDictionary valueForKey:@"message"];
                      NSString *status=[responseDictionary valueForKey:@"status"];
                      glableArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
                    
                    if([status isEqualToString:@"W"])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^(void)
                         {
                    
                            self.tableview.userInteractionEnabled=YES;
                                glableArray=[NSMutableArray new];
                                [self.tableview reloadData];
                            
                             UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.tableview.frame.origin.x, self.tableview.frame.origin.y, self.tableview.frame.size.height, self.tableview.frame.size.width)];
                             imageView.contentMode = UIViewContentModeScaleAspectFit;
                             self.tableview.backgroundColor=[UIColor whiteColor];
                             imageView.image =[UIImage imageNamed:@"Empty-wishlist"];
                             
                             self.tableview.backgroundView = imageView;
                             self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
                             self.tableview.separatorColor=[UIColor clearColor];
                             self.tableview.scrollEnabled=NO;
                             [SVProgressHUD dismiss];
                             //   [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                          });
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
                     
//                            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[dic valueForKey:@"product_image"] ]];
//                            product_calss.product_image = imageData;
                            product_calss.product_image=[NSString stringWithFormat:@"%@",[dic valueForKey:@"product_image"]];
                            [detailsArray addObject:product_calss];
                            
                            if(detailsArray.count==glableArray.count)
                            {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    
                                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:WISHPRODUCTLIST];
                                    [_tableview reloadData];
                                     self.tableview.userInteractionEnabled=YES;
                                    [SVProgressHUD dismiss];
//                                    [self refreshView];
                                });
                                //                       [_tableview reloadData];
                            }
                        }
                     
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [SVProgressHUD dismiss];
                            self.tableview.userInteractionEnabled=YES;
                           [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
                        });
                        
                    }
                }
          }];
            [dataTask resume];
//        }
        
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


- (IBAction)act_setting:(id)sender {
    
    UIStoryboard  *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HomeTabBar *paymentOrder = (HomeTabBar *)[storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
    paymentOrder.selectedIndex=3;
    [self.navigationController pushViewController:paymentOrder animated:YES];
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
