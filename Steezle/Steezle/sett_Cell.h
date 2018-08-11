//
//  sett_Cell.h
//  Steezle
//
//  Created by Ryan Smith on 2018-02-02.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sett_Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@end
