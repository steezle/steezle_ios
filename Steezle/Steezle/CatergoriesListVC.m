//
//  CatergoriesListVC.m
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import "CatergoriesListVC.h"
#import "CategoriesListCell.h"
#import "subCategoriesCell.h"
#import "HomeTabBar.h"
#import "ShoppingCartVC.h"
#import "Globals.h"
#import "Utils.h"
#import "SVProgressHUD.h"
#import "ProductVC.h"
#import "catergoriesClass.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "ViewControllerCell.h"
#import "ViewControllerCellHeader.h"
#include <stdlib.h>
#include "userdefaultArrayCall.h"
#define FONTNAME_REG   @"HelveticaNeue"

#define LFONT_10         [UIFont fontWithName:FONTNAME_REG size:14]
@interface CatergoriesListVC ()

{
    NSMutableArray *arrSelectedSectionIndex;
    BOOL isMultipleExpansionAllowed;
    NSMutableArray *attributes,*subattributes,*runtimeSubArry;
    NSIndexPath *currentIndex;
    NSInteger subcount;
    BOOL FromBrand;
    NSMutableArray      *sectionTitleArray;
    NSMutableDictionary *sectionContentDict;
    NSMutableArray      *arrayForBool;
 
}
@end

@implementation CatergoriesListVC
@synthesize product_id,productTitleLBL,productTitle,errorImage;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // self.title = NSLocalizedString(@"Master", @"Master");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            // self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCategories];

}
-(void)getCategories
{
    
    if([Utils isNetworkAvailable] ==YES)
    {
        
        [SVProgressHUD show];
        
        NSDictionary *params = @{@"user_id":[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]],@"id": product_id};
        NSURLSessionConfiguration *sessionConfiguration= [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@",BaseURL,Sub_categories];
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
               //                    [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
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
                 
                 _categorylistArray = [NSMutableArray new];
                 _categorylistArray = [responseDictionary[@"data"] mutableCopy];
                  [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                 NSLog(@"%@",_categorylistArray);
                 subattributes=[NSMutableArray new];
                 _detailsArray=[NSMutableArray new];
                 runtimeSubArry=[NSMutableArray new];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     // UI UPDATE 2
                     for (int i = 0 ; i<_categorylistArray.count; i++)
                     {
                         NSDictionary *dic = [_categorylistArray objectAtIndex:i];
                         catergoriesClass *calssobj=[[catergoriesClass alloc]init];
                         calssobj.name = [NSString stringWithFormat:@"%@", [dic valueForKey:@"name"]];
                         calssobj.cater_id = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
                         [subattributes addObject:[[dic valueForKey:@"sub_categories"] mutableCopy]];
                         if([[dic valueForKey:@"image"] isKindOfClass:[NSNull class]])
                         {
                             
                         }
                         else
                         {
                            calssobj.image=[NSString stringWithFormat:@"%@",[dic valueForKey:@"image"]];
                             
                         }
                         [_detailsArray addObject:calssobj];
                         if(_detailsArray.count==_categorylistArray.count)
                         {
                             if (!sectionTitleArray)
                             {
                                 sectionTitleArray=[NSMutableArray new];
                                 for (int i=0; i<_detailsArray.count; i++)
                                 {
                                     NSDictionary *dic=[NSDictionary new];
                                     dic=[_detailsArray objectAtIndex:i];
                                     [sectionTitleArray addObject:[NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]]];
                                 }
                                 //sectionTitleArray=[_detailsArray mutableCopy];
                                 //sectionTitleArray = [NSMutableArray arrayWithObjects:@"Aachen", @"Berlin", @"Düren", @"Essen", @"Münster", nil];
                             }
                             if (!arrayForBool)
                             {
                                 arrayForBool=[NSMutableArray new];
                                 for (int i=0; i<_detailsArray.count; i++)
                                 {
                                     [arrayForBool addObject: [NSNumber numberWithBool:NO]];
                                 }
                                 
                             }
                             if (!sectionContentDict)
                             {
                                 sectionContentDict  = [[NSMutableDictionary alloc] init];
                                 
                                 for (int i=0; i<subattributes.count; i++)
                                 {
                                     NSMutableArray *dicarray=[NSMutableArray new];
                                     dicarray=[[subattributes objectAtIndex:i]mutableCopy];
                                     
                                     NSMutableArray *array1 = [NSMutableArray new];
                                     for (int p=0; p<dicarray.count; p++)
                                     {
                                         NSDictionary *dic=[NSDictionary new];
                                         dic=[[dicarray objectAtIndex:p] mutableCopy];
                                         [array1 addObject:[dic valueForKey:@"name"]];
                                     }
                                     [sectionContentDict setValue:array1 forKey:[sectionTitleArray objectAtIndex:i]];
                                 }
                                 
                             }
                             
                             //
                         }
                       
                     }
                     [self.tableView reloadData];
                     [SVProgressHUD dismissWithDelay:1];
                    
                 });
                 
             }
             else if ([status isEqualToString:@"F"])
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
                        [self showWarningAlertWithTitle:@"Steezle" andMessage:message];
                    });
             }
//            [SVProgressHUD dismiss];
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
- (NSString *)capitalizeFirstLetterOnlyOfString:(NSString *)string
{
    NSMutableString *result = [string lowercaseString].mutableCopy;
    [result replaceCharactersInRange:NSMakeRange(0, 1) withString:[[result substringToIndex:1] capitalizedString]];
    
    return result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"product id:%@",product_id);
    
  
   
    
    productTitleLBL.text=[self capitalizeFirstLetterOnlyOfString:productTitle];
    errorImage.alpha=0;
    if ([productTitle isEqualToString:@"Shuffle"])
    {
        FromBrand=YES;
    }
    
    
   
    
    
//    sectionTitleArray=[NSMutableArray new];
    
//    attributes = [[NSMutableArray alloc] initWithObjects:@"H:S", @"H:W", @"H:AGR", @"H:TPC", @"H:P", @"H:TI", nil];
//    subattributes= [[NSMutableArray alloc] initWithObjects:@"asdgfasd", @"asdgfsd", @"gsdgsdgR", @"HsdgsdgPC", @"HsdgsdgP", @"HsdgsdgssdgTI", nil];
//    isMultipleExpansionAllowed = YES;
//
//    arrSelectedSectionIndex = [[NSMutableArray alloc] init];
//
//    if (!isMultipleExpansionAllowed)
//    {
//        [arrSelectedSectionIndex addObject:[NSNumber numberWithInt:(int)_detailsArray.count+2]];
//    }
    
    
    
   
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitleArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[arrayForBool objectAtIndex:section] boolValue])
    {
        return [[sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:section]] count];
    }
    return 0;
}
- (void) handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    NSInteger index = gestureRecognizer.view.tag;
    NSLog(@"%ld",(long)index);
    catergoriesClass *catergories_calss = nil;
    catergories_calss = [_detailsArray objectAtIndex:index];
    NSString *name=[NSString stringWithFormat:@"%@",catergories_calss.name];
    NSString *product_id=[NSString stringWithFormat:@"%@",catergories_calss.cater_id];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductVC *myVC = (ProductVC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductVC"];
    myVC.product_id=product_id;
    myVC.Page_Title=name;
    myVC.FromShuffel=YES;
    myVC.delegate=self;
    //    [self presentViewController:myVC animated:NO completion:nil];
    [self.navigationController pushViewController:myVC animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,60)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor whiteColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, self.view.frame.size.width-20-50, 60)];
    UILabel *bottomLbl           = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-1, headerView.frame.size.width, 1)];
    bottomLbl.backgroundColor=[UIColor grayColor];
    UIImageView *imageview  = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 40, 40)];
    catergoriesClass *catergories_calss = nil;
           catergories_calss = [_detailsArray objectAtIndex:section];
    [imageview sd_setShowActivityIndicatorView:YES];
    [imageview sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [imageview sd_setImageWithURL:[NSURL URLWithString:catergories_calss.image]
                  placeholderImage:[UIImage imageNamed:@"empty_menu"]
                           options:SDWebImageRefreshCached];
    [headerView addSubview:imageview];
    [headerView addSubview:bottomLbl];
    BOOL manyCells    = [[arrayForBool objectAtIndex:section] boolValue];
//    catergoriesClass *catergories_calss = nil;
//     catergories_calss = [sectionTitleArray objectAtIndex:section];
//    headerView.lbTitle.text = [NSString stringWithFormat:@"%@",catergories_calss.name];
    if (!manyCells)
    {
         headerString.text= [NSString stringWithFormat:@"%@",sectionTitleArray[section]];
//        headerString.text=[NSString stringWithFormat:@"%@",sectionTitleArray[section]];
//        headerString.text = [sectionTitleArray objectAtIndex:section];
    }
    else
    {
       headerString.text= [NSString stringWithFormat:@"%@",sectionTitleArray[section]];
//        headerString.text = [sectionTitleArray objectAtIndex:section];
    }
    headerString.textAlignment      = NSTextAlignmentLeft;
    headerString.textColor          = [UIColor blackColor];
    [headerView addSubview:headerString];
    if (FromBrand==YES)
    {
        UITapGestureRecognizer *tap;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [headerView addGestureRecognizer:tap];
    }
    else
    {
        if ([[sectionTitleArray objectAtIndex:section] isEqualToString:@"VIEW ALL"])
        {
            UITapGestureRecognizer  *headerTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
            [headerView addGestureRecognizer:headerTapped];
            UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"upArrowBlack"] : [UIImage imageNamed:@"NextArrowBlack"]];
            upDownArrow.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
            upDownArrow.frame = CGRectMake(self.view.frame.size.width-40, 10, 30, 30);
            [headerView addSubview:upDownArrow];
        }
        else
        {
            UITapGestureRecognizer  *headerTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
            [headerView addGestureRecognizer:headerTapped];
            UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"upArrowBlack"] : [UIImage imageNamed:@"downArrowBlack"]];
            upDownArrow.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
            upDownArrow.frame = CGRectMake(self.view.frame.size.width-40, 10, 30, 30);
            [headerView addSubview:upDownArrow];
        }
        
       
    }

    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 50;
    }
    
    return 0;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    if (!manyCells)
    {
        cell.textLabel.text = @"click to enlarge";
    }
    else
    {
        NSArray *content = [sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]];
        cell.textLabel.text = [content objectAtIndex:indexPath.row];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld",(long)indexPath.section);

    NSLog(@"%@",[sectionTitleArray objectAtIndex:indexPath.section]);
    NSLog(@"%@",[[sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]);

        NSString *name=[[sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
        NSString *product_id=[NSString stringWithFormat:@"%@",subattributes[indexPath.section][indexPath.row][@"id"]];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
        ProductVC *myVC = (ProductVC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductVC"];
        myVC.product_id=product_id;
        myVC.Page_Title=name;
        myVC.delegate=self;
    //    [self presentViewController:myVC animated:NO completion:nil];
        [self.navigationController pushViewController:myVC animated:YES];
}


#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0)
    {
        if ([[sectionTitleArray objectAtIndex:indexPath.section] isEqualToString:@"VIEW ALL"])
        {
            catergoriesClass *catergories_calss = nil;
            catergories_calss = [_detailsArray objectAtIndex:indexPath.section];
            NSString *name=[NSString stringWithFormat:@"%@",catergories_calss.name];
            NSString *product_id=[NSString stringWithFormat:@"%@",catergories_calss.cater_id];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ProductVC *myVC = (ProductVC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductVC"];
            myVC.product_id=product_id;
            myVC.Page_Title=name;
            myVC.delegate=self;
            //[self presentViewController:myVC animated:NO completion:nil];
            [self.navigationController pushViewController:myVC animated:YES];
        }
        else
        {
            BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
            collapsed       = !collapsed;
            [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
            
            //reload specific section animated
            NSRange range   = NSMakeRange(indexPath.section, 1);
            NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 55.0f;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return 44.0f;
//
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return _detailsArray.count;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//
//    //    NSInteger count;
//    //    count=[[NSString stringWithFormat:@"%d",(int)subattributes[section][]] integerValue];
//    if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]])
//    {
//         return subcount;
//    }
////    if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]])
////    {
////        //NSInteger count;
////        //count=[[NSString stringWithFormat:@"%d",(int)runtimeSubArry[section]] integerValue];
////        //return runtimeSubArry.count;
////
////        return subcount;
////    }
//    else
//    {
//        return 0;
//    }
//
//
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCell"];
//
//    if (cell ==nil)
//    {
//        [_tableView registerClass:[ViewControllerCell class] forCellReuseIdentifier:@"ViewControllerCell"];
//
//        cell = [_tableView dequeueReusableCellWithIdentifier:@"ViewControllerCell"];
//    }
//
////
//    NSArray *ary=[NSArray new];
//    ary=[[runtimeSubArry objectAtIndex:indexPath.section] mutableCopy];
//
//    NSDictionary *dic = [ary objectAtIndex:indexPath.row];
//    cell.lblName.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
////        calssobj.cater_id = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
////        if([[dic valueForKey:@"image"] isKindOfClass:[NSNull class]])
////        {
////
////        }
////        else
////        {
////            calssobj.image=[NSString stringWithFormat:@"%@",[dic valueForKey:@"image"]];
////
////        }
//
////    cell.lblName.text = [NSString stringWithFormat:@"%@",subattributes[indexPath.row]];
//
//    cell.backgroundColor = indexPath.row%2==0?[UIColor lightTextColor]:[[UIColor lightTextColor] colorWithAlphaComponent:0.5f];
//
//    return cell;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//    ViewControllerCellHeader *headerView = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCellHeader"];
//
//    if (headerView ==nil)
//    {
//        [_tableView registerClass:[ViewControllerCellHeader class] forCellReuseIdentifier:@"ViewControllerCellHeader"];
//        headerView = [tableView dequeueReusableCellWithIdentifier:@"ViewControllerCellHeader"];
//
//    }
//    catergoriesClass *catergories_calss = nil;
//       catergories_calss = [_detailsArray objectAtIndex:section];
//       [headerView.image sd_setShowActivityIndicatorView:YES];
//       [headerView.image sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
//       [headerView.image sd_setImageWithURL:[NSURL URLWithString:catergories_calss.image]
//                              placeholderImage:[UIImage imageNamed:@"empty_menu"]
//                                       options:SDWebImageRefreshCached];
//
//    headerView.lbTitle.text = [NSString stringWithFormat:@"%@",catergories_calss.name];
//
//    if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]])
//    {
//        headerView.btnShowHide.selected = YES;
//    }
//
//    [[headerView btnShowHide] setTag:section];
//
//    [[headerView btnShowHide] addTarget:self action:@selector(btnTapShowHideSection:) forControlEvents:UIControlEventTouchUpInside];
//
//    //[headerView.contentView setBackgroundColor:section%2==0?[UIColor groupTableViewBackgroundColor]:[[UIColor groupTableViewBackgroundColor] colorWithAlphaComponent:0.5f]];
//
//    return headerView.contentView;
//}

//-(IBAction)btnTapShowHideSection:(UIButton*)sender
//{
//     NSArray *array=[NSArray new];
//    if (!sender.selected)
//    {
//        if (!isMultipleExpansionAllowed)
//        {
//            [arrSelectedSectionIndex replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:sender.tag]];
//            [runtimeSubArry addObject:[subattributes[sender.tag] mutableCopy]];
//            array=[[runtimeSubArry objectAtIndex:sender.tag] mutableCopy];
//            subcount=array.count;
////             runtimeSubArry=[subattributes[sender.tag] mutableCopy];
//        }
//        else
//        {
//            [arrSelectedSectionIndex addObject:[NSNumber numberWithInteger:sender.tag]];
////            runtimeSubArry=[subattributes[sender.tag] mutableCopy];
//            [runtimeSubArry addObject:[subattributes[sender.tag] mutableCopy]];
//            array=[[runtimeSubArry objectAtIndex:sender.tag] mutableCopy];
//            subcount=array.count;
//        }
//        sender.selected = YES;
//    }
//    else
//    {
//        sender.selected = NO;
//        if ([arrSelectedSectionIndex containsObject:[NSNumber numberWithInteger:sender.tag]])
//        {
//            [arrSelectedSectionIndex removeObject:[NSNumber numberWithInteger:sender.tag]];
////            runtimeSubArry=[NSMutableArray new];
//            [runtimeSubArry removeObjectAtIndex:sender.tag];
//            subcount=0;
//        }
//    }
//
//    if (!isMultipleExpansionAllowed)
//    {
//        [_tableView reloadData];
//    }
//    else
//    {
////        [_tableView reloadData];
//        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
//
//    }
//}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    //    UILabel *typeLbl = (UILabel *)[self.view viewWithTag:100];
//    //    UIButton *buttonsample = (UIButton *)[self.view viewWithTag:101];
//    //   // buttonsample.tag = 102+indexPath.row;
//    //    [buttonsample addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    //    typeLbl.text = @"testddsj";
//
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//           CategoriesListCell *cell = (CategoriesListCell*)[_tableView dequeueReusableCellWithIdentifier:@"ListCell"];
//            catergoriesClass *catergories_calss = nil;
//            catergories_calss = [_detailsArray objectAtIndex:indexPath.row];
//            [cell.image sd_setShowActivityIndicatorView:YES];
//            [cell.image sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
//
//            [cell.image sd_setImageWithURL:[NSURL URLWithString:catergories_calss.image]
//                          placeholderImage:[UIImage imageNamed:@"empty_menu"]
//                                   options:SDWebImageRefreshCached];
//
//            double screenHeight = [[UIScreen mainScreen] bounds].size.height;
//            if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
//            {
//                if(screenHeight == 480)
//                {
//                    NSLog(@"iPhone 4/4S");
//                    // smallFonts = true;
//                }
//                else if (screenHeight == 568)
//                {
//                    cell.textLabel.font=LFONT_10;
//                }
//                else if (screenHeight == 667)
//                {
//                    NSLog(@"iPhone 6/6S");
//                }
//                else if (screenHeight == 736)
//                {
//                    NSLog(@"iPhone 6+, 6S+");
//                }
//                else
//                {
//                    NSLog(@"Others");
//                }
//            }
//            cell.lbl.text=[NSString stringWithFormat:@"%@",catergories_calss.name];
//
//            return cell;
//
//}
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
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    catergoriesClass *catergories_calss = nil;
//    catergories_calss = [_detailsArray objectAtIndex:indexPath.row];
//    NSLog(@"index:%ld",(long)indexPath.row);
//    NSString *name=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
//
//    if([name isEqualToString:@"3"])
//    {
//      name=@"ACCESSORIES";
//
//    }
//    else
//    {
//      name=[NSString stringWithFormat:@"%@",catergories_calss.name];
//    }
//
//    NSString *product_id=[NSString stringWithFormat:@"%@",catergories_calss.cater_id];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//    ProductVC *myVC = (ProductVC *)[storyboard instantiateViewControllerWithIdentifier:@"ProductVC"];
//    myVC.product_id=product_id;
//    myVC.Page_Title=name;
//    myVC.delegate=self;
////    [self presentViewController:myVC animated:NO completion:nil];
//    [self.navigationController pushViewController:myVC animated:YES];
//}

- (IBAction)backBtnClick:(id)sender
{
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)updateTotalcount:(NSString *)total_bag andSteez:(NSString *)total_steez
{
    [[NSUserDefaults standardUserDefaults]setObject:total_bag forKey:Total_Cart];
    [[NSUserDefaults standardUserDefaults]setObject:total_steez forKey:Total_Steez];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //        _badge_lbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Steez]];
        _cart_countLBL.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:Total_Cart]];
    });
    
}
- (IBAction)setting_act:(id)sender {
    
    UIStoryboard  *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HomeTabBar *paymentOrder = (HomeTabBar *)[storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
    paymentOrder.selectedIndex=3;
    [self.navigationController pushViewController:paymentOrder animated:YES];
    
}
- (IBAction)shopping_Act:(id)sender {
    
    ShoppingCartVC *myVC = (ShoppingCartVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ShoppingCartVC"];
    
    [self.navigationController pushViewController:myVC animated:YES];
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
