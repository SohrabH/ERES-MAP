//
//  ViewController.h
//  ERES-MAP
//
//  Created by Sohrab Hussain on 22/11/14.
//  Copyright (c) 2014 DLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Superpin/Superpin.h>

@interface ViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic,weak) IBOutlet SPMapView *mapView;
@end

