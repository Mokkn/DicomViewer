//
//  MainViewController.m
//  DCM
//
//  Created by 本谷崇之 on 2016/09/22.
//  Copyright © 2016年 MototaniTakayuki. All rights reserved.
//

#import "MainViewController.h"
#import "Dicom2DView.h"
#import "DicomDecoder.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet Dicom2DView *dicom2dView;
@property (nonatomic) DicomDecoder *dicomDecoder;
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) CGAffineTransform prevTransform;
@property (nonatomic) CGPoint startPoint;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * dicomPath = [[NSBundle mainBundle] pathForResource:@"test" ofType: @"dcm"];
    [self decodeAndDisplay:dicomPath];
    
    NSString * info = [self.dicomDecoder infoFor:PATIENT_NAME];
    NSLog(@"Patient: %@", info);
    
    info = [self.dicomDecoder infoFor:MODALITY];
    NSLog(@"Modality: %@", info);
    
    info = [self.dicomDecoder infoFor:SERIES_DATE];
    NSLog(@"%@", info);
    
    info = [NSString stringWithFormat:@"WW/WL: %ld / %ld", (long)self.dicom2dView.winWidth, (long)self.dicom2dView.winCenter];
    NSLog(@"%@", info);
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.maximumNumberOfTouches = 1;
    [self.dicom2dView addGestureRecognizer:self.panGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction) handlePanGesture:(UIPanGestureRecognizer *)sender {
    UIGestureRecognizerState state = [sender state];
    
    if (state == UIGestureRecognizerStateBegan) {
        self.prevTransform = self.dicom2dView.transform;
        self.startPoint = [sender locationInView:self.view];
    }
    else if (state == UIGestureRecognizerStateChanged || state == UIGestureRecognizerStateEnded) {
        
        CGPoint location    = [sender locationInView:self.view];
        CGFloat offsetX     = location.x - self.startPoint.x;
        CGFloat offsetY     = location.y - self.startPoint.y;
        self.startPoint          = location;
        
//         adjust window width/level
        
        self.dicom2dView.winWidth  += offsetX * self.dicom2dView.changeValWidth;
        self.dicom2dView.winCenter += offsetY * self.dicom2dView.changeValCentre;
        
        if (self.dicom2dView.winWidth <= 0) {
            self.dicom2dView.winWidth = 1;
        }
        
        if (self.dicom2dView.winCenter == 0) {
            self.dicom2dView.winCenter = 1;
        }
        
        if (self.dicom2dView.signed16Image) {
            self.dicom2dView.winCenter += SHRT_MIN;
        }
        
        [self.dicom2dView setWinWidth:self.dicom2dView.winWidth];
        [self.dicom2dView setWinCenter:self.dicom2dView.winCenter];
        //TODO: 現在のww, wlを保持して次の画像にも適応する
        [self displayWith:self.dicom2dView.winWidth windowCenter:self.dicom2dView.winCenter];
    }
}

- (void)decodeAndDisplay:(NSString *)path {
    self.dicomDecoder = [[DicomDecoder alloc] init];
    [self.dicomDecoder setDicomFilename:path];
    
    [self displayWith:self.dicomDecoder.windowWidth windowCenter:self.dicomDecoder.windowCenter];
}

- (void) displayWith:(NSInteger)windowWidth windowCenter:(NSInteger)windowCenter {
    if (!self.dicomDecoder.dicomFound || !self.dicomDecoder.dicomFileReadSuccess) {
        self.dicomDecoder = nil;
        return;
    }
    
    NSInteger winWidth        = windowWidth;
    NSInteger winCenter       = windowCenter;
    NSInteger imageWidth      = self.dicomDecoder.width;
    NSInteger imageHeight     = self.dicomDecoder.height;
    NSInteger bitDepth        = self.dicomDecoder.bitDepth;
    NSInteger samplesPerPixel = self.dicomDecoder.samplesPerPixel;
    BOOL signedImage          = self.dicomDecoder.signedImage;
    
    BOOL needsDisplay = NO;
    
    if (samplesPerPixel == 1 && bitDepth == 8) {
        Byte * pixels8 = [self.dicomDecoder getPixels8];
        if (winWidth == 0 && winCenter == 0) {
            Byte max = 0, min = 255;
            NSInteger num = imageWidth * imageHeight;
            for (NSInteger i = 0; i < num; i++) {
                if (pixels8[i] > max) {
                    max = pixels8[i];
                }
                if (pixels8[i] < min) {
                    min = pixels8[i];
                }
            }
            winWidth = (NSInteger)((max + min)/2.0 + 0.5);
            winCenter = (NSInteger)((max - min)/2.0 + 0.5);
        }
        
        [self.dicom2dView setPixels8:pixels8
                          width:imageWidth
                         height:imageHeight
                    windowWidth:winWidth
                   windowCenter:winCenter
                samplesPerPixel:samplesPerPixel
                    resetScroll:YES];
        needsDisplay = YES;
    }
    if (samplesPerPixel == 1 && bitDepth == 16) {
        ushort * pixels16 = [self.dicomDecoder getPixels16];
        if (winWidth == 0 || winCenter == 0) {
            ushort max = 0, min = 65535;
            NSInteger num = imageWidth * imageHeight;
            for (NSInteger i = 0; i < num; i++) {
                if (pixels16[i] > max) {
                    max = pixels16[i];
                }
                if (pixels16[i] < min) {
                    min = pixels16[i];
                }
            }
            winWidth = (NSInteger)((max + min)/2.0 + 0.5);
            winCenter = (NSInteger)((max - min)/2.0 + 0.5);
        }
        
        self.dicom2dView.signed16Image = signedImage;
        
        [self.dicom2dView setPixels16:pixels16
                           width:imageWidth
                          height:imageHeight
                     windowWidth:winWidth
                    windowCenter:winCenter
                 samplesPerPixel:samplesPerPixel
                     resetScroll:YES];
        
        needsDisplay = YES;
    }
    
    if (samplesPerPixel == 3 && bitDepth == 8) {
        Byte * pixels24 = [self.dicomDecoder getPixels24];
        if (winWidth == 0 || winCenter == 0) {
            Byte max = 0, min = 255;
            NSInteger num = imageWidth * imageHeight * 3;
            for (NSInteger i = 0; i < num; i++) {
                if (pixels24[i] > max) {
                    max = pixels24[i];
                }
                if (pixels24[i] < min) {
                    min = pixels24[i];
                }
            }
            winWidth = (max + min)/2 + 0.5;
            winCenter = (max - min)/2 + 0.5;
        }
        
        [self.dicom2dView setPixels8:pixels24
                          width:imageWidth
                         height:imageHeight
                    windowWidth:winWidth
                   windowCenter:winCenter
                samplesPerPixel:samplesPerPixel
                    resetScroll:YES];
        
        needsDisplay = YES;
    }
    
    if (needsDisplay) {
        CGFloat x = (self.view.frame.size.width - imageWidth) /2;
        CGFloat y = (self.view.frame.size.height - imageHeight) /2;
        self.dicom2dView.frame = CGRectMake(x, y, imageWidth, imageHeight);
        [self.dicom2dView setNeedsDisplay];
        
        NSString * info = [NSString stringWithFormat:@"WW/WL: %ld / %ld", (long)self.dicom2dView.winWidth, (long)self.dicom2dView.winCenter];
        NSLog(@"%@", info);
    }
}
@end
