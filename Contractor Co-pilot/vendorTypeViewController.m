//
//  vendorTypeViewController.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/18/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import "vendorTypeViewController.h"
#import "locationListTableViewController.h"
#import "Vendor.h"
#import "AppDelegate.h"

@interface vendorTypeViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *confirmSelectionButton;
@property (strong, nonatomic) NSArray *pickerData;
@property (strong, nonatomic) NSString *vendorType;
@property (strong, nonatomic) NSString *passedVendorType;
@property (strong, nonatomic) NSString *ypSearchString;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation vendorTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize Data
}
- (void)viewWillAppear:(BOOL)animated
{
    _pickerData = @[@"Property Rental", @"Electric Utilities", @"Water Utilities", @"Garbage Utilities", @"Gas Utilities", @"Mailing Center", @"Transportation", @"Restaraunts", @"Entertainment", @"Fuel", @"Grocers", @"Discount Stores", @"Custom Search"];
    
    
    // Connect data
    self.vendorPicker.dataSource = self;
    self.vendorPicker.delegate = self;
    
    _confirmSelectionButton.layer.cornerRadius = 4;
    _confirmSelectionButton.layer.masksToBounds = YES;
    
    //manually set initial a selection!
    [_vendorPicker selectRow:0 inComponent:0 animated:YES];
    _ypSearchString = @"Property Rental";
    
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CAGradientLayer *viewLayer = [_appDelegate makeBackgroundLayerForView:self.view];
    [self.view.layer insertSublayer:viewLayer atIndex:0];
    [_vendorPicker setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIPickerView Methods
// The number of columns of data
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerData count];
}

// The data to return for the row and component (column) that's being passed in
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    _vendorType = _pickerData[row];
    
    return _vendorType;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch(row)
    {
        case 0:
            _ypSearchString = @"Property Rental";
            break;
        case 1:
            _ypSearchString = @"Electric Utilities";
            break;
        case 2:
            _ypSearchString = @"Water Utilities";
            break;
        case 3:
            _ypSearchString = @"Garbage Utilities";
            break;
        case 4:
            _ypSearchString = @"Gas Utilities";
            break;
        case 5:
            _ypSearchString = @"Mailing Center";
            break;
        case 6:
            _ypSearchString = @"Transportation";
            break;
        case 7:
            _ypSearchString = @"Restaraunts";
            break;
        case 8:
            _ypSearchString = @"Entertainment";
            break;
        case 9:
            _ypSearchString = @"Fuel";
            break;
        case 10:
            _ypSearchString = @"Grocers";
            break;
        case 11:
            _ypSearchString = @"Discount Stores";
            break;
        case 12:
            _ypSearchString = @"Custom Search";
            [self displayAlert];
            break;
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = _pickerData[row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

#pragma  mark - AlertView methods

-(void)displayAlert
{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Enter a Vendor" message:@"Please enter a vendor to search for." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.tag = 0;
    
    UITextField *vendorTypeField = [alertView textFieldAtIndex:0];
    vendorTypeField.keyboardAppearance = UIKeyboardAppearanceDark;
    alertView.tintColor = [UIColor redColor];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0)
    {
        UITextField *alertField = [alertView textFieldAtIndex:0];
        // Check to see if it's blank
        if([alertField.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SORRY!"
                                                        message:@"There are no results for that vendor!\n Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
            alert.tag = 1;
            [alert show];
        }
        else
        {
            _ypSearchString = alertField.text;
        
            _pickerData = @[@"Property Rental", @"Utilities", @"Mailing Center", @"Transportation", @"Restaraunts", @"Entertainment", @"Fuel", @"Grocers", @"Discount Stores", alertField.text];
        
            [_vendorPicker reloadAllComponents];
        }
    }
    
    else
    {
        [self displayAlert];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[locationListTableViewController class]])
    {
        locationListTableViewController *lltvc = (locationListTableViewController *)segue.destinationViewController;
        
        lltvc.passedVendorType = _ypSearchString;
        
    }
}

@end
