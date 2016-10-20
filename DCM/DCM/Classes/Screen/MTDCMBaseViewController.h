//
//  MTDCMBaseViewController.h
//  DCM
//
//  Created by 本谷崇之 on 2016/10/20.
//  Copyright © 2016年 MototaniTakayuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dicom2DView.h"
#import "DicomDecoder.h"

@interface MTDCMBaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet Dicom2DView *dicom2dView;

@property (nonatomic) DicomDecoder *dicomDecoder;
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) CGAffineTransform prevTransform;
@property (nonatomic) CGPoint startPoint;

- (void)decodeAndDisplay:(NSString *)path;
- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender;
- (void) displayWith:(NSInteger)windowWidth windowCenter:(NSInteger)windowCenter;

@end
