//
//  CustomOverlayView.m
//  Koloda-ObjC
//
//  Created by Vong on 15/8/18.
//  Copyright (c) 2015年 Vong. All rights reserved.
//

#import "CustomOverlayView.h"

@interface CustomOverlayView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CustomOverlayView

- (void)setType:(OverlayType)type
{
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.cornerRadius=10.0f;
    _imageView.layer.shadowRadius  = 10.0f;
    _imageView.layer.shadowColor   = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    _imageView.layer.shadowOpacity = 0.3f;
    _imageView.layer.masksToBounds = YES;
    
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_imageView.bounds, shadowInsets)];
    _imageView.layer.shadowPath    = shadowPath.CGPath;
    
    switch (type)
    {
        case OverlayTypeLeft:

            self.imageView.image = [UIImage imageNamed:@"overly_skip1"];
            break;
        case OverlayTypeRight:
            self.imageView.image = [UIImage imageNamed:@"overly_yes1"];
            break;
        case OverlayTypeNone:
        default:
            self.imageView.image = nil;
            break;
    }
}

@end
