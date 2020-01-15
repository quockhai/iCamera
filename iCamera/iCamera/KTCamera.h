//
//  KTCamera.h
//  iCamera
//
//  Created by Quốc Khải on 2020/1/15.
//  Copyright © 2020 Quốc Khải. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@class KTCamera;
@protocol KTCameraDelegate <NSObject>

-(void)camera:(KTCamera*)camera didOutputSampleImage:(CIImage*)ciImage;
-(void)camera:(KTCamera*)camera didCaptureImage:(UIImage*)image;

@end

@interface KTCamera : NSObject <AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property(strong, nonatomic) CIFilter * _Nullable filter;

@property(strong, nonatomic) AVCaptureSession * session;

@property(strong, nonatomic) AVCaptureDevice * device;
@property(strong, nonatomic) AVCaptureDeviceInput * input;

@property(strong, nonatomic) AVCapturePhotoOutput * photoOutput;
@property(strong, nonatomic) AVCaptureVideoDataOutput * videoOutput;
@property(strong, nonatomic) AVCaptureFileOutput * fileOutput;

@property(nonatomic) AVCaptureFlashMode flashMode;
@property(strong, nonatomic) AVCaptureVideoPreviewLayer * previewLayer;

@property(weak, nonatomic) id<KTCameraDelegate> delegate;


-(void)setupSessionWithCompletionHandler:(void (^)(NSError* error))completionHandle;

-(void)startRunning;
-(void)stopRunning;

-(void)capturePhoto;

@end

NS_ASSUME_NONNULL_END
