//
//  CoordinatesTool.h
//  TunifyIPhone
//
//  Created by Elegia on 18/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CoordinatesTool;
@protocol CoordinatesToolDelegate <NSObject>
@optional
- (void) userLocationFound:(CoordinatesTool *)sender;
- (void) userLocationError:(CoordinatesTool *)sender;
- (void) pubLocationFound:(CoordinatesTool *)sender;
- (void) pubLocationError:(CoordinatesTool *)sender;
@end

@interface CoordinatesTool : NSObject <CLLocationManagerDelegate> {
	id <CoordinatesToolDelegate> delegate;
	
	CLLocationManager *locationManager;
	NSString *pubCoordinates;
	CLLocation *pubLocation;
	NSString *userCoordinates;
	CLLocation *userLocation;
	
	BOOL *pubLocationOK;
	BOOL *userLocationOK;
	
}

@property (nonatomic, assign) id <CoordinatesToolDelegate> delegate;
@property (nonatomic, retain) NSString *pubCoordinates;
@property (nonatomic, retain) CLLocation *pubLocation;
@property (nonatomic, retain) NSString *userCoordinates;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, assign) BOOL *pubLocationOK;
@property (nonatomic, assign) BOOL *userLocationOK;

- (void) stop;
- (void) fetchUserLocation;
- (void) fetchPubLocation:(NSString *)pubAddress;
- (CLLocationDistance) fetchDistance;
- (CLLocationDistance) fetchDistance:(CLLocation *)locationA locationB:(CLLocation *)locationB;

@end