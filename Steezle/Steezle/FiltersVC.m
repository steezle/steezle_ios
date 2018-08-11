//
//  FiltersVC.m
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "FiltersVC.h"
#import "FilterCollectionCell.h"
#import "CatergoriesListVC.h"
#import "Globals.h"
#import "Utils.h"
#import "ShoppingCartVC.h"
#import "SVProgressHUD.h"
#import "catergoriesClass.h"
#import "ProductVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "userdefaultArrayCall.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "SearchViewController.h"
#import "HomeView.h"

@interface FiltersVC ()<UITextFieldDelegate,UISearchControllerDelegate,SearchViewControllerDelegate>
{
    int tag;
    int flag;
    NSString *searchStr;
    NSMutableArray *categorylistArray1;
    
}

@end

@implementation FiltersVC
@synthesize errorImage;
-(UIView *)PaddingView
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    _IteamCardLBL.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
    [self getCategories];
    //    [self apicallMethodURL];
    
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
                _child_top_h.constant=40;
                
                
            } else {
                
            }
        }
        else
        {
            NSLog(@"Others");
        }
    }
}
-(void)getCategories
{
    
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        self.collectionView.userInteractionEnabled=NO;
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        NSDictionary *params = @{@"user_id":user_id};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Categories];
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
                                                                     [SVProgressHUD dismiss];self.collectionView.userInteractionEnabled=YES;
                                                                     [self serverError];
                                                                     //    [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                                                                 });
                                              }
                                              else
                                              {
                                                  
                                                  NSError *parseError = nil;
                                                  NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                  NSString *message =[responseDictionary valueForKey:@"message"];
                                                  NSString *status =[responseDictionary valueForKey:@"status"];
                                                  [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                                                  [self removeImage];
                                                  if([status isEqualToString:@"S"])
                                                  {
                                                      
                                                      _categorylistArray=[NSMutableArray new];
                                                      _categorylistArray =[responseDictionary[@"data"] mutableCopy];
                                                      NSLog(@"%@",_categorylistArray);
                                                      _detailsArray=[NSMutableArray new];
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          // UI UPDATE 2
                                                          for (int i = 0 ; i<_categorylistArray.count; i++)
                                                          {
                                                              NSDictionary *dic = [_categorylistArray objectAtIndex:i];
                                                              catergoriesClass *calssobj=[[catergoriesClass alloc]init];
                                                              calssobj.name = [NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]];
                                                              calssobj.cater_id = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
                                                              // NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:[dic valueForKey:@"image"] ]];
                                                              // calssobj.image = imageData;
                                                              calssobj.image=[NSString stringWithFormat:@"%@",[dic valueForKey:@"image"]];
                                                              [_detailsArray addObject:calssobj];
                                                              if(_detailsArray.count==_categorylistArray.count)
                                                              {
                                                                  [self.collectionView reloadData];
                                                                  self.collectionView.userInteractionEnabled=YES;
                                                                  [SVProgressHUD dismiss];
                                                                  
                                                              }
                                                          }
                                                      });
                                                  }
                                                  else if ([status isEqualToString:@"F"])
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                     {
                                                                         [SVProgressHUD dismiss];
                                                                         self.collectionView.userInteractionEnabled=YES;
                                                                         [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                                                                     });
                                                  }
                                                  else
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                     {
                                                                         [SVProgressHUD dismiss];
                                                                         self.collectionView.userInteractionEnabled=YES;
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
            self.collectionView.userInteractionEnabled=YES;
            [self Interneterror];
            
            //            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    errorImage.alpha=0;
    [SVProgressHUD setForegroundColor:[UIColor blackColor]];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    tag=1;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    CGRect rect = self.collectionView.frame;
    rect.origin.x = 5;
    rect.origin.y = 0;
    rect.size.width = [[UIScreen mainScreen] bounds].size.width - 5;
    rect.size.height = [[UIScreen mainScreen] bounds].size.height;
    
    self.collectionView.frame = rect;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)didReceiveMemoryWarning
{
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
//-(void) setBorder:(UIView *) theView withBGColor:(UIColor *) color withCornerRadius :(float) radius andBorderWidth :(float) borderWidth andBorderColor :(UIColor *) bgColor WithAlpha:(float) curAlpha
//{
//    theView.layer.borderWidth = borderWidth;
//    theView.layer.cornerRadius = radius;
//    theView.layer.borderColor = [color CGColor];
//    UIColor *c = [color colorWithAlphaComponent:curAlpha];
//    theView.layer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);
//}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //return [_categorylistArray count];
    return _detailsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    FilterCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    
    catergoriesClass *catergories_calss = nil;
    catergories_calss = [_detailsArray objectAtIndex:indexPath.row];
    
    [cell.image sd_setShowActivityIndicatorView:YES];
    [cell.image sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:catergories_calss.image]
                  placeholderImage:[UIImage imageNamed:@"empty_home"]
                           options:SDWebImageRefreshCached];
    
    //    cell.image.contentMode = UIViewContentModeScaleAspectFit;
    //    cell.image.image = [UIImage imageWithData: catergories_calss.image];
    NSString *brandstr=[NSString stringWithFormat:@"%@",catergories_calss.name];
    
    if ([brandstr isEqualToString:@"Shuffle"])
    {
        brandstr=@"SHUFFLE";
    }
    
    cell.lbl.text=brandstr;
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //    cell.layer.borderWidth = 7.0f;
    cell.layer.contentsScale = [UIScreen mainScreen].scale;
    cell.layer.shadowOpacity = 0.75f;
    cell.layer.shadowRadius = 5.0f;
    cell.layer.shadowOffset = CGSizeZero;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    cell.layer.shouldRasterize = NO;
    
    
    //    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:cell.image.bounds];
    //    cell.image.layer.masksToBounds = NO;
    //    cell.image.layer.shadowColor = [UIColor blackColor].CGColor;
    //    cell.image.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    //    cell.image.layer.shadowOpacity = 0.5f;
    //    cell.image.layer.shadowPath = shadowPath.CGPath;
    
    //    cell.image.image = [UIImage imageNamed: [image_array objectAtIndex:indexPath.row]];
    //    cell.lbl.text = [label_array objectAtIndex:indexPath.row];
    //    cell.backgroundColor = [UIColor blackColor];
    //    [self setBorder:cell withBGColor:[UIColor greenColor] withCornerRadius:3.0 andBorderWidth:0.5 andBorderColor:[UIColor redColor] WithAlpha:1.0];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size=CGSizeMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-80);
    
    double screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
    {
        if(screenHeight == 812)
        {
            size=CGSizeMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-120);
            // smallFonts = true;
        }
    }
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    float width1,height1;
////    if(indexPath.row==1 || indexPath.row==3)
////    {
////         width1=(self.collectionView.frame.size.width/2)-10;
////         height1=(self.collectionView.frame.size.height/2)-7.5;
////    }
////    else
////    {
//         width1=(self.collectionView.frame.size.width/2)-30;
//         height1=(self.collectionView.frame.size.height/2)-30;
////    }
//    return CGSizeMake(width1, height1);
//
//
////    int width = (self.view.frame.size.width -10)/2;
////    //int height = width+20;
////    int height =(self.view.frame.size.height -120)/2;
//////    var width = (self.view.frame.size.width - 12 * 3) / 3 //some width
//////    var height = width * 1.5; //ratio
//////    return CGSize(width: width, height: height);
////    return CGSizeMake(width, height);
//}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Clicked %ld", indexPath.row);
    catergoriesClass *catergories_calss = nil;
    catergories_calss = [_detailsArray objectAtIndex:indexPath.row];
    
    NSString *str_id=[NSString stringWithFormat:@"%@",catergories_calss.cater_id];
    
    NSString *brandstr=[NSString stringWithFormat:@"%@",catergories_calss.name];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([brandstr isEqualToString:@"Shuffle"])
    {
        brandstr=@"SHUFFLE";
        //        SubBrandCateVC *subBrand = (SubBrandCateVC *)[storyboard instantiateViewControllerWithIdentifier:@"SubBrandCateVC"];
        //        subBrand.product_id=str_id;
        //        subBrand.productTitle=brandstr;
        //        //    [self presentViewController:myVC animated:NO completion:nil];
        //        [self.navigationController pushViewController:subBrand animated:YES];
        
        //        NSString *name=[[sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ProductVC *myVC = (ProductVC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductVC"];
        myVC.product_id=str_id;
        myVC.Page_Title=brandstr;
        myVC.FromShuffel=YES;
        myVC.delegate=self;
        //    [self presentViewController:myVC animated:NO completion:nil];
        [self.navigationController pushViewController:myVC animated:YES];
        
    }else
    {
        CatergoriesListVC *myVC = (CatergoriesListVC *)[storyboard instantiateViewControllerWithIdentifier:@"CatergoriesListVC"];
        
        myVC.product_id=str_id;
        myVC.productTitle=brandstr;
        //    [self presentViewController:myVC animated:NO completion:nil];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    
    
    
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"indexPath:%@",indexPath);
}


//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5.0;
//}
// Layout: Set Edges
//- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//
//    return UIEdgeInsetsMake(10,10,10,10);  // top, left, bottom, right
//}
//#pragma mark – UICollectionViewDelegateFlowLayout
//
//// 1
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGSize s = CGSizeMake([[UIScreen mainScreen] bounds].size.width/2 - 8, [[UIScreen mainScreen] bounds].size.height/2-70);
//    return s;
//}
//
//// 3
//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 0, 5, 5);
//}



//- (IBAction)backBtnClick:(id)sender
//{
//      [self dismissViewControllerAnimated:NO completion:nil];
//      [self.navigationController popViewControllerAnimated:TRUE];
//}

- (IBAction)ActionSearchBTN:(id)sender
{
    SearchViewController * con=[SearchViewController new];
    con.delegate=self;
    [self.navigationController pushViewController:con animated:YES];
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    SearchViewController *searchVC = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    //    [self presentViewController:searchVC animated:YES completion:nil];
    
    //    [self.navigationController pushViewController:searchVC animated:YES];
    //    if(tag==1)
    //    {
    //        _searchLbl.hidden=YES;
    //        _search_TF.hidden=NO;
    //        [self.search_TF becomeFirstResponder];
    //        tag=0;
    //    }
    //    else
    //    {
    //        _searchLbl.hidden=NO;
    //        _search_TF.hidden=YES;
    ////        [self.search_TF becomeFirstResponder];
    //        tag=1;
    //    }
    
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
-(void)updateTotalcount:(NSString *)total_bag andSteez:(NSString *)total_steez
{
    [[NSUserDefaults standardUserDefaults]setObject:total_bag forKey:Total_Cart];
    [[NSUserDefaults standardUserDefaults]setObject:total_steez forKey:Total_Steez];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //        _badge_lbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Steez]];
        _IteamCardLBL.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
    });
    
}
- (IBAction)ActCardShopping:(id)sender
{
    
    //    ShoppingCartVC *myVC = (ShoppingCartVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ShoppingCartVC"];
    //    [self.navigationController pushViewController:myVC animated:YES];
    
    BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
    if (!skipUser)
    {
        //        [self getCategories];
        ShoppingCartVC *myVC = (ShoppingCartVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ShoppingCartVC"];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
                                                                      message:@"Sign in or Sign Up to add products to Bag"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Continue"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                        LoginVC *home = (LoginVC *)[storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                                        [self.navigationController pushViewController:home animated:YES];
                                    }];
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}


-(void)apicallMethodURL
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        //  NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        NSDictionary *params = @{@"user_id":user_id};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,GetCart ];
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
                                                                     self.collectionView.userInteractionEnabled=NO;
                                                                     [self serverError];
                                                                     //                     [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                                                                 });
                                              }
                                              else
                                              {
                                                  NSError *parseError = nil;
                                                  NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                  NSDictionary *card_Dic=[NSDictionary new];
                                                  card_Dic =[responseDictionary[@"data"] mutableCopy];
                                                  [self removeImage];
                                                  NSString *status=[responseDictionary valueForKey:@"status"];
                                                  if([status isEqualToString:@"S"])
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          flag=1;
                                                          [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                                                          [SVProgressHUD dismiss];
                                                          self.collectionView.userInteractionEnabled=NO;
                                                          
                                                      });
                                                  }
                                                  else if([status isEqualToString:@"F"])
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          flag=0;
                                                          self.collectionView.userInteractionEnabled=NO;
                                                          
                                                          [SVProgressHUD dismiss];
                                                          
                                                      });
                                                  }
                                                  else
                                                  {
                                                      dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                     {
                                                                         [SVProgressHUD dismiss];
                                                                         self.collectionView.userInteractionEnabled=NO;
                                                                         
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
            self.collectionView.userInteractionEnabled=NO;
            
            [self Interneterror];
            
            //            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
        
    }
    
}

#pragma mark - searchViewController协议代理
- (void)searchViewControllerSearchButtonClicked:(SearchViewController *)controller andSearchValue:(NSString *)searchValue
{
    NSLog(@"searchValue-->%@",searchValue);
    searchStr=searchValue;
    //    [controller.navigationController popViewControllerAnimated:YES];
    [self SearchAPICallPostMethodSearchvalue];
    
}

- (void)searchViewControllerCancleButtonClicked:(SearchViewController *)controller{
    
    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)SearchAPICallPostMethodSearchvalue
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        NSDictionary *params = @{@"user_id":user_id,@"s":searchStr};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,Search ];
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
                                                                     [self serverError];
                                                                     //                                                                     [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                                                                 });
                                                  
                                              }
                                              else
                                              {
                                                  [self removeImage];
                                                  NSError *parseError = nil;
                                                  NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                  NSLog(@"%@",responseDictionary);
                                                  NSString *message = [responseDictionary valueForKey:@"message"];
                                                  NSString *status=[responseDictionary valueForKey:@"status"];
                                                  
                                                  if([status isEqualToString:@"S"])
                                                  {
                                                      [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          categorylistArray1=[NSMutableArray new];
                                                          categorylistArray1 =[responseDictionary[@"data"] mutableCopy];
                                                          NSLog(@"%@",categorylistArray1);
                                                          [SVProgressHUD dismiss];
                                                          //                    if (_Fromproduct==YES)
                                                          //                    {
                                                          //                        [self passDataBack];
                                                          //                    }else
                                                          //                    {
                                                          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                          ProductVC *myVC = (ProductVC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductVC"];
                                                          // myVC.product_id=product_id;
                                                          myVC.FromSearchApi=TRUE;
                                                          //                     myVC.product_id=[responseDictionary valueForKey:@"product_id"];
                                                          myVC.ProductlistArray=[NSMutableArray new];
                                                          myVC.ProductlistArray=[categorylistArray1 mutableCopy];
                                                          myVC.Page_Title=@"Categories";
                                                          [self.navigationController pushViewController:myVC animated:YES];
                                                          
                                                          //                    }
                                                      });
                                                      // [SVProgressHUD dismiss];
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
            [self Interneterror];
            
            //            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
        
    }
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

