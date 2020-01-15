# iCamera
Live camera filter with CIFilter in Objective-C

## Install
Add `KTCamera.h` and `KTCamera.m` in your project.

## Usage
**Setup & Running camera session**

```objc
-(void)setupCamera {
    self.camera = [KTCamera new];
    self.camera.delegate = self;
    self.camera.flashMode = AVCaptureFlashModeOff;
    [self.camera setupSessionWithCompletionHandler:^(NSError * _Nonnull error) {
        if (error != nil) {
            NSLog(@"Setup camera error: %@", error.localizedDescription);
            return;
        }
        
        [self.camera startRunning];
    }];
}
```

**Add camera filter**

```objc
	self.camera.filter = [CIFilter filterWithName:@"CIComicEffect"];
```

**Capture photo**

```objc
	[self.camera capturePhoto];
```

**Delegate**

```objc
-(void)camera:(KTCamera *)camera didOutputSampleImage:(CIImage *)ciImage {
    dispatch_async(dispatch_get_main_queue(), ^{
        //Using ciImage for preview
    });
}

-(void)camera:(KTCamera *)camera didCaptureImage:(UIImage *)image {
	//Handle capture photo (filtered image)
}
```

