//
//  DicomPlayView.h
//  DCM
//
//  Created by Mototani Takayuki on 2016/12/21.
//  Copyright © 2016年 MototaniTakayuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dicom2DView.h"
#import "DicomDecoder.h"

@interface DicomPlayView : Dicom2DView

@property (nonatomic) DicomDecoder *dicomDecoder;
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) CGAffineTransform prevTransform;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) double currentWinWidth;
@property (nonatomic) double currentWinCentre;

- (void)decodeAndDisplay:(NSString *)path;
- (void) displayWith:(NSInteger)windowWidth windowCenter:(NSInteger)windowCenter;

@end
