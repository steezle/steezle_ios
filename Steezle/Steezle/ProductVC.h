//
//  ProductVC.h
//  Steezle
//
//  Created by Aecor Digital on 01/09/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DraggableView.h"
#import "SwipeView.h"
#import "CustomOverlayView.h"

@interface ProductVC : UIViewController

//@property (weak, nonatomic) IBOutlet UIView *swipeView;

//methods called in DraggableView

//-(void)cardSwipedLeft:(UIView *)card;
//-(void)cardSwipedRight:(UIView *)card;

- (IBAction)ActionSearchBTN:(id)sender;
@property (weak, nonatomic) IBOutlet SwipeView *swipeView;

@property (assign, nonatomic) NSInteger count;

@property (weak, nonatomic) IBOutlet UILabel *productCompletedLbl;
//@property (weak, nonatomic) IBOutlet UIImageView *bottomProductImage;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLblValue;

//@property (retain,nonatomic)NSArray* exampleCardLabels; //%%% the labels the cards
//@property (retain,nonatomic)NSMutableArray* allCards;
//@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (IBAction)categoryBtnClick:(id)sender;
- (IBAction)profileBtnClick:(id)sender;
- (IBAction)cardBtnClick:(id)sender;
- (IBAction)refreshBtnClick:(id)sender;
//- (IBAction)orderNowBtnClic:(id)sender;
//- (IBAction)filterBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *LblPriceValue;

@property (weak, nonatomic) IBOutlet UILabel *lbl_product_title;
@property (weak,nonatomic)NSString *product_id;

@property(nonatomic,assign)id delegate;
@property (strong,nonatomic)NSString *Page_Title;

@property (strong, nonatomic) NSMutableArray *ProductlistArray;

//@property (weak, nonatomic) IBOutlet UIButton *cartBTN;

- (IBAction)shareBTNAcition:(id)sender;
@property (strong, nonatomic) NSMutableArray *detailsArray;
//- (IBAction)heartAction:(id)sender;
@property (weak,nonatomic) NSString *product_title;
@property (weak,nonatomic) NSString *product_image_url;
@property (weak,nonatomic) NSString *product_Description;
@property (weak, nonatomic) IBOutlet UILabel *badge_lbl;

@property (weak, nonatomic) IBOutlet UIButton *shareBTN;

@property (weak,nonatomic)NSString *productID;
//@property (weak,nonatomic)NSString *count;
@property (weak,nonatomic)NSString *WishProduct_id;
@property (nonatomic, assign) BOOL FromSearchApi;
@property (nonatomic, assign) BOOL FromFilterApi;
@property (nonatomic, assign) BOOL FromShuffel;
- (IBAction)ActCross:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *CrossBTN;
- (IBAction)ActHeart:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hearBTN;
- (IBAction)ActRIght:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *RightBTN;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
- (IBAction)Actback:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *HeaderLBL;
@property (weak, nonatomic) IBOutlet UIButton *refreshBTN;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Ref_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Ref_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Swip_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Prod_det_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom_h;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *child_view_top;

- (IBAction)filter_Act:(id)sender;
- (IBAction)ActionShoppingBag:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *shoppingCountLbl;
- (IBAction)SettingAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *errorImage;

@end

