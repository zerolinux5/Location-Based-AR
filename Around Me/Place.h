//
//  Place.h
//  Around Me
//
//  Created by Jesus Magana on 7/17/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface Place : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *website;

- (id)initWithLocation:(CLLocation *)location reference:(NSString *)reference name:(NSString *)name address:(NSString *)address;
- (NSString *)infoText;

@end
