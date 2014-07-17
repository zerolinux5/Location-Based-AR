//
//  PlaceAnnotation.h
//  Around Me
//
//  Created by Jesus Magana on 7/17/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Place;

@interface PlaceAnnotation : NSObject <MKAnnotation>

- (id)initWithPlace:(Place *)place;
- (CLLocationCoordinate2D)coordinate;
- (NSString *)title;

@end