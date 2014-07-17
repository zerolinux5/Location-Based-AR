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

@interface MainViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

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
            NSLog(@"Response: %@", response);
            //more code here
            
        } errorHandler:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
		[manager stopUpdatingLocation];
	}
}

@end
