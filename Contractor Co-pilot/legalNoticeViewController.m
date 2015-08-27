//
//  legalNoticeViewController.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/24/15.
//  Copyright (c) 2015 Jon Smith. All rights reserved.
//

#import "legalNoticeViewController.h"
#import "AppDelegate.h"

@interface legalNoticeViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation legalNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CAGradientLayer *viewLayer = [_appDelegate makeBackgroundLayerForView:self.view];
    [self.view.layer insertSublayer:viewLayer atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
