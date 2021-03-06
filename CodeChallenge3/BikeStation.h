//
//  BikeStation.h
//  CodeChallenge3
//
//  Created by Tewodros Wondimu on 1/23/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BikeStation : NSObject

@property id stationID;

@property NSString *stationName;
@property NSString *statusValue;
@property NSString *stAddress1;
@property NSString *city;
@property NSString *landMark;

@property int availableDocks;
@property int totalDocks;
@property int statusKey;
@property int availableBikes;

@property float latitude;
@property float longitude;

@property float distanceFromCurrentLocation;

@property CLLocation *location;

@property CLLocationCoordinate2D coordinate;

- (instancetype)initWithStationName:(NSString *)stationName statusValue:(NSString *)statusValue streetAddress:(NSString *)stAddress1 city:(NSString *)city landMark:(NSString *)landMark availableDocs:(int)availableDocks totalDocks:(int)totalDocks latitude:(float)latitude longitude:(float)longitude statusKey:(int)statusKey availableBikes:(int)availableBikes;

@end
