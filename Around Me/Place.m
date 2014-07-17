//
//  Place.m
//  Around Me
//
//  Created by Jesus Magana on 7/17/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "Place.h"

@implementation Place

- (id)initWithLocation:(CLLocation *)location reference:(NSString *)reference name:(NSString *)name address:(NSString *)address {
	if((self = [super init])) {
		_location = location;
		_reference = reference;
		_placeName = name;
		_address = address;
	}
	return self;
}

@end
