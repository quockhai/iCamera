# iCamera
Live camera filter with CIFilter in Objective-C

<p align="center">
<img src="https://img.shields.io/badge/platform-iOS%2010%2B-blue.svg?style=flat" alt="Platform: iOS 10+"/>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-ObjC-orange" alt="Language: ObjC" /></a>
<img src="http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat" alt="License: MIT" /> <br><br>
</p>

<br>

## Installation

Add `KTCamera.h` and `KTCamera.m` in your project.

<br>

## Usage

<br>

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

<br>

**Add camera filter**

```objc
self.camera.filter = [CIFilter filterWithName:@"CIComicEffect"];
```

<br>

**Capture photo**

```objc
[self.camera capturePhoto];
```

<br>

**Delegate handle**

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

<br>

## Contributing

As the creators, and maintainers of this project, we're glad to invite contributors to help us stay up to date. 

- If you **found a bug**, open an [issue](https://github.com/quockhai/iCamera/issues).
- If you **have a feature request**, open an [issue](https://github.com/quockhai/iCamera/issues).
- If you **want to contribute**, submit a [pull request](https://github.com/quockhai/iCamera/pulls).

<br>

## License

**KTCamera** is available under the MIT license. See the [LICENSE](https://github.com/quockhai/iCamera/blob/master/LICENSE) file for more info.
