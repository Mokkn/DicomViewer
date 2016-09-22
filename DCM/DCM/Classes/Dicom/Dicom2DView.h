//
//  Dicom2DView.h
//  DCM
//
//  Created by 本谷崇之 on 2016/09/22.
//  Copyright © 2016年 MototaniTakayuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prefix.h"

@interface Dicom2DView : UIView {
    NSInteger hOffset;
    NSInteger vOffset;
    NSInteger hMax;
    NSInteger vMax;
    NSInteger imgWidth;
    NSInteger imgHeight;
    NSInteger panWidth;
    NSInteger panHeight;
    BOOL newImage;
    
    // For Window Level
    //
    NSInteger winMin;
    NSInteger winMax;
    NSInteger winCenter;
    NSInteger winWidth;
    NSInteger winShr1;
    NSInteger deltaX;
    NSInteger deltaY;
    
    double changeValWidth;
    double changeValCentre;
    BOOL signed16Image;
    BOOL imageAvailable;
    
    Byte * pix8;
    ushort * pix16;
    Byte * pix24;
    
    Byte * lut8;
    Byte * lut16;
    
    CGColorSpaceRef colorspace;
    CGContextRef bitmapContext;
    CGImageRef bitmapImage;
}

@property (nonatomic) BOOL signed16Image;
@property (nonatomic) NSInteger winCenter;
@property (nonatomic) NSInteger winWidth;
@property (nonatomic) double changeValWidth;
@property (nonatomic) double changeValCentre;

- (void)setPixels8:(Byte *)pixel
             width:(NSInteger)width
            height:(NSInteger)height
       windowWidth:(double)winW
      windowCenter:(double)winC
   samplesPerPixel:(NSInteger)spp
       resetScroll:(BOOL)reset;

- (void)setPixels16:(ushort *)pixel
              width:(NSInteger)width
             height:(NSInteger)height
        windowWidth:(double)winW
       windowCenter:(double)winC
    samplesPerPixel:(NSInteger)spp
        resetScroll:(BOOL)reset;

- (UIImage *)dicomImage;

@end
