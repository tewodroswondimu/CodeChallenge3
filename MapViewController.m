//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.bikeStation.latitude, self.bikeStation.longitude);
    [self setupMapWithCoordinate2D:coordinate];

    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = self.bikeStation.stationName;
    annotation.subtitle = self.bikeStation.stAddress1;

    [self.mapView addAnnotation:annotation];
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
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.animatesDrop = YES;
    pin.image = [UIImage imageNamed:@"bikeImage"];
    return pin;
}

@end
