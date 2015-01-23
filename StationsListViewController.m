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

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSMutableArray *bikeStations;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bikeStations = [NSMutableArray new];
    self.searchBar.delegate = self;

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
                                                                       location:resultBikeStationDictionary[@"location"]
                                                                       landMark:resultBikeStationDictionary[@"landMark"]
                                                                  availableDocs:[resultBikeStationDictionary[@"availableDocks"] intValue]
                                                                     totalDocks:[resultBikeStationDictionary[@"totalDocks"] intValue]
                                                                       latitude:[resultBikeStationDictionary[@"latitude"] floatValue]
                                                                      longitude:[resultBikeStationDictionary[@"longitude"] floatValue]
                                                                      statusKey:[resultBikeStationDictionary[@"statusKey"] intValue]
                                                                 availableBikes:[resultBikeStationDictionary[@"availableBikes"] intValue]
                                        ];
            [self.bikeStations addObject:bikeStation];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bikeStations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    BikeStation *bikeStation = [self.bikeStations objectAtIndex:indexPath.row];
    cell.textLabel.text = bikeStation.stationName;
    cell.detailTextLabel.text = bikeStation.stAddress1;
    cell.imageView.image = [UIImage imageNamed:@"bikeImage"];
    return cell;
}

#pragma mark - Prepare for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapViewController *mvc = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    mvc.bikeStation = [self.bikeStations objectAtIndex:indexPath.row];
}

@end