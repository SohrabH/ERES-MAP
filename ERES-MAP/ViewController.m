//
//  ViewController.m
//  ERES-MAP
//
//  Created by Sohrab Hussain on 22/11/14.
//  Copyright (c) 2014 DLD. All rights reserved.
//

#import "ViewController.h"
#import "REVClusterMap.h"
#import "REVClusterAnnotationView.h"
#import "BasicMapAnnotationView.h"
#import <CoreLocation/CoreLocation.h>
#import "AccessorizedCalloutMapAnnotationView.h"

#define BASE_RADIUS .5 // = 1 mile
#define MINIMUM_LATITUDE_DELTA 0.20
#define BLOCKS 4

#define MINIMUM_ZOOM_LEVEL 100000


@interface ViewController()<MKMapViewDelegate>
@property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic, retain) BasicMapAnnotation *customAnnotation;

@end

@implementation ViewController
@synthesize calloutAnnotation = _calloutAnnotation;
@synthesize selectedAnnotationView = _selectedAnnotationView;
@synthesize customAnnotation = _customAnnotation;

- (void)dealloc
{
     _mapView = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];
    
    _mapView = [[REVClusterMapView alloc] initWithFrame:viewBounds];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 51.22;
    coordinate.longitude = 4.39625;
    _mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000);
    
    NSMutableArray *pins = [NSMutableArray array];
    
    for(int i=0;i<500;i++) {
        CGFloat latDelta = rand()*0.125/RAND_MAX - 0.02;
        CGFloat lonDelta = rand()*0.130/RAND_MAX - 0.08;
        
        CGFloat lat = 51.21992;
        CGFloat lng = 4.39625;
        
        
        CLLocationCoordinate2D newCoord = {lat+latDelta, lng+lonDelta};
        REVClusterPin *pin = [[REVClusterPin alloc] init];
        pin.title = [NSString stringWithFormat:@"Pin %i",i+1];;
        pin.subtitle = [NSString stringWithFormat:@"Pin %i subtitle",i+1];
        pin.coordinate = newCoord;
        [pins addObject:pin];
    }
    
    [_mapView addAnnotations:pins];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_mapView removeAnnotations:_mapView.annotations];
    _mapView.frame = self.view.bounds;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark Map view delegate

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (self.calloutAnnotation &&
        view.annotation == self.customAnnotation &&
        !((BasicMapAnnotationView *)view).preventSelectionChange) {
        [_mapView removeAnnotation: self.calloutAnnotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation class] == MKUserLocation.class)
    {
        //userLocation = annotation;
        return nil;
    }
    
    REVClusterPin *pin = (REVClusterPin *)annotation;
    MKAnnotationView *annView;
    
    if (annotation == self.calloutAnnotation)
    {
        CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
        if (!calloutMapAnnotationView) {
            calloutMapAnnotationView = [[AccessorizedCalloutMapAnnotationView alloc] initWithAnnotation:annotation
                                                                                         reuseIdentifier:@"CalloutAnnotation"];
            calloutMapAnnotationView.contentHeight = 78.0f;
            UIImage *asynchronyLogo = [UIImage imageNamed:@"asynchrony-logo-small.png"];
            UIImageView *asynchronyLogoView = [[UIImageView alloc] initWithImage:asynchronyLogo];
            asynchronyLogoView.frame = CGRectMake(5, 2, asynchronyLogoView.frame.size.width, asynchronyLogoView.frame.size.height);
            [calloutMapAnnotationView.contentView addSubview:asynchronyLogoView];
        }
        
        calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
        calloutMapAnnotationView.mapView = _mapView;
        return calloutMapAnnotationView;
    }
    else if (annotation == self.customAnnotation) {
        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation
                                                                                  reuseIdentifier:@"CustomAnnotation"];
        annotationView.canShowCallout = NO;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        return annotationView;
    }
    
    
    if( [pin nodeCount] > 0 )
    {
        pin.title = @"___";
        
        annView = (REVClusterAnnotationView*)
        [mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if( !annView )
            annView = (REVClusterAnnotationView*)
            [[REVClusterAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:@"cluster"];
        
        annView.image = [UIImage imageNamed:@"cluster.png"];
        
        [(REVClusterAnnotationView*)annView setClusterText:
         [NSString stringWithFormat:@"%lu",[pin nodeCount]]];
        
        annView.canShowCallout = NO;
    }
    else
    {
        annView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if( !annView )
            annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        
        annView.image = [UIImage imageNamed:@"pingreen.png"];
        annView.canShowCallout = NO;
        annView.calloutOffset = CGPointMake(-6.0, 60.0);
        annView.highlighted = true;
//        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation
//                                                                                  reuseIdentifier:@"CustomAnnotation"];
//        annotationView.canShowCallout = NO;
//        annotationView.pinColor = MKPinAnnotationColorGreen;
//        annotationView.animatesDrop = true;
//        return annotationView;

    }
    return annView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"REVMapViewController mapView didSelectAnnotationView:");
    if (![view isKindOfClass:[REVClusterAnnotationView class]])
    {
        if (self.calloutAnnotation == nil) {
            self.calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
                                                                       andLongitude:view.annotation.coordinate.longitude];
        } else {
            self.calloutAnnotation.latitude = view.annotation.coordinate.latitude;
            self.calloutAnnotation.longitude = view.annotation.coordinate.longitude;
        }
        [_mapView addAnnotation:self.calloutAnnotation];
        self.selectedAnnotationView = view;
        return;

    }
    
    CLLocationCoordinate2D centerCoordinate = [(REVClusterPin *)view.annotation coordinate];
    
    MKCoordinateSpan newSpan =
    MKCoordinateSpanMake(mapView.region.span.latitudeDelta/2.0,
                         mapView.region.span.longitudeDelta/2.0);
    
    //mapView.region = MKCoordinateRegionMake(centerCoordinate, newSpan);
    
    [mapView setRegion:MKCoordinateRegionMake(centerCoordinate, newSpan)
              animated:YES];
}

@end
