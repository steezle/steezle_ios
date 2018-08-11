//
//  ProductVC.m
//  Steezle
//
//  Created by Aecor Digital on 01/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "ProductVC.h"
#import "HomeTabBar.h"
#import "ProfileVC.h"
#import "ShoppingCartVC.h"
#import "ProductDetail_VC.h"
#import "AppDelegate.h"
#import "ProductFilterVC.h"
#import "Globals.h"
#import "CatergoriesListVC.h"
#import "Utils.h"
#import "SVProgressHUD.h"
#import "ProductClass.h"
#import "ProductWishListVC.h"
#import "userdefaultArrayCall.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FilterPro_VC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "SearchViewController.h"
#import <CoreText/CTStringAttributes.h>
#import "HomeView.h"
#import "LoginVC.h"


@interface ProductVC ()<UIImagePickerControllerDelegate,SwipeDelegate,SwipeViewDataSource,UITextFieldDelegate,SearchViewControllerDelegate,SecondViewFilterControllerDelegate>
{
    NSInteger cardsLoadedIndex;
    NSInteger last_index,badge_count;
    //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedimageproduct;
    //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    AppDelegate *appdeleagte;
    NSMutableArray *gloableArray;
    NSString *undo;
    NSInteger undo_direction,PageCount,PageSearchCount,PageFilterCount,pageType,maxPageCount;
    
    NSString  *shareimage;
    NSMutableArray *wishList_Product_id_Array,*TotalProduct_Swipe;
    int tag;
    UIImageView *imagPro_compl;
    UIImageView  *imageviewCatgy;
    BOOL fromSearch,current_index;
    NSString *searchStr;
    NSMutableArray *categorylistArray1,*previousFilterArray;
    
    
}

@end

@implementation ProductVC
@synthesize product_id,count,productID,WishProduct_id,FromSearchApi,ProductlistArray,swipeView,Page_Title,delegate,FromFilterApi,errorImage;

//%%% all the labels I'm using as example data at the moment

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
            _Ref_H.constant=30;
            _Ref_w.constant=30;
            _Swip_H.constant=300;
            _Prod_det_H.constant=60;
            _bottom_h.constant=45;
           
            //  _logoY.constant=70;
            //  smallFonts = true;
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
                _child_view_top.constant=40;
                
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (current_index)
    {
        gloableArray=[NSMutableArray new];
        wishList_Product_id_Array=[NSMutableArray new];
        appdeleagte=(AppDelegate *)[UIApplication sharedApplication].delegate;
        undo_direction=0;
        current_index=NO;
        if(FromSearchApi==YES)
        {
            [self setvalueWhensearchingFromCategory];
        }
        else if (FromFilterApi==YES)
        {
            [self setvalueWhensearchingFromCategory];
        }
        else
        {
            [self getCategories];
        }
    }
    else
    {
        _badge_lbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Steez]];
        _shoppingCountLbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
    }
    
    
}
- (NSString *)capitalizeFirstLetterOnlyOfString:(NSString *)string
{
    NSMutableString *result = [string lowercaseString].mutableCopy;
    [result replaceCharactersInRange:NSMakeRange(0, 1) withString:[[result substringToIndex:1] capitalizedString]];
    
    return result;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    if ([Page_Title isEqualToString:@"SHUFFLE"])
        self.HeaderLBL.text=Page_Title;
    else
        self.HeaderLBL.text=[self capitalizeFirstLetterOnlyOfString:Page_Title];
    
    
    errorImage.alpha=0;
    PageCount=1;
    PageSearchCount=1;
    PageFilterCount=1;
    current_index=YES;
    previousFilterArray=[NSMutableArray new];
    _badge_lbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Steez]];
    _shoppingCountLbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
//    _refreshBTN.layer.cornerRadius = 20;
//    _refreshBTN.layer.shadowRadius = 5.0f;
//    _refreshBTN.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    _refreshBTN.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
//    _refreshBTN.layer.shadowOpacity = 1.0f;
//    _refreshBTN.layer.masksToBounds = NO;
    
    
   
    tag=1;
    
   
//    self.count = 5;
    
    swipeView.dataSource = self;
    swipeView.delegate = self;
 
    
   
    NSLog(@"%@",product_id);
    [[NSUserDefaults standardUserDefaults] setObject:product_id forKey:@"prod_Id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"productId"]);
    
    
    
    NSLog(@"%d",FromSearchApi);
    undo=@"null";
    undo_direction=0;
 
    last_index=0;
//    count=[@(0) stringValue];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    tapGesture.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGesture];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self adddshadowOnwithborder];
}
-(void)adddshadowOnwithborder
{
    swipeView.layer.shadowRadius  = 5.0f;
    swipeView.layer.shadowColor   = [UIColor blackColor].CGColor;
    swipeView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    swipeView.layer.shadowOpacity = 0.3f;
    swipeView.layer.masksToBounds = NO;
    
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(swipeView.bounds, shadowInsets)];
    swipeView.layer.shadowPath    = shadowPath.CGPath;
    
  
    _bottomView.layer.shadowRadius  = 2.0f;
    _bottomView.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    _bottomView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    _bottomView.layer.shadowOpacity = 0.3f;
    _bottomView.layer.masksToBounds = NO;


    UIEdgeInsets shadowInsetsbottom     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPathbottom      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_bottomView.bounds, shadowInsetsbottom)];
    _bottomView.layer.shadowPath    = shadowPathbottom.CGPath;
    
    
//    _refreshBTN.layer.shadowRadius  = 2.0f;
//    _refreshBTN.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
//    _refreshBTN.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
//    _refreshBTN.layer.shadowOpacity = 0.3f;
//    _refreshBTN.layer.masksToBounds = NO;
//    
//    UIEdgeInsets shadowInsetsre     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
//    UIBezierPath *shadowPathre      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_refreshBTN.bounds, shadowInsetsre)];
//    _refreshBTN.layer.shadowPath    = shadowPathre.CGPath;
    
    
    
    _CrossBTN.backgroundColor=[UIColor whiteColor];
    _RightBTN.backgroundColor=[UIColor whiteColor];
    _hearBTN.backgroundColor=[UIColor whiteColor];
  
    [_CrossBTN setImage:[UIImage imageNamed:@"s_big_cross1"] forState:UIControlStateNormal];
     [_RightBTN setImage:[UIImage imageNamed:@"s_unsel_right11"] forState:UIControlStateNormal];
     [_hearBTN setImage:[UIImage imageNamed:@"s_big_unsel_hear11"] forState:UIControlStateNormal];

}

-(void)getCategories
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSString *pro_Id;
        pro_Id=product_id;
        
        if (product_id==nil)
        {
           pro_Id=[[NSUserDefaults standardUserDefaults] valueForKey:@"prod_Id"];
        }
        
        NSString *userId=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        NSDictionary *params;
        NSURLSession *session;
        NSString *url;
//        if([userId isEqualToString:@"(null)"])
//        {
//            params = @{@"category_id":pro_Id};
//        }
//        else
//        {
            if (_FromShuffel==YES)
            {
               
                params = @{@"user_id":userId,@"paged":[NSString stringWithFormat:@"%ld",(long)PageCount]};
                NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
                url=[[NSString alloc]initWithFormat:@"%@%@",BaseURL,ProductShuffel ];
            }
            else
            {
                
                params = @{@"category_id":pro_Id,@"user_id":userId,@"brand_id":@"0",@"paged":[NSString stringWithFormat:@"%ld",(long)PageCount]};
                NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
                url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,ProductList ];
            }
            
//        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
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
//                    NSString *message = [responseDictionary valueForKey:@"message"];
                    NSString *status=[responseDictionary valueForKey:@"status"];
                    maxPageCount=[[responseDictionary valueForKey:@"pages"] integerValue];
                    [self removeImage];
                    
                  if ([status isEqualToString:@"S"])
                  {

                        pageType=1;
                        [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                        ProductlistArray=[NSMutableArray new];
                        ProductlistArray =[responseDictionary[@"data"] mutableCopy];
                        NSLog(@"%@",ProductlistArray);
                        _detailsArray=[NSMutableArray new];
                        TotalProduct_Swipe=[NSMutableArray new];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // UI UPDATE 2
                        for (int i = 0 ; i<ProductlistArray.count; i++)
                        {
                                NSDictionary *dic = [ProductlistArray objectAtIndex:i];
                                ProductClass *product_calss=[[ProductClass alloc]init];
                                product_calss.imagesArray=[NSMutableArray new];
                                product_calss.imagesArray=[[dic valueForKey:@"images"] mutableCopy];
                                
                                product_calss.Description = [NSString stringWithFormat:@"%@", [dic valueForKey:@"description"]];
                                product_calss.cater_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"id"]];
                                product_calss.regular_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"regular_price"]];
                                product_calss.sale_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"sale_price"]];
                                product_calss.imagestr = [NSString stringWithFormat:@"%@", [dic valueForKey:@"main_image"]];
                                product_calss.title = [NSString stringWithFormat:@"%@", [dic valueForKey:@"title"]];
                                product_calss.price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"price"]];
                                
//                                NSDictionary *brandDic=[[dic valueForKey:@"brands"] mutableCopy];
//                                NSLog(@"%@",[brandDic valueForKey:@"name"]);
                                
                                product_calss.brandName = [NSString stringWithFormat:@"%@",[dic valueForKey:@"brands"]];
//                                if(brandDic.count== 0)
//                                {
//                                    product_calss.brandName = @"";
//                                }
                                
                                if([[dic valueForKey:@"main_image"] isKindOfClass:[NSNull class]])
                                {
                                    
                                }
                                else
                                {
                                   
                                    product_calss.main_image=[NSString stringWithFormat:@"%@",[dic valueForKey:@"main_image"]];
                                }
                                [TotalProduct_Swipe addObject:product_calss];
//                                [_detailsArray addObject:product_calss];
                                if(TotalProduct_Swipe.count==ProductlistArray.count)
                                {
                                    // loadedCards = [[NSMutableArray alloc] init];
                                    //allCards = [[NSMutableArray alloc] init];
                                    // cardsLoadedIndex = 0;
                                    [self InitalArrayLoading];
                                    count=0;
                                    [imagPro_compl removeFromSuperview];
                                    [imageviewCatgy removeFromSuperview];
                                    [self.swipeView frameForCardAtIndex:0];
                                    [self.swipeView visibleCardsCount];
                                    [self.swipeView cardsCount];
                                    [self.swipeView resetCurrentCardNumber];
                                    [self.swipeView reloadData];
//                                    _badge_lbl.text=[NSString stringWithFormat:@"%d",(int)badge_count];
                                    //[self loadCards];
                                    [SVProgressHUD dismiss];
                                }
                            }
                        });
//                    }
                   
                }
                else  if([status isEqualToString:@"F"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^(void)
                                 {
                                               imageviewCatgy=[[UIImageView alloc]initWithFrame:self.swipeView.frame];
                                               imageviewCatgy.image=[UIImage imageNamed:@"image_not_found"];
                                               [self.view addSubview:imageviewCatgy];
                                               [SVProgressHUD dismiss];
                                               //   [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self Interneterror];
//            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
    }
    
}
-(void)updateTotalcount:(NSString *)total_bag andSteez:(NSString *)total_steez
{
    [[NSUserDefaults standardUserDefaults]setObject:total_bag forKey:Total_Cart];
    [[NSUserDefaults standardUserDefaults]setObject:total_steez forKey:Total_Steez];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        _badge_lbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Steez]];
        _shoppingCountLbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
    });
   
}
//- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
//{
//    NSLog(@"rightSwipeHandle");
//}
//
//- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
//{
//    NSLog(@"leftSwipeHandle");
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)categoryBtnClick:(id)sender
{
     if(FromSearchApi)
     {
//         [self dismissViewControllerAnimated:NO completion:nil];
         [self.navigationController popViewControllerAnimated:YES];
     }
    else
    {
        
        if(self.navigationController.viewControllers.count>2)
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3] animated:YES];
        
        
    }
    
}

- (IBAction)profileBtnClick:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileVC *myVC = (ProfileVC *)[storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
    myVC.fromProduct=YES;
//    [self presentViewController:myVC animated:NO completion:nil];
    [self.navigationController pushViewController:myVC animated:YES];
}

- (IBAction)cardBtnClick:(id)sender
{

//  [self presentViewController:productVC animated:NO completion:nil];
//    UIStoryboard  *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    HomeTabBar *paymentOrder = (HomeTabBar *)[storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
//    paymentOrder.selectedIndex=1;
//    [self.navigationController pushViewController:paymentOrder animated:YES];
    
    BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
    if (!skipUser)
    {
        ProductWishListVC *wishVC = (ProductWishListVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ProductWishListVC"];
        //[self presentViewController:wishVC animated:NO completion:nil];
        
        [self.navigationController pushViewController:wishVC animated:YES];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
                                                                      message:@"Sign in or Sign Up to add products to My Steez"preferredStyle:UIAlertControllerStyleAlert];
        
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

- (IBAction)refreshBtnClick:(id)sender
{
    if (_detailsArray!=nil)
    {
        [imagPro_compl removeFromSuperview];
        [imageviewCatgy removeFromSuperview];
    }
    
    
    if(undo_direction==2)
    {
        undo_direction=0;
        count=count-1;
        [self.swipeView revertAction];
        NSLog(@"right swipe:%ld",last_index);
        ProductClass *pro_cals=nil;
        badge_count=badge_count-1;
        pro_cals= [_detailsArray objectAtIndex:last_index];
        NSLog(@"%@",pro_cals.cater_id);
        NSInteger product_id=[pro_cals.cater_id integerValue];
        [self apiremoveFavoriteMethodProduct_id:[NSString stringWithFormat:@"%ld",(long)product_id]];
        if (![self checkProductExist:product_id])
        {
            badge_count=badge_count-1;
            [appdeleagte.wish_product_id_array removeObject:pro_cals.cater_id];
            [[NSUserDefaults standardUserDefaults] setObject:appdeleagte.wish_product_id_array  forKey:WISHPRODUCTLIST];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            _badge_lbl.text=[NSString stringWithFormat:@"%d",(int)badge_count];
            
        }
        
        _lbl_product_title.text=pro_cals.title;
        //float price=[[NSString stringWithFormat:@"%@",pro_cals.price] floatValue];
        // _LblPriceValue.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",price]];
        _LblPriceValue.text=[NSString stringWithFormat:@"%@",pro_cals.price];
        _brandNameLblValue.text=[NSString stringWithFormat:@"%@",pro_cals.brandName];
        
        if ([[NSString stringWithFormat:@"%@",pro_cals.brandName] isEqualToString:@"Yung2"])
        {
            NSMutableAttributedString *carbonDioxide = [[NSMutableAttributedString alloc] initWithString:@"Yung2"];
            [carbonDioxide addAttribute:(NSString *)kCTSuperscriptAttributeName value:@+1 range:NSMakeRange(4,1)];
            _brandNameLblValue.attributedText=carbonDioxide;
        }
        _product_title=[NSString stringWithFormat:@"%@",pro_cals.title];
        _product_Description=[NSString stringWithFormat:@"%@",pro_cals.description];
        productID=[NSString stringWithFormat:@"%@",pro_cals.cater_id];
        shareimage=[NSString stringWithFormat:@"%@",pro_cals.main_image];
        
    }
    if(undo_direction==1)
    {
//
        count=count-1;
        [self.swipeView revertAction];
        if(count==0)
        {
            undo_direction=0;
           
        }
        NSLog(@"left swipe:%ld",last_index);
        ProductClass *pro_cals=nil;
        pro_cals= [_detailsArray objectAtIndex:last_index];
        _lbl_product_title.text=pro_cals.title;

        //float price=[[NSString stringWithFormat:@"%@",pro_cals.price] floatValue];
        //_LblPriceValue.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",price]];
        
        _LblPriceValue.text=
        [NSString stringWithFormat:@"%@",pro_cals.price];
        _product_title=[NSString stringWithFormat:@"%@",pro_cals.title];
        _product_Description=[NSString stringWithFormat:@"%@",pro_cals.description];
        _brandNameLblValue.text=[NSString stringWithFormat:@"%@",pro_cals.brandName];
        if ([[NSString stringWithFormat:@"%@",pro_cals.brandName] isEqualToString:@"Yung2"]) {
            NSMutableAttributedString *carbonDioxide = [[NSMutableAttributedString alloc] initWithString:@"Yung2"];
            [carbonDioxide addAttribute:(NSString *)kCTSuperscriptAttributeName value:@+1 range:NSMakeRange(4,1)];
            _brandNameLblValue.attributedText=carbonDioxide;
        }
        productID=[NSString stringWithFormat:@"%@",pro_cals.cater_id];
        shareimage=[NSString stringWithFormat:@"%@",pro_cals.main_image];
        
    }
//    if([undo isEqualToString:@"Left"])
//    {
//        
//        [allCards removeLastObject];
//        [loadedCards removeLastObject];
//        cardsLoadedIndex = [loadedCards count]+1;
//        [self loadCards];
//       
//    }
//    else if ([undo isEqualToString:@"Right"])
//    {
//        [allCards removeLastObject];
//        [loadedCards removeLastObject];
//        cardsLoadedIndex = [loadedCards count]-1;
//        [self loadCards];
//    }
//    else
//    {
//        
//    }
//    cardsLoadedIndex=0;
//    [allCards removeAllObjects];
//    [loadedCards removeAllObjects];
//    [self loadCards];
    
}

- (IBAction)orderNowBtnClic:(id)sender
{
    [SVProgressHUD show];

    ProductClass *product_details = nil;
    //product_details = [_detailsArray objectAtIndex:[count integerValue]];
    ProductDetail_VC *myVC = (ProductDetail_VC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailVC"];
//    //myVC.index=[NSString stringWithFormat:@"%@",count];
    myVC.product_Details=product_details;
    myVC.productId=product_id;
    myVC.fromenowOrder=YES;
//
//    //[self presentViewController:myVC animated:NO completion:nil];
    [self.navigationController pushViewController:myVC animated:YES];
        //[SVProgressHUD dismiss];
    
}

- (IBAction)filterBtnClick:(id)sender
{
    ProductFilterVC *myVC = (ProductFilterVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ProductFilterVC"];
//    [self presentViewController:myVC animated:NO completion:nil];
    
    [self.navigationController pushViewController:myVC animated:YES];
}


///swipe delegate and view

//-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
//{
//    //DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake((self.swipeView.frame.size.width - CARD_WIDTH)/2, (self.swipeView.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
//
//    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:CGRectMake(0, 0, self.swipeView.frame.size.width, self.swipeView.frame.size.height)];
//    ProductClass *pro_cals=nil;////
//
//    pro_cals= [_detailsArray objectAtIndex:0];              _lbl_product_title.text=pro_cals.title;
//    _LblPriceValue.text=[@"$ " stringByAppendingString:[NSString stringWithFormat:@"%@",pro_cals.price]];
////    self.bottomProductImage.image = [UIImage imageWithData:pro_cals.main_image];
//    _product_image_url=[NSString stringWithFormat:@"%@",pro_cals.imagestr];
//    _product_title=[NSString stringWithFormat:@"%@",pro_cals.title];
//    _product_Description=[NSString stringWithFormat:@"%@",pro_cals.description];
//    productID=[NSString stringWithFormat:@"%@",pro_cals.cater_id];
//    pro_cals= [_detailsArray objectAtIndex:index];
//
//    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:pro_cals.main_image ]];
//    //                                 product_calss.main_image = imageData;
////    UIImage *myimg = [UIImage imageWithData:pro_cals.main_image];
//    shareimage=imageData;
//    //draggableView.information.text = [exampleCardLabels objectAtIndex:index]; //%%% placeholder for card-specific information
//    [draggableView.imageView sd_setShowActivityIndicatorView:YES];
//    [draggableView.imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
//
//    [draggableView.imageView sd_setImageWithURL:[NSURL URLWithString:pro_cals.main_image]
//                  placeholderImage:[UIImage imageNamed:@"catergories-placeholder"]
//                           options:SDWebImageRefreshCached];
////    draggableView.imageView.image = myimg;
//
//    draggableView.delegate = self;
//    return draggableView;
//}
//%%% loads all the cards and puts the first x in the "loaded cards" array
//-(void)loadCards
//{
//    if([_detailsArray count] > 0)
//    {
//        NSInteger numLoadedCardsCap =(([_detailsArray count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[_detailsArray count]);
//        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
//
//        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
//        for (int i = 0; i<[_detailsArray count]; i++)
//        {
//            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
//            [allCards addObject:newCard];
//
//            if (i<=numLoadedCardsCap)
//            {
//                //%%% adds a small number of cards to be loaded
//                [loadedCards addObject:newCard];
//
//            }
//        }
//
//        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
//        // are showing at once and clogging a ton of data
//        for (int i = 0; i<[loadedCards count]; i++)
//        {
//            if (i>0)
//            {
//                [self.swipeView insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
//            }
//            else
//            {
//                [self.swipeView addSubview:[loadedCards objectAtIndex:i]];
//            }
//            cardsLoadedIndex++;
//            //%%% we loaded a card into loaded cards, so we have to increment
//        }
//    }
//}

//#warning include own action here!
////%%% action called when the card goes to the left.
//// This should be customized with your own action
//
//-(void)cardSwipedLeft:(UIView *)card
//{
//    undo=@"Left";
//
//    //do whatever you want with the card that was swiped
//
//    //DraggableView *c = (DraggableView *)card;
//
//    [loadedCards removeObjectAtIndex:0];
//
//    index++;
//
//    //%%% card was swiped, so it's no longer a "loaded card"
//
//    if (cardsLoadedIndex-1 < [allCards count])
//
//    {
//
//        //%%% if we haven't reached the end of all cards, put another into the loaded cards
//
//        self.productCompletedLbl.hidden = TRUE;
//        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex-1]];
//
//        ProductClass *pro_cals=nil;
//
//        pro_cals= [_detailsArray objectAtIndex:cardsLoadedIndex-1];
//        undo_index=cardsLoadedIndex-1;
//        _lbl_product_title.text=pro_cals.title;//
//
//        _LblPriceValue.text=[@"$ " stringByAppendingString:[NSString stringWithFormat:@"%@",pro_cals.price]];//
//        _product_image_url=[NSString stringWithFormat:@"%@",pro_cals.main_image];
//        _product_title=[NSString stringWithFormat:@"%@",pro_cals.title];
//        _product_Description=[NSString stringWithFormat:@"%@",pro_cals.description];
//          productID=[NSString stringWithFormat:@"%@",pro_cals.cater_id];
//        //self.bottomProductImage.image =[UIImage imageWithData:pro_cals.main_image];
//        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:pro_cals.main_image ]];
//        cardsLoadedIndex=cardsLoadedIndex+1;
//        shareimage=imageData;
//        //%%% loaded a card, so have to increment count
//        if(loadedCards.count>1)
//        {
//        [self.swipeView insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
//        }
//        else
//        {
//            self.productCompletedLbl.hidden = FALSE;
//            _lbl_product_title.text=@"";
//            _product_image_url=@"";
//            _product_title=@"";
//            _product_Description=@"";
//            _LblPriceValue.text=@"";
//        }
//
//    }
//
//    else
//
//    {
//
//        self.productCompletedLbl.hidden = FALSE;
//
//        _lbl_product_title.text=@"";
//        _product_image_url=@"";
//        _product_title=@"";
//        _product_Description=@"";
//        _LblPriceValue.text=@"";
//
////        self.bottomProductImage.image =[UIImage imageWithData:nil];
//
//    }
//
//}

//#warning include own action here!
//
////%%% action called when the card goes to the right.
//// This should be customized with your own action
//
//-(void)cardSwipedRight:(UIView *)card
//
//{
//    undo=@"Right";
//    //do whatever you want with the card that was swiped
//    //DraggableView *c = (DraggableView *)card;
//    [loadedCards removeObjectAtIndex:0];
//    //%%% card was swiped, so it's no longer a "loaded card"
//    ProductClass *pro_cals=nil;
//    // if (![self checkProductExist:index])
//    //{
//
//        if (index<[allCards count])
//
//        {
//            badge_count=badge_count+1;
//            pro_cals= [_detailsArray objectAtIndex:index];
//            NSLog(@"%@",pro_cals.cater_id);
//            undo_index=index;
//             [appdeleagte.wish_product_id_array addObject:pro_cals.cater_id];
//             [[NSUserDefaults standardUserDefaults] setObject:appdeleagte.wish_product_id_array  forKey:WISHPRODUCTLIST];
//             [[NSUserDefaults standardUserDefaults] synchronize];
//            _badge_lbl.text=[NSString stringWithFormat:@"%d",(int)badge_count];
//        }
//
////    }
//    else
//    {
//
//        //Print alert Product already added.
//
//    }
//
//    if (cardsLoadedIndex-1 < [allCards count])
//
//    {
//        //%%% if we haven't reached the end of all cards, put another into the loaded cards
//
//        self.productCompletedLbl.hidden = TRUE;
//
//        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex-1]];
//
//        pro_cals= [_detailsArray objectAtIndex:cardsLoadedIndex-1];
//
//        _lbl_product_title.text=pro_cals.title;
//
//        _LblPriceValue.text=[@"$ " stringByAppendingString:[NSString stringWithFormat:@"%@",pro_cals.price]];
//        _product_image_url=[NSString stringWithFormat:@"%@",pro_cals.main_image];
//        _product_title=[NSString stringWithFormat:@"%@",pro_cals.title];
//        _product_Description=[NSString stringWithFormat:@"%@",pro_cals.description];
//        productID=[NSString stringWithFormat:@"%@",pro_cals.cater_id];
//        NSLog(@"%@",productID);
//        WishProduct_id=productID;
//          NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:pro_cals.main_image ]];
//        shareimage=imageData;
//
//        //NSInteger index1=cardsLoadedIndex-2;
//
//        //count=[@(index1) stringValue];
//
////        self.bottomProductImage.image =[UIImage imageWithData:pro_cals.main_image];
//
//        //%%% loaded a card, so have to increment count
//
//        cardsLoadedIndex++;
//        if(loadedCards.count>1)
//        {
//
//                    [self.swipeView insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
//        }
//        else
//        {
//            self.productCompletedLbl.hidden = FALSE;
//
//            _lbl_product_title.text=@"";
//            _LblPriceValue.text=@"";
//            _product_image_url=@"";
//            _product_title=@"";
//            _product_Description=@"";
//
//        }
//
//
//
//
//        // cardsLoadedIndex=cardsLoadedIndex-1;;
//
//        //[appdeleagte.productItemArray addObject:[_detailsArray objectAtIndex:cardsLoadedIndex-2]];
//
//    }
//
//    else
//
//    {
//
//        self.productCompletedLbl.hidden = FALSE;
//
//        _lbl_product_title.text=@"";
//        _LblPriceValue.text=@"";
//        _product_image_url=@"";
//        _product_title=@"";
//        _product_Description=@"";
//
////        self.bottomProductImage.image =[UIImage imageWithData:nil];
//
//    }
//
//    index++;
//
//}


//-(BOOL)checkProductExist:(NSInteger)index
//{
//    NSInteger  count1=[appdeleagte.productItemArray count];
    
//    if(index<count1)
//    {
//        UIAlertController * alert = [UIAlertController
//                                     alertControllerWithTitle:@"Sorry"
//                                     message:@"Product allready in your card"
//                                     preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* okButton = [UIAlertAction
//                                   actionWithTitle:@"OK"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction * action)
//                                   {
//                                       
//                                   }];
//        
//        
//        [alert addAction:okButton];
//        [self presentViewController:alert animated:YES completion:nil];
//        
//        return TRUE;
//        
//    }
//    
//    
    
    //Get from NSUserDefaults and check already exist return true.
    //    [appdeleagte.productItemArray addObject:[_ProductlistArray objectAtIndex:index]];
    //    [[NSUserDefaults standardUserDefaults] setObject:appdeleagte.productItemArray  forKey:@"favoritearray"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    return FALSE;
//
//}

- (IBAction)shareBTNAcition:(id)sender
{
   
//    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//    content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
//
//    FBSDKShareButton *button = [[FBSDKShareButton alloc] init];
//    button.shareContent = content;
//    button.center=self.view.center;
//    [self.shareBTN addSubview:button];

     [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:@"Steezle"];
         NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:shareimage]];
        UIImage *img = [UIImage imageWithData:imageData];
        
        [controller addImage:img];
        
         //database data fatch method
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            [self presentViewController:controller animated:YES completion:Nil];
            //hide that after your Dela Loading finished fromDatabase
        });
        
    });
//         [SVProgressHUD dismiss];
    
    
    
    
    
    //    FBSDKShareLinkContent *content =[[FBSDKShareLinkContent alloc] init];
    //    content.contentURL = [NSURL URLWithString:BaseURL];
    //    content.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_product_image_url]];
    //    content.contentTitle= _product_title;
    //    content.contentDescription=_product_Description;
    //    FBSDKShareDialog *dialog=[[FBSDKShareDialog alloc]init];
    //    dialog.mode=FBSDKShareDialogModeNative;
    //    if (![dialog canShow])
    //    {
    //        // fallback presentation when there is no FB app
    //        dialog.mode = FBSDKShareDialogModeWeb;
    //        //
    //    }
    //    dialog.shareContent=content;
    //    dialog.delegate=self;
    //    dialog.fromViewController=self;
    //    [dialog show];
    
    
//        NSString *appLink =@"put Link Here";
//
//        NSLog(@"app link: %@",appLink);
//        NSArray *postItems = @[appLink];
//        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:postItems  applicationActivities:nil];
//        [self presentViewController:activityVC animated:YES completion:nil];
    
}
//- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
//
//}
//- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
//
//}
//
//- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
//    NSLog(@"%@",error);
//}
- (IBAction)heartAction:(id)sender
{
    
//    if (![self checkProductExistforHeart:index])
//    {
//
//        ProductClass *pro_cals=nil;
//        pro_cals= [_detailsArray objectAtIndex:index];
//        [appdeleagte.favoriteProductArray addObject:[ProductlistArray objectAtIndex:index]];
//        [[NSUserDefaults standardUserDefaults] setObject:appdeleagte.favoriteProductArray  forKey:@"productarray"];
        
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
//    }
    
}
-(BOOL)checkProductExistforHeart:(NSInteger)index1
{
//    NSInteger  count1=[appdeleagte.favoriteProductArray count];
    
    //    for(int i=0;i<=count1;i++)
    //    {
//    if(index1<count1)
//    {
        //            if(count1==0)
        //            {
        //                 return FALSE;
        //            }
        //            else
        //            {
//        UIAlertController * alert = [UIAlertController
//                                     alertControllerWithTitle:@"Sorry"
//                                     message:@"Product allready in your favorite list"
//                                     preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction* okButton = [UIAlertAction
//                                   actionWithTitle:@"OK"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction * action)
//                                   {
//
//                                   }];
//
//        [alert addAction:okButton];
//        [self presentViewController:alert animated:YES completion:nil];
//        return TRUE;
        //            }
        
        
//    }
    
    //
    //    }
    
    //Get from NSUserDefaults and check already exist return true.
    //    [appdeleagte.productItemArray addObject:[_ProductlistArray objectAtIndex:index]];
    //    [[NSUserDefaults standardUserDefaults] setObject:appdeleagte.productItemArray  forKey:@"favoritearray"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return FALSE;
    
}
//swipe tinder
- (NSUInteger)swipeViewNumberOfCards:(SwipeView *)swipeView
{
    return _detailsArray.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView
          cardAtIndex:(NSUInteger)index
{
    ProductClass *pro_cals=nil;
    //count=index;
    //swipeView.backgroundColor=[UIColor whiteColor];
    pro_cals= [_detailsArray objectAtIndex:index];
     UIImageView *imageView = [[UIImageView alloc] init];
    last_index=index;
    imageView.backgroundColor=[UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.cornerRadius=10.0f;
    imageView.layer.shadowRadius  = 10.0f;
    imageView.layer.shadowColor   = [UIColor blackColor].CGColor;
    imageView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    imageView.layer.shadowOpacity = 0.3f;
    imageView.layer.masksToBounds = YES;

    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(imageView.bounds, shadowInsets)];
    imageView.layer.shadowPath    = shadowPath.CGPath;
    
    [imageView sd_setShowActivityIndicatorView:YES];
    [imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [imageView sd_setImageWithURL:[NSURL URLWithString:pro_cals.main_image]                  placeholderImage:[UIImage imageNamed:@"catergories-placeholder.png"]                           options:SDWebImageRefreshCached];
    
    return imageView;
}

- (OverlayView *)swipeView:(SwipeView *)swipeView
        cardOverlayAtIndex:(NSUInteger)index
{
    CustomOverlayView *overlay = [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil][0];
    if(index==0)
    {
//            dispatch_async(dispatch_get_main_queue(), ^{
        
            ProductClass *pro_cals=nil;
            pro_cals= [_detailsArray objectAtIndex:0];
            
            _lbl_product_title.text=pro_cals.title;
//            float price=[[NSString stringWithFormat:@"%@",pro_cals.price] floatValue];
//            _LblPriceValue.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",price]];
            _LblPriceValue.text=[NSString stringWithFormat:@"%@",pro_cals.price];
            _product_title=[NSString stringWithFormat:@"%@",pro_cals.title];
            _product_Description=[NSString stringWithFormat:@"%@",pro_cals.description];
            productID=[NSString stringWithFormat:@"%@",pro_cals.cater_id];
            _brandNameLblValue.text=[NSString stringWithFormat:@"%@",pro_cals.brandName];
        if ([[NSString stringWithFormat:@"%@",pro_cals.brandName] isEqualToString:@"Yung2"]) {
            NSMutableAttributedString *carbonDioxide = [[NSMutableAttributedString alloc] initWithString:@"Yung2"];
            [carbonDioxide addAttribute:(NSString *)kCTSuperscriptAttributeName value:@+1 range:NSMakeRange(4,1)];
            _brandNameLblValue.attributedText=carbonDioxide;
        }
            shareimage=[NSString stringWithFormat:@"%@",pro_cals.main_image];
//                 });
        }
   
    return overlay;
}
-(void)InitalArrayLoading
{
    for (int i=0; i<TotalProduct_Swipe.count; i++)
    {
        if (i+1==21)
        {
            break;
        }
        [_detailsArray addObject:TotalProduct_Swipe[i]];
    }
}
-(void)loadSwipe
{
    NSInteger ordersCount=_detailsArray.count;
    for (NSInteger i=_detailsArray.count; i<TotalProduct_Swipe.count; i++)
    {
        if ((i+1)==(ordersCount+21))
        {
            break;
        }
        [_detailsArray addObject:TotalProduct_Swipe[i]];
    }
    
    
}
- (void)swipeView:(SwipeView *)swipeView didSwipeCardAtIndex:(NSUInteger)index inDirection:(SwipeDirection)direction
{
    
       ProductClass *pro_cals=nil;

       if(direction==1 )//left
       {
           undo_direction=direction;
           if (index == _detailsArray.count-1)
            {
//              self.productCompletedLbl.hidden = FALSE;
                if (TotalProduct_Swipe.count!=_detailsArray.count)
                {
                    [self loadSwipe];
                    [self.swipeView reloadData];
                }
                else if (TotalProduct_Swipe.count==_detailsArray.count)
                {
                    
                    switch (pageType)
                    {
                        case 1:
                                PageCount=PageCount+1;
                            if (maxPageCount>=PageCount) {
                                  [self getCategories];
                            }
                            else
                            {
                                maxPageCount=0;
                                PageFilterCount=0;
                                PageSearchCount=0;
                                PageCount=0;
                                _lbl_product_title.text=@"";
                                _LblPriceValue.text=@"";
                                _product_image_url=@"";
                                _product_title=@"";
                                _product_Description=@"";
                                _brandNameLblValue.text=@"";
                                shareimage=NULL;
                                imagPro_compl=[[UIImageView alloc]initWithFrame:self.swipeView.frame];
                                imagPro_compl.image=[UIImage imageNamed:@"product_completed"];
                                imagPro_compl.contentMode=UIViewContentModeScaleAspectFit;
                                [self.view addSubview:imagPro_compl];
                            }
                            
                            break;
                        case 2:
                                PageSearchCount=PageSearchCount+1;
                            if (maxPageCount>=PageSearchCount)
                            {
                                [self SearchAPICallPostMethod:searchStr];
                            }
                            else
                            {
                                maxPageCount=0;
                                PageFilterCount=0;
                                PageSearchCount=0;
                                PageCount=0;
                                _lbl_product_title.text=@"";
                                _LblPriceValue.text=@"";
                                _product_image_url=@"";
                                _product_title=@"";
                                _product_Description=@"";
                                _brandNameLblValue.text=@"";
                                shareimage=NULL;
                                imagPro_compl=[[UIImageView alloc]initWithFrame:self.swipeView.frame];
                                imagPro_compl.image=[UIImage imageNamed:@"product_completed"];
                                imagPro_compl.contentMode=UIViewContentModeScaleAspectFit;
                                [self.view addSubview:imagPro_compl];
                            }
                            
                            break;
                        case 3:
                            
                            PageFilterCount=PageFilterCount+1;
                            if (maxPageCount>=PageFilterCount)
                            {
                                [self SetFilterProduct];
                            }
                            else
                            {
                                maxPageCount=0;
                                PageFilterCount=0;
                                PageSearchCount=0;
                                PageCount=0;
                                _lbl_product_title.text=@"";
                                _LblPriceValue.text=@"";
                                _product_image_url=@"";
                                _product_title=@"";
                                _product_Description=@"";
                                _brandNameLblValue.text=@"";
                                shareimage=NULL;
                                imagPro_compl=[[UIImageView alloc]initWithFrame:self.swipeView.frame];
                                imagPro_compl.image=[UIImage imageNamed:@"product_completed"];
                                imagPro_compl.contentMode=UIViewContentModeScaleAspectFit;
                                [self.view addSubview:imagPro_compl];
                            }
                            break;
                        default:
                            break;
                    }
                    
                }
                else
                {
                    maxPageCount=0;
                    PageFilterCount=0;
                    PageSearchCount=0;
                    PageCount=0;
                    _lbl_product_title.text=@"";
                    _LblPriceValue.text=@"";
                    _product_image_url=@"";
                    _product_title=@"";
                    _product_Description=@"";
                    _brandNameLblValue.text=@"";
                    shareimage=NULL;
                    imagPro_compl=[[UIImageView alloc]initWithFrame:self.swipeView.frame];
                    imagPro_compl.image=[UIImage imageNamed:@"product_completed"];
                    imagPro_compl.contentMode=UIViewContentModeScaleAspectFit;
                    [self.view addSubview:imagPro_compl];
                }
               
                
                
             }
           else
           {
//               count=count+1;
               pro_cals= [_detailsArray objectAtIndex:index+1];
               _lbl_product_title.text=pro_cals.title;
//               float price=[[NSString stringWithFormat:@"%@",pro_cals.price] floatValue];
//               _LblPriceValue.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",price]];
               _LblPriceValue.text=[NSString stringWithFormat:@"%@",pro_cals.price];
               _brandNameLblValue.text=[NSString stringWithFormat:@"%@",pro_cals.brandName];
               if ([[NSString stringWithFormat:@"%@",pro_cals.brandName] isEqualToString:@"Yung2"]) {
                   NSMutableAttributedString *carbonDioxide = [[NSMutableAttributedString alloc] initWithString:@"Yung2"];
                   [carbonDioxide addAttribute:(NSString *)kCTSuperscriptAttributeName value:@+1 range:NSMakeRange(4,1)];
                   _brandNameLblValue.attributedText=carbonDioxide;
               }
               
               _product_title=[NSString stringWithFormat:@"%@",pro_cals.title];
               _product_Description=[NSString stringWithFormat:@"%@",pro_cals.description];
               productID=[NSString stringWithFormat:@"%@",pro_cals.cater_id];
               shareimage=[NSString stringWithFormat:@"%@",pro_cals.main_image];
               
           }
         
       }
       if(direction==2)//right
        {
            undo_direction=direction;
            if (index == _detailsArray.count-1)
            {
              
                pro_cals= [_detailsArray objectAtIndex:index];
                NSLog(@"%@",pro_cals.cater_id);
                undo_direction=direction;
                NSInteger product_id=[pro_cals.cater_id integerValue];
//                if (![self checkProductExist:product_id])
//                {
                    badge_count=badge_count+1;
//                    [appdeleagte.wish_product_id_array addObject:pro_cals.cater_id];
//                    [[NSUserDefaults standardUserDefaults] setObject:appdeleagte.wish_product_id_array  forKey:WISHPRODUCTLIST];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    _badge_lbl.text=[NSString stringWithFormat:@"%d",(int)badge_count];
                [self apicallMethodURLandreloading:[NSString stringWithFormat:@"%ld",(long)product_id]];
//                }
//                else
//                {
//
//                    [self showWarningAlertWithTitle:@"Steezle" andMessage:@"product is already on the wishlist"];
//
//                }
//
                
                if (TotalProduct_Swipe.count!=_detailsArray.count) {
                    
                    [self loadSwipe];
                    [imagPro_compl removeFromSuperview];
                    [imageviewCatgy removeFromSuperview];
                    [self.swipeView frameForCardAtIndex:0];
                    [self.swipeView visibleCardsCount];
                    [self.swipeView cardsCount];
                    [self.swipeView resetCurrentCardNumber];
                    [self.swipeView reloadData];
                    
                }
                else
                {
                    _lbl_product_title.text=@"";
                    _LblPriceValue.text=@"";
                    _product_image_url=@"";
                    _product_title=@"";
                    _product_Description=@"";
                    _brandNameLblValue.text=@"";
                    shareimage=NULL;
                    imagPro_compl=[[UIImageView alloc]initWithFrame:self.swipeView.frame];
                    imagPro_compl.image=[UIImage imageNamed:@"product_completed"];
                    imagPro_compl.contentMode=UIViewContentModeScaleAspectFit;
                    [self.view addSubview:imagPro_compl];
                }
//                self.productCompletedLbl.hidden = FALSE;
               

            }
            else
            {
                if(index==0)
                {
                    count=0;
                }
                else
                {
                    count=count+1;
                }
                
                pro_cals= [_detailsArray objectAtIndex:index];
                NSLog(@"%@",pro_cals.cater_id);
                undo_direction=direction;
                NSInteger product_id=[pro_cals.cater_id integerValue];
//                if (![self checkProductExist:product_id])
//                {
                    badge_count=badge_count+1;
//                    [appdeleagte.wish_product_id_array addObject:pro_cals.cater_id];
//                    [[NSUserDefaults standardUserDefaults] setObject:appdeleagte.wish_product_id_array  forKey:WISHPRODUCTLIST];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    _badge_lbl.text=[NSString stringWithFormat:@"%d",(int)badge_count];
                [self apicallMethodURLandreloading:[NSString stringWithFormat:@"%ld",(long)product_id]];
                    
//                }
//                else
//                {
//                        [self showWarningAlertWithTitle:@"Steezle" andMessage:@"product is already on the wishlist"];
//                }
                 pro_cals= [_detailsArray objectAtIndex:index+1];
                _lbl_product_title.text=pro_cals.title;
//                float price=[[NSString stringWithFormat:@"%@",pro_cals.price] floatValue];
//                _LblPriceValue.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",price]];
                _LblPriceValue.text=[NSString stringWithFormat:@"%@",pro_cals.price];
                _product_title=[NSString stringWithFormat:@"%@",pro_cals.title];
                _brandNameLblValue.text=[NSString stringWithFormat:@"%@",pro_cals.brandName];
               
                
                if ([[NSString stringWithFormat:@"%@",pro_cals.brandName] isEqualToString:@"Yung2"])
                {
                    NSMutableAttributedString *carbonDioxide = [[NSMutableAttributedString alloc] initWithString:@"Yung2"];
                    [carbonDioxide addAttribute:(NSString *)kCTSuperscriptAttributeName value:@+1 range:NSMakeRange(4,1)];
                    _brandNameLblValue.attributedText=carbonDioxide;
                }
                _product_Description=[NSString stringWithFormat:@"%@",pro_cals.description];
                productID=[NSString stringWithFormat:@"%@",pro_cals.cater_id];
                shareimage=[NSString stringWithFormat:@"%@",pro_cals.main_image];
                
            }
            
        }
 
}

- (void)swipeViewDidRunOutOfCards:(SwipeView *)swipeView
{
   
//    [swipeView resetCurrentCardNumber];
}

- (void)swipeView:(SwipeView *)swipeView didSelectCardAtIndex:(NSUInteger)index
{
    NSLog(@"index:%lu",(unsigned long)index);
    
    ProductClass *pro_class = nil;
    pro_class = [_detailsArray objectAtIndex:index];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ProductDetail_VC *myVC = (ProductDetail_VC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductDetailVC"];
    NSString *index1=[NSString stringWithFormat:@"%@",pro_class.cater_id];
    myVC.productId=index1;
////    [self presentViewController:myVC animated:NO completion:nil];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

- (BOOL)swipeViewShouldApplyAppearAnimation:(SwipeView *)swipeView
{
   
    return YES;
}

- (BOOL)swipeViewShouldMoveBackgroundCard:(SwipeView *)swipeView
{
    
    return YES;
    
}

- (BOOL)swipeViewShouldTransparentizeNextCard:(SwipeView *)swipeView
{
    
    return YES;
}

- (POPPropertyAnimation *)swipeViewBackgroundCardAnimation:(SwipeView *)swipeView
{
   
    return nil;
}
-(BOOL)checkProductExist:(NSInteger)productId
{
    for (int i=0; i<appdeleagte.wish_product_id_array.count; i++)
    {
        NSInteger product=[[appdeleagte.wish_product_id_array objectAtIndex:i] integerValue];
        
        if (product==productId)
        {
            return TRUE;
        }
    }
    
    return FALSE;
    
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
                             if([msg isEqualToString:@"product is already on the wishlist"])
                             {
                                 [self refreshBtnClick:self];
                             }
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)ProductDetailsfilldata
{
    
}


-(void)apicallforFavoriteList
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
      
        NSDictionary *params = @{@"user_id":user_id};
      
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,GetFavorite];
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
//                                  [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                              });
          }
          else
          {
              
                 NSError *parseError = nil;
                 NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                 NSLog(@"%@",responseDictionary);
                 NSString *message = [responseDictionary valueForKey:@"message"];
                 NSString *status=[responseDictionary valueForKey:@"status"];
                 gloableArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
                 [self removeImage];
                 if ([status isEqualToString:@"S"])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                
                         NSMutableArray* wish_product = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:WISHPRODUCTLIST]];
                         appdeleagte.wish_product_id_array=[wish_product mutableCopy];
                          for (int i = 0 ; i<gloableArray.count; i++)
                          {
                              NSDictionary *dic = [gloableArray objectAtIndex:i];
                              [wishList_Product_id_Array addObject:[dic valueForKey:@"product_id"]];
                               [appdeleagte.wish_product_id_array addObject:[dic valueForKey:@"product_id"]];
                             if(wishList_Product_id_Array.count==gloableArray.count)
                             {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                       NSString *badge = [NSString stringWithFormat:@"%d",(int)[appdeleagte.wish_product_id_array count]];
                                       badge_count=[badge integerValue];
                                       _badge_lbl.text=[NSString stringWithFormat:@"%d",(int)badge_count];
                                       [SVProgressHUD dismiss];
                                      
                              });
                            //[_tableview reloadData];
                             }
                          }
                     });
                    }
                  else  if([status isEqualToString:@"F"])
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
        //  }
        
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

- (IBAction)ActCross:(id)sender
{
//    _CrossBTN.userInteractionEnabled = NO;
//    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [swipeView swipeDirection:1];
        _CrossBTN.backgroundColor=[UIColor blackColor];
        _RightBTN.backgroundColor=[UIColor whiteColor];
        _hearBTN.backgroundColor=[UIColor whiteColor];
        
        [_CrossBTN setImage:[UIImage imageNamed:@"s_big_sel_whiteCross"] forState:UIControlStateNormal];
        [_RightBTN setImage:[UIImage imageNamed:@"s_unsel_right11"] forState:UIControlStateNormal];
        [_hearBTN setImage:[UIImage imageNamed:@"s_big_unsel_hear11"] forState:UIControlStateNormal];
//    } completion:^(BOOL finished)
//    {
//        _CrossBTN.userInteractionEnabled = YES;
//    }];
//
 
    
    
    
}
- (IBAction)ActHeart:(id)sender {
    
    
    [swipeView swipeDirection:2];
    
    _CrossBTN.backgroundColor=[UIColor whiteColor];
    _RightBTN.backgroundColor=[UIColor whiteColor];
    _hearBTN.backgroundColor=[UIColor blackColor];
    
    [_CrossBTN setImage:[UIImage imageNamed:@"s_big_cross1"] forState:UIControlStateNormal];
    [_RightBTN setImage:[UIImage imageNamed:@"s_unsel_right11"] forState:UIControlStateNormal];
    [_hearBTN setImage:[UIImage imageNamed:@"s_big_sel_hear11"] forState:UIControlStateNormal];
    
    
}
- (IBAction)ActRIght:(id)sender {
    
    [swipeView swipeDirection:2];
    _CrossBTN.backgroundColor=[UIColor whiteColor];
    _RightBTN.backgroundColor=[UIColor blackColor];
    _hearBTN.backgroundColor=[UIColor whiteColor];
    
    [_CrossBTN setImage:[UIImage imageNamed:@"s_big_cross1"] forState:UIControlStateNormal];
    [_RightBTN setImage:[UIImage imageNamed:@"s_big_sel_right11"] forState:UIControlStateNormal];
    [_hearBTN setImage:[UIImage imageNamed:@"s_big_unsel_hear11"] forState:UIControlStateNormal];
    
}

-(void)hideKeyboard
{
    [self.view endEditing: YES];
    
}



-(void)SearchAPICallPostMethod:(NSString *)searchname
{

    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        NSDictionary *params=@{@"user_id":user_id,@"s":searchname,@"paged":[NSString stringWithFormat:@"%ld",(long)PageSearchCount]};
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
//                              [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                          });
       }
       else
       {
             //  [SVProgressHUD dismiss];
             NSError *parseError = nil;
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
             NSLog(@"%@",responseDictionary);
             NSString *message = [responseDictionary valueForKey:@"message"];
             NSString *status=[responseDictionary valueForKey:@"status"];
             maxPageCount=[[responseDictionary valueForKey:@"pages"] integerValue];
            [self removeImage];
             // NSString *WishList_count=[responseDictionary valueForKey:@"fav_product_ids"];

         if ([status isEqualToString:@"S"])
           {
               fromSearch=YES;
               //_detailsArray=[NSMutableArray new];
               // [self.swipeView reloadData];
               ProductlistArray=[NSMutableArray new];
               ProductlistArray =[responseDictionary[@"data"] mutableCopy];
               NSLog(@"%@",ProductlistArray);
               _detailsArray=[NSMutableArray new];
               TotalProduct_Swipe=[NSMutableArray new];
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   // UI UPDATE 2
                   for (int i = 0 ; i<ProductlistArray.count; i++)
                   {
                       NSDictionary *dic = [ProductlistArray objectAtIndex:i];
                       ProductClass *product_calss=[[ProductClass alloc]init];
                       
                       product_calss.imagesArray=[NSMutableArray new];
                       product_calss.imagesArray=[[dic valueForKey:@"images"] mutableCopy];
                       product_calss.Description = [NSString stringWithFormat:@"%@", [dic valueForKey:@"description"]];
                       product_calss.cater_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"id"]];
                       product_calss.regular_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"regular_price"]];
                       product_calss.sale_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"sale_price"]];
                       product_calss.imagestr = [NSString stringWithFormat:@"%@", [dic valueForKey:@"main_image"]];
                       product_calss.title = [NSString stringWithFormat:@"%@", [dic valueForKey:@"title"]];
                       product_calss.price=[NSString stringWithFormat:@"%@", [dic valueForKey:@"price"]];
                       //                            float price=[[dic valueForKey:@"price"] floatValue];
                       //                            product_calss.price=[@"" stringByAppendingString:[NSString stringWithFormat:@"%.02f",price]];
                       //                             product_calss.price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"price"]];
                       //                             NSDictionary *brandDic=[[dic valueForKey:@"brands"] mutableCopy];
                       //                             NSLog(@"%@",[brandDic valueForKey:@"name"]);
                       
                       product_calss.brandName = [NSString stringWithFormat:@"%@",[dic valueForKey:@"brands"]];
                       if([[dic valueForKey:@"main_image"] isKindOfClass:[NSNull class]])
                       {
                           
                       }
                       else
                       {
                           product_calss.main_image=[NSString stringWithFormat:@"%@",[dic valueForKey:@"main_image"]];
                       }
                       [TotalProduct_Swipe addObject:product_calss];
                       //                            [_detailsArray addObject:product_calss];
                       if(TotalProduct_Swipe.count==ProductlistArray.count)
                       {
                           [self InitalArrayLoading];
                           // loadedCards = [[NSMutableArray alloc] init];
                           // allCards = [[NSMutableArray alloc] init];
                           // cardsLoadedIndex = 0;
                           // loadedimageproduct = [[NSMutableArray alloc] init];
                           // undo_direction=0;
                           [imagPro_compl removeFromSuperview];
                           [imageviewCatgy removeFromSuperview];
                           [self.swipeView frameForCardAtIndex:0];
                           [self.swipeView visibleCardsCount];
                           [self.swipeView cardsCount];
                           [self.swipeView resetCurrentCardNumber];
                           [self.swipeView reloadData];
                           //          _badge_lbl.text=[NSString stringWithFormat:@"%d",(int)badge_count];
                           //   [self loadCards];
                           [SVProgressHUD dismiss];
                       }
                   }
               });
           }
         else  if([status isEqualToString:@"F"])
           {
               
               dispatch_async(dispatch_get_main_queue(), ^(void){
                    [SVProgressHUD dismiss];
                   [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self Interneterror];
//            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });

    }

}

- (IBAction)Actback:(id)sender {
    
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)ActionSearchBTN:(id)sender
{
    
    SearchViewController * con=[SearchViewController new];
    con.delegate=self;
    [self.navigationController pushViewController:con animated:YES];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
//    SearchViewController *searchVC = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
//    searchVC.delegate=self;
//    searchVC.Fromproduct=YES;
//    [self.navigationController pushViewController:searchVC animated:YES];
//    if(tag==1)
//    {
//        _search_TF.hidden=NO;
//        [self.search_TF becomeFirstResponder];
//        tag=0;
//    }
//    else
//    {
//        _search_TF.hidden=YES;
//        // [self.search_TF becomeFirstResponder];
//        tag=1;
//    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
  
}
-(void)apicallMethodURLandreloading:(NSString *)prod_id
{
    if([Utils isNetworkAvailable] ==YES)
    {
        BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
        if (!skipUser)
        {
            [SVProgressHUD show];
            NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
            //        NSMutableArray* product_id_array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:WISHPRODUCTLIST]];
            
            NSString  *urlFavorite;
            NSDictionary *params;
            urlFavorite=[NSString stringWithFormat:@"%@",AddFavorite];
            //        NSError *error = nil;
            //        NSDictionary *dic=[product_id_array mutableCopy];
            //        NSMutableString *createJSON = [[NSMutableString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding];
            //
            //       //  [createJSON replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[createJSON length]}];
            //       [createJSON replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[createJSON length]}];
            //   [createJSON replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:(NSRange){0,[createJSON length]}];
            //            [createJSON stringByReplacingOccurrencesOfString:@"" withString:@""];
            // NSString *product_str=[NSString stringWithFormat:@"%@",createJSON];
            
            params = @{@"user_id":user_id,@"product_id":prod_id};
            
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
                                     [SVProgressHUD dismiss];
                                     [self serverError];
                                     //                                          [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                                 });
              }
              else
              {
                  //  [SVProgressHUD dismiss];
                  NSError *parseError = nil;
                  NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                  NSLog(@"%@",responseDictionary);
                  [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                  //      NSString *message = [responseDictionary valueForKey:@"message"];
                  NSString *status=[responseDictionary valueForKey:@"status"];
                  [self removeImage];
                  if ([status isEqualToString:@"S"])
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          [SVProgressHUD dismiss];
                          
                      });
                  }
                  else if([status isEqualToString:@"F"])
                  {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [SVProgressHUD dismiss];
                      });
                  }
                  
                  else
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
                          [SVProgressHUD dismiss];
                          
                      });
                  }
              }
          }];
            [dataTask resume];
        }
        else
        {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
              message:@"Sign in or Sign Up to add products to My Steez" preferredStyle:UIAlertControllerStyleAlert];
            
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
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self Interneterror];
//            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
    }
    
}
-(void)setvalueFromFlterSwipeReload
{
    _detailsArray=[NSMutableArray new];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    // UI UPDATE 2
    for (int i = 0 ; i<ProductlistArray.count; i++)
    {
        NSDictionary *dic = [ProductlistArray objectAtIndex:i];
        ProductClass *product_calss=[[ProductClass alloc]init];
        
        product_calss.imagesArray=[NSMutableArray new];
        product_calss.imagesArray=[[dic valueForKey:@"images"] mutableCopy];
        product_calss.Description = [NSString stringWithFormat:@"%@", [dic valueForKey:@"description"]];
        product_calss.cater_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"id"]];
        product_calss.regular_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"regular_price"]];
        product_calss.sale_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"sale_price"]];
        product_calss.imagestr = [NSString stringWithFormat:@"%@", [dic valueForKey:@"main_image"]];
        product_calss.title = [NSString stringWithFormat:@"%@", [dic valueForKey:@"title"]];
        float price=[[dic valueForKey:@"price"] floatValue];
        product_calss.price=[@"" stringByAppendingString:[NSString stringWithFormat:@"%.02f",price]];
        //                             product_calss.price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"price"]];
        //                             NSDictionary *brandDic=[[dic valueForKey:@"brands"] mutableCopy];
        //                             NSLog(@"%@",[brandDic valueForKey:@"name"]);
        
        product_calss.brandName = [NSString stringWithFormat:@"%@",[dic valueForKey:@"brands"]];
        if([[dic valueForKey:@"main_image"] isKindOfClass:[NSNull class]])
        {
            
        }
        else
        {
            product_calss.main_image=[NSString stringWithFormat:@"%@",[dic valueForKey:@"main_image"]];
        }
        [_detailsArray addObject:product_calss];
        if(_detailsArray.count==ProductlistArray.count)
        {
            //loadedCards = [[NSMutableArray alloc] init];
            // allCards = [[NSMutableArray alloc] init];
            // cardsLoadedIndex = 0;
            //   loadedimageproduct = [[NSMutableArray alloc] init];
            //undo_direction=0;
            [imagPro_compl removeFromSuperview];
            [imageviewCatgy removeFromSuperview];
            [self.swipeView frameForCardAtIndex:0];
            [self.swipeView visibleCardsCount];
            [self.swipeView cardsCount];
            [self.swipeView resetCurrentCardNumber];
            [self.swipeView reloadData];
            //_badge_lbl.text=[NSString stringWithFormat:@"%d",(int)badge_count];
            //   [self loadCards];
            [SVProgressHUD dismiss];
        }
    }
}
-(void)setvalueWhensearchingFromCategory
{
     
    _detailsArray=[NSMutableArray new];
    TotalProduct_Swipe=[NSMutableArray new];
//    dispatch_async(dispatch_get_main_queue(), ^{
        // UI UPDATE 2
        for (int i = 0 ; i<ProductlistArray.count; i++)
        {
            NSDictionary *dic = [ProductlistArray objectAtIndex:i];
            ProductClass *product_calss=[[ProductClass alloc]init];
            
            product_calss.imagesArray=[NSMutableArray new];
            product_calss.imagesArray=[[dic valueForKey:@"images"] mutableCopy];
            product_calss.Description = [NSString stringWithFormat:@"%@", [dic valueForKey:@"description"]];
            product_calss.cater_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"id"]];
            product_calss.regular_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"regular_price"]];
            product_calss.sale_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"sale_price"]];
            product_calss.imagestr = [NSString stringWithFormat:@"%@", [dic valueForKey:@"main_image"]];
            product_calss.title = [NSString stringWithFormat:@"%@", [dic valueForKey:@"title"]];
            product_calss.price=[NSString stringWithFormat:@"%@",[dic valueForKey:@"price"]];
            
            product_calss.brandName = [NSString stringWithFormat:@"%@",[dic valueForKey:@"brands"]];
            if([[dic valueForKey:@"main_image"] isKindOfClass:[NSNull class]])
            {
                
            }
            else
            {
                product_calss.main_image=[NSString stringWithFormat:@"%@",[dic valueForKey:@"main_image"]];
            }
//            [_detailsArray addObject:product_calss];
            [TotalProduct_Swipe addObject:product_calss];
            if(TotalProduct_Swipe.count==ProductlistArray.count)
            {
                [self InitalArrayLoading];
                //loadedCards = [[NSMutableArray alloc] init];
                //allCards = [[NSMutableArray alloc] init];
                //cardsLoadedIndex = 0;
                //loadedimageproduct = [[NSMutableArray alloc] init];
                //undo_direction=0;
                [imagPro_compl removeFromSuperview];
                [imageviewCatgy removeFromSuperview];
                
                
                [self.swipeView frameForCardAtIndex:0];
                [self.swipeView visibleCardsCount];
                [self.swipeView cardsCount];
                [self.swipeView resetCurrentCardNumber];
                [self.swipeView reloadData];
                //_badge_lbl.text=[NSString stringWithFormat:@"%d",(int)badge_count];
                //   [self loadCards];
                [SVProgressHUD dismiss];
            }
        }
//    });
}

- (IBAction)filter_Act:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FilterPro_VC *filterVC = (FilterPro_VC *)[storyboard instantiateViewControllerWithIdentifier:@"FilterPro_VC"];
   
    //[self presentViewController:myVC animated:NO completion:nil];
    filterVC.CategoryID=product_id;
    if (_FromShuffel==YES)
    {
        filterVC.FromShuffel=YES;
    }
    filterVC.delegate=self;
    [self.navigationController pushViewController:filterVC animated:YES];
}

- (IBAction)ActionShoppingBag:(id)sender
{
    ShoppingCartVC *myVC = (ShoppingCartVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ShoppingCartVC"];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

- (void)dataFromController:(NSMutableArray *)data
{
    ProductlistArray= [[data objectAtIndex:0] mutableCopy];
    previousFilterArray=[[data objectAtIndex:1] mutableCopy];
    maxPageCount=[[data objectAtIndex:2] integerValue];
    FromFilterApi=YES;
    current_index=YES;
    pageType=3;
    //[self setvalueWhensearchingFromCategory];
    
}
- (void)dataFromseacrhController:(NSMutableArray *)data
{
    ProductlistArray= [data mutableCopy];
    current_index=YES;
    FromSearchApi=YES;
    //    [self setvalueWhensearchingFromCategory];
}
#pragma mark - searchViewController
- (void)searchViewControllerSearchButtonClicked:(SearchViewController *)controller andSearchValue:(NSString *)searchValue
{
    NSLog(@"searchValue-->%@",searchValue);
    searchStr=searchValue;
    FromSearchApi=YES;
    current_index=YES;
    [self SearchAPICallPostMethodSearchvalue:controller andSearchValue:searchValue];
    // [self SearchAPICallPostMethodSearchvalue:controller];
   
}
- (void)searchViewControllerCancleButtonClicked:(SearchViewController *)controller{
    
    [controller.navigationController popViewControllerAnimated:YES];
}
-(void)SearchAPICallPostMethodSearchvalue:(SearchViewController *)controller andSearchValue:(NSString *)searchValue
{
    searchStr=searchValue;
    FromSearchApi=YES;
    current_index=YES;
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
//                                   [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                               });
            }
            else
            {
                   //[SVProgressHUD dismiss];
                   NSError *parseError = nil;
                   NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                   NSLog(@"%@",responseDictionary);
                   NSString *message = [responseDictionary valueForKey:@"message"];
                   NSString *status=[responseDictionary valueForKey:@"status"];
                    maxPageCount=[[responseDictionary valueForKey:@"pages"] integerValue];
                    [self removeImage];
                   if([status isEqualToString:@"S"])
                   {
                         dispatch_async(dispatch_get_main_queue(), ^{
                         pageType=2;
                      self.HeaderLBL.text=[self capitalizeFirstLetterOnlyOfString:searchValue];
                      ProductlistArray=[NSMutableArray new];
                      ProductlistArray =[responseDictionary[@"data"] mutableCopy];
                      NSLog(@"%@",ProductlistArray);
                      [SVProgressHUD dismiss];
                      [controller.navigationController popViewControllerAnimated:YES];
                       
                  });
                  // [SVProgressHUD dismiss];
                }
                 else if ([status isEqualToString:@"F"])
                 {
                         dispatch_async(dispatch_get_main_queue(), ^{
                         // [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                         [SVProgressHUD dismiss];
                         //Background Thread
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
            [self Interneterror];
//            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
        
    }
}
//API NAME: cancel-order
//parms: order_id, usre_id
- (IBAction)SettingAct:(id)sender {
    
//    int controllerIndex = 4;
    BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
    if (!skipUser)
    {
        UIStoryboard  *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        HomeTabBar *paymentOrder = (HomeTabBar *)[storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
        paymentOrder.selectedIndex=3;
        [self.navigationController pushViewController:paymentOrder animated:YES];
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
   
    
   
    
}
-(void)apiremoveFavoriteMethodProduct_id:(NSString *)pro_id
{
    
    if([Utils isNetworkAvailable] ==YES)
    {
        
        [SVProgressHUD show];
        
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
            [self Interneterror];
//            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
    }
    
}
-(void)SetFilterProduct
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSString *pro_Id;
        pro_Id=product_id;
        
        if (product_id==nil)
        {
            pro_Id=[[NSUserDefaults standardUserDefaults] valueForKey:@"prod_Id"];
        }
        NSError *error = nil;
        
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        NSData *jsonData2;
        
        
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
        
        
//
//        [previousFilterArray addObject:secondJsonDictionary];
//
        jsonData2 = [NSJSONSerialization dataWithJSONObject:previousFilterArray options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        NSDictionary *params;
        if (_FromShuffel==YES)
        {
            params = @{@"user_id":user_id,@"category_id":@"0",@"filters":jsonString,@"brand_id":@"0"/*pro_Id*/,@"paged":[NSString stringWithFormat:@"%ld",(long)PageFilterCount]};
        }
        else
        {
            params = @{@"user_id":user_id,@"category_id":pro_Id,@"filters":jsonString,@"brand_id":@"0",@"paged":[NSString stringWithFormat:@"%ld",(long)PageFilterCount]};
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
                            [self removeImage];
                             if([status isEqualToString:@"S"])
                             {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       ProductlistArray=[NSMutableArray new];
                                       ProductlistArray =[responseDictionary[@"data"] mutableCopy];
                                       NSLog(@"%@",ProductlistArray);
                                       _detailsArray=[NSMutableArray new];
                                       TotalProduct_Swipe=[NSMutableArray new];
                                       // UI UPDATE 2
                                      for (int i = 0 ; i<ProductlistArray.count; i++)
                                           {
                                               NSDictionary *dic = [ProductlistArray objectAtIndex:i];
                                               ProductClass *product_calss=[[ProductClass alloc]init];
                                               
                                               product_calss.imagesArray=[NSMutableArray new];
                                               product_calss.imagesArray=[[dic valueForKey:@"images"] mutableCopy];
                                               product_calss.Description = [NSString stringWithFormat:@"%@", [dic valueForKey:@"description"]];
                                               product_calss.cater_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"id"]];
                                               product_calss.regular_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"regular_price"]];
                                               product_calss.sale_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"sale_price"]];
                                               product_calss.imagestr = [NSString stringWithFormat:@"%@", [dic valueForKey:@"main_image"]];
                                               product_calss.title = [NSString stringWithFormat:@"%@", [dic valueForKey:@"title"]];
                                               product_calss.price=[NSString stringWithFormat:@"%@", [dic valueForKey:@"price"]];
//                                               float price=[[dic valueForKey:@"price"] floatValue];
//                                               product_calss.price=[@"" stringByAppendingString:[NSString stringWithFormat:@"%.02f",price]];
                                               //                             product_calss.price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"price"]];
                                               //                             NSDictionary *brandDic=[[dic valueForKey:@"brands"] mutableCopy];
                                               //                             NSLog(@"%@",[brandDic valueForKey:@"name"]);
                                               
                                               product_calss.brandName = [NSString stringWithFormat:@"%@",[dic valueForKey:@"brands"]];
                                               if([[dic valueForKey:@"main_image"] isKindOfClass:[NSNull class]])
                                               {
                                                   
                                               }
                                               else
                                               {
                                                   product_calss.main_image=[NSString stringWithFormat:@"%@",[dic valueForKey:@"main_image"]];
                                               }
                                               [TotalProduct_Swipe addObject:product_calss];
                                               //                            [_detailsArray addObject:product_calss];
                                               if(TotalProduct_Swipe.count==ProductlistArray.count)
                                               {
                                                   [self InitalArrayLoading];
                                                   // loadedCards = [[NSMutableArray alloc] init];
                                                   // allCards = [[NSMutableArray alloc] init];
                                                   // cardsLoadedIndex = 0;
                                                   // loadedimageproduct = [[NSMutableArray alloc] init];
                                                   // undo_direction=0;
                                                   [imagPro_compl removeFromSuperview];
                                                   [imageviewCatgy removeFromSuperview];
                                                   [self.swipeView frameForCardAtIndex:0];
                                                   [self.swipeView visibleCardsCount];
                                                   [self.swipeView cardsCount];
                                                   [self.swipeView resetCurrentCardNumber];
                                                   [self.swipeView reloadData];
                                                   //          _badge_lbl.text=[NSString stringWithFormat:@"%d",(int)badge_count];
                                                   //   [self loadCards];
                                                   [SVProgressHUD dismiss];
                                               }
                                           }
                                     
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
        //             }
        
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

