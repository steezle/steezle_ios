//
//  PayementOrderDetailsVC.m
//  Steezle
//
//  Created by webmachanics on 14/11/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "PayementOrderDetailsVC.h"
#import "OrderDetailsCell.h"
#import "Globals.h"
#import "Utils.h"
#import "OrderDetailsClass.h"
#import "userdefaultArrayCall.h"
#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "DateUTC.h"
#import <CoreText/CTStringAttributes.h>
#define FONTNAME_REG   @"HelveticaNeue"
#define LFONT_13         [UIFont fontWithName:FONTNAME_REG size:13]
@interface PayementOrderDetailsVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSMutableArray *ProdDetsArray;
    NSMutableArray *GlobalArray;
    NSMutableArray *detailsArray;
    NSMutableArray *countarray;
    
}
@end

@implementation PayementOrderDetailsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _dicView.alpha=0;
    _discountLBl.alpha=0;
    _CouponCodeLBL.alpha=0;
    _lineLBL.alpha=0;
    ProdDetsArray=[NSMutableArray new];
    countarray=[NSMutableArray new];
    
    self.tableView.userInteractionEnabled=NO;
    [self methodForPaymentDetailsAPIcalling];
    
   
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
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
- (void)viewWillAppear:(BOOL)animated
{
    // just add this line to the end of this method or create it if it does not exist
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
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
    return ProdDetsArray.count;
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
     OrderDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
   
    if (cell == nil)
    {
       
       cell = (OrderDetailsCell*)[tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
        
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }

    OrderDetailsClass *ord_calss = nil;
    ord_calss = [ProdDetsArray objectAtIndex:indexPath.row];

    [cell.ProduImage sd_setShowActivityIndicatorView:YES];
    [cell.ProduImage sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [cell.ProduImage sd_setImageWithURL:[NSURL URLWithString:ord_calss.imageURL]                  placeholderImage:[UIImage imageNamed:@"empty_menu"]                           options:SDWebImageRefreshCached];
    cell.ProduImage.contentMode = UIViewContentModeScaleAspectFit;

    cell.PriceLBL.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%@",ord_calss.price]];

    cell.NameLBL.text=[NSString stringWithFormat:@"%@",ord_calss.name];
    cell.qtyLBL.text=[NSString stringWithFormat:@"%@",ord_calss.quantity];
    cell.BrandNameLBL.text=[NSString stringWithFormat:@"%@",ord_calss.brand_name];
    if ([cell.BrandNameLBL.text isEqualToString:@"Yung2"]) {
        NSMutableAttributedString *carbonDioxide = [[NSMutableAttributedString alloc] initWithString:@"Yung2"];
        [carbonDioxide addAttribute:(NSString *)kCTSuperscriptAttributeName value:@+1 range:NSMakeRange(4,1)];
        cell.BrandNameLBL.attributedText=carbonDioxide;
    }
    
    
    cell.SizeLBL.text=[NSString stringWithFormat:@"%@",ord_calss.size];
    cell.ColorLBL.text=[NSString stringWithFormat:@"%@",ord_calss.color];
    
    if (ord_calss.size==nil && ord_calss.color==nil)
    {
        cell.SizeLBL.text=@"";
        cell.ColorLBL.text=@"";
        cell.dotLBL.backgroundColor=[UIColor whiteColor];
    }
    else if (ord_calss.size==nil)
    {
        cell.SizeLBL.text=@"";
        cell.ColorLBL.text=[NSString stringWithFormat:@"%@",ord_calss.color];
        cell.dotLBL.backgroundColor=[UIColor whiteColor];
    }
    else if (ord_calss.color==nil)
    {
        cell.SizeLBL.text=@"";
        cell.ColorLBL.text=[NSString stringWithFormat:@"%@",ord_calss.size];
        cell.dotLBL.backgroundColor=[UIColor whiteColor];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)ActBack:(id)sender {
    
     [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)ActionProcess:(id)sender {
    
   
}



-(void)methodForPaymentDetailsAPIcalling
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
         NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:USERID]];
        NSDictionary *params = @{@"user_id":user_id,@"order_id":_Order_Id};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,OrderDetail ];
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
                                     self.tableView.userInteractionEnabled=YES;
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
                    GlobalArray=[NSMutableArray new];
                  
                    detailsArray=[NSMutableArray new];
                  
                    if([status isEqualToString:@"F"])
                    {
                       
                        self.tableView.userInteractionEnabled=YES;
                        //Background Thread
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            
                            [self.tableView reloadData];
                            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.height, self.tableView.frame.size.width)];
                            imageView.contentMode = UIViewContentModeScaleAspectFit;
                            self.tableView.backgroundColor=[UIColor whiteColor];
                            imageView.image =[UIImage imageNamed:@"empty_orderList"];
                            
                            self.tableView.backgroundView = imageView;
                            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                            self.tableView.separatorColor=[UIColor clearColor];
                            self.tableView.scrollEnabled=NO;
                            [SVProgressHUD dismiss];
                        });
                    }
                   else if ([status isEqualToString:@"S"])
                   {
                       
                         dispatch_async(dispatch_get_main_queue(), ^{
                             GlobalArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
                             detailsArray=[[GlobalArray valueForKey:@"line_items"] mutableCopy];
                             
                             NSLog(@"%@",GlobalArray);
                             
                              _MarchandiseLBL.text=[NSString stringWithFormat:@"$%@",[GlobalArray valueForKey:@"subtotal"]];
                              _ShippingLBL.text=[NSString stringWithFormat:@"$%@",[GlobalArray valueForKey:@"Shipping"]];
                             
                             NSString *tel=[GlobalArray valueForKey:@"used_coupons"];
                              if(tel==(id) [NSNull null] || [tel length]==0 || [tel isEqualToString:@""] || [tel isEqualToString:@"<null>"])
                                 
                              {
                                   _discountView.constant=0;
                                    _disValue.alpha=0;
                                    _discountLBl.alpha=0;
                                   _lineLBL.alpha=0;
                                   _CouponCodeLBL.alpha=0;
                                   _dicView.alpha=0;
                               }
                             else
                             {
                                _disValue.text=[NSString stringWithFormat:@"-$%@",[GlobalArray valueForKey:@"total_discount"]];
                                 _disValue.alpha=1;
                                 _discountLBl.alpha=1;
                                 _CouponCodeLBL.alpha=1;
                                 _lineLBL.alpha=1;
                                 _dicView.alpha=1;
                                 _CouponCodeLBL.text=[NSString stringWithFormat:@"(%@)",tel];
                                
                                 
                             }
                              _TexLBL.text=[NSString stringWithFormat:@"$%@",[GlobalArray valueForKey:@"Tax"]];
                              _TotalOrderLBL.text=[NSString stringWithFormat:@"$%@",[GlobalArray valueForKey:@"total"]];
                              _Order_idLBL.text=[NSString stringWithFormat:@"#%@",[GlobalArray valueForKey:@"id"]];
                             NSDictionary *pay=[NSDictionary new];
                             pay=[[GlobalArray valueForKey:@"payment_details"]mutableCopy];
                             _PaymentTypeLBL.text=[NSString stringWithFormat:@"%@",[pay valueForKey:@"method_title"]];
                             NSString *status=[NSString stringWithFormat:@"%@",[GlobalArray valueForKey:@"status"]];
                             
                             if ([status isEqualToString:@"completed"])
                             {
                                 
                                 self.ProcessBTN.backgroundColor=[UIColor colorWithRed:17/255.0 green:100/255.0 blue:5/255.0 alpha:1.0f];
                                 
                             }
                             else
                             {
                                 
                                 self.ProcessBTN.backgroundColor=[UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1.0f];
                             }
                             
                             [self.ProcessBTN setTitle:[self capitalizeFirstLetterOnlyOfString:status] forState:UIControlStateNormal];
                              
                              _AddressLBL.text=[NSString stringWithFormat:@"%@",[GlobalArray valueForKey:@"billing_address"]];
                       
//                              NSString *updateDate=[NSString stringWithFormat:@"%@",[GlobalArray valueForKey:@"updated_at"]];
                             NSString *datestring= [DateUTC ChangeDateInUTC:[GlobalArray valueForKey:@"updated_at"]];
                              _PlacedDateLBL.text=datestring;
                       
                       
                       for (int i=0;i<detailsArray.count; i++)
                       {
                           NSDictionary *dic=[NSDictionary new];
                           dic=[[detailsArray objectAtIndex:i] mutableCopy];
                           
                           OrderDetailsClass *order_class=[[OrderDetailsClass alloc]init];
                           order_class.id_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"id"]];
                           order_class.name = [NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]];
                           order_class.price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"price"]];
                           order_class.product_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_id"]];
                           order_class.imageURL = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_thumbnail_url"]];
                           order_class.quantity = [NSString stringWithFormat:@"%@", [dic valueForKey:@"quantity"]];
                           order_class.sku = [NSString stringWithFormat:@"%@", [dic valueForKey:@"sku"]];
                           order_class.subtotal = [NSString stringWithFormat:@"%@", [dic valueForKey:@"subtotal"]];
                           order_class.subtotal_tax = [NSString stringWithFormat:@"%@", [dic valueForKey:@"subtotal_tax"]];
                           order_class.total = [NSString stringWithFormat:@"%@", [dic valueForKey:@"total"]];
                           order_class.total_tax = [NSString stringWithFormat:@"%@", [dic valueForKey:@"total_tax"]];
                           order_class.variation_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"variation_id"]];
                           order_class.brand_name = [NSString stringWithFormat:@"%@", [dic valueForKey:@"brand"]];
                           
                           NSDictionary *dicvariation=[NSDictionary new];
                           dicvariation=[[dic valueForKey:@"variation"]mutableCopy];

                           if (dicvariation.count!=0 && dicvariation[@"attribute_pa_size"] && dicvariation[@"attribute_pa_color"])
                            {
                                NSLog(@"Exists");
                                order_class.size=[NSString stringWithFormat:@"%@",[dicvariation valueForKey:@"attribute_pa_size"]];
                                order_class.color=[NSString stringWithFormat:@"%@",[dicvariation valueForKey:@"attribute_pa_color"]];
                                
                                order_class.count=@"both";
                           }
                           else if (dicvariation.count!=0 && dicvariation[@"attribute_pa_size"])
                           {
                               order_class.size=[NSString stringWithFormat:@"%@",[dicvariation valueForKey:@"attribute_pa_size"]];
                                order_class.count=@"size";
                           }
                           else if (dicvariation.count!=0 && dicvariation[@"attribute_pa_color"])
                           {
                                order_class.color=[NSString stringWithFormat:@"%@",[dicvariation valueForKey:@"attribute_pa_color"]];
                                order_class.count=@"color";
                           }
                           else
                           {
                                NSLog(@"Does not exist");
                               order_class.count=@"simple";
                           }
                           [countarray addObject:order_class.count];
                           [ProdDetsArray addObject:order_class];
                           
                           if(ProdDetsArray.count==detailsArray.count)
                           {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   NSInteger count=ProdDetsArray.count;
                                   if (count>2)
                                   {
                                        _tableHightLayout.constant=count*120;
                                   }
                                  
                                   self.tableView.userInteractionEnabled=YES;
                                   [self.tableView reloadData];
                                    [SVProgressHUD dismiss];
                                   
                               });
                          }
                      }
                             
                    });
                     
                   }
                   else
                  {
                          dispatch_async(dispatch_get_main_queue(), ^(void)
                          {
                              self.tableView.userInteractionEnabled=YES;
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
              self.tableView.userInteractionEnabled=YES;
               [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
            
        });
       
    }

}

- (NSString *)capitalizeFirstLetterOnlyOfString:(NSString *)string
{
    NSMutableString *result = [string lowercaseString].mutableCopy;
    [result replaceCharactersInRange:NSMakeRange(0, 1) withString:[[result substringToIndex:1] capitalizedString]];
    
    return result;
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

@end
