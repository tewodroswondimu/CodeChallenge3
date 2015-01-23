//
//  BikeStationAnnotation.h
//  CodeChallenge3
//
//  Created by Tewodros Wondimu on 1/23/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BikeStation.h"

@interface BikeStationAnnotation : MKPointAnnotation

@property BikeStation *bikeStation;

@end
