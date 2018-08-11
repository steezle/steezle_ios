//
//  FilterPro_VC.m
//  Steezle
//
//  Created by Ryan Smith on 2018-01-19.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import "FilterPro_VC.h"
//#import "VPRangeSlider.h"
#import "FilterBrandCell.h"
#import <QuartzCore/QuartzCore.h>
#import "userdefaultArrayCall.h"
#import "SVProgressHUD.h"
#import "Utils.h"
#import "Globals.h"
#import "SliderDemo.h"
#import "ProductVC.h"
#import <CoreText/CTStringAttributes.h>
//#import "RangeSlider.h"

@interface FilterPro_VC ()<UITableViewDelegate,UITableViewDataSource,TTRangeSliderDelegate>
{
    NSMutableArray *brand_array;
    SliderDemo *sliderVctr;
    float min,max;
    NSString *setMin,*setMax;
    NSMutableArray *productArray;
    
}
//@property (strong,nonatomic) IBOutlet RangeSlider *rangeSlider;
//@property (weak, nonatomic) IBOutlet VPRangeSlider *rangeSliderView;
@property (weak, nonatomic) IBOutlet TTRangeSlider *rangeSlider;
@end

@implementation FilterPro_VC
@synthesize  filter_arr,CategoryID,filter_Price,slideView,delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    brand_array=[NSMutableArray new];
    filter_arr=[NSMutableArray new];
//    self.tableview.allowsMultipleSelection = YES;
//    brand_array= [[NSMutableArray alloc] initWithObjects:@"asdgfasd", @"asdgfsd", @"gsdgsdgR", @"HsdgsdgPC", @"HsdgsdgP", @"HsdgsdgssdgTI", nil];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.allowsMultipleSelection=YES;
    [self getFilterCategories];
   
   
//    self.rangeSliderView.requireSegments = NO;
//    self.rangeSliderView.sliderSize = CGSizeMake(20, 20);
//    self.rangeSliderView.segmentSize = CGSizeMake(10, 10);
//
//    self.rangeSliderView.rangeSliderForegroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0f];
//
//
//    self.rangeSliderView.rangeSliderButtonImage = [UIImage imageNamed:@"slider"];
//    [self.rangeSliderView setDelegate:self];
//    [self.rangeSliderView scrollStartSliderToStartRange:min andEndRange:max];
    
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

-(void)updateRangeLabel:(SliderDemo *)slider
{
    self.minLbl.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%0.0f", slider.selectedMinimumValue]];
    self.MaxLbl.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%0.0f", slider.selectedMaximumValue]];
    setMax=[NSString stringWithFormat:@"%0.0f", slider.selectedMaximumValue];
    setMin=[NSString stringWithFormat:@"%0.0f", slider.selectedMinimumValue];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
//#pragma mark - VPRangeSliderDelegate
//- (void)sliderScrolling:(VPRangeSlider *)slider withMinPercent:(CGFloat)minPercent andMaxPercent:(CGFloat)maxPercent
//{
//    self.rangeSliderView.minRangeText = [NSString stringWithFormat:@"%.0f", minPercent];
//    self.rangeSliderView.maxRangeText = [NSString stringWithFormat:@"%.0f", maxPercent];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40 ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return brand_array.count;
    //    return addressArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FilterBrandCell *cell= (FilterBrandCell*)[tableView dequeueReusableCellWithIdentifier:@"brand_cell"];
   
    cell.lbl.text=[NSString stringWithFormat:@"%@",brand_array[indexPath.row][@"brand"]];
    
    if ([cell.lbl.text isEqualToString:@"Yung2"]) {
        NSMutableAttributedString *carbonDioxide = [[NSMutableAttributedString alloc] initWithString:@"Yung2"];
        [carbonDioxide addAttribute:(NSString *)kCTSuperscriptAttributeName value:@+1 range:NSMakeRange(4,1)];
        cell.lbl.attributedText=carbonDioxide;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Selected row of section >> %ld",(long)indexPath.row);
    [filter_arr addObject:brand_array[indexPath.row][@"brand_id"]];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected row of section >> %ld",(long)indexPath.row);
    NSString *value=[NSString stringWithFormat:@"%@",brand_array[indexPath.row][@"brand_id"]];
    for (int i=0;i<filter_arr.count;i++)
    {
         if ([value isEqualToString:[NSString stringWithFormat:@"%@",filter_arr[i]]])
         {
                    [filter_arr removeObjectAtIndex:i];
         }
     }
    
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
//    {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//
//        NSString *value=[NSString stringWithFormat:@"%@",brand_array[indexPath.row][@"brand_id"]];
////
//        for (int i=0;i<filter_arr.count;i++)
//        {
//            if ([value isEqualToString:[NSString stringWithFormat:@"%@",filter_arr[i]]])
//            {
//                [filter_arr removeObjectAtIndex:i];
//            }
//        }
//
//
//    }
//    else
//    {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        [filter_arr addObject:brand_array[indexPath.row][@"brand_id"]];
//
//    }
//}

- (IBAction)act_apply:(id)sender
{
    [self SetFilterProduct];
}
- (IBAction)Act_back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ProductVC *myVC = (ProductVC *)[storyboard   instantiateViewControllerWithIdentifier:@"ProductVC"];
//    //myVC.product_id=product_id;
//    myVC.FromFilterApi=TRUE;
//    myVC.ProductlistArray=[NSMutableArray new];
//    myVC.ProductlistArray=[productArray mutableCopy];
//    [self.navigationController pushViewController:myVC animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)getFilterCategories
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        NSDictionary *params;
        if (_FromShuffel==YES)
        {
            params = @{@"user_id":user_id,@"category_id":@"0",@"brand_id":@"0"/*CategoryID*/};
        }
        else
        {
            params = @{@"user_id":user_id,@"category_id":CategoryID,@"brand_id":@"0"};
        }
//        params = @{@"user_id":user_id,@"category_id":CategoryID};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Filter_Product];
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
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
 
                          brand_array=[[responseDictionary valueForKey:@"brand_filtters"] mutableCopy];
                          filter_Price=[[responseDictionary valueForKey:@"price_filters"] mutableCopy];
                          
                          max=[[filter_Price valueForKey:@"max_price"] floatValue];
                          min=[[filter_Price valueForKey:@"min_price"] floatValue];
                          
                          
                          self.rangeSlider.delegate = self;
                          self.rangeSlider.minValue = min;
                          self.rangeSlider.maxValue = max;
                          self.rangeSlider.selectedMinimum =min;
                          self.rangeSlider.selectedMaximum =max;
                          self.rangeSlider.lineHeight = 2;
                          self.rangeSlider.handleColor = [UIColor blackColor];
                          self.rangeSlider.handleDiameter = 20;
                          self.rangeSlider.selectedHandleDiameterMultiplier = 1.3;
                          NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                          formatter.numberStyle = NSNumberFormatterCurrencyStyle;
                          self.rangeSlider.numberFormatterOverride = formatter;
                         
//                          _rangeSlider.minimumValue=min;
//                          _rangeSlider.maximumValue=max;
                          
//                         [_rangeSlider setMinimumRange:min maximumRange:max];
//                         [_rangeSlider setMinimumValue:min maximumValue:max];
                          
                          
                          
                          //_rangeSlider.minimumRange=min;
                          //_rangeSlider.maximumRange=max;
//                         [self updateLabels];
                          //UIView *VctrDtl=[[UIView alloc]initWithFrame:slideView.frame];
                       
                         
                         
//                          sliderVctr=[[SliderDemo alloc] initWithFrame:CGRectMake(0,0,self.slideView.bounds.size.width, self.slideView.bounds.size.height)];
//                          sliderVctr.minimumValue =min;
//                          sliderVctr.selectedMinimumValue = min;
//                          sliderVctr.maximumValue = max;
//                          sliderVctr.selectedMaximumValue = max;
//                          sliderVctr.minimumRange = 1;
                         
//                          [rangeSlider addTarget:self action:@selector(updateRangeLabel:) forControlEvents:UIControlEventValueChanged];
//                          [VctrDtl addSubview:sliderVctr];
                          setMin=[NSString stringWithFormat:@"$%d",(int)min];
                          setMax=[NSString stringWithFormat:@"$%d",(int)max];
                          
                          self.minLbl.text=setMin;
                          self.MaxLbl.text=setMax;
                          
//                          [slideView addSubview:sliderVctr];
                         [_tableview reloadData];
                         [SVProgressHUD dismiss];
                            });
                      
                      
                  }
                  else if ([status isEqualToString:@"F"])
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
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
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
       
    }
    
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
-(void)SetFilterProduct
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSError *error = nil;
        NSMutableArray *arr=[NSMutableArray new];
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        NSData *jsonData2;
        NSDictionary *price_dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   setMin, @"min",
                                   setMax, @"max",
                                   nil];
//        NSDictionary *secondJsonDictionary;
//        if ([filter_arr count]>0)
//        {
//          secondJsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                  filter_arr, @"brand",
//                                                  price_dic, @"price",nil];
//        }
//        else
//        {
//            secondJsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    price_dic, @"price",nil];
//        }
        
        NSDictionary *secondJsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              filter_arr, @"brand",
                                              price_dic, @"price",nil];
        [arr addObject:secondJsonDictionary];
        
         jsonData2 = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        NSDictionary *params;
        if (_FromShuffel==YES)
        {
           params = @{@"user_id":user_id,@"category_id":@"0",@"filters":jsonString,@"brand_id":@"0"/*CategoryID*/};
        }
        else
        {
            params = @{@"user_id":user_id,@"category_id":CategoryID,@"filters":jsonString,@"brand_id":@"0"};
        }
        
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Filter_Apply];
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
                     dispatch_async(dispatch_get_main_queue(), ^{
//                         [passDataBack]
                         
                         productArray =[NSMutableArray new];
//
                         
                        [ productArray  addObject:[[responseDictionary valueForKey:@"data"]mutableCopy]];
                         
                         [productArray addObject:[responseDictionary valueForKey:@"selected_filters"]];
                         [productArray addObject:[responseDictionary valueForKey:@"pages"]];
                         [SVProgressHUD dismiss];
                         [self passDataBack];
                     
                    });
                 }
                else if ([status isEqualToString:@"F"])
                {
                       dispatch_async(dispatch_get_main_queue(), ^{
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
        // }
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
        
    }
}
//[button addTarget:self action:@selector(passDataBack) forControlEvents:UIControlEventTouchUpInside];
- (void)passDataBack
{
    if ([delegate respondsToSelector:@selector(dataFromController:)])
    {
        [delegate dataFromController:productArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)valueChanged:(id)sender {
    [self updateLabels];
}

- (void)updateLabels
{
//    NSLog(@"$%d",(int)_rangeSlider.maximumValue);
//    NSLog(@"$%d",(int)_rangeSlider.minimumValue);
//    self.minLbl.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%0.0f", _rangeSlider.minimumValue]];
//    self.MaxLbl.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%0.0f", _rangeSlider.maximumValue]];
//    setMax=[NSString stringWithFormat:@"%0.0f", _rangeSlider.maximumValue];
//    setMin=[NSString stringWithFormat:@"%0.0f", _rangeSlider.minimumValue];
//    self.minLbl.text = [NSString stringWithFormat:@"%f", self.rangeSlider.minimumValue];
//    self.MaxLbl.text = [NSString stringWithFormat:@"%f", self.rangeSlider.maximumValue];
}
#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    
    NSLog(@"Standard slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
//    NSLog(@"$%d",(int)_rangeSlider.maximumValue);
//    NSLog(@"$%d",(int)_rangeSlider.minimumValue);
    ///self.minLbl.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%0.0f", selectedMinimum]];
   /// self.MaxLbl.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%0.0f", selectedMaximum]];
    setMax=[NSString stringWithFormat:@"%.0f",selectedMaximum];
    setMin=[NSString stringWithFormat:@"%.0f", selectedMinimum];
    
}


@end
