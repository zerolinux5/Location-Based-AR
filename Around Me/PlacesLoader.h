//
//  PlacesLoader.h
//  Around Me
//
//  Created by Jesus Magana on 7/17/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <Foundation/Foundation.h>

//1
@class CLLocation;
@class Place;

//2
typedef void (^SuccessHandler)(NSDictionary *responseDict);
typedef void (^ErrorHandler)(NSError *error);

@interface PlacesLoader : NSObject

//3
+ (PlacesLoader *)sharedInstance;

//4
- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

- (void)loadDetailInformation:(Place *)location successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

@end