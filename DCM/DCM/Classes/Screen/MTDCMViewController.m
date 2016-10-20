//
//  MainViewController.m
//  DCM
//
//  Created by 本谷崇之 on 2016/09/22.
//  Copyright © 2016年 MototaniTakayuki. All rights reserved.
//

#import "MTDCMViewController.h"


@interface MTDCMViewController ()


@end

@implementation MTDCMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * dicomPath = [[NSBundle mainBundle] pathForResource:@"test" ofType: @"dcm"];
    [self decodeAndDisplay:dicomPath];
    
    NSString * info = [self.dicomDecoder infoFor:PATIENT_NAME];
    NSLog(@"Patient: %@", info);
    
    info = [self.dicomDecoder infoFor:MODALITY];
    NSLog(@"Modality: %@", info);
    
    info = [self.dicomDecoder infoFor:SLICE_NUMBER];
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

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender {
    [super handlePanGesture:sender];
}


@end
