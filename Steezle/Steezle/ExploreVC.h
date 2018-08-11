//
//  ExploreVC.h
//  Steezle
//
//  Created by sanjay on 25/08/17.
//  Copyright © 2017 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    //NSArray *image_array, *label_array;
}

@property (strong, nonatomic) NSMutableArray *categorylistArray;
@property (strong, nonatomic) NSMutableArray *detailsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TOP_H;
@property (weak, nonatomic) IBOutlet UIImageView *errorImage;

@end
