//
//  KTPreviewImageController.h
//  iCamera
//
//  Created by Quốc Khải on 2020/1/15.
//  Copyright © 2020 Quốc Khải. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KTPreviewImageController : UIViewController

@property(strong, nonatomic) UIImageView * captureView;
@property(strong, nonatomic) UIButton * closeButton;

@property(strong, nonatomic) UIImage * captureImage;

-(instancetype)initWithImage:(UIImage*)image;

@end

NS_ASSUME_NONNULL_END
