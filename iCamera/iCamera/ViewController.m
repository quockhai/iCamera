//
//  ViewController.m
//  iCamera
//
//  Created by Quốc Khải on 2020/1/14.
//  Copyright © 2020 Quốc Khải. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGFloat viewHeight;
    CGFloat spaceView;
}
@end

@implementation ViewController

-(void)loadView {
    [super loadView];
    
    viewHeight = 50.0;
    spaceView = 10.0;
    
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:imageView];
    
    UIButton* captureButton = [[UIButton alloc] initWithFrame:CGRectZero];
    captureButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:captureButton];
    
    [NSLayoutConstraint activateConstraints:@[
       [imageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
       [imageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
       [imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
       [imageView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
       [captureButton.widthAnchor constraintEqualToConstant:viewHeight * 1.2],
       [captureButton.heightAnchor constraintEqualToAnchor:captureButton.widthAnchor],
       [captureButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-spaceView],
       [captureButton.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor]
    ]];
    
    self.imageView = imageView;
    
    self.captureButton = captureButton;
}

-(void)configureSubViews {
    self.captureButton.backgroundColor = UIColor.whiteColor;
    self.captureButton.layer.cornerRadius = viewHeight * 0.6;
    self.captureButton.layer.masksToBounds = true;
    [self.captureButton addTarget:self action:@selector(captureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.flashMode = AVCaptureFlashModeOff;
    
    [self configureSubViews];
    
    [self setupSession];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self displayPreview:self.view];
}

-(void)captureButtonTapped:(UIButton*)buton {
    [self toggleFlash];
    
//    AVCapturePhotoSettings * photoSetting = [AVCapturePhotoSettings new];
//    photoSetting.flashMode = self.flashMode;
//
//    [self.photoOutput capturePhotoWithSettings:photoSetting delegate:self];
}

-(void)setupSession {
    
    NSError * sessionError = nil;
    
    self.session = [[AVCaptureSession alloc] init];
    
    AVCaptureDeviceDiscoverySession * discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
    
    for (AVCaptureDevice * camera in discoverySession.devices) {
        if (camera.position == AVCaptureDevicePositionBack) {
            self.device = camera;
        }
    }
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&sessionError];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
//    AVCaptureVideoPreviewLayer * previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
//    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
//    [self.view.layer addSublayer:previewLayer];
    
    self.photoOutput = [[AVCapturePhotoOutput alloc] init];
    NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecTypeJPEG};
    AVCapturePhotoSettings * photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:outputSettings];
    [self.photoOutput setPreparedPhotoSettingsArray:@[photoSettings] completionHandler:nil];
    
    if ([self.session canAddOutput:self.photoOutput]) {
        [self.session addOutput:self.photoOutput];
    }
    
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.videoOutput setSampleBufferDelegate:self queue:dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL)];
    
    if ([self.session canAddOutput:self.videoOutput]) {
        [self.session addOutput:self.videoOutput];
    }
    
    if (sessionError != nil) {
        NSLog(@"Error: %@", sessionError.localizedDescription);
        return;
    }
    
    [self.session startRunning];
}

-(void)displayPreview:(UIView*)view {
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [view.layer insertSublayer:self.previewLayer atIndex:0];
    self.previewLayer.frame = view.frame;
}

-(void)toggleFlash {
//    if (self.flashMode == AVCaptureFlashModeOn) {
//        self.flashMode = AVCaptureFlashModeOff;
//    } else {
//        self.flashMode = AVCaptureFlashModeOn;
//    }
    
    if (self.device == nil) {
        return;
    }
    
    if (self.device.hasTorch == false) {
        return;
    }
    
    NSError * torchError;
    
    [self.device lockForConfiguration:&torchError];
    
    if (self.device.torchMode == AVCaptureTorchModeOn) {
        self.device.torchMode = AVCaptureTorchModeOff;
    } else {
        [self.device setTorchModeOnWithLevel:1.0 error:&torchError];
    }
    
    [self.device unlockForConfiguration];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

-(void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    NSLog(@"VIDEO BUFFER: %fs (%fs)", CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)), CMTimeGetSeconds(CMSampleBufferGetDuration(sampleBuffer)));
    
    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    CIFilter * filter = [CIFilter filterWithName:@"CIComicEffect"];
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CIImage * cameraImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    [filter setValue:cameraImage forKey:kCIInputImageKey];
    
    CIImage * filteredImage = [filter valueForKey:kCIOutputImageKey];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = [UIImage imageWithCIImage:filteredImage];
    });
}

-(void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    NSLog(@"DROP BUFFER: %fs (%fs)", CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)), CMTimeGetSeconds(CMSampleBufferGetDuration(sampleBuffer)));
}

#pragma mark - AVCapturePhotoCaptureDelegate
-(void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    CIFilter * filter = [CIFilter filterWithName:@"CIComicEffect"];

//    CIImage * cameraImage = [CIImage imageWithCVPixelBuffer:photo.CGImageRepresentation];
    
    NSData * imageData = photo.fileDataRepresentation;
    
    CIImage * ciImage = [CIImage imageWithData:imageData];
    
    [filter setValue:ciImage forKey:kCIInputImageKey];
    
    CIImage * filteredImage = [filter valueForKey:kCIOutputImageKey];
    
    UIImage * image = [UIImage imageWithCIImage:filteredImage];
    
    
    NSLog(@"Image: %@", image);
    dispatch_async(dispatch_get_main_queue(), ^{
            NSError * outputError = nil;
            
        //    [PHPhotoLibrary.sharedPhotoLibrary performChangesAndWait:^{
        //        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //    } error:&outputError];
            
        //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                     NSLog(@"Success");
                }
                else {
                    NSLog(@"write error : %@",error);
                }
            }];
            
            if (outputError!= nil) {
                NSLog(@"Capture error: %@", outputError.localizedDescription);
            }
    });
}

//-func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

@end
