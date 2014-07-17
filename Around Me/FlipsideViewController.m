//
//  FlipsideViewController.m
//  Around Me
//
//  Created by Jean-Pierre Distler on 30.01.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Place.h"
#import "MarkerView.h"
#import "PlacesLoader.h"

NSString * const kPhoneKey = @"formatted_phone_number";
NSString * const kWebsiteKey = @"website";

const int kInfoViewTag = 1001;

@interface FlipsideViewController () <MarkerViewDelegate>

@property (nonatomic, strong) AugmentedRealityController *arController;
@property (nonatomic, strong) NSMutableArray *geoLocations;

@end

@implementation FlipsideViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    if(!_arController) {
        _arController = [[AugmentedRealityController alloc] initWithView:[self view] parentViewController:self withDelgate:self];
    }
    
    [_arController setMinimumScaleFactor:0.5];
    [_arController setScaleViewsBasedOnDistance:YES];
    [_arController setRotateViewsBasedOnPerspective:YES];
    [_arController setDebugMode:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self geoLocations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)generateGeoLocations {
	//1
	[self setGeoLocations:[NSMutableArray arrayWithCapacity:[_locations count]]];
    
	//2
	for(Place *place in _locations) {
		//3
		ARGeoCoordinate *coordinate = [ARGeoCoordinate coordinateWithLocation:[place location] locationTitle:[place placeName]];
		//4
		[coordinate calibrateUsingOrigin:[_userLocation location]];
        
		MarkerView *markerView = [[MarkerView alloc] initWithCoordinate:coordinate delegate:self];
        [coordinate setDisplayView:markerView];
        
		//5
		[_arController addCoordinate:coordinate];
		[_geoLocations addObject:coordinate];
	}
}

- (void)didTapMarker:(ARGeoCoordinate *)coordinate {
}

- (NSMutableArray *)geoLocations {
	if(!_geoLocations) {
		[self generateGeoLocations];
	}
	return _geoLocations;
}

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

-(void)didUpdateHeading:(CLHeading *)newHeading {
    
}

-(void)didUpdateLocation:(CLLocation *)newLocation {
    
}

-(void)didUpdateOrientation:(UIDeviceOrientation)orientation {
    
}

- (void)didTouchMarkerView:(MarkerView *)markerView {
	//1
	ARGeoCoordinate *tappedCoordinate = [markerView coordinate];
	CLLocation *location = [tappedCoordinate geoLocation];
    
	//2
	int index = [_locations indexOfObjectPassingTest:^(id obj, NSUInteger index, BOOL *stop) {
		return [[(Place *)obj location] isEqual:location];
	}];
    
	//3
	if(index != NSNotFound) {
		//4
		Place *tappedPlace = [_locations objectAtIndex:index];
		[[PlacesLoader sharedInstance] loadDetailInformation:tappedPlace successHanlder:^(NSDictionary *response) {
			//5
			NSLog(@"Response: %@", response);
			NSDictionary *resultDict = [response objectForKey:@"result"];
			[tappedPlace setPhoneNumber:[resultDict objectForKey:kPhoneKey]];
			[tappedPlace setWebsite:[resultDict objectForKey:kWebsiteKey]];
			[self showInfoViewForPlace:tappedPlace];
		} errorHandler:^(NSError *error) {
			NSLog(@"Error: %@", error);
		}];
	}
}

- (void)showInfoViewForPlace:(Place *)place {
	CGRect frame = [[self view] frame];
	UITextView *infoView = [[UITextView alloc] initWithFrame:CGRectMake(50.0f, 50.0f, frame.size.width - 100.0f, frame.size.height - 100.0f)];
	[infoView setCenter:[[self view] center]];
	[infoView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
	//1
	[infoView setText:[place infoText]];
	[infoView setTag:kInfoViewTag];
	[infoView setEditable:NO];
    
	[[self view] addSubview:infoView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UIView *infoView = [[self view] viewWithTag:kInfoViewTag];
    
	[infoView removeFromSuperview];
}

@end
