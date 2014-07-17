//
//  MainViewController.m
//  Around Me
//
//  Created by Jean-Pierre Distler on 30.01.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import "MainViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PlacesLoader.h"

#import "Place.h"
#import "PlaceAnnotation.h"

NSString * const kNameKey = @"name";
NSString * const kReferenceKey = @"reference";
NSString * const kAddressKey = @"vicinity";
NSString * const kLatitudeKeypath = @"geometry.location.lat";
NSString * const kLongitudeKeypath = @"geometry.location.lng";

@interface MainViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSArray *locations;

@end

@implementation MainViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
	[self setLocationManager:[[CLLocationManager alloc] init]];
	[_locationManager setDelegate:self];
	[_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	//1
	CLLocation *lastLocation = [locations lastObject];
    
	//2
	CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
	NSLog(@"Received location %@ with accuracy %f", lastLocation, accuracy);
    
	//3
	if(accuracy < 100.0) {
		//4
		MKCoordinateSpan span = MKCoordinateSpanMake(0.14, 0.14);
		MKCoordinateRegion region = MKCoordinateRegionMake([lastLocation coordinate], span);
        
		[_mapView setRegion:region animated:YES];
        
        [[PlacesLoader sharedInstance] loadPOIsForLocation:[locations lastObject] radius:1000 successHandler:^(NSDictionary *response) {
            [[PlacesLoader sharedInstance] loadPOIsForLocation:[locations lastObject] radius:1000 successHandler:^(NSDictionary *response) {
                NSLog(@"Response: %@", response);
                //1
                if([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
                    //2
                    id places = [response objectForKey:@"results"];
                    //3
                    NSMutableArray *temp = [NSMutableArray array];
                    
                    //4
                    if([places isKindOfClass:[NSArray class]]) {
                        for(NSDictionary *resultsDict in places) {
                            //5
                            CLLocation *location = [[CLLocation alloc] initWithLatitude:[[resultsDict valueForKeyPath:kLatitudeKeypath] floatValue] longitude:[[resultsDict valueForKeyPath:kLongitudeKeypath] floatValue]];
                            
                            //6
                            Place *currentPlace = [[Place alloc] initWithLocation:location reference:[resultsDict objectForKey:kReferenceKey] name:[resultsDict objectForKey:kNameKey] address:[resultsDict objectForKey:kAddressKey]];
                            
                            [temp addObject:currentPlace];
                            
                            //7
                            PlaceAnnotation *annotation = [[PlaceAnnotation alloc] initWithPlace:currentPlace];
                            [_mapView addAnnotation:annotation];
                        }
                    }
                    
                    //8
                    _locations = [temp copy];
                    
                    NSLog(@"Locations: %@", _locations);
                }
            } errorHandler:^(NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            
            
            
        } errorHandler:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
		[manager stopUpdatingLocation];
	}
}

@end
