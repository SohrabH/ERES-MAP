#import <MapKit/MapKit.h>

@interface SPMapView : MKMapView {
}

/** Size in points of a cell in SPMapView's clustering grid. Default: 100pt */
@property(nonatomic, assign) CGFloat clusteringCellSize;

/** Set to false to disable clustering and make SPMapView behave like a regular MKMapView. 
    Enabled per default. */
@property(nonatomic, assign) BOOL clusteringEnabled;

/** Maximum count of non-clustered annotations in a grid cell of the clustering grid. Default: 3 */
@property(nonatomic, assign) NSUInteger clusteringThreshold;

/** Array containing annotations to be excluded from clustering.
    -[NSArray containsObject:] is used for equality comparison. */
@property(nonatomic, strong) NSArray *skipAnnotations;

/** Class used to draw individual cluster annotations. Default: SPClusterView. See SPClusterView if you want to replace this with your own drawing code */
@property(nonatomic, assign) Class defaultClusterViewClass;

/**
 * Forces Superpin to recluster. This will result in a noticeable flash.
 */
- (void)recluster;

/**
 * Returns all annotations currently on the map view. The clustered annotations are returned as SPCluster annotations.  */
- (NSArray*)currentAnnotations;

/**
 * Returns all annotations that were added on the map view, without clustering.  */
- (NSArray*)annotations;

@end