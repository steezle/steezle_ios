//
//  FilterBrandCell.m
//  Steezle
//
//  Created by Ryan Smith on 2018-01-22.
//  Copyright © 2018 WebMobi. All rights reserved.
//

#import "FilterBrandCell.h"

@implementation FilterBrandCell

- (void)awakeFromNib {
    [super awakeFromNib];
        self.accessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Brand_Sel"]];
    }else
    {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Brand_unsel"]];
    }
}


@end
