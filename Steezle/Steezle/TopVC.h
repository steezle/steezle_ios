//
//  TopVC.h
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterCollectionCell.h"

@interface TopVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
//    <UICollectionViewDelegate,UICollectionViewDataSource>
//    NSArray *image_array, *label_array;
}
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *categorylistArray;
@property (weak, nonatomic) IBOutlet UITableView *tableveiw;
@property (weak, nonatomic) IBOutlet UIView *AlertView;
@property (weak, nonatomic) IBOutlet UIView *SubAlertView;
- (IBAction)ActionShoppingBag:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ShoppingBagBTN;
@property (weak, nonatomic) IBOutlet UILabel *CartCountLBL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TOP_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_h;
@property (weak, nonatomic) IBOutlet UIImageView *errorImage;


@end
