//
//  FiltersVC.h
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeView.h"
#import "LoginVC.h"

@interface FiltersVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) NSMutableArray *categorylistArray;
@property (strong, nonatomic) NSMutableArray *detailsArray;
@property (weak, nonatomic) IBOutlet UIButton *searchBTN;

- (IBAction)ActionSearchBTN:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *searchLbl;
- (IBAction)ActCardShopping:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *IteamCardLBL;
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *child_top_h;

@property (weak, nonatomic) IBOutlet UIImageView *errorImage;



@end
