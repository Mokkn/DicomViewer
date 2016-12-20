//
//  MainViewController.m
//  DCM
//
//  Created by 本谷崇之 on 2016/09/22.
//  Copyright © 2016年 MototaniTakayuki. All rights reserved.
//

#import "MTDCMViewController.h"
#import "DicomPlayView.h"

@interface MTDCMViewController ()
@property (weak, nonatomic) IBOutlet DicomPlayView *dicomPlayView;


@end

@implementation MTDCMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * dicomPath = [[NSBundle mainBundle] pathForResource:@"test" ofType: @"dcm"];
    [self.dicomPlayView decodeAndDisplay:dicomPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
