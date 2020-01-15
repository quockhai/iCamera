//
//  ViewController.h
//  iCamera
//
//  Created by Quốc Khải on 2020/1/14.
//  Copyright © 2020 Quốc Khải. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "KTCamera.h"
#import "KTFilterCollectionCell.h"

@interface ViewController : UIViewController <KTCameraDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
 
@property(strong, nonatomic) UIImageView* imageView;

@property(strong, nonatomic) UICollectionView * filterCollectionView;
@property(strong, nonatomic) UIButton * captureButton;

@property(strong, nonatomic) KTCamera * camera;


@end

