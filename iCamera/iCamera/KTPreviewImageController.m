//
//  KTPreviewImageController.m
//  iCamera
//
//  Created by Quốc Khải on 2020/1/15.
//  Copyright © 2020 Quốc Khải. All rights reserved.
//

#import "KTPreviewImageController.h"

#define kViewHeight 50.0
#define kSpaceView 10.0

@interface KTPreviewImageController ()

@end

@implementation KTPreviewImageController

-(instancetype)initWithImage:(UIImage*)image {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.captureImage = image;
    }
    
    return self;
}

-(void)loadView {
    [super loadView];
        
    UIImageView* captureView = [[UIImageView alloc] initWithFrame:CGRectZero];
    captureView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:captureView];
    
    UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    closeButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:closeButton];
    
    [NSLayoutConstraint activateConstraints:@[
       [captureView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
       [captureView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
       [captureView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
       [captureView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
       [closeButton.widthAnchor constraintEqualToConstant:kViewHeight * 1.2],
       [closeButton.heightAnchor constraintEqualToAnchor:closeButton.widthAnchor],
       [closeButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-kSpaceView],
       [closeButton.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor]
    ]];

    self.captureView = captureView;
    self.closeButton = closeButton;
}

-(void)configureSubViews {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.captureView.image = self.captureImage;
    
    self.closeButton.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.75];
    self.closeButton.layer.cornerRadius = kViewHeight * 0.6;
    self.closeButton.layer.masksToBounds = true;
    [self.closeButton setTitle:@"X" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
    [self.closeButton addTarget:self action:@selector(dismissViewController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSubViews];
}

-(void)dismissViewController:(UIButton*)button {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
