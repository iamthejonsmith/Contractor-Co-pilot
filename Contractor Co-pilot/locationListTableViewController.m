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

@interface locationListTableViewController ()<UIAlertViewDelegate>

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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    _vendors = [NSMutableArray array];
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.navigationItem.title = _passedVendorType;
    
    CAGradientLayer *viewLayer = [_appDelegate makeBackgroundLayerForView:self.view];
    
    UIGraphicsBeginImageContext(viewLayer.bounds.size);
    [viewLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * bgAsImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imgView.image = bgAsImage;
    
    if (bgAsImage != nil)
    {
        self.tableView.backgroundView = imgView;
    }
    [self loadRequest];
    [self refreshTableData];
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
    NSString *locationString = [NSString stringWithFormat:@"%@ %@, %@, %@ %@",_appDelegate.myLocation.streetNumber, _appDelegate.myLocation.streetName,_appDelegate.myLocation.city,_appDelegate.myLocation.state, _appDelegate.myLocation.zip];
    NSString *location = [locationString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *queryString = [_passedVendorType stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *urlString = [NSString stringWithFormat:@"http://pubapi.yp.com/search-api/search/devapi/search?searchloc=%@&term=%@&format=json&sort=distance&listingcount=50&key=p9hc4k9mbg",location, queryString];
    NSURL *myURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    NSURLSessionTask *task = [_session dataTaskWithRequest:request completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error)
                              {
                                  NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:0
                                                                                                error:nil];
                                  NSDictionary *searchResult = responseData[@"searchResult"];
                                  
                                  id searchListings = searchResult[@"searchListings"];
                                  
                                  //NSDictionary *searchListings = searchResult[@"searchListings"];
                                  
                                  if (responseData) {
                                      if ([searchListings isKindOfClass:[NSString class]]) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SORRY!"
                                                                                          message:@"There are no results for that vendor!\n Please try again."
                                                                                         delegate:self
                                                                                cancelButtonTitle:@"OK"
                                                                                otherButtonTitles:nil];
                                          [alert show];
                                              });
                                      }
                                      else
                                      {
                                      NSArray *immutableListings = searchListings[@"searchListing"];
                                      for (NSDictionary *listingDictionary in immutableListings)
                                      {
                                            NSString *name = listingDictionary[@"businessName"];
                                            NSString *phone = listingDictionary[@"phone"];
                                            NSString *street = listingDictionary[@"street"];
                                            NSString *city = listingDictionary[@"city"];
                                            NSString *state = listingDictionary[@"state"];
                                            NSString *zip = listingDictionary[@"zip"];
                                            NSString *latitude = listingDictionary[@"latitude"];
                                            NSString *longitude = listingDictionary[@"longitude"];
                                            NSString *distance = listingDictionary[@"distance"];
                                            NSString *address = [NSString stringWithFormat:@"%@ %@, %@ %@", street, city, state, zip];
    
                                            double vendorDistance = [distance doubleValue];
                                          
                                            Vendor *vendor = [[Vendor alloc]initWithVendor:name andAddress:   address andPhone:phone andLatitude:latitude andLongitude:  longitude andDistance:vendorDistance];
                                            [_vendors addObject:vendor];
                                          
                                        }
                                      }
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.tableView reloadData];
                                          [_hud hide:YES];
                                      });
                                  };
                              }];
    [task resume];
                              
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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
    }
    else if([segue.destinationViewController isKindOfClass:[MapViewController class]])
    {
        
        MapViewController *mvc = (MapViewController *)segue.destinationViewController;
        
        NSArray *passedArray = _vendors;
        mvc.passedArray = passedArray;
        
    }
}


@end
