//
//  DicomPlayView.m
//  DCM
//
//  Created by Mototani Takayuki on 2016/12/21.
//  Copyright © 2016年 MototaniTakayuki. All rights reserved.
//

#import "DicomPlayView.h"

@interface DicomPlayView()

@end

@implementation DicomPlayView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGesture];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupGesture];
    }
    return self;
}

- (void)setupGesture {
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:self.panGesture];
}

- (void)decodeAndDisplay:(NSString *)path {
    self.dicomDecoder = [[DicomDecoder alloc] init];
    [self.dicomDecoder setDicomFilename:path];
    if (self.currentWinCentre == 0 && self.currentWinWidth == 0) {
        [self displayWith:self.dicomDecoder.windowWidth windowCenter:self.dicomDecoder.windowCenter];
    } else {
        [self displayWith:self.currentWinWidth windowCenter:self.currentWinCentre];
    }
}

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender {
    UIGestureRecognizerState state = [sender state];
    
    if (state == UIGestureRecognizerStateBegan) {
        self.prevTransform = self.transform;
        self.startPoint = [sender locationInView:self];
    }
    else if (state == UIGestureRecognizerStateChanged || state == UIGestureRecognizerStateEnded) {
        
        CGPoint location    = [sender locationInView:self];
        CGFloat offsetX     = location.x - self.startPoint.x;
        CGFloat offsetY     = location.y - self.startPoint.y;
        self.startPoint     = location;
        
        //         adjust window width/level
        self.winWidth  += offsetX * self.changeValWidth;
        self.winCenter += offsetY * self.changeValCentre;
        if (self.winWidth <= 0) {
            self.winWidth = 1;
        }
        if (self.winCenter == 0) {
            self.winCenter = 1;
        }
        if (self.signed16Image) {
            self.winCenter += SHRT_MIN;
        }
        [self setWinWidth:self.winWidth];
        [self setWinCenter:self.winCenter];
        self.currentWinWidth = self.winWidth;
        self.currentWinCentre = self.winCenter;
        [self displayWith:self.winWidth windowCenter:self.winCenter];
    }
}

- (void) displayWith:(NSInteger)windowWidth windowCenter:(NSInteger)windowCenter {
    if (!self.dicomDecoder.dicomFound || !self.dicomDecoder.dicomFileReadSuccess) {
        self.dicomDecoder = nil;
        return;
    }
    
    NSInteger winWidth2        = windowWidth;
    NSInteger winCenter2       = windowCenter;
    NSInteger imageWidth      = self.dicomDecoder.width;
    NSInteger imageHeight     = self.dicomDecoder.height;
    NSInteger bitDepth        = self.dicomDecoder.bitDepth;
    NSInteger samplesPerPixel = self.dicomDecoder.samplesPerPixel;
    BOOL signedImage          = self.dicomDecoder.signedImage;
    
    BOOL needsDisplay = NO;
    
    if (samplesPerPixel == 1 && bitDepth == 8) {
        Byte * pixels8 = [self.dicomDecoder getPixels8];
        if (winWidth2 == 0 && winCenter2 == 0) {
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
            winWidth2 = (NSInteger)((max + min)/2.0 + 0.5);
            winCenter2 = (NSInteger)((max - min)/2.0 + 0.5);
        }
        
        [self setPixels8:pixels8
                   width:imageWidth
                  height:imageHeight
             windowWidth:winWidth2
            windowCenter:winCenter2
         samplesPerPixel:samplesPerPixel
             resetScroll:YES];
        needsDisplay = YES;
    }
    if (samplesPerPixel == 1 && bitDepth == 16) {
        ushort * pixels16 = [self.dicomDecoder getPixels16];
        if (winWidth2 == 0 || winCenter2 == 0) {
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
            winWidth2 = (NSInteger)((max + min)/2.0 + 0.5);
            winCenter2 = (NSInteger)((max - min)/2.0 + 0.5);
        }
        
        self.signed16Image = signedImage;
        
        [self setPixels16:pixels16
                    width:imageWidth
                   height:imageHeight
              windowWidth:winWidth2
             windowCenter:winCenter2
          samplesPerPixel:samplesPerPixel
              resetScroll:YES];
        
        needsDisplay = YES;
    }
    
    if (samplesPerPixel == 3 && bitDepth == 8) {
        Byte * pixels24 = [self.dicomDecoder getPixels24];
        if (winWidth2 == 0 || winCenter2 == 0) {
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
            winWidth2 = (max + min)/2 + 0.5;
            winCenter2 = (max - min)/2 + 0.5;
        }
        
        [self setPixels8:pixels24
                   width:imageWidth
                  height:imageHeight
             windowWidth:winWidth2
            windowCenter:winCenter2
         samplesPerPixel:samplesPerPixel
             resetScroll:YES];
        
        needsDisplay = YES;
    }
    
    if (needsDisplay) {
        [self setNeedsDisplay];
        NSString * info = [NSString stringWithFormat:@"WW/WL: %ld / %ld", (long)self.winWidth, (long)self.winCenter];
        NSLog(@"%@", info);
    }
}

@end
