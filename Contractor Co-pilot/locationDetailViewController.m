//
//  locationDetailViewController.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Jon Smith. All rights reserved.
//

#import "locationDetailViewController.h"
#import "Vendor.h"
#import "AppDelegate.h"
#import "Location.h"

@interface locationDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextView *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) NSString *phoneNumber;

@end

@implementation locationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _phoneNumber = @"Phone not implemented!";
    
    self.navigationItem.title = _passedVendor.vendorName;
    _nameLabel.text = [NSString stringWithFormat:@"Name: %@", _passedVendor.vendorName];
    _addressLabel.text = [NSString stringWithFormat:@"Address: %@", _passedVendor.vendorAddress];
    _phoneLabel.text = [NSString stringWithFormat:@"%@", _phoneNumber];
    
    CAGradientLayer *viewLayer = [CAGradientLayer layer];
    viewLayer.frame = self.view.bounds;
    viewLayer.colors = [NSArray arrayWithObjects:
                        (id)[[UIColor darkGrayColor] CGColor],
                        (id)[[UIColor darkTextColor] CGColor],
                        nil];
    [self.view.layer insertSublayer:viewLayer atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
