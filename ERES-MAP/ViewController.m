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
#import "InfoWindowView.h"

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
    coordinate.latitude = 25.26140086;
    coordinate.longitude = 55.29669413;
    _mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 5000, 5000);
    
    
}

-(void)viewDidLoad
{
    arrBrokers = [[NSMutableArray alloc]init];
    dictOneBroker = [[NSMutableDictionary alloc]init];
}
-(void)viewWillAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getBrokersList];
    });
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
        if (!calloutMapAnnotationView)
        {
            calloutMapAnnotationView = [[AccessorizedCalloutMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutAnnotation"];
            calloutMapAnnotationView.contentHeight = 86.0f;
            
            InfoWindowView *infoWindowObj = [[InfoWindowView alloc]init];
            [self checkNullValues:[arrBrokers objectAtIndex:self.calloutAnnotation.tag]];
            infoWindowObj.lblName.text   = [dictOneBroker objectForKey:@"ConatctEn"];
            infoWindowObj.lblEmail.text  = [dictOneBroker objectForKey:@"Email"];
            infoWindowObj.lblPhone.text  = [dictOneBroker objectForKey:@"Phone"];
            infoWindowObj.lblMobile.text = [dictOneBroker objectForKey:@"Mobile"];
            infoWindowObj.lblFax.text    = [dictOneBroker objectForKey:@"Fax"];
            infoWindowObj.tvAddress.text = [dictOneBroker objectForKey:@"AddressEn"];
            
            [calloutMapAnnotationView.contentView addSubview:infoWindowObj];
        }
        calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
        calloutMapAnnotationView.mapView = _mapView;
        
        return calloutMapAnnotationView;
    }
    else if (annotation == self.customAnnotation)
    {
        MKPinAnnotationView *annotationView = [[BasicMapAnnotationView alloc] initWithAnnotation:annotation
                                                                                 reuseIdentifier:@"CustomAnnotation"];
        annotationView.canShowCallout = NO;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        return annotationView;
    }

    if( [pin nodeCount] > 0 )
    {
        pin.title = @"___";
        
        //annView = (REVClusterAnnotationView*) [mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if( !annView )
            annView = (REVClusterAnnotationView*)
            [[REVClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"];
        
        annView.image = [UIImage imageNamed:@"cluster.png"];
        
        [(REVClusterAnnotationView*)annView setClusterText:
         [NSString stringWithFormat:@"%lu",[pin nodeCount]]];
        annView.highlighted = false;

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
    }
    
    
    
    return annView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    REVClusterPin *pin = (REVClusterPin *)view.annotation;
    self.calloutAnnotation = nil;
    NSLog(@"REVMapViewController mapView didSelectAnnotationView: %@", pin.title);
    if (![view isKindOfClass:[REVClusterAnnotationView class]])
    {
        if (self.calloutAnnotation == nil)
        {
            self.calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
                                                                       andLongitude:view.annotation.coordinate.longitude];
        }
        else
        {
            self.calloutAnnotation.latitude = view.annotation.coordinate.latitude;
            self.calloutAnnotation.longitude = view.annotation.coordinate.longitude;
        }
        self.calloutAnnotation.tag = [pin.title integerValue];
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

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *view in views)
    {
        if ([views count] == 1)
        {
            [[view superview] bringSubviewToFront:view];

        }
    }
}

-(void)checkNullValues : (NSDictionary *) dict
{
    NSArray *arrKey = [dict allKeys];
    dictOneBroker = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < [[dict allKeys] count]; i++)
    {
        NSLog(@"Key = %@", [[dict allKeys] objectAtIndex:i]);
        if ([[dict objectForKey:[arrKey objectAtIndex:i]] isEqual:[NSNull null]])
            [dictOneBroker setObject:@"-" forKey:[arrKey objectAtIndex:i]];
        else
            [dictOneBroker setObject:[dict objectForKey:[arrKey objectAtIndex:i]] forKey:[arrKey objectAtIndex:i]];
        
    }
}
#pragma mark
#pragma mark Fetching Properties Methods

- (void)getBrokersList
{
    activity.hidden = FALSE;
    [activity startAnimating];
    NSString* UrlString = [NSString stringWithFormat:@"%@",@"http://94.56.46.41/ejariapi/search/brokerlist?"];
    WebServiceHelper *webObj = [[WebServiceHelper alloc]init];
    webObj.delegate = self;
    [webObj getMethodWithURL:UrlString];
    
}

-(void) finished :(NSDictionary *)data
{
    for (int i = 0; i < [[data objectForKey:@"result"] count]; i++)
    {
        for (int j = 0; j < [[[[data objectForKey:@"result"] objectAtIndex:i] objectForKey:@"Offices"] count]; j++)
        {
            [arrBrokers addObject:[[[[data objectForKey:@"result"] objectAtIndex:i] objectForKey:@"Offices"] objectAtIndex:j]];
        }
    }
    
    [self addBrokerPins];
}

-(void)addBrokerPins
{
    NSMutableArray *pins = [NSMutableArray array];
    
    for(int i = 0; i< [arrBrokers count]; i++)
    {
        
        CGFloat lat = [[[[arrBrokers objectAtIndex:i] objectForKey:@"location"] objectForKey:@"longitude"] floatValue];
        CGFloat lng = [[[[arrBrokers objectAtIndex:i] objectForKey:@"location"] objectForKey:@"latitude"] floatValue];
        
        
        CLLocationCoordinate2D newCoord = {lat, lng};
        REVClusterPin *pin = [[REVClusterPin alloc] init];
        pin.title = [NSString stringWithFormat:@"%d",i];
//        pin.title = [NSString stringWithFormat:@"Pin %i",i+1];;
//        pin.subtitle = [NSString stringWithFormat:@"Pin %i subtitle",i+1];
        pin.coordinate = newCoord;
        [pins addObject:pin];
    }
    
    [_mapView addAnnotations:pins];
     [activity stopAnimating];
}
@end
