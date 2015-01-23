//
//  BikeStation.m
//  CodeChallenge3
//
//  Created by Tewodros Wondimu on 1/23/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "BikeStation.h"

@implementation BikeStation

- (instancetype)initWithStationName:(NSString *)stationName statusValue:(NSString *)statusValue streetAddress:(NSString *)stAddress1 city:(NSString *)city location:(NSString *)location landMark:(NSString *)landMark availableDocs:(int)availableDocks totalDocks:(int)totalDocks latitude:(float)latitude longitude:(float)longitude statusKey:(int)statusKey availableBikes:(int)availableBikes
{
    self = [super init];
    if (self) {
        self.stationName = stationName;
        self.statusValue = statusValue;
        self.stAddress1 = stAddress1;
        self.city = city;
        self.location = location;
        self.landMark = landMark;
        self.availableDocks = availableDocks;
        self.totalDocks = totalDocks;
        self.latitude = latitude;
        self.longitude = longitude;
        self.statusKey = statusKey;
        self.availableBikes = availableBikes;
    }
    return self;
}

@end
