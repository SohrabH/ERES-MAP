//
//  ViewController.h
//  ERES-MAP
//
//  Created by Sohrab Hussain on 22/11/14.
//  Copyright (c) 2014 DLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "REVClusterMapView.h"
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "WebServiceHelper.h"

@interface ViewController : UIViewController <MKMapViewDelegate, WsCompleteDelegate>
{
    IBOutlet UIActivityIndicatorView *activity;
    REVClusterMapView *_mapView;
    CalloutMapAnnotation *_calloutAnnotation;
    MKAnnotationView *_selectedAnnotationView;
    BasicMapAnnotation *_customAnnotation;
    NSMutableArray *arrBrokers;
    NSMutableDictionary *dictOneBroker;
}

@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;

// @property (nonatomic,weak) IBOutlet SPMapView *mapView;
@end

