//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import "BikeStationAnnotation.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *currentAnnotation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLLocationCoordinate2D bikeStationCoordinate = CLLocationCoordinate2DMake(self.bikeStation.latitude, self.bikeStation.longitude);
    [self setupMapWithCoordinate2D:bikeStationCoordinate];
    [self createAnnotationForBikeStationCoordinate:bikeStationCoordinate];

    [self createAnnotationForCoordinate:self.currentLocation.coordinate];
}

- (void)createAnnotationForBikeStationCoordinate:(CLLocationCoordinate2D)coordinate
{
    BikeStationAnnotation *annotation = [BikeStationAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = self.bikeStation.stationName;
    annotation.subtitle = self.bikeStation.stAddress1;
    annotation.bikeStation = self.bikeStation;
    [self.mapView addAnnotation:annotation];
}

- (void)createAnnotationForCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.currentAnnotation = [MKPointAnnotation new];
    self.currentAnnotation.coordinate = coordinate;
    self.currentAnnotation.title = @"Current Location";

    [self.mapView addAnnotation:self.currentAnnotation];
}

#pragma mark SETUP

// Scale Map to region
- (void)setupMapWithCoordinate2D:(CLLocationCoordinate2D)coordinate
{
//    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(41.87808499, -87.6329);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
}

#pragma mark MKMAPVIEW DELEGATE METHODS

// Show callout when pin annotation is tapped
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];

    if (annotation != self.currentAnnotation) {
        pin.image = [UIImage imageNamed:@"bikeImage"];
    }
    else
    {
        pin.pinColor = MKPinAnnotationColorRed;
    }
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.animatesDrop = YES;

    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    [self getDirectionsToWithCoordinate:self.bikeStation.coordinate];
}

#pragma mark ALERTVIEW

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    // optional - add more buttons:
//    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}

#pragma mark DIRECTIONS

- (void)getDirectionsToWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    // Create a request with the source as our current location
    // And the destination as the mapItem that we found through MKLocalSearch
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.bikeStation.coordinate addressDictionary:nil];
    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];;
    request.destination = destinationItem;

    // Get the directions for the specified request
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSArray *routes = response.routes;

        // Get the first route from multiple routes
        MKRoute *route = routes.firstObject;

        // Count the number of steps to display the step number
        int x = 1;

        // Append the directions into one mutable string
        NSMutableString *directionsString = [NSMutableString string];

        // Go through all the steps in the route
        for (MKRouteStep *step in route.steps) {
            // For each step display a number and the step instructions
            [directionsString appendFormat:@"%d: %@\n", x, step.instructions];
            x++;
        }

        // Show the directions inside the alert view
        NSString *title = [NSString stringWithFormat:@"Directions to: %@", self.bikeStation.stationName];
        [self showAlertViewWithTitle:title message:directionsString];
    }];
}

@end
