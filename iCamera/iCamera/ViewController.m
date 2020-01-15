//
//  ViewController.m
//  iCamera
//
//  Created by Quốc Khải on 2020/1/14.
//  Copyright © 2020 Quốc Khải. All rights reserved.
//

#import "ViewController.h"
#import "KTPreviewImageController.h"

#define kViewHeight 50.0
#define kSpaceView 10.0
#define kCornerRadius 5.0

#define kScreenWidth UIScreen.mainScreen.bounds.size.width
#define kScreenHeight UIScreen.mainScreen.bounds.size.height

@interface ViewController ()
{
    NSMutableArray * filters;
}
@end

@implementation ViewController

-(void)loadView {
    [super loadView];
        
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:imageView];
    
    UIButton* captureButton = [[UIButton alloc] initWithFrame:CGRectZero];
    captureButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:captureButton];
    
    CGFloat itemSize = kViewHeight * 1.5 - kSpaceView;
    
    UICollectionViewFlowLayout * collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.itemSize = CGSizeMake(itemSize, itemSize);
    collectionLayout.sectionInset = UIEdgeInsetsMake(kSpaceView * 0.5, kSpaceView, kSpaceView * 0.5, kSpaceView);
    collectionLayout.minimumInteritemSpacing = kSpaceView;
    collectionLayout.minimumLineSpacing = kSpaceView;
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView * filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionLayout];
    filterCollectionView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:filterCollectionView];
    
    [NSLayoutConstraint activateConstraints:@[
        [filterCollectionView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor],
        [filterCollectionView.heightAnchor constraintEqualToConstant:itemSize + kSpaceView],
        [filterCollectionView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor],
        [filterCollectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
       [imageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
       [imageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
       [imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
       [imageView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
       [captureButton.widthAnchor constraintEqualToConstant:kViewHeight * 1.2],
       [captureButton.heightAnchor constraintEqualToAnchor:captureButton.widthAnchor],
       [captureButton.bottomAnchor constraintEqualToAnchor:filterCollectionView.topAnchor constant:-kSpaceView],
       [captureButton.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor]
    ]];
    
    self.imageView = imageView;
    
    self.filterCollectionView = filterCollectionView;
    self.captureButton = captureButton;
}

-(void)configureSubViews {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.filterCollectionView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.25];
    self.filterCollectionView.dataSource = self;
    self.filterCollectionView.delegate = self;
    self.filterCollectionView.pagingEnabled = false;
    self.filterCollectionView.showsVerticalScrollIndicator = false;
    self.filterCollectionView.showsHorizontalScrollIndicator = false;
    [self.filterCollectionView registerClass:[KTFilterCollectionCell class] forCellWithReuseIdentifier:@"filterCell"];
    
    self.captureButton.backgroundColor = UIColor.whiteColor;
    self.captureButton.layer.cornerRadius = kViewHeight * 0.6;
    self.captureButton.layer.masksToBounds = true;
    [self.captureButton addTarget:self action:@selector(captureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSubViews];
    
    [self setupFilters];
    [self setupCamera];
}

-(void)setupCamera {
    self.camera = [KTCamera new];
    self.camera.delegate = self;
//    self.camera.filter = [CIFilter filterWithName:@"CIComicEffect"];
    self.camera.flashMode = AVCaptureFlashModeOff;
    [self.camera setupSessionWithCompletionHandler:^(NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"Setup camera error: %@", error.localizedDescription);
            return;
        }
        
        [self.camera startRunning];
    }];
}

-(void)captureButtonTapped:(UIButton*)buton {
    [self.camera capturePhoto];
}

#pragma mark - KTCameraDelegate
-(void)camera:(KTCamera *)camera didOutputSampleImage:(CIImage *)ciImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = [UIImage imageWithCIImage:ciImage];
    });
}

-(void)camera:(KTCamera *)camera didCaptureImage:(UIImage *)image {
    KTPreviewImageController * viewController = [[KTPreviewImageController alloc] initWithImage:image];
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - Filters
-(void)setupFilters {
    filters = [NSMutableArray new];
    
    CIFilter * filter01 = [CIFilter filterWithName:@"CIComicEffect"];
    [filters addObject:filter01];
    
    CIFilter * filter02 = [CIFilter filterWithName:@"CILineOverlay"];
    [filters addObject:filter02];
    
    CIFilter * filter03 = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
    [filters addObject:filter03];
    
    CIFilter * filter04 = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
    [filters addObject:filter04];
    
    CIFilter * filter05 = [CIFilter filterWithName:@"CISepiaTone"];
    [filters addObject:filter05];
    
    CIFilter * filter06 = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
    [filters addObject:filter06];
    
    CIFilter * filter07 = [CIFilter filterWithName:@"CIPhotoEffectFade"];
    [filters addObject:filter07];
    
    CIFilter * filter08 = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
    [filters addObject:filter08];
    
    CIFilter * filter09 = [CIFilter filterWithName:@"CIPhotoEffectMono"];
    [filters addObject:filter09];
    
    CIFilter * filter10 = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
    [filters addObject:filter10];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return filters.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = [UIImage imageNamed:@"filterImage"];
    
    if (indexPath.row > 0) {
        CIFilter * filter = [filters objectAtIndex:indexPath.row - 1];
        [filter setValue:[[CIImage alloc] initWithImage:image] forKey:kCIInputImageKey];
        
        image = [UIImage imageWithCIImage:filter.outputImage];
    }
    
    KTFilterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"filterCell" forIndexPath:indexPath];
    cell.imageView.image = image;

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.camera.filter = nil;
    } else {
        self.camera.filter = [filters objectAtIndex:indexPath.row - 1];
    }
}

- (UIImage*)filterImage:(CIImage*)inputImage withFilter:(CIFilter*)filter {
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    return [UIImage imageWithCIImage:filter.outputImage];
}
@end
