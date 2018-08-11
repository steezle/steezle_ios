//
//  ProductDetail_VC.m
//  Steezle
//
//  Created by Ryan Smith on 2018-05-24.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import "ProductDetail_VC.h"
#import "UIImageView+WebCache.h"
#import "ProductNameCell.h"
#import "ProductDescCell.h"
#import "LastAddToBagBtnCell.h"
#import "SizeVariationCell.h"
#import "ColorVariationCell.h"
#import "OtherVariationsCell.h"
#import "SSPopup.h"
//b

@interface ProductDetail_VC ()<SSPopupDelegate>
{
    
    NSMutableArray *imageArray;
    NSMutableArray *Attributes_array;
    NSString *variation;
    NSMutableArray *image_array;
    BOOL redmore,WishList;
    NSString *description;
    NSMutableArray *glableArray;
    NSMutableArray *displaySizeArr;
    int count;
    BOOL NotDepandance;
    BOOL old,new;
    NSMutableArray *variation_Name_Array;
    NSMutableArray *variation_Type_Array;
    NSMutableDictionary *variation_Attributes_Dictionary;
    
    NSMutableArray *color_array,*lenses_array,*color_list_array;
    NSMutableArray *size_array;
    NSMutableArray *other_variations_array;
    NSMutableDictionary *selected_other_variations_dictionary;
    
    NSMutableArray *color_code_array;
    NSMutableArray *variation_id_array;
    NSInteger selectedIndex_size;
    NSInteger selectedIndex_color;
    NSString *basedOn,*Count_of_variation_Type;
    
    NSString *size;
    NSString *firstType;
    NSString *variationID;
    NSString *color;
    NSMutableArray *pa_color_array,*pa_size_array,*pa_size_value_array,*pa_color_code_array,*pa_color_title_array,*pa_leses;
    BOOL fromdidselect;
    NSMutableArray *images;
    NSInteger currentIndex;
    BOOL empty;
    NSString *selected_color;
    NSString *selected_lenses;
    
    
    NSMutableArray *tot_value;
    int i;
    NSString *product_name;
    NSString *product_price;
    NSString *brand_name;
    
    NSMutableArray *product_images_list;
    NSMutableArray *variations_Array;
    NSMutableArray *colorList;
    UILabel *labelValue;
    
    
}

@end

@implementation ProductDetail_VC
@synthesize productId,ProductlistArray,detailsArrayapi,fromenowOrder,collectionViewColor,product_Details;
@synthesize variationDir;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selected_color = @"";
    selected_lenses = @"";
    
    
    self.tableview.separatorColor = [UIColor clearColor];
    old = true;
    fromenowOrder = false;
    [self configurePageControl];
    [SVProgressHUD show];
    [self getCategories];
    self.tableview.estimatedRowHeight = 80;
    
    selected_other_variations_dictionary = [[NSMutableDictionary alloc] init];
    
    //    [_tableview registerNib:[UINib nibWithNibName:@"" bundle:nil] forCellReuseIdentifier:@""];
    
}

#pragma mark - Set Up UI


-(void) configurePageControl {
    // The total number of pages that are available is based on how many available colors we have.
    _pageControlForImages = [[UIPageControl alloc] init];
    _pageControlForImages.currentPage = 0;
    _pageControlForImages.tintColor = [UIColor blackColor];
    _pageControlForImages.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControlForImages.currentPageIndicatorTintColor = [UIColor blackColor];
}
#pragma mark - API Call

-(void)getCategories
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]stringForKey:USERID]];
        
        NSDictionary *params = @{@"user_id":user_id,@"product_id":productId};
        NSLog(@"Produce ID : %@",productId);
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,ProductSubDetails];
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
                                     [self.tableview reloadData];
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
                      ProductlistArray=[NSMutableArray new];
                      detailsArrayapi=[NSMutableArray new];
                      Attributes_array=[NSMutableArray new];
                      [ProductlistArray addObject:responseDictionary[@"data"]];
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          NSDictionary *dic = [ProductlistArray objectAtIndex:0];
                          ProductClass *product_calss=[[ProductClass alloc]init];
                          product_calss.imagesArray=[NSMutableArray new];
                          product_calss.imagesArray=[[dic valueForKey:@"images"] mutableCopy];
                          //NSLog(@"Name of images comes from server : %@",product_calss.imagesArray);
                          imageArray = product_calss.imagesArray;
                          
                          
                          variation=[NSString stringWithFormat:@"%@",[dic valueForKey:@"type"]];
                          
                          //adding images to use in images scroll view
                          product_images_list = [[NSMutableArray alloc] init];
                          //                          [product_images_list addObject:[dic valueForKey:@"main_image"]];
                          for(int j=0;j<product_calss.imagesArray.count;j++)
                          {
                              
                              [product_images_list addObject:[product_calss.imagesArray objectAtIndex:j]];
                          }
                          
                          self.pageControlForImages.numberOfPages = product_images_list.count;
                          [image_array addObject:[dic valueForKey:@"main_image"]];
                          for(int j=0;j<product_calss.imagesArray.count;j++)
                          {
                              
                              [image_array addObject:[product_calss.imagesArray objectAtIndex:j]];
                          }
                          product_calss.Description = [NSString stringWithFormat:@"%@", [dic valueForKey:@"description"]];
                          description = product_calss.Description;
                          product_calss.cater_id = [NSString stringWithFormat:@"%@", [dic valueForKey:@"id"]];
                          
                          product_calss.main_image=[NSString stringWithFormat: @"%@",[dic valueForKey:@"main_image"]];
                          
                          product_calss.price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"price"]];
                          product_price = product_calss.price;
                          
                          product_calss.regular_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"regular_price"]];
                          product_calss.sale_price = [NSString stringWithFormat:@"%@", [dic valueForKey:@"sale_price"]];
                          product_calss.title = [NSString stringWithFormat:@"%@", [dic valueForKey:@"title"]];
                          product_name = product_calss.title;
                          
                          product_calss.brandName = [NSString stringWithFormat:@"%@",[dic valueForKey:@"brands"]];
                          brand_name = product_calss.brandName;
                          [detailsArrayapi addObject:product_calss];
                          [self filldetailsForNowOrder];
                          
                          if([variation isEqualToString:@"variable"])
                          {
                              Attributes_array=[[ProductlistArray valueForKey:@"attributes"] mutableCopy];
                              NSLog(@"%@",Attributes_array);
                              
                              
                              NSMutableArray *variations_array_temp=[[Attributes_array valueForKey:@"variations"] mutableCopy];
                              
                              variations_Array = [[NSMutableArray alloc] initWithArray:variations_array_temp[0]];
                              //variations_Array =[[Attributes_array valueForKey:@"variations"] objectAtIndex:0];
                              basedOn=[NSString stringWithFormat:@"%lu",(unsigned long)[variations_Array count]];
                              
                              other_variations_array = [[NSMutableArray alloc] init];
                              
                              for(int i=0;i<variations_Array.count;i++)
                              {
                                  firstType=[NSString stringWithFormat:@"%@",[variations_Array objectAtIndex:0]];
                                    //#Check and modify other_variation_array as per requirement
                                NSString *variation_value = variations_Array[i][@"value"];

                                if([variation_value isEqualToString:@"pa_size"]){
                                  continue;
                                }

                                if([variation_value isEqualToString:@"pa_color"]){
                                continue;
                                }
//                                if([variation_value isEqualToString:@"pa_blue-light-filter-proection"]){
//                                  continue;
//                                }
//                                if([variation_value isEqualToString:@"pa_lenses"]){
//                                  continue;
//                                }
                                  [other_variations_array addObject:variations_Array[i]];
                              }
                              
                              variation_Attributes_Dictionary=[[Attributes_array valueForKey:@"variation_attributes"][0] mutableCopy];
                              NSLog(@"Variation Attributs %@", variation_Attributes_Dictionary);
                              
                        //For size
                        size_array = [variation_Attributes_Dictionary[@"pa_size"] mutableCopy];

                        color_array = [variation_Attributes_Dictionary[@"pa_color"] mutableCopy];
                        lenses_array = [variation_Attributes_Dictionary[@"pa_lenses"] mutableCopy];
                        color_list_array = [variation_Attributes_Dictionary[@"pa_blue-light-filter-proection"] mutableCopy];

                            
                          }
                          else
                          {
                              
                          }
                          [self.tableview reloadData];
                          
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


#pragma mark - Table View Data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        //Image scrollview
        return 400.0;
    }
    else if (indexPath.row == 1){
        //Price cell
        return 80;
    }
    else if (indexPath.row == 2){
        //Description
        return 80;
       // return UITableViewAutomaticDimension    ;
    }
    else if (indexPath.row == 3){
        //Size
        if (size_array.count == 0) {
            return 0;
        }
        return 80;
    }
    else if (indexPath.row == 4){
        //Color
        if (color_array.count == 0) {
            return 0;
        }
        return 80;
    }
    
    else if(indexPath.row == 5+(other_variations_array.count)){
        return 70;
    }else {
        //Other variations cell
        return 85;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6+(other_variations_array.count);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        ProductImageCell *cell = (ProductImageCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell_Prooduct_images"];
        
        //1. Adding page control
        
        CGRect pageControlFrame = _pageControlForImages.frame;
        pageControlFrame.origin.x = ([UIScreen mainScreen].bounds.size.width / 2.0) - (pageControlFrame.size.width/2.0);
        pageControlFrame.origin.y = 330.0;
        
        _pageControlForImages.frame = pageControlFrame;
        [cell.contentView addSubview:_pageControlForImages];
        
        //2. Adding images
        
        cell.ImagesScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * product_images_list.count, cell.ImagesScrollView.frame.size.height);
        
        cell.ImagesScrollView.delegate = self;
        
        for (int i=0; i <product_images_list.count; i++)
        {
            NSLog(@"here is the list %@",product_images_list);
            
            UIImageView *myimage = [[UIImageView alloc]initWithFrame:CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width,cell.ImagesScrollView.frame.size.height)];
            myimage.contentMode = UIViewContentModeScaleAspectFill;
            [myimage sd_setImageWithURL:[NSURL URLWithString:product_images_list[i]]
                       placeholderImage:[UIImage imageNamed:nil]];
            [cell.ImagesScrollView addSubview:myimage];
        }
        return cell;
        
    }
    else if (indexPath.row == 1)
    {
        
        ProductNameCell *cell = (ProductNameCell*)[tableView dequeueReusableCellWithIdentifier:@"Product_Name_cell"];
        
        cell.Price_Lbl.text = product_price;
        cell.Name_Lbl.text = product_name;
        cell.Sub_Name_Lbl.text = brand_name;
        
        return cell;
    }
    else if (indexPath.row == 2){
        
        
        NSLog(@"Description: %@",description);
        ProductDescCell *cell = (ProductDescCell*)[tableView dequeueReusableCellWithIdentifier:@"Produce_Description_cell"];
        
                if(fromenowOrder == true)
                {
                  if (![description isEqualToString:@""])
                        {
                            NSString *des=[@"" stringByAppendingString:[NSString stringWithFormat:@"%@",description]];
                            NSString *destrip = des;

                            cell.lblDesciption.text=destrip;

                        }
                }
        fromenowOrder = true;
        [self addReadMoreStringToUILabel:  cell.lblDesciption];

        return cell;
    }
    else if(indexPath.row == 3 )
    {
        SizeVariationCell *cell = (SizeVariationCell*)[tableView dequeueReusableCellWithIdentifier:@"SizeVariationCellID"];
        
        
        if ([cell.collectionviewSize.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
            UICollectionViewFlowLayout *flowlayout = (UICollectionViewFlowLayout *)cell.collectionviewSize.collectionViewLayout;
//            [flowlayout setEstimatedItemSize:CGSizeMake(200, 40)];
            flowlayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
        }

        
        cell.collectionviewSize.delegate = self;
        cell.collectionviewSize.dataSource = self;
        
        [cell.collectionviewSize reloadData];
        
        return cell;

    }
    else if (indexPath.row ==4)
    {
        ColorVariationCell *cell = (ColorVariationCell*)[tableView dequeueReusableCellWithIdentifier:@"colorcellid"];

        self.collectionViewColor = cell.collectionViewColor;

        cell.collectionViewColor.delegate = self;
        cell.collectionViewColor.dataSource = self;

        [cell.collectionViewColor reloadData];

        return cell;
    }
    
    else if(indexPath.row == 5+(other_variations_array.count))
    {
        LastAddToBagBtnCell *cell = (LastAddToBagBtnCell*)[tableView dequeueReusableCellWithIdentifier:@"LastAddToBagBtnCellId"];
        
        cell.wishBtn.tag = 0;
        cell.addBtn.tag = 1;
        
        
        [cell.wishBtn addTarget:self action:@selector(wishButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (self.isFromMySteeze) {
            [cell.wishBtn setImage:[UIImage imageNamed:@"s_big_sel_hear11black"] forState:UIControlStateNormal];
        }else {
            [cell.wishBtn setImage:[UIImage imageNamed:@"s_big_unsel_hear11"] forState:UIControlStateNormal];
        }
        [cell.addBtn addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];


        return cell;
    }else
    {
        OtherVariationsCell *cell = (OtherVariationsCell*)[tableView dequeueReusableCellWithIdentifier:@"othervariationscellId"];
        
        for(UIView *view in  cell.contentView.subviews){
            [view removeFromSuperview];
        }
        CGFloat elementsview_y = 0 ;
        NSDictionary *variation_dic = other_variations_array[indexPath.row-5];
        NSString *key = variation_dic[@"value"];
        NSArray *variation_attributes_values_array = variation_Attributes_Dictionary[key];
        NSLog(@"variation_attributes_values_array %@",variation_attributes_values_array);
        
        UIView *elementsView = [[UIView alloc] initWithFrame:CGRectMake(0, elementsview_y, UIScreen.mainScreen.bounds.size.width,85)];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(22, 10 , UIScreen.mainScreen.bounds.size.width - 40, 35)];
        
        labelTitle.text = variation_dic[@"title"];
        
        [elementsView addSubview:labelTitle];
        
        labelValue = [[UILabel alloc] initWithFrame:CGRectMake(22, 50 , UIScreen.mainScreen.bounds.size.width - 40, 35)];
        
        //To Change Dynamic
        labelValue.layer.borderColor = [UIColor blackColor].CGColor;
        labelValue.layer.borderWidth = 1.0;
        if ([variation_dic[@"value"] isEqualToString:@"pa_lenses"]) {
            if ([selected_lenses isEqualToString:@""]) {
                labelValue.text = variation_attributes_values_array[0][@"title"];
            }else{
                labelValue.text = selected_lenses;
            }

        }else if ([variation_dic[@"value"] isEqualToString:@"pa_blue-light-filter-proection"]){
            if ([selected_color isEqualToString:@""]) {
                labelValue.text = variation_attributes_values_array[0][@"title"];
            }else{
                labelValue.text = selected_color;
            }

        }else {
            
            if ([selected_other_variations_dictionary valueForKey:variation_dic[@"value"]] != nil) {
                labelValue.text = [selected_other_variations_dictionary valueForKey:variation_dic[@"value"]];
            }else {
                labelValue.text = variation_attributes_values_array[0][@"title"];
            }
            
        }

        
        UIButton *tableOpenBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [tableOpenBtn addTarget:self action:@selector(SelectFilters:) forControlEvents:UIControlEventTouchUpInside];
        tableOpenBtn.frame = CGRectMake(22, 50 , UIScreen.mainScreen.bounds.size.width - 40, 35);
        tableOpenBtn.reversesTitleShadowWhenHighlighted = TRUE;
        tableOpenBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [elementsView addSubview:tableOpenBtn];
        
        [elementsView addSubview:labelValue];
        
        [cell.contentView addSubview:elementsView];
        
        
        for(int i=0; i<other_variations_array.count; i++) {
            
            
            elementsview_y += 85;
            
            
        }
        return cell;
    }
    
}
#pragma mark - Dropdown

-(void)SelectFilters:(id)sender
{
    NSLog(@"good %@",color_array);
    NSLog(@"good %@",color_list_array);

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableview];
    NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:buttonPosition];
    NSDictionary *variation_dic = other_variations_array[indexPath.row-5];

    colorList=[[NSMutableArray alloc]init];

    if ([variation_dic[@"value"]  isEqual:  @"pa_lenses"])
    {
        for (int i=0; i < lenses_array.count; i++)
        {
            NSLog(@"lenses_list %@",lenses_array[i][@"title"]);
            [colorList addObject:lenses_array[i][@"title"]];
        }

    }
    else if([variation_dic[@"value"] isEqual: @"pa_blue-light-filter-proection"])
    {
        for (int i=0; i < color_list_array.count; i++)
        {
            NSLog(@"colorlist %@",color_list_array[i][@"title"]);
            [colorList addObject:color_list_array[i][@"title"]];
            
        }
        [self.tableview reloadData];

    }
    else //if([variation_dic[@"value"] isEqual: @"pa_prescription"])
    {
        for (int i=0; i < [variation_Attributes_Dictionary[variation_dic[@"value"]] count]; i++)
        {
            NSLog(@"colorlist %@",variation_Attributes_Dictionary[variation_dic[@"value"]][i][@"title"]);
            [colorList addObject:variation_Attributes_Dictionary[variation_dic[@"value"]][i][@"title"]];
            
        }
        [self.tableview reloadData];
        
    }
    /*else if([variation_dic[@"value"] isEqual: @"pa_custom-engraving"])
    {
        for (int i=0; i < [variation_Attributes_Dictionary[@"pa_custom-engraving"] count]; i++)
        {
            NSLog(@"colorlist %@",variation_Attributes_Dictionary[@"pa_custom-engraving"][i][@"title"]);
            [colorList addObject:variation_Attributes_Dictionary[@"pa_custom-engraving"][i][@"title"]];
            
        }
        [self.tableview reloadData];
        
    }*/

    SSPopup* selection=[[SSPopup alloc]init];
    selection.backgroundColor=[UIColor colorWithWhite:0.00 alpha:0.4];
    
    selection.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    selection.SSPopupDelegate=self;
    [self.view  addSubview:selection];
    
    [selection CreateTableview:colorList withSender:sender  withTitle:@"Please Select" setCompletionBlock:^(int tag){
        
        NSLog(@"Tag--->%d",tag);
        [lenses_array objectAtIndex:tag];
        NSLog(@"lattest value is: %@",[lenses_array objectAtIndex:tag]);
//        selected_lenses = [lenses_array objectAtIndex:tag][@"title"];
        NSLog(@" value : %@",selected_lenses);
        
        if ([variation_dic[@"value"]  isEqual:  @"pa_lenses"])
        {
            selected_lenses = [lenses_array objectAtIndex:tag][@"title"];
        }
        else if([variation_dic[@"value"] isEqual:  @"pa_blue-light-filter-proection"])
        {
            selected_color = [color_list_array objectAtIndex:tag][@"title"];
        }
        else{
            NSString *selected = variation_Attributes_Dictionary[variation_dic[@"value"]][tag][@"title"];
            NSLog(@"%@",selected);
            [selected_other_variations_dictionary setValue:selected forKey:variation_dic[@"value"]];
            
        }
        old = false;
        [self.tableview reloadData];
    }];
    
}

#pragma mark - Wish Button

-(void)wishButtonClicked:(UIButton*)sender
{
    if (sender.tag == 0)
    {
        // Your code here
        NSLog(@"Wish");
        BOOL skipUser=[[NSUserDefaults standardUserDefaults] boolForKey:SKIPUSER];
        if (!skipUser )
        {
            if (self.isFromMySteeze)
                [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Already added to steeze"];
            else
                [self addInwishlistProductApicallingMethod];
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
    else
    {
    }
}
-(void)addButtonClicked:(UIButton*)sender
{
    if (sender.tag == 1)
    {
        // Your code here
        NSLog(@"add");
        
        [self API_Call_For_Check_Variation];
        
    }
    else
    {
    }
}

#pragma mark - Scroll view delegate Function

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageSize = [UIScreen mainScreen].bounds.size.width;
    
    int currentPage = scrollView.contentOffset.x/pageSize ;
    
    self.pageControlForImages.currentPage = currentPage ;
}

#pragma mark - User Define Function
- (NSUInteger)fitString:(NSString *)string intoLabel:(UILabel *)label
{
    UIFont *font           = label.font;
    NSLineBreakMode mode   = label.lineBreakMode;
    
    CGFloat labelWidth     = label.frame.size.width;
    CGFloat labelHeight    = label.frame.size.height;
    CGSize  sizeConstraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
    
    
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    CGRect boundingRect = [attributedText boundingRectWithSize:sizeConstraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    {
        if (boundingRect.size.height > labelHeight)
        {
            NSUInteger index = 0;
            NSUInteger prev;
            NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            
            do
            {
                prev = index;
                if (mode == NSLineBreakByCharWrapping)
                    index++;
                else
                    index = [string rangeOfCharacterFromSet:characterSet options:0 range:NSMakeRange(index + 1, [string length] - index - 1)].location;
            }
            
            while (index != NSNotFound && index < [string length] && [[string substringToIndex:index] boundingRectWithSize:sizeConstraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height <= labelHeight);
            
            return prev;
        }
    }
    
    return [string length];
}
- (void)addReadMoreStringToUILabel:(UILabel*)label
{
    ProductDescCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *readMoreText = @" ...Read More \n\n\n";
    NSInteger lengthForString = label.text.length;

        if (lengthForString >= 100 && redmore==NO)
        {
            cell.lblDesciption.numberOfLines = 11;
            NSInteger lengthForVisibleString = [self fitString:label.text intoLabel:label];
            NSMutableString *mutableString = [[NSMutableString alloc] initWithString:label.text];
            NSString *trimmedString = [mutableString stringByReplacingCharactersInRange:NSMakeRange(lengthForVisibleString, (label.text.length - lengthForVisibleString)) withString:@""];
            NSInteger readMoreLength = readMoreText.length;
            NSString *trimmedForReadMore = [trimmedString stringByReplacingCharactersInRange:NSMakeRange((trimmedString.length - readMoreLength), readMoreLength) withString:@""];
            NSMutableAttributedString *answerAttributed = [[NSMutableAttributedString alloc] initWithString:trimmedForReadMore attributes:@{NSFontAttributeName : label.font}];
            
            NSMutableAttributedString *readMoreAttributed = [[NSMutableAttributedString alloc] initWithString:readMoreText attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName : [UIColor blackColor]}];
            
            [answerAttributed appendAttributedString:readMoreAttributed];
            label.attributedText = answerAttributed;
           
            
            UITapGestureRecognizer *readMoreGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readMoreDidClickedGesture)];
            readMoreGesture.numberOfTapsRequired = 1;
            [label addGestureRecognizer:readMoreGesture];
            
            label.userInteractionEnabled = YES;
        }
        else
        {
            cell.lblDesciption.numberOfLines = 11;

            
            UITapGestureRecognizer *readMoreGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readMoreDidClickedGesture)];
            readMoreGesture.numberOfTapsRequired = 1;
            [label addGestureRecognizer:readMoreGesture];
            
            label.userInteractionEnabled = YES;
            cell.lblDesciption.text=description;
        }
}
-(void)readMoreDidClickedGesture
{
    ProductDescCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.lblDesciption.numberOfLines = 0;
    [self showWarningAlertWithTitle:@"Steezle" andMessage:description];
    redmore=YES;
    [self addReadMoreStringToUILabel:cell.lblDesciption];
}

#pragma mark - Alert message
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

-(void)filldetailsForNowOrder
{
    image_array=[NSMutableArray new];
    ProductClass *pro_class = nil;
    pro_class = [detailsArrayapi objectAtIndex:0];
    
    [image_array addObject:pro_class.main_image];
    if(pro_class.imagesArray.count)
    {
        for(int j=0;j<pro_class.imagesArray.count;j++)
        {
            [image_array addObject:[pro_class.imagesArray objectAtIndex:j]];
            
            
        }
    }

    [SVProgressHUD dismiss];

}

- (void)imageIndexOnChange:(NSInteger)index
{
    
    currentIndex = index;
    [_image sd_setImageWithURL:[NSURL URLWithString:[image_array objectAtIndex:currentIndex]]];
    
    NSInteger height = _image.image.size.height;
    NSInteger width = _image.image.size.width;
    _image.contentMode=UIViewContentModeScaleAspectFit;
    
    if (width<=100 || height<=100 )
    {
        if (width!=0 || height!=0)
        {
            _image.contentMode=UIViewContentModeCenter;
        }
        
    }
    
}
- (IBAction)Back_Btm_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Collection Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==collectionViewColor)
    {
        if([firstType isEqualToString:@"pa_color"] && [basedOn isEqualToString:@"2"])
        {
            return color_array.count;
        }
        else if([firstType isEqualToString:@"pa_size"] && [basedOn isEqualToString:@"2"])
        {
            return color_array.count;
        }
        else
        {
            return color_array.count;
        }
        
    }
    else
    {
        if([firstType isEqualToString:@"pa_color"] && [basedOn isEqualToString:@"2"])
        {
            return size_array.count;
        }
        else if ([firstType isEqualToString:@"pa_size"] && [basedOn isEqualToString:@"2"])
        {
            return size_array.count;
        }
        else
        {
            return size_array.count;
        }
        
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == collectionViewColor)
    {
        CVColorCell *cell2 =[collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell" forIndexPath:indexPath];
        cell2.colorView.layer.borderWidth=2;
        cell2.colorView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        if([firstType isEqualToString:@"pa_color"] && [basedOn isEqualToString:@"2"])
        {
            NSDictionary *dic_color=[NSDictionary new];
            dic_color=[color_array objectAtIndex:indexPath.row][@"color_rgb"];
            
            if(selectedIndex_color==indexPath.row)
            {
                cell2.Colorimage.backgroundColor=[UIColor colorWithRed:[[dic_color valueForKey:@"r"]floatValue]/255.0 green:[[dic_color valueForKey:@"g"]floatValue]/255.0 blue:[[dic_color valueForKey:@"b"]floatValue]/255.0 alpha:1.0f];
                if ([[dic_color valueForKey:@"r"] isEqualToString:@"255"] && [[dic_color valueForKey:@"g"] isEqualToString:@"255"] && [[dic_color valueForKey:@"b"] isEqualToString:@"255"])
                {
                    cell2.subImage.image =[UIImage imageNamed:@"sect_right"];
                }
                else
                {
                    cell2.subImage.image =[UIImage imageNamed:@"select_right"];
                }
                
                cell2.colorView.layer.borderWidth=4;
                cell2.colorView.layer.borderColor=[UIColor blackColor].CGColor;
                
            }
            else
            {
                cell2.Colorimage.backgroundColor=[UIColor colorWithRed:[[dic_color valueForKey:@"r"]floatValue]/255.0 green:[[dic_color valueForKey:@"g"]floatValue]/255.0 blue:[[dic_color valueForKey:@"b"]floatValue]/255.0 alpha:1.0f];
                cell2.subImage.image =[UIImage imageNamed:@"unselect_right"];
                cell2.colorView.layer.borderWidth=2;
                cell2.colorView.layer.borderColor=[UIColor lightGrayColor].CGColor;
                
            }
        }
        else if([firstType isEqualToString:@"pa_size"] && [basedOn isEqualToString:@"2"])
        {
            
            if(selectedIndex_color==indexPath.row)
            {
                NSString *color=[NSString stringWithFormat:@"%@",[color_array objectAtIndex:indexPath.row][@"color_hex"]];
                
                cell2.Colorimage.backgroundColor=[self getUIColorObjectFromHexString:color alpha:1.0f];
                if ([color isEqualToString:@"#ffffff"])
                {
                    cell2.subImage.image =[UIImage imageNamed:@"sect_right"];
                }
                else
                {
                    cell2.subImage.image =[UIImage imageNamed:@"select_right"];
                }
                
                cell2.colorView.layer.borderWidth=4;
                cell2.colorView.layer.borderColor=[UIColor blackColor].CGColor;
            }
            else
            {
                
                NSString *color=[NSString stringWithFormat:@"%@",[color_array objectAtIndex:indexPath.row][@"color_hex"]];
                cell2.Colorimage.backgroundColor=[self getUIColorObjectFromHexString:color alpha:1.0f];
                cell2.subImage.image =[UIImage imageNamed:@"unselect_right"];
                cell2.colorView.layer.borderWidth=2;
                cell2.colorView.layer.borderColor=[UIColor lightGrayColor].CGColor;
                
            }
            
        }
        else
        {
            
            NSDictionary *dic_color=[NSDictionary new];
            dic_color=[color_array objectAtIndex:indexPath.row][@"color_rgb"];
            NSLog(@"%lu",(unsigned long)dic_color.count);
            
            if(selectedIndex_color==indexPath.row && dic_color.count!=0)
            {
                
                cell2.Colorimage.backgroundColor=[UIColor colorWithRed:[[dic_color valueForKey:@"r"]floatValue]/255.0 green:[[dic_color valueForKey:@"g"]floatValue]/255.0 blue:[[dic_color valueForKey:@"b"]floatValue]/255.0 alpha:1.0f];
                
                if ([[NSString stringWithFormat:@"%@",[dic_color valueForKey:@"r"]] isEqualToString:@"255"] && [[NSString stringWithFormat:@"%@",[dic_color valueForKey:@"g"]] isEqualToString:@"255"] && [[NSString stringWithFormat:@"%@",[dic_color valueForKey:@"b"]] isEqualToString:@"255"])
                {
                    cell2.subImage.image =[UIImage imageNamed:@"sect_right"];
                }
                else
                {
                    cell2.subImage.image =[UIImage imageNamed:@"select_right"];
                }
                
                cell2.colorView.layer.borderWidth=4;
                cell2.colorView.layer.borderColor=[UIColor blackColor].CGColor;
            }
            else
            {
                if( dic_color.count!=0)
                {
                    cell2.Colorimage.backgroundColor=[UIColor colorWithRed:[[dic_color valueForKey:@"r"]floatValue]/255.0 green:[[dic_color valueForKey:@"g"]floatValue]/255.0 blue:[[dic_color valueForKey:@"b"]floatValue]/255.0 alpha:1.0f];
                    cell2.subImage.image =[UIImage imageNamed:@"unselect_right"];
                    cell2.colorView.layer.borderWidth=2;
                    cell2.colorView.layer.borderColor=[UIColor lightGrayColor].CGColor;
                }
                
            }
            
            
        }
        return cell2;
        
    }
    else
    {
        
        static NSString *CellSize = @"SizeCell";
        CVSizeCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:CellSize forIndexPath:indexPath];
        cell1.sizeView.layer.borderWidth=2;
        cell1.sizeView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        if([firstType isEqualToString:@"pa_color"] && [basedOn isEqualToString:@"2"])
        {
            
            
            NSString *title=[NSString stringWithFormat:@"%@",[size_array objectAtIndex:indexPath.row]];
            
            cell1.SizeLbl.text=[title uppercaseString];
            
            cell1.SizeLbl.preferredMaxLayoutWidth = 200;
            
            if(selectedIndex_size==indexPath.row)
            {
                cell1.sizeView.layer.borderWidth=4;
                cell1.sizeView.layer.borderColor=[UIColor blackColor].CGColor;
                cell1.SizeLbl.textColor=[UIColor blackColor];
                
                //                 cell1.SizeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"select_size"]];
            }
            else
            {
                cell1.sizeView.layer.borderWidth=2;
                cell1.sizeView.layer.borderColor=[UIColor grayColor].CGColor;
                cell1.SizeLbl.textColor=[UIColor lightGrayColor];
                //                 cell1.SizeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"unselect_size"]];
            }
        }
        else if([firstType isEqualToString:@"pa_size"] && [basedOn isEqualToString:@"2"])
        {
            NSString *title=size_array[indexPath.row][@"display_title"];
            //[NSString stringWithFormat:@"%@",[pa_size_value_array objectAtIndex:indexPath.row]];
            cell1.SizeLbl.text=[title uppercaseString];
            
            
            if(selectedIndex_size==indexPath.row)
            {
                cell1.sizeView.layer.borderWidth=4;
                cell1.sizeView.layer.borderColor=[UIColor blackColor].CGColor;
                cell1.SizeLbl.textColor=[UIColor blackColor];
                //                cell1.SizeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"select_size"]];
            }
            else
            {
                cell1.sizeView.layer.borderWidth=2;
                cell1.sizeView.layer.borderColor=[UIColor grayColor].CGColor;
                cell1.SizeLbl.textColor=[UIColor lightGrayColor];
                //                cell1.SizeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"unselect_size"]];
            }
        }
        else
        {
            NSString *title=[NSString stringWithFormat:@"%@",[size_array objectAtIndex:indexPath.row][@"display_title"]];
            cell1.SizeLbl.text=[title uppercaseString];
            
            
            if(selectedIndex_size==indexPath.row)
            {
                
                cell1.sizeView.layer.borderWidth=4;
                cell1.sizeView.layer.borderColor=[UIColor blackColor].CGColor;
                cell1.SizeLbl.textColor=[UIColor blackColor];
                //                cell1.SizeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"select_size"]];
            }
            else
            {
                cell1.sizeView.layer.borderWidth=2;
                cell1.sizeView.layer.borderColor=[UIColor grayColor].CGColor;
                cell1.SizeLbl.textColor=[UIColor lightGrayColor];
                //                cell1.SizeLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"unselect_size"]];
            }
        }
        
        return cell1;
        
    }
    
}

#pragma mark - Collection Datasource

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    
        if(collectionView==collectionViewColor)
        {
            selectedIndex_color=(long)indexPath.row;
            [collectionView reloadData];
            
        }
        else
        {
            selectedIndex_size=(long)indexPath.row;
            [collectionView reloadData];
            fromdidselect=YES;
        }
}
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize mElementSize;
    if (collectionView != collectionViewColor) {

    }
    
    if (collectionView == collectionViewColor) {
        
    }else {
        NSString *title = @"";
        if([firstType isEqualToString:@"pa_color"] && [basedOn isEqualToString:@"2"]) {
            title=[NSString stringWithFormat:@"%@",[size_array objectAtIndex:indexPath.row]];
        }else if([firstType isEqualToString:@"pa_size"] && [basedOn isEqualToString:@"2"]) {
            title=size_array[indexPath.row][@"display_title"];
        }else {
            title=[NSString stringWithFormat:@"%@",[size_array objectAtIndex:indexPath.row][@"display_title"]];
        }
        
        
        
        CGFloat width = [self widthOfString:title withFont:[UIFont fontWithName:@"OpenSans" size:25.0]];
        if (width < 40) {
            width = 40;
        }
        
        mElementSize=CGSizeMake(width,40);
        return mElementSize;

    }

    
    mElementSize=CGSizeMake(40,40);
    return mElementSize;
    
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

-(float)calculateHeightForLbl:(NSString*)text width:(float)width{
    CGSize constraint = CGSizeMake(width,20000.0f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                            context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0;
}
// Layout: Set Edges
- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

#pragma mark - API Call For Variation Check

-(void)API_Call_For_Check_Variation
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        
        if([variation isEqualToString:@"variable"])
        {
            NSError *error = nil;
            NSData *jsonData2;

            NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
            NSLog(@"Produce ID : %@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]]);
            NSLog(@"Produce ID : %@",productId);

            NSLog(@"Selectd Size : %@",[size_array objectAtIndex:selectedIndex_size][@"title"]);
            NSLog(@"Selectd Color From List : %@",[color_list_array objectAtIndex:selectedIndex_color][@"title"]);
            NSLog(@"Selectd Color From Collecton : %@",[color_array objectAtIndex:selectedIndex_color][@"title"]);

            if (color_array == nil) {
                NSLog(@"This is Color_list :%@",color_list_array);
                NSLog(@"This is Color_list :%@",[color_list_array objectAtIndex:selectedIndex_color]);

            } else {
                NSLog(@"This is color_collection: %@",color_array);
                NSLog(@"This is color_collection :%@",[color_array objectAtIndex:selectedIndex_color]);
            }

            NSLog(@"Param to send %@ , %@ ,%@ ,%@, %@ ", user_id,productId, [size_array objectAtIndex:selectedIndex_size][@"title"],[color_list_array objectAtIndex:selectedIndex_color][@"title"],[color_array objectAtIndex:selectedIndex_color][@"title"]);

            NSMutableArray * arr = [[NSMutableArray alloc] init];

            if([variation isEqualToString:@"variable"]) {
                if([firstType isEqualToString:@"pa_color"] && [basedOn isEqualToString:@"1"])
                {
                    size=@"";
                }
                if ([firstType isEqualToString:@"pa_size"] && [basedOn isEqualToString:@"1"])
                {
                    color=@"";
                }
                NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];

                NSMutableDictionary *variations = [[NSMutableDictionary alloc] init];
                [variations setValue:[size_array objectAtIndex:selectedIndex_size][@"title"] forKey:@"pa_size"];
                [variations setValue:[color_array objectAtIndex:selectedIndex_color][@"title"] forKey:@"pa_color"];
                if (selected_other_variations_dictionary.count > 0) {
                    [selected_other_variations_dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        [variations setValue:obj forKey:key];
                    }];
                }
                NSError * err;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:variations options:0 error:&err];
                NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary *params = @{@"product_id":productId,@"user_id":user_id,@"variations":myString};

                NSLog(@"product_id :%@ user_id: %@ variations: %@",productId,user_id,variations);

                NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

                NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,CheckVariatons ];
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
                                                          //glableArray=[[responseDictionary valueForKey:@"data"] mutableCopy];

                                                          NSString *bagCount = @"";
                                                          NSString *totalSteez = @"";

                                                          if ([responseDictionary valueForKey:@"bag_count"] == nil || [[responseDictionary valueForKey:@"bag_count"] isEqual:[NSNull null]]) {
                                                              bagCount = @"1";
                                                          }else {
                                                              bagCount = [responseDictionary valueForKey:@"bag_count"];
                                                          }

                                                          if ([responseDictionary valueForKey:@"total_steez"] == nil || [[responseDictionary valueForKey:@"total_steez"] isEqual:[NSNull null]]) {
                                                              totalSteez = @"1";
                                                          }else {
                                                              totalSteez = [responseDictionary valueForKey:@"total_steez"];
                                                          }


                                                          [self updateTotalcount:bagCount andSteez:totalSteez];

                                                          if ([status isEqualToString:@"S"])
                                                          {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [SVProgressHUD dismiss];
                                                                  // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CARTFLAG];
                                                                  // [[NSUserDefaults standardUserDefaults] synchronize];

                                                                  NSLog(@"%@",status);
                                                                  self.alertView.hidden=NO;
                                                                  self.subAlertView.hidden=NO;

                                                                  //   [self dismissViewControllerAnimated:NO completion:nil];
                                                                  double delayInSeconds = 1;
                                                                  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                                                  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                                      self.alertView.hidden=YES;
                                                                      self.subAlertView.hidden=YES;
                                                                  });
                                                                  // code here
                                                                  
                                                                  [self callapiForAddProductIntoCart];
                                                                  
                                                              });
                                                              //                      }
                                                          }
                                                          //                  }
                                                          else if([status isEqualToString:@"F"])
                                                          {
                                                              [SVProgressHUD dismiss];
                                                              //Background Thread
                                                              dispatch_async(dispatch_get_main_queue(), ^(void){

                                                                  UIAlertController * alert = [UIAlertController
                                                                                               alertControllerWithTitle:@"Steezle"
                                                                                               message:message preferredStyle:UIAlertControllerStyleAlert];
                                                                  UIAlertAction* okButton = [UIAlertAction
                                                                                             actionWithTitle:@"OK"
                                                                                             style:UIAlertActionStyleDefault
                                                                                             handler:^(UIAlertAction * action)
                                                                                             {
                                                                                             }];
                                                                  [alert addAction:okButton];
                                                                  [self presentViewController:alert animated:YES completion:nil];
                                                                  //Run UI Updates
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
            
            [self callapiForAddProductIntoCart];
            
//            NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
//
//            NSDictionary *params = @{@"cart_products":productId,@"user_id":user_id};
//            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//            NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,AddCart ];
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//            NSData *requestData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
//            //TODO handle error
//            [request setHTTPMethod:@"POST"];
//            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//            [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
//            [request setHTTPBody: requestData];
//
//
//            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//                                              {
//                                                  if (error)
//                                                  {
//                                                      dispatch_async(dispatch_get_main_queue(), ^(void)
//                                                                     {
//                                                                         NSLog(@"response%@",error);
//                                                                         [SVProgressHUD dismiss];
//
//                                                                         [self showWarningAlertWithTitle:@"Steezle" andMessage:error.localizedDescription];
//                                                                     });
//                                                  }
//                                                  else
//                                                  {
//
//                                                      NSError *parseError = nil;
//                                                      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//                                                      NSLog(@"%@",responseDictionary);
//                                                      NSString *message = [responseDictionary valueForKey:@"message"];
//                                                      NSString *status=[responseDictionary valueForKey:@"status"];
//                                                      //glableArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
//                                                      [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
//
//                                                      if ([status isEqualToString:@"S"])
//                                                      {
//                                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                                              [SVProgressHUD dismiss];
//                                                              // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CARTFLAG];
//                                                              // [[NSUserDefaults standardUserDefaults] synchronize];
//
//                                                              NSLog(@"%@",status);
//                                                              self.alertView.hidden=NO;
//                                                              self.subAlertView.hidden=NO;
//
//                                                              //   [self dismissViewControllerAnimated:NO completion:nil];
//                                                              double delayInSeconds = 1;
//                                                              dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                                                              dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                                                                  self.alertView.hidden=YES;
//                                                                  self.subAlertView.hidden=YES;            [self.navigationController popViewControllerAnimated:TRUE];
//                                                              });
//                                                              // code here
//                                                          });
//
//                                                      }
//                                                      else if([status isEqualToString:@"F"])
//                                                      {
//                                                          [SVProgressHUD dismiss];
//                                                          //Background Thread
//                                                          dispatch_async(dispatch_get_main_queue(), ^(void){
//
//                                                              UIAlertController * alert = [UIAlertController
//                                                                                           alertControllerWithTitle:@"Steezle"
//                                                                                           message:message preferredStyle:UIAlertControllerStyleAlert];
//                                                              UIAlertAction* okButton = [UIAlertAction
//                                                                                         actionWithTitle:@"OK"
//                                                                                         style:UIAlertActionStyleDefault
//                                                                                         handler:^(UIAlertAction * action)
//                                                                                         {
//                                                                                         }];
//                                                              [alert addAction:okButton];
//                                                              [self presentViewController:alert animated:YES completion:nil];
//                                                              //Run UI Updates
//                                                          });
//                                                      }
//
//                                                      else
//                                                      {
//
//                                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                                              [SVProgressHUD dismiss];
//                                                              [self showWarningAlertWithTitle:@"Steezle" andMessage:@"Internal Server Error.Please try again later"];
//                                                          });
//                                                      }
//                                                  }
//                                              }];
//            [dataTask resume];
        }
        
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            
            [self showWarningAlertWithTitle:@"Warning" andMessage:@"No Internet Connection found..."];
        });
        
    }
}


#pragma mark - API Call Add

-(void)callapiForAddProductIntoCart
{
    
    if([Utils isNetworkAvailable] == YES)
    {
        
        [SVProgressHUD show];
        NSError *error = nil;
        NSData *jsonData2;
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
        
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        
        if([variation isEqualToString:@"variable"])
        {
            if([firstType isEqualToString:@"pa_color"] && [basedOn isEqualToString:@"1"])
            {
                size=@"";
            }
            if ([firstType isEqualToString:@"pa_size"] && [basedOn isEqualToString:@"1"])
            {
                color=@"";
            }
            
            if(variationID==nil)
            {
                [self gatedetailsTopassAPI:0];
                
            }
            NSDictionary *firstJsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 size, @"pa_size",
                                                 color, @"pa_color",
                                                 nil];
            NSDictionary *secondJsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  productId, @"product_id",
                                                  variationID, @"variation_id",
                                                  firstJsonDictionary, @"variations",
                                                  @"1", @"qty",
                                                  nil];
            [arr addObject:secondJsonDictionary];
            
            jsonData2 = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
        }
        else
        {
            NSDictionary *firstJsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 productId, @"product_id",
                                                 @"1", @"qty",
                                                 nil];
            
            [arr addObject:firstJsonDictionary];
            
            jsonData2 = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
        }
        
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        
        NSLog(@"jsonData as string:\n%@", jsonString);
        
        //NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
        
        NSDictionary *params = @{@"cart_products":jsonString,@"user_id":user_id};
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
                  //glableArray=[[responseDictionary valueForKey:@"data"] mutableCopy];
                  [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                  
                  if ([status isEqualToString:@"S"])
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [SVProgressHUD dismiss];
                          // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CARTFLAG];
                          // [[NSUserDefaults standardUserDefaults] synchronize];
                          
                          NSLog(@"%@",status);
                          self.alertView.hidden=NO;
                          self.subAlertView.hidden=NO;
                          
                          //   [self dismissViewControllerAnimated:NO completion:nil];
                          double delayInSeconds = 1;
                          dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                          dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                              self.alertView.hidden=YES;
                              self.subAlertView.hidden=YES;
                              
                              UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Steezle" message:@"Added to Bag" preferredStyle:UIAlertControllerStyleAlert];
                              
                              UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                  [self.navigationController popViewControllerAnimated:YES];
                              }];
                              
                              [controller addAction:action];
                              
                              [self.navigationController presentViewController:controller animated:YES completion:nil];
                              
                              
                          });
                          // code here
                      });
                      
                  }
                  else if([status isEqualToString:@"F"])
                  {
                      [SVProgressHUD dismiss];
                      //Background Thread
                      dispatch_async(dispatch_get_main_queue(), ^(void){
                          
                          UIAlertController * alert = [UIAlertController
                                                       alertControllerWithTitle:@"Steezle"
                                                       message:message preferredStyle:UIAlertControllerStyleAlert];
                          UIAlertAction* okButton = [UIAlertAction
                                                     actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                                                     {
                                                     }];
                          [alert addAction:okButton];
                          [self presentViewController:alert animated:YES completion:nil];
                          //Run UI Updates
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
-(void)gatedetailsTopassAPI:(NSInteger )index1
{
    if(NotDepandance)
    {
        
        variationID=[NSString stringWithFormat:@"%@",[variation_id_array objectAtIndex:0]];
    }
    else
    {
        variationID=[NSString stringWithFormat:@"%@",[variation_id_array objectAtIndex:index1]];
    }
    
    if([firstType isEqualToString:@"pa_color"] && [basedOn isEqualToString:@"2"])
    {
        color=[NSString stringWithFormat:@"%@",[pa_color_title_array objectAtIndex:index1]];
        NSLog(@"%@",color);
        //          size=[NSString stringWithFormat:@"%@",[pa_size_value_array objectAtIndex:index1]];
    }
    else if([firstType isEqualToString:@"pa_size"] && [basedOn isEqualToString:@"2"])
    {
        //color=[NSString stringWithFormat:@"%@",[pa_color_title_array objectAtIndex:index1]];
        
        color=[NSString stringWithFormat:@"%@",[color_array objectAtIndex:index1]];
    }
    else if([firstType isEqualToString:@"pa_size"] && [basedOn isEqualToString:@"1"])
    {
        size=[NSString stringWithFormat:@"%@",[displaySizeArr objectAtIndex:index1]];
    }
    else
    {
        color=[NSString stringWithFormat:@"%@",[color_code_array objectAtIndex:index1]];
    }
    NSLog(@"Color:%@",color);
    NSLog(@"Size:%@",size);
}
-(void)updateTotalcount:(NSString *)total_bag andSteez:(NSString *)total_steez
{
    [[NSUserDefaults standardUserDefaults]setObject:total_bag forKey:Total_Cart];
    [[NSUserDefaults standardUserDefaults]setObject:total_steez forKey:Total_Steez];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

-(void)addInwishlistProductApicallingMethod
{
    if([Utils isNetworkAvailable] ==YES)
    {
        [SVProgressHUD show];
        NSString *user_id=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
        NSDictionary *params = @{@"user_id":user_id,@"product_id":productId};
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSString *url=[[NSString alloc]initWithFormat:@"%@%@", BaseURL,AddFavorite ];
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
                      [self updateTotalcount:[responseDictionary valueForKey:@"bag_count"] andSteez:[responseDictionary valueForKey:@"total_steez"]];
                      
                      if ([status isEqualToString:@"S"])
                      {
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              [SVProgressHUD dismiss];
                              
                              UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Steezle" message:@"Added to Steeze" preferredStyle:UIAlertControllerStyleAlert];
                              
                              UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                  [self.navigationController popViewControllerAnimated:YES];
                              }];
                              
                              [controller addAction:action];
                              
                              [self.navigationController presentViewController:controller animated:YES completion:nil];
                              
                              
////                              [_MysteezBTN setImage:[UIImage imageNamed:@"s_big_sel_hear11black"] forState:UIControlStateNormal];
//                              self.MysteezBTN = [UIImage imageNamed:@"s_big_sel_hear11black"];
//                              self.alertView.hidden=NO;
//                              self.subAlertView.hidden=NO;
////                              self.alertLBL.text=@"Added to Steez";
//                              double delayInSeconds = 1;
//                              dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                              dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                                  self.alertView.hidden=YES;
//                                  self.subAlertView.hidden=YES;
//
//                              });
                              
                          });
                      }
                      else if([status isEqualToString:@"F"])
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
@end
