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
@property NSMutableArray *searchedBikeStations;

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
    long count;
    if (self.searchBar.text.length == 0)
    {
        count = self.bikeStations.count;
    }
    else
    {
        count = self.searchedBikeStations.count;
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    BikeStation *bikeStation = [BikeStation new];
    if (self.searchBar.text.length == 0) {
        bikeStation = [self.bikeStations objectAtIndex:indexPath.row];
        cell.textLabel.text = bikeStation.stationName;

        cell.detailTextLabel.text = [NSString stringWithFormat:@"There are %i available bike", bikeStation.availableBikes];
    }
    else
    {
        bikeStation = [self.searchedBikeStations objectAtIndex:indexPath.row];
        if (bikeStation != nil) {
            cell.textLabel.text = bikeStation.stationName;

            cell.detailTextLabel.text = [NSString stringWithFormat:@"There are %i available bike", bikeStation.availableBikes];
        }
    }
    cell.detailTextLabel.numberOfLines = 2;
    cell.imageView.image = [UIImage imageNamed:@"bikeImage"];

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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.stationName contains[c] %@", searchBar.text];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self.bikeStations filteredArrayUsingPredicate:predicate]];
    if (tempArray.count != 0) {
        self.searchedBikeStations = tempArray;
    }
    [self.tableView reloadData];
}

#pragma mark - Prepare for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapViewController *mvc = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;

    if (self.searchBar.text.length == 0)
    {
        mvc.bikeStation = [self.bikeStations objectAtIndex:indexPath.row];
    }
    else
    {
        mvc.bikeStation = [self.searchedBikeStations objectAtIndex:indexPath.row];
    }
    mvc.currentLocation = self.currentLocation;
}

@end
