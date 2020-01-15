//
//  KTCamera.m
//  iCamera
//
//  Created by Quốc Khải on 2020/1/15.
//  Copyright © 2020 Quốc Khải. All rights reserved.
//

#import "KTCamera.h"

@implementation KTCamera

-(instancetype)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

-(void)capturePhoto {
    if (self.session != nil && self.photoOutput != nil) {
        AVCapturePhotoSettings * photoSetting = [AVCapturePhotoSettings new];
        photoSetting.flashMode = self.flashMode;
        
        [self.photoOutput capturePhotoWithSettings:photoSetting delegate:self];
    }
}

-(void)startRunning {
    if (self.session != nil) {
        [self.session startRunning];
    }
}

-(void)stopRunning {
    if (self.session != nil) {
        [self.session stopRunning];
    }
}

-(void)setupSessionWithCompletionHandler:(void (^)(NSError* error))completionHandle {
    
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
        completionHandle(sessionError);
        return;
    }
    
    completionHandle(nil);
}

-(void)toggleFlash {    
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

-(void)displayPreview:(UIView*)view {
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [view.layer insertSublayer:self.previewLayer atIndex:0];
    self.previewLayer.frame = view.frame;
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

-(void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    NSLog(@"VIDEO BUFFER: %fs (%fs)", CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)), CMTimeGetSeconds(CMSampleBufferGetDuration(sampleBuffer)));
    
    connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CIImage * cameraImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    if (self.filter != nil) {
        [self.filter setValue:cameraImage forKey:kCIInputImageKey];
        
        CIImage * filteredImage = [self.filter valueForKey:kCIOutputImageKey];
        
        [self.delegate camera:self didOutputSampleImage:filteredImage];
    } else {
        [self.delegate camera:self didOutputSampleImage:cameraImage];
    }
}

-(void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    NSLog(@"DROP BUFFER: %fs (%fs)", CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)), CMTimeGetSeconds(CMSampleBufferGetDuration(sampleBuffer)));
}

#pragma mark - AVCapturePhotoCaptureDelegate
-(void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    NSData * imageData = photo.fileDataRepresentation;
    CIImage * captureImage = [CIImage imageWithData:imageData];
    
//    CGImageRef cgImage = photo.CGImageRepresentation;
//    CIImage * captureImage = [CIImage imageWithCGImage:cgImage];
    
    captureImage = [captureImage imageByApplyingCGOrientation:kCGImagePropertyOrientationRight];

    if (self.filter != nil) {
        [self.filter setValue:captureImage forKey:kCIInputImageKey];
        
        CIImage * filteredImage = [self.filter valueForKey:kCIOutputImageKey];
        
        UIImage * image = [UIImage imageWithCIImage:filteredImage];
        [self.delegate camera:self didCaptureImage:image];
    } else {
        UIImage * image = [UIImage imageWithCIImage:captureImage];
        [self.delegate camera:self didCaptureImage:image];
    }
}

@end
