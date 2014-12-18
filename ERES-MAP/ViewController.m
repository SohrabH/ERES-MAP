//
//  ViewController.m
//  ERES-MAP
//
//  Created by Sohrab Hussain on 22/11/14.
//  Copyright (c) 2014 DLD. All rights reserved.
//

#import "ViewController.h"
#import "SPAirport.h"
@interface ViewController()<MKMapViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [self.mapView setVisibleMapRect:MKMapRectWorld];
    
    self.mapView.delegate = self;
    
    // Uncomment these lines for alternative cluster view style:
    //    [SPClusterView setBackgroundImage:[UIImage imageNamed:@"cluster_dark.png"]];
    //    [SPClusterView setTextColor:[UIColor whiteColor]];
    
    // Load airports from plist in the background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *airports = [SPAirport allAirports];
        
        // Exclude JFK and VIE from clustering
        NSArray *skip = [airports filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(code == 'VIE') OR (code == 'JFK')"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          //  self.mapView.skipAnnotations = skip;
            [self.mapView addAnnotations:airports];
        });
    });
}

-(MKAnnotationView*)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString* reuseIdentifier = @"SPAirport";
    
    if ([annotation isKindOfClass:[SPAirport class]]) {
        MKAnnotationView* annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
            annotationView.canShowCallout = YES;
        }
        annotationView.image = ((SPAirport*)annotation).icon;
        return annotationView;
    } else {
        // Let Superpin handle SPCluster view
        return nil;
    }
}

- (void)mapView:(MKMapView *)aMapView didSelectAnnotationView:(MKAnnotationView *)view {
    id<MKAnnotation> annotation = view.annotation;
    if([annotation isKindOfClass:[SPCluster class]]) {
        SPCluster *cluster = (SPCluster*)annotation;
        MKCoordinateRegion region = MKCoordinateRegionForMapRect(cluster.encompassingMapRect);
        [aMapView setRegion:[aMapView regionThatFits:region] animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
