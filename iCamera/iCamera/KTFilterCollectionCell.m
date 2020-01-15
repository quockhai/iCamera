//
//  KTFilterCollectionCell.m
//  iCamera
//
//  Created by Quốc Khải on 2020/1/15.
//  Copyright © 2020 Quốc Khải. All rights reserved.
//

#import "KTFilterCollectionCell.h"

@implementation KTFilterCollectionCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.25];
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = true;

        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:self.imageView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.imageView.widthAnchor constraintEqualToAnchor: self.widthAnchor],
            [self.imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor],
            [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [self.imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor]
        ]];
    
        self.imageView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.25];
        self.imageView.image = [UIImage imageNamed:@"icon_selected"];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return self;
}

@end
