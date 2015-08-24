//
//  locationListTableViewController.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/17/15.
//  Copyright (c) 2015 Nutech Systems, inc. All rights reserved.
//

#import "locationListTableViewController.h"
#import "locationDetailViewController.h"
#import "MapViewController.h"
#import "Location.h"
#import "AppDelegate.h"
#import "Vendor.h"
#import "MBProgressHUD.h"

@interface locationListTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *vendorTable;
@property (strong, nonatomic) Vendor *currentVendor;
@property (strong, nonatomic) NSMutableArray *vendors;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSString *vendorLocations;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) double distance;

@end

@implementation locationListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshTableData];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    _vendors = [NSMutableArray array];
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.navigationItem.title = _passedVendorType;
    [self loadRequest];
    
    CAGradientLayer *viewLayer = [_appDelegate makeBackgroundLayerForView:self.view];
    [self.view.layer insertSublayer:viewLayer atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

// set the tableView number of rows to the number of elements in the _posts array
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_vendors)
    {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return [_vendors count];
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}

// set up the custom cell in our tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"VendorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Vendor *vendorAtIndex = _vendors[indexPath.row];
    
    cell.textLabel.text = vendorAtIndex.vendorName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f miles", vendorAtIndex.distance];
    
    return cell;
}

-(void)refreshTableData
{
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor redColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Data Load methods

-(void)loadRequest
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config
                                             delegate:nil
                                        delegateQueue:nil];
    [self loadingOverlay];
    NSString *location = _appDelegate.myLocation.city;
    NSString *queryString = [_passedVendorType stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *urlString = [NSString stringWithFormat:@"http://api.sandbox.yellowapi.com/FindBusiness/?what=%@&where=%@&fmt=json&UID=127.0.0.1&apikey=svu68f2kz5snynqrdnetv76u", queryString, location];
    NSURL *myURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    NSURLSessionTask *task = [_session dataTaskWithRequest:request completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error)
                              {
                                  NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                 error:nil];
                                  
                                  if (responseData) {
                                      NSArray *immutableListings = responseData[@"listings"];
                                      for (NSDictionary *listingDictionary in immutableListings) {
                                          NSString *name = listingDictionary[@"name"];
                                          NSDictionary *addressDict = listingDictionary[@"address"];
                                          NSString *street = addressDict[@"street"];
                                          NSString *city = addressDict[@"city"];
                                          NSString *state = addressDict[@"prov"];
                                          NSString *zip = addressDict[@"pcode"];
                                          
                                          NSString *latitude;
                                          NSString *longitude;
                                          NSString *address;
                                          
                                          if(![listingDictionary[@"geoCode"] isEqual:[NSNull null]])
                                          {
                                              latitude = listingDictionary[@"geoCode"][@"latitude"];
                                              longitude = listingDictionary[@"geoCode"][@"longitude"];
                                              address = [NSString stringWithFormat:@"%@ %@, %@ %@", street, city, state, zip];
                                          }
                                          
                                          else
                                          {
                                              latitude = _appDelegate.myLocation.latitude;
                                              longitude = _appDelegate.myLocation.longitude;
                                              address = _appDelegate.currLocation;
                                          }
                                          
                                          double myLat = [_appDelegate.myLocation.latitude doubleValue];
                                          double myLong = [_appDelegate.myLocation.longitude doubleValue];
                                          double vendorLat = [latitude doubleValue];
                                          double vendorLong = [longitude doubleValue];
                                          
                                          CLLocation *myLoc = [[CLLocation alloc]initWithLatitude:myLat longitude:myLong];
                                          
                                          CLLocation *vendorLoc = [[CLLocation alloc]initWithLatitude:vendorLat longitude:vendorLong];
                                          
                                          float meterDistance = [myLoc distanceFromLocation:vendorLoc];
                                          
                                          _distance = (meterDistance/1275.758);
                                          
                                          Vendor *vendor = [[Vendor alloc]initWithVendor:name andAddress:address andPhone:nil andLatitude:latitude andLongitude:longitude andDistance:_distance];
                                          [_vendors addObject:vendor];
                                          
                                          
                                      }
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.tableView reloadData];
                                          [_hud hide:YES];
                                      });
                                  };
                              }];
    [task resume];
}

#pragma mark - Loading Overlay methods

// loading progress overlay method
- (void)loadingOverlay
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"Loading Vendors";
    [_hud show: YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[locationDetailViewController class]])
    {
        
        locationDetailViewController *ldvc = (locationDetailViewController *)segue.destinationViewController;
        NSIndexPath *vendorPath = [self.vendorTable indexPathForSelectedRow];
        
        Vendor *selectedVendor = _vendors[vendorPath.row];
        ldvc.passedVendor = selectedVendor;
        ;
    }
    else if([segue.destinationViewController isKindOfClass:[MapViewController class]])
    {
        
        MapViewController *mvc = (MapViewController *)segue.destinationViewController;
        
        NSArray *passedArray = _vendors;
        mvc.passedArray = passedArray;
        ;
    }
}


@end
