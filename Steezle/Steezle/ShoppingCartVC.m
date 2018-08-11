//
//  ShoppingCartVC.m
//  Steezle
//
//  Created by sanjay on 01/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "ShoppingCartVC.h"
#import "CardSaveVC.h"
//#import "ProductClass.h"
#import "shoppingCartCell.h"
#import "ProductDetail_VC.h"
#import "userdefaultArrayCall.h"
#import "Globals.h"
#import "Cart_class.h"
#import "Utils.h"
#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "PayementVC.h"
#import "newaddressVC.h"
#import "HomeTabBar.h"
#import <CoreText/CTStringAttributes.h>
#import "HomeView.h"
#import "LoginVC.h"
#define FONTNAME_REG   @"HelveticaNeue"
#define FONTBOLD_REG   @"Helvetica-Bold"
#define LFONT_10         [UIFont fontWithName:FONTNAME_REG size:14]
#define LFONT_17         [UIFont fontWithName:FONTBOLD_REG size:17]
@interface ShoppingCartVC ()<UITableViewDelegate,UITableViewDataSource>
{
    //    NSMutableArray *glableArray;
    NSMutableArray *detailsArray;
    NSMutableArray *QuantityArray,*product_id_array;
    NSInteger quantityIndex,itemsCount;
    NSMutableDictionary *UpdatePriceTotal_Dic;
    NSMutableDictionary *updateCartDic;
    NSMutableArray *updateProductArray;
    BOOL update;
    NSString *TotalProductPrice;
    NSString *variation;
}
@end

@implementation ShoppingCartVC
@synthesize glableArray,errorImage;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _itemLbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
    glableArray =[NSMutableArray new];
    TotalProductPrice=@"";
    updateCartDic=[NSMutableDictionary new];
    updateProductArray=[NSMutableArray new];
    QuantityArray=[NSMutableArray new];
    product_id_array=[NSMutableArray new];
    UpdatePriceTotal_Dic=[NSMutableDictionary new];
    [self  apicallMethodURL];
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
            __btn_h.constant=40;
            _totalview_h.constant=40;
            _total_p_h.constant=24;
            _total_L_h.constant=24;
            _both_h.constant=100;
            _lbl_totalOrderPrice.font=LFONT_17;
            _total_lbl_order.font=LFONT_17;
            
            
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
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    errorImage.alpha=0;
    self.shop_now_view.hidden=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
   
}

-(void)productDetailsFill
{
    Cart_class *pro_class = nil;
    NSString *price;
    NSString *totalMarchandise;
    NSString *total_price_str;
    
    float mar = 0.0,total = 0.0;
    
    float total_price = 0.0;
    
    for (int i=0; i<detailsArray.count;i++)
    {
        pro_class = [detailsArray objectAtIndex:i];
        price=[NSString stringWithFormat:@"%@",pro_class.price];
        total_price=[price floatValue] + total_price;
        totalMarchandise=[NSString stringWithFormat:@"%.2f",total_price];
        mar=[totalMarchandise floatValue];
        if(i==detailsArray.count-1)
        {
             total_price=total_price;
//            total_price=total_price+15 + 15.21f;
            total_price_str=[NSString stringWithFormat:@"%@",TotalProductPrice];
            total=[total_price_str floatValue];
        }
    }
    if([total_price_str length] == 0)
    {
        _lbl_marchandiseValue.text=[@"$" stringByAppendingString:@"0.00"];
        _lbl_totalOrderPrice.text=[@"$" stringByAppendingString:@"0.00"];
        _lbl_shopping.text=[@"$" stringByAppendingString:@"0.00"];
        _lbl_tax.text=[@"$" stringByAppendingString:@"0.00"];
       
        self.payNowBTN.userInteractionEnabled=NO;
        
        self.payNowBTN.alpha=0.3f;
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.height, self.tableView.frame.size.width)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.tableView.backgroundColor=[UIColor whiteColor];
        imageView.image =[UIImage imageNamed:@"Empty-shopping-bag"];
        
        self.tableView.backgroundView = imageView;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor=[UIColor clearColor];
        self.tableView.scrollEnabled=NO;
    }
    else
    {
        self.payNowBTN.userInteractionEnabled=YES;
        self.payNowBTN.alpha=1.0f;
        _lbl_marchandiseValue.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%@",totalMarchandise]];
        float total_p=[total_price_str floatValue];
        _lbl_totalOrderPrice.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%.02f",total_p]];
        _lbl_shopping.text=[@"$" stringByAppendingString:@"15.00"];
        _lbl_tax.text=[@"$" stringByAppendingString:@"15.21"];
        
        [UpdatePriceTotal_Dic setObject:[NSString stringWithFormat:@"%.2f",mar] forKey:@"Marchandise_Value"];
        [UpdatePriceTotal_Dic setObject:[NSString stringWithFormat:@"%.2f",total] forKey:@"Total_order_price"];
        
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
    shoppingCartCell *cell = (shoppingCartCell*)[tableView dequeueReusableCellWithIdentifier:@"cellShopping"];
    
    Cart_class *pro_class = nil;
    pro_class = [detailsArray objectAtIndex:indexPath.row];
    
//    cell.PlusBTN.layer.borderWidth=1.f;
//    cell.PlusBTN.layer.borderColor=[UIColor colorWithRed:4.0/255 green:110.0/255 blue:201.0/255 alpha:1.0f].CGColor;
//    cell.SubBTN.layer.borderWidth=1.f;
//    cell.SubBTN.layer.borderColor=[UIColor colorWithRed:4.0/255 green:110.0/255 blue:201.0/255 alpha:1.0f].CGColor;
    
    [cell.image sd_setShowActivityIndicatorView:YES];
    [cell.image sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:pro_class.product_image]                  placeholderImage:[UIImage imageNamed:@"empty_menu"]                           options:SDWebImageRefreshCached];
    cell.image.contentMode = UIViewContentModeScaleAspectFit;
    
//cell.image.image = [UIImage imageWithData:pro_class.product_image];
   
    cell.PlusBTN.tag = indexPath.row;
    cell.SubBTN.tag = indexPath.row;
    cell.LblCount.tag=indexPath.row;
    
    [cell.PlusBTN addTarget:self action:@selector(PlusbuttonClicked:) forControlEvents:UIControlEventTouchUpInside]; //add colon in selector buttonClicked
    [cell.SubBTN addTarget:self action:@selector(SubbuttonClicked:) forControlEvents:UIControlEventTouchUpInside]; //add colon in selector buttonAttachClicked
//    [cell.PlusBTN setTag:indexPath.row];
//    [cell.SubBTN setTag:indexPath.row];
    
//   if(quantityIndex==indexPath.row && update)
//
//   {
//       update=NO;
//       cell.LblCount.text=[NSString stringWithFormat:@"%ld",(long)Quantity];
//   }
    cell.LblCount.text = [NSString stringWithFormat:@"%@",[QuantityArray objectAtIndex:indexPath.row]];
    cell.priceLbl.text=[@"$" stringByAppendingString:[NSString stringWithFormat:@"%@",pro_class.price]];
   
    cell.lbl_tshart.text=[NSString stringWithFormat:@"%@",pro_class.product_title];
//    cell.priceLbl.text=[NSString stringWithFormat:@"%@",pro_class.price];
    cell.lbl_toro.text=[NSString stringWithFormat:@"%@",pro_class.brand_name];
    
    if ([cell.lbl_toro.text isEqualToString:@"Yung2"]) {
        NSMutableAttributedString *carbonDioxide = [[NSMutableAttributedString alloc] initWithString:@"Yung2"];
        [carbonDioxide addAttribute:(NSString *)kCTSuperscriptAttributeName value:@+1 range:NSMakeRange(4,1)];
        cell.lbl_toro.attributedText=carbonDioxide;
    }
    
   
    cell.lbl_colorValue.text=[NSString stringWithFormat:@"%@",pro_class.pa_color];
    cell.lbl_sizevalue.text=[NSString stringWithFormat:@"%@",pro_class.pa_size];
    if (pro_class.pa_size==nil && pro_class.pa_color==nil)
    {
        cell.lbl_sizevalue.text=@"";
        cell.lbl_colorValue.text=@"";
        cell.dotLBL.backgroundColor=[UIColor whiteColor];
       
    }
    else if (pro_class.pa_size==nil)
    {
        cell.lbl_sizevalue.text=@"";
//        cell.lbl_sizevalue.text=[NSString stringWithFormat:@"%@",pro_class.pa_size];
        cell.lbl_colorValue.text=[NSString stringWithFormat:@"%@",pro_class.pa_color];
        cell.dotLBL.backgroundColor=[UIColor whiteColor];
       
    }
   else  if (pro_class.pa_color==nil)
    {
        cell.lbl_sizevalue.text=@"";
        cell.lbl_colorValue.text=[NSString stringWithFormat:@"%@",pro_class.pa_size];
//        cell.colorWidthLayout.constant=0;
        cell.dotLBL.backgroundColor=[UIColor whiteColor];
        
    }
    
    

    return cell;
    
}



- (void)PlusbuttonClicked:(UIButton *)sender
{
    
//    shoppingCartCell *cell = (shoppingCartCell*)[self.tableView dequeueReusableCellWithIdentifier:@"cellShopping"];
    
    BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
    
    if (!skipUser)
    {
        NSInteger num = [sender tag];
        NSInteger value = [[QuantityArray objectAtIndex:num] integerValue];
        value += 1;
        if(value>100)
        {
            
        }
        else
        {
            self.tableView.userInteractionEnabled=NO;
            QuantityArray[num] = @(value);
            itemsCount=itemsCount+1;
            NSString *count=[NSString stringWithFormat:@"%lu",(long)itemsCount];
            _itemLbl.text=count;
            
            Cart_class *cart_obj=nil;
            cart_obj= [detailsArray objectAtIndex:num];
            
            NSString *productID=[NSString stringWithFormat:@"%@",cart_obj.product_id];
            NSString *qty=[NSString stringWithFormat:@"%ld",(long)value];
            NSString *variationID=[NSString stringWithFormat:@"%@",cart_obj.variation_id];
            for(int i=0;i<updateProductArray.count;i++)
            {
                NSDictionary *dic=[[updateProductArray objectAtIndex:i]  mutableCopy];
                NSString *productid=[NSString stringWithFormat:@"%@",[dic valueForKey:@"product_id"]];
                
                NSString *variation_id=[NSString stringWithFormat:@"%@",[dic valueForKey:@"variation_id"]];
                if([productID isEqualToString:productid] && [variationID isEqualToString:variation_id])
                {
                    [updateProductArray removeObjectAtIndex:i];
                    break;
                }
            }
            
            updateCartDic = [NSMutableDictionary dictionaryWithObjectsAndKeys: productID,@"product_id",variationID,@"variation_id",qty,@"qty",nil];
            [updateProductArray addObject:updateCartDic];
            
            
            [self APIcheckoutpaymentUpdate:@"YES"];
            
            
            //        [self updateTotalPrice_increase:num];
        }
        
        NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:num inSection:0];
        NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [_tableView reloadRowsAtIndexPaths:rowsToReload
                          withRowAnimation:UITableViewRowAnimationNone];
        
        
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
-(void)updateTotalPrice_decrease:(NSInteger )_index
{
   
    float marchandis_price=0.0,Total_price=0.0;
    
    marchandis_price=[[UpdatePriceTotal_Dic valueForKey:@"Marchandise_Value"] floatValue];
    Total_price=[[UpdatePriceTotal_Dic valueForKey:@"Total_order_price"] floatValue];
    
    
    Cart_class *pro_class = nil;
    NSString *price;
    NSString *totalMarchandise;
    NSString *total_price_str;
    float total_price;
    float marchandis_p;
    
    pro_class = [detailsArray objectAtIndex:_index];
    price=[NSString stringWithFormat:@"%@",pro_class.price];
    
   
        total_price=Total_price-[price floatValue];
        marchandis_p= marchandis_price - [price floatValue];
    
    totalMarchandise=[NSString stringWithFormat:@"%.2f",marchandis_p];
    total_price_str=[NSString stringWithFormat:@"%.2f",total_price];

    
    if([total_price_str length] == 0)
    {
        _lbl_marchandiseValue.text=[@"$ " stringByAppendingString:@"0.00"];
        _lbl_totalOrderPrice.text=[@"$ " stringByAppendingString:@"0.00"];
        _lbl_shopping.text=[@"$ " stringByAppendingString:@"0.00"];
        _lbl_tax.text=[@"$ " stringByAppendingString:@"0.00"];
        
        //        [UpdatePriceTotal_Dic setObject:_lbl_marchandiseValue.text forKey:@"Marchandise_Value"];
        //        [UpdatePriceTotal_Dic setObject:_lbl_totalOrderPrice.text forKey:@"Total_order_price"];
        self.payNowBTN.userInteractionEnabled=NO;
        self.payNowBTN.alpha=0.3f;
    }
    else
    {
        self.payNowBTN.userInteractionEnabled=YES;
        self.payNowBTN.alpha=1.0f;
        _lbl_marchandiseValue.text=[@"$ " stringByAppendingString:[NSString stringWithFormat:@"%@",totalMarchandise]];
        _lbl_totalOrderPrice.text=[@"$ " stringByAppendingString:[NSString stringWithFormat:@"%@",total_price_str]];
        _lbl_shopping.text=[@"$ " stringByAppendingString:@"15.00"];
        _lbl_tax.text=[@"$ " stringByAppendingString:@"15.21"];
        
        [UpdatePriceTotal_Dic removeObjectForKey:@"Marchandise_Value"];
        [UpdatePriceTotal_Dic removeObjectForKey:@"Total_order_price"];
        
        [UpdatePriceTotal_Dic setObject:[NSString stringWithFormat:@"%@",totalMarchandise] forKey:@"Marchandise_Value"];
        [UpdatePriceTotal_Dic setObject:[NSString stringWithFormat:@"%@",total_price_str] forKey:@"Total_order_price"];
        
    }
    
    
    
}
-(void)updateTotalPrice_increase:(NSInteger )_index
{
  
    float marchandis_price=0.0,Total_price=0.0;
    
    marchandis_price=[[UpdatePriceTotal_Dic valueForKey:@"Marchandise_Value"] floatValue];
    Total_price=[[UpdatePriceTotal_Dic valueForKey:@"Total_order_price"] floatValue];
    
    
    Cart_class *pro_class = nil;
    NSString *price;
    NSString *totalMarchandise;
    NSString *total_price_str;
    float total_price;
    float marchandis_p;
    
    pro_class = [detailsArray objectAtIndex:_index];
    price=[NSString stringWithFormat:@"%@",pro_class.price];
    
    total_price=[price floatValue] + Total_price;
    marchandis_p=marchandis_price + [price floatValue];
    
    totalMarchandise=[NSString stringWithFormat:@"%.2f",marchandis_p];
    total_price_str=[NSString stringWithFormat:@"%.2f",total_price];
    
    
    if([total_price_str length] == 0)
    {
        _lbl_marchandiseValue.text=[@"$ " stringByAppendingString:@"0.00"];
        _lbl_totalOrderPrice.text=[@"$ " stringByAppendingString:@"0.00"];
        _lbl_shopping.text=[@"$ " stringByAppendingString:@"0.00"];
        _lbl_tax.text=[@"$ " stringByAppendingString:@"0.00"];
//        [UpdatePriceTotal_Dic setObject:_lbl_marchandiseValue.text forKey:@"Marchandise_Value"];
//        [UpdatePriceTotal_Dic setObject:_lbl_totalOrderPrice.text forKey:@"Total_order_price"];
        self.payNowBTN.userInteractionEnabled=NO;
        self.payNowBTN.alpha=0.3f;
    }
    else
    {
        self.payNowBTN.userInteractionEnabled=YES;
        self.payNowBTN.alpha=1.0f;
        _lbl_marchandiseValue.text=[@"$ " stringByAppendingString:[NSString stringWithFormat:@"%@",totalMarchandise]];
        _lbl_totalOrderPrice.text=[@"$ " stringByAppendingString:[NSString stringWithFormat:@"%@",total_price_str]];
        _lbl_shopping.text=[@"$ " stringByAppendingString:@"15.00"];
        _lbl_tax.text=[@"$ " stringByAppendingString:@"15.21"];
        
        [UpdatePriceTotal_Dic removeObjectForKey:@"Marchandise_Value"];
         [UpdatePriceTotal_Dic removeObjectForKey:@"Total_order_price"];
        
       [UpdatePriceTotal_Dic setObject:[NSString stringWithFormat:@"%@",totalMarchandise] forKey:@"Marchandise_Value"];
        [UpdatePriceTotal_Dic setObject:[NSString stringWithFormat:@"%@",total_price_str] forKey:@"Total_order_price"];
        
    }
    

    
}
- (void)SubbuttonClicked:(UIButton *)sender {

    
    BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
    
    if (!skipUser)
    {
        NSInteger num = [sender tag];
        NSInteger value = [[QuantityArray objectAtIndex:num] integerValue];
        value -= 1;
        if(value<1)
        {
            //        _lbl_totalOrderPrice.text=[@"$ " stringByAppendingString:@"0.00"];
            //        _lbl_shopping.text=[@"$ " stringByAppendingString:@"0.00"];
            //        _lbl_tax.text=[@"$ " stringByAppendingString:@"0.00"];
        }
        else
        {
            QuantityArray[num] = @(value);
            itemsCount=itemsCount-1;
            NSString *count=[NSString stringWithFormat:@"%lu",(long)itemsCount];
            _itemLbl.text=count;
            Cart_class *cart_obj=nil;
            
            cart_obj= [detailsArray objectAtIndex:num];
            
            NSString *productID=[NSString stringWithFormat:@"%@",cart_obj.product_id];
            NSString *qty=[NSString stringWithFormat:@"%ld",(long)value];
            NSString *variationID=[NSString stringWithFormat:@"%@",cart_obj.variation_id];
            for(int i=0;i<updateProductArray.count;i++)
            {
                NSDictionary *dic=[[updateProductArray objectAtIndex:i]  mutableCopy];
                
                NSString *productid=[NSString stringWithFormat:@"%@",[dic valueForKey:@"product_id"]];
                NSString *variation_id=[NSString stringWithFormat:@"%@",[dic valueForKey:@"variation_id"]];
                
                if([productID isEqualToString:productid] && [variationID isEqualToString:variation_id])
                {
                    [updateProductArray removeObjectAtIndex:i];
                    break;
                }
            }
            
            updateCartDic = [NSMutableDictionary dictionaryWithObjectsAndKeys: productID,@"product_id",variationID,@"variation_id",qty,@"qty",nil];
            [updateProductArray addObject:updateCartDic];
            
            
            [self APIcheckoutpaymentUpdate:@"YES"];
            
            
            //        [self updateTotalPrice_decrease:num];
            
        }
        NSIndexPath *rowToReload = [NSIndexPath indexPathForRow:num inSection:0];
        NSArray *rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
        [_tableView reloadRowsAtIndexPaths:rowsToReload
                          withRowAnimation:UITableViewRowAnimationNone];
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

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"%ld",(long)indexPath.row);
//    ProductClass *pro_class = nil;
//    pro_class = [detailsArray objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ProductDetail_VC *myVC = (ProductDetail_VC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductDetailVCd"];
//    NSString *index=[NSString stringWithFormat:@"%@",pro_class.product_id];
//    myVC.productId=index;
    [self.navigationController pushViewController:myVC animated:YES];
    
}
*/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Cart_class *pro_class = nil;
        pro_class = [detailsArray objectAtIndex:indexPath.row];
        NSString *pro_id=[NSString stringWithFormat:@"%@",pro_class.product_id];
        NSString *vari_id=[NSString stringWithFormat:@"%@",pro_class.variation_id];
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Steezle"
                        message:@"Do you want to remove this item?"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
//                                        [detailsArray removeObjectAtIndex:indexPath.row];
                                        
                                        [self apiremoveCartMethodProduct_id:pro_id andVariation:vari_id];
                                        //        AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
                                        //        [appdelegate.productItemArray removeObjectAtIndex:indexPath.row];
                                        [self productDetailsFill];
                                        [tableView reloadData];
                                        NSString *count=[NSString stringWithFormat:@"%lu",(unsigned long)[detailsArray count]];
                                        itemsCount=[detailsArray count];
                                        _itemLbl.text=count;
                                        // tell table to refresh now
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
- (IBAction)backBtnClick:(id)sender
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)cardBtnClick:(id)sender {
    
    CardSaveVC *myVC = (CardSaveVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"CardSaveVC"];
//    [self presentViewController:myVC animated:NO completion:nil];
    [self.navigationController pushViewController:myVC animated:YES];
    
}
- (IBAction)bagAction:(id)sender
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)checkoutAction:(id)sender
{
    //here
    BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
    
    if (!skipUser)
    {
        [self APIcheckoutpaymentUpdate:@"NO"];
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



-(void)apicallMethodURL
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        self.tableView.userInteractionEnabled=NO;
        self.payNowBTN.userInteractionEnabled=NO;
        
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
                                   
                                    self.tableView.userInteractionEnabled=YES;
                                    self.payNowBTN.userInteractionEnabled=YES;
                                     [SVProgressHUD dismiss];
                                    [self serverError];
//                                    [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                                });
                
             }
            else
            {
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                NSDictionary *card_Dic=[NSDictionary new];
                card_Dic =[responseDictionary[@"data"] mutableCopy];
                NSString *message =[responseDictionary valueForKey:@"message"];
                NSString *status=[responseDictionary valueForKey:@"status"];
                [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                [self removeImage];
                 if ([status isEqualToString:@"S"])
                {

                        glableArray =[card_Dic[@"cart"] mutableCopy];
                        NSString *currency = [card_Dic valueForKey:@"currency"];
                        NSString *total_cart_item=[card_Dic valueForKey:@"total_cart_item"];
                        NSString *cart_total = [card_Dic valueForKey:@"cart_total"];
                        
                        NSLog(@"%@ /n %@ \n %@",currency,total_cart_item,cart_total);
                        
                        TotalProductPrice=[NSString stringWithFormat:@"%@",[card_Dic valueForKey:@"cart_subtotal"]];
                        
                        detailsArray=[NSMutableArray new];
                        // UI UPDATE 2
                        for (int i = 0 ; i<glableArray.count; i++)
                        {
                            NSDictionary *dic = [glableArray objectAtIndex:i];
                            
                            Cart_class *cart_calss=[[Cart_class alloc]init];
                            
                            cart_calss.product_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_id"]];
                            cart_calss.product_title = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_title"]];
                            cart_calss.qty = [NSString stringWithFormat:@"%@", [dic valueForKey:@"qty"]];
                            cart_calss.price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"price"]];
                            cart_calss.regular_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"regular_price"]];
                            cart_calss.sale_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"sale_price"]];
                            cart_calss.variation_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"variation_id"]];
                            NSDictionary *dic1=[dic valueForKey:@"variation"];
                            NSString *strVari=[NSString stringWithFormat:@"%@",dic1];
                            if ([strVari isEqualToString:@""])
                            {
                                
                            }
                            else
                            {
                                NSDictionary *dicvariation=[NSDictionary new];
                                dicvariation=[[dic valueForKey:@"variation"]mutableCopy];
                                
                                if (dicvariation.count!=0 && dicvariation[@"attribute_pa_size"] && dicvariation[@"attribute_pa_color"])
                                {
                                    NSLog(@"Exists");
                                    cart_calss.pa_size = [NSString stringWithFormat:@"%@", [dicvariation valueForKey:@"attribute_pa_size"]];
                                    cart_calss.pa_color = [NSString stringWithFormat:@"%@", [dicvariation valueForKey:@"attribute_pa_color"]];
                                    
                                    //                                cart_calss.count=@"both";
                                }
                                else if (dicvariation.count!=0 && dicvariation[@"attribute_pa_size"])
                                {
                                    cart_calss.pa_size = [NSString stringWithFormat:@"%@", [dicvariation valueForKey:@"attribute_pa_size"]];
                                    //                                cart_calss.count=@"size";
                                }
                                else if (dicvariation.count!=0 && dicvariation[@"attribute_pa_color"])
                                {
                                    cart_calss.pa_color = [NSString stringWithFormat:@"%@", [dicvariation valueForKey:@"attribute_pa_color"]];
                                    //                                cart_calss.count=@"color";
                                }
                                else
                                {
                                    NSLog(@"Does not exist");
                                    // order_class.count=@"simple";
                                }
                                
                            }
                            
                            
                            cart_calss.brand_name = [NSString stringWithFormat:@"%@", [dic valueForKey:@"brand"]];
                            cart_calss.product_image=[NSString stringWithFormat:@"%@",[dic valueForKey:@"product_image"]];
                            
                            //NSLog(@"%@",cart_calss.pa_color);
                            //NSLog(@"%@",cart_calss.pa_size);
                            
                            [QuantityArray addObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"qty"]]];
                            [product_id_array addObject:[dic valueForKey:@"product_id"]];
                            [detailsArray addObject:cart_calss];
                            
                        }
                        if(detailsArray.count==glableArray.count)
                        {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                self.shop_now_view.hidden=YES;
                                [self productDetailsFill];
                                [self.tableView reloadData];
                                self.tableView.userInteractionEnabled=YES;
                                self.payNowBTN.userInteractionEnabled=YES;

                                //  NSString *count=[NSString stringWithFormat:@"%lu",(unsigned long)[detailsArray count]];
                                //           itemsCount=[detailsArray count];
                                NSString *count=[NSString stringWithFormat:@"%@",total_cart_item];
                                itemsCount=[count integerValue];
                                _itemLbl.text=count;
                                [SVProgressHUD dismiss];
                            });
                            // [_tableview reloadData];
                        }

//                    });
                }
               else if([status isEqualToString:@"F"])
                {
                    //Background Thread
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        
                        self.shop_now_view.hidden=NO;
                        self.tableView.userInteractionEnabled=YES;
                        self.payNowBTN.userInteractionEnabled=YES;
                        [self.tableView reloadData];
                        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.height, self.tableView.frame.size.width)];
                        imageView.contentMode = UIViewContentModeScaleAspectFit;
                        self.tableView.backgroundColor=[UIColor whiteColor];
                        imageView.image =[UIImage imageNamed:@"Empty-shopping-bag"];
                        
                        self.tableView.backgroundView = imageView;
                        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                        self.tableView.separatorColor=[UIColor clearColor];
                        self.tableView.scrollEnabled=NO;
                        [SVProgressHUD dismiss];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        self.tableView.userInteractionEnabled=YES;
                        self.payNowBTN.userInteractionEnabled=YES;

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
            
            self.tableView.userInteractionEnabled=YES;
            self.payNowBTN.userInteractionEnabled=YES;
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
        
        _itemLbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
    });
    
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
-(void)apiremoveCartMethodProduct_id:(NSString *)pro_id  andVariation:(NSString *)var_id
{
    
    if([Utils isNetworkAvailable] ==YES)
    {
        
        [SVProgressHUD show];
        self.payNowBTN.userInteractionEnabled=NO;
        self.tableView.userInteractionEnabled=NO;
        NSError *error=nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:updateProductArray options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
       NSDictionary *params = @{@"user_id":user_id,@"product_id":pro_id,@"variation_id":var_id,@"updated_cart":jsonString};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@",BaseURL,RemoveCart ];
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
                              self.tableView.userInteractionEnabled=YES;
                              self.payNowBTN.userInteractionEnabled=YES;
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
          NSDictionary *newitemdic=[NSDictionary new];
          newitemdic=[[responseDictionary valueForKey:@"data"] mutableCopy];
          NSString *message = [responseDictionary valueForKey:@"message"];
          NSString *status=[responseDictionary valueForKey:@"status"];
          
          NSString *total_cart_item=[newitemdic valueForKey:@"total_cart_item"];
          NSString *cart_total = [newitemdic valueForKey:@"cart_total"];
          glableArray =[newitemdic[@"cart"] mutableCopy];
          NSLog(@"%@ /n %@ ",total_cart_item,cart_total);
          TotalProductPrice=[NSString stringWithFormat:@"%@",[newitemdic valueForKey:@"cart_subtotal"]];
          
          detailsArray=[NSMutableArray new];
          QuantityArray=[NSMutableArray new];
          [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
          [self removeImage];
           if ([status isEqualToString:@"S"])
          {
              for (int i = 0 ; i<glableArray.count; i++)
              {
                  NSDictionary *dic = [glableArray objectAtIndex:i];
                  
                  Cart_class *cart_calss=[[Cart_class alloc]init];
                  
                  cart_calss.product_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_id"]];
                  cart_calss.product_title = [NSString stringWithFormat:@"%@", [dic valueForKey:@"product_title"]];
                  cart_calss.qty = [NSString stringWithFormat:@"%@", [dic valueForKey:@"qty"]];
                  cart_calss.price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"price"]];
                  cart_calss.regular_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"regular_price"]];
                  cart_calss.sale_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"sale_price"]];
                  cart_calss.variation_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"variation_id"]];
                  NSDictionary *dic1=[dic valueForKey:@"variation"];
                  NSString *strVari=[NSString stringWithFormat:@"%@",dic1];
                  if(![strVari isEqualToString:@""])
                  {
                      
                      cart_calss.pa_size = [NSString stringWithFormat:@"%@", [dic1 valueForKey:@"attribute_pa_size"]];
                      cart_calss.pa_color = [NSString stringWithFormat:@"%@", [dic1 valueForKey:@"attribute_pa_color"]];
                      
                  }
                  
                  cart_calss.brand_name = [NSString stringWithFormat:@"%@", [dic valueForKey:@"brand"]];
                  cart_calss.product_image=[NSString stringWithFormat:@"%@",[dic valueForKey:@"product_image"]];
                  
                  // NSLog(@"%@",cart_calss.pa_color);
                  // NSLog(@"%@",cart_calss.pa_size);
                
                  [QuantityArray addObject:[NSString stringWithFormat:@"%@", [dic valueForKey:@"qty"]]];
                  [product_id_array addObject:[dic valueForKey:@"product_id"]];
                  [detailsArray addObject:cart_calss];
                  
              }
              if(detailsArray.count==glableArray.count)
              {
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      [self productDetailsFill];
                      [self.tableView reloadData];
                      NSString *count=[NSString stringWithFormat:@"%@",total_cart_item];
                      itemsCount=[count integerValue];
                      _itemLbl.text=count;
                      self.tableView.userInteractionEnabled=YES;
                      self.payNowBTN.userInteractionEnabled=YES;
                      [SVProgressHUD dismiss];
                  });
                  //   [_tableview reloadData];
              }
              if(glableArray.count==0)
              {
                  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"card_flag"];
//                  [[NSUserDefaults standardUserDefaults ] setValue:@"NO" forKey:CART_FLAG];
                  dispatch_async(dispatch_get_main_queue(), ^{
                       
                       [self.tableView reloadData];
                       [SVProgressHUD dismiss];
                       self.tableView.userInteractionEnabled=YES;
                      self.payNowBTN.userInteractionEnabled=YES;
                       UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.height, self.tableView.frame.size.width)];
                       imageView.contentMode = UIViewContentModeScaleAspectFit;
                       self.tableView.backgroundColor=[UIColor whiteColor];
                       imageView.image =[UIImage imageNamed:@"Empty-shopping-bag"];

                       self.tableView.backgroundView = imageView;
                       self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                       self.tableView.separatorColor=[UIColor clearColor];
                       self.tableView.scrollEnabled=NO;
                       

                       });
              }
          }
         else if([status isEqualToString:@"F"])
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.userInteractionEnabled=YES;
                  self.payNowBTN.userInteractionEnabled=YES;
                    [SVProgressHUD dismiss];
                   [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
              });
          }
          
          else
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  self.tableView.userInteractionEnabled=YES;
                  self.payNowBTN.userInteractionEnabled=YES;
                  [SVProgressHUD dismiss];
                  [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
              });
          }
          
          // UI UPDATE 2
          
      }
     }];
        [dataTask resume];
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.userInteractionEnabled=YES;
            self.payNowBTN.userInteractionEnabled=YES;
            [SVProgressHUD dismiss];
            [self Interneterror];
//            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
       
    }
    
}
-(void)APIcheckoutpaymentUpdate:(NSString *)flag
{
    
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSError *error=nil;
        self.tableView.userInteractionEnabled=NO;
        self.payNowBTN.userInteractionEnabled=NO;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:updateProductArray options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:USERID]];
        NSDictionary *params = @{@"user_id":user_id,@"updated_cart":jsonString};
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@",BaseURL,Checkout];
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
                                        self.tableView.userInteractionEnabled=YES; self.payNowBTN.userInteractionEnabled=YES;
                                        [SVProgressHUD dismiss];
                                        [self serverError];
//                                        [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
                                    });
                     
                 }
                 else
                 {
                     
                        NSError *parseError = nil;
                     
                        NSMutableArray *checkoutArray=[NSMutableArray new];
                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                        NSLog(@"%@",responseDictionary);
                     
                        NSString *message = [responseDictionary valueForKey:@"message"];
                        NSString *status=[responseDictionary valueForKey:@"status"];
                     
                        [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                        checkoutArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
                     
                        [self removeImage];
                        if([status isEqualToString:@"F"])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^(void)
                            {
                                self.tableView.userInteractionEnabled=YES;
                                self.payNowBTN.userInteractionEnabled=YES;
                                [SVProgressHUD dismiss];
                                
                               
                                    [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                               
                                
                             });
                         }
                        else if ([status isEqualToString:@"S"] && [flag isEqualToString:@"NO"])
                        {
                              dispatch_async(dispatch_get_main_queue(), ^(void){
                                  self.tableView.userInteractionEnabled=YES;
                                  self.payNowBTN.userInteractionEnabled=YES;
                                  [SVProgressHUD dismiss];
                                  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  
                                  newaddressVC *addresscv = (newaddressVC *)[storyboard instantiateViewControllerWithIdentifier:@"newaddressVC"];
                                  addresscv.ArrayPassdetails= checkoutArray.mutableCopy;
                                  addresscv.FromPaymentPage=YES;
                                  [self.navigationController pushViewController:addresscv animated:YES];
                               });
                        }
                        else if ([status isEqualToString:@"S"] && [flag isEqualToString:@"YES"])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^(void){
                                glableArray =[NSMutableArray new];
                                TotalProductPrice=@"";
                                updateCartDic=[NSMutableDictionary new];
                                updateProductArray=[NSMutableArray new];
                                QuantityArray=[NSMutableArray new];
                                product_id_array=[NSMutableArray new];
                                UpdatePriceTotal_Dic=[NSMutableDictionary new];
                                [self  apicallMethodURL];
                            });
                        }
                       else
                       {
                           
                           dispatch_async(dispatch_get_main_queue(), ^(void){
                               
                               self.tableView.userInteractionEnabled=YES;
                               self.payNowBTN.userInteractionEnabled=YES;
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
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
          
            self.tableView.userInteractionEnabled=YES;
            self.payNowBTN.userInteractionEnabled=YES;
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
- (IBAction)Action_emptyShop:(id)sender
{
    
    UIStoryboard  *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HomeTabBar *paymentOrder = (HomeTabBar *)[storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
    [self.navigationController pushViewController:paymentOrder animated:YES];
//    [self.navigationController popViewControllerAnimated:TRUE];
}
@end
