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

@interface ViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate>
 
@property(strong, nonatomic) UIImageView* imageView;
@property(strong, nonatomic) UIButton * captureButton;

@property(strong, nonatomic) AVCaptureSession * session;

@property(strong, nonatomic) AVCaptureDevice * device;
@property(strong, nonatomic) AVCaptureDeviceInput * input;

@property(strong, nonatomic) AVCapturePhotoOutput * photoOutput;
@property(strong, nonatomic) AVCaptureVideoDataOutput * videoOutput;//AVCapturePhotoOutput
@property(nonatomic) AVCaptureFlashMode flashMode;

@property(strong, nonatomic) AVCaptureVideoPreviewLayer * previewLayer;


@end

