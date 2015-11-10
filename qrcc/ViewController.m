//
//  ViewController.m
//  qrcc
//
//  Created by Carter Chang on 11/10/15.
//  Copyright © 2015 Carter Chang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *videoDevice;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCamera];
}

- (IBAction)onTestGoWeb:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
}

-(void) setupCamera {
    //Setup camera
    NSArray * devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    NSError *error;
    self.session =[[AVCaptureSession alloc] init];
    NSLog(@"========!!!!!==!!!!!!!!!!!!!!!!========");
    
    for ( AVCaptureDevice * device in devices )
    {
        if ( AVCaptureDevicePositionFront == [ device position ] )
        {
            // We asked for the front camera and got the front camera, now keep a pointer to it:
            frontCamera = device;
        }
        else if ( AVCaptureDevicePositionBack == [ device position ] )
        {
            // We asked for the back camera and here it is:
            backCamera = device;
        }
    }
    
    self.videoDevice = backCamera;
    
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    previewLayer.session = self.session;
    previewLayer.frame = self.cameraView.bounds;
    [self.cameraView.layer addSublayer:previewLayer];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    
    //    NSDictionary *outputSettings = [NSDictionary dictionaryWithObject:
    //                                       [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [self.session addOutput:self.stillImageOutput];
    
    [self.session startRunning];
}

@end
