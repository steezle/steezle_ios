//
//  ProductDetail_VC.h
//  Steezle
//
//  Created by Ryan Smith on 2018-05-24.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductImageCell.h"
#import "SVProgressHUD.h"
#import "Utils.h"
#import "ProductClass.h"
#import "userdefaultArrayCall.h"
#import "Globals.h"
#import "Cart_class.h"
#import "ProductWishListVC.h"
#import "userdefaultArrayCall.h"
#import "CVSizeCell.h"
#import "CVColorCell.h"
#import "productDetailsClass.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
//#import "ImageZoomViewer.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import <CoreText/CTStringAttributes.h>
#import "HomeView.h"
#import "KTMImageBrowserViewController.h"
#import "ProductNameCell.h"
#import "LastAddToBagBtnCell.h"
#import "SSPopup.h"
#import "LoginVC.h"

@interface ProductDetail_VC : UIViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SSPopupDelegate>

- (IBAction)Back_Btm_click:(id)sender;

@property (weak , nonatomic)NSString *productId;
@property (strong, nonatomic) NSMutableArray *ProductlistArray;
@property (strong, nonatomic) NSMutableArray *variationDir;
@property (strong, nonatomic) NSMutableArray *detailsArrayapi;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) UICollectionView *collectionViewColor;


@property (strong, nonatomic) UIPageControl *pageControlForImages;

@property (nonatomic, assign) BOOL fromenowOrder;
@property (strong,nonatomic)ProductClass *product_Details;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIView *subAlertView;

@property (nonatomic, nonatomic) IBOutlet UIImage *MysteezBTN;

@property (nonatomic) BOOL isFromMySteeze;



@end
