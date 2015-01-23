//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "MapViewController.h"
#import "BikeStation.h"

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property CLLocationManager *myLocationManager;
@property CLLocation *currentLocation;

@property NSMutableArray *bikeStations;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bikeStations = [NSMutableArray new];
    self.searchBar.delegate = self;

    // Set up LocationManager object
    self.myLocationManager = [CLLocationManager new];
    [self.myLocationManager requestAlwaysAuthorization];
    self.myLocationManager.delegate = self;

    self.currentLocation = [CLLocation new];

    NSString *url = @"http://www.bayareabikeshare.com/stations/json";
    [self getBikeStationsFromJSONURLString:url];
}

- (void)getBikeStationsFromJSONURLString:(NSString *)url
{
    [self.bikeStations removeAllObjects];

    // Create a url from the string
    NSURL *jsonURL = [NSURL URLWithString:url];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:jsonURL];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        // Create a dictionary of the results
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        NSArray *resultsBikeStationArray = resultsDictionary[@"stationBeanList"];

        // Loops through the results array of members
        for (NSDictionary *resultBikeStationDictionary in resultsBikeStationArray) {

            BikeStation *bikeStation = [[BikeStation alloc] initWithStationName:resultBikeStationDictionary[@"stationName"]
                                                                    statusValue:resultBikeStationDictionary[@"statusValue"]
                                                                  streetAddress:resultBikeStationDictionary[@"stAddress1"]
                                                                           city:resultBikeStationDictionary[@"city"]
                                                                       landMark:resultBikeStationDictionary[@"landMark"]
                                                                  availableDocs:[resultBikeStationDictionary[@"availableDocks"] intValue]
                                                                     totalDocks:[resultBikeStationDictionary[@"totalDocks"] intValue]
                                                                       latitude:[resultBikeStationDictionary[@"latitude"] floatValue]
                                                                      longitude:[resultBikeStationDictionary[@"longitude"] floatValue]
                                                                      statusKey:[resultBikeStationDictionary[@"statusKey"] intValue]
                                                                 availableBikes:[resultBikeStationDictionary[@"availableBikes"] intValue]
                                        ];
            [self.bikeStations addObject:bikeStation];
            [self.myLocationManager startUpdatingLocation];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bikeStations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    BikeStation *bikeStation = [self.bikeStations objectAtIndex:indexPath.row];
    cell.textLabel.text = bikeStation.stationName;

    cell.imageView.image = [UIImage imageNamed:@"bikeImage"];
    cell.detailTextLabel.text = bikeStation.stAddress1;

//    Check if they are ordered by distance
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", bikeStation.distanceFromCurrentLocation];
    return cell;
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

#pragma mark - Location Manager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = locations.lastObject;
    NSLog(@"%@", self.currentLocation);
    if (self.currentLocation != nil)
    {
        if (self.currentLocation.verticalAccuracy < 1000 && self.currentLocation.horizontalAccuracy < 1000)
        {
            for (BikeStation *bikeStation in self.bikeStations) {
                bikeStation.distanceFromCurrentLocation = [bikeStation.location distanceFromLocation:self.currentLocation];
                [self.tableView reloadData];
            }
            [self reorderBikeStationByDistance];
            [self.myLocationManager stopUpdatingLocation];
        }
    }
}

// Sorted array by distance
- (void)reorderBikeStationByDistance
{
    // Sort all the pizzerias by their distance from the current user's location
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distanceFromCurrentLocation" ascending:true];
    NSArray *sortedArray = [self.bikeStations sortedArrayUsingDescriptors:@[sortDescriptor]];

    // reset the pizzerias array and fill in with the sorted array
    [self.bikeStations removeAllObjects];
    self.bikeStations = [NSMutableArray arrayWithArray:sortedArray];
}

#pragma mark search delegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@", searchBar.text);
//    for (BikeStation *bikeStation in self.bikeStations) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"$@ contains %@", bikeStation.stationName, searchBar.text];
//        NSArray *temporaryArray = [self.bikeStations filteredArrayUsingPredicate:predicate];
//        
    }
}

#pragma mark - Prepare for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapViewController *mvc = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    mvc.bikeStation = [self.bikeStations objectAtIndex:indexPath.row];
    mvc.currentLocation = self.currentLocation;
}

@end
