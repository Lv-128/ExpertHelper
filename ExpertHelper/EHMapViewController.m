//
//  EHMapViewController.m
//  ExpertHelper
//
//  Created by adminaccount on 1/21/15.
//  Copyright (c) 2015 Katolyk S. All rights reserved.
//

#import "EHMapViewController.h"
#import "EHMapAnotation.h"
#import <MapKit/MapKit.h>
#import "UIView+MKAnnotationView.h"

@interface EHMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *lm;
@property (strong, nonatomic) MKDirections *directions;

@end

@implementation EHMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self selectBarButtonItem];
    [self searchDestination];
    
    self.lm = [[CLLocationManager alloc]init];
    [self.lm requestAlwaysAuthorization];
    self.lm.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    if ([self.directions isCalculating])
        [self.directions cancel];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *l = [locations firstObject];
    MKCoordinateRegion UserLoc;
    UserLoc.center = l.coordinate;
    MKCoordinateSpan span;
    span.longitudeDelta = 0.30f;
    span.latitudeDelta = 0.30f;
    UserLoc.span = span;
}

#pragma mark - viewDidLoad Methods

- (void)searchDestination
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = self.location;
    request.region = _mapView.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse
                                         *response, NSError *error) {
        if (response.mapItems.count == 0)
            [self showAlertWithTitle:@"Error" andMessage:@"No matches found"];
        else
            for (MKMapItem *item in response.mapItems)
            {
                EHMapAnotation* annotation = [[EHMapAnotation alloc] init];
                
                annotation.subtitle = @"Maybe Group??";
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                [self.mapView addAnnotation:annotation];
                [self actionShowAll:nil];
            }
    }];
    
}

- (void)selectBarButtonItem
{
    UIBarButtonItem *zoomButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                  target:self action:@selector(actionShowAll:)];
    
    self.navigationItem.rightBarButtonItem = zoomButton;
}

#pragma mark - mapView Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView *pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Annotation"];
    
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
        pin.pinColor = MKPinAnnotationColorPurple;
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        //        pin.draggable = YES;
        
        UIButton *directionButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [directionButton addTarget:self action:@selector(actionDirection:) forControlEvents:UIControlEventTouchUpInside];
        pin.leftCalloutAccessoryView = directionButton;
        
    } else
        pin.annotation = annotation;
    
    return pin;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        renderer.lineWidth = 2.f;
        renderer.strokeColor = [UIColor colorWithRed:0.f green:0.5f blue:1.f alpha:1.f];
        return renderer;
    }
    return nil;
}

#pragma mark - actions Methods

- (void)actionShowAll:(UIBarButtonItem *)sender
{
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location = annotation.coordinate;
        
        MKMapPoint center = MKMapPointForCoordinate(location);
        
        double delta = 20000;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
}

- (void)actionDirection:(UIButton *)sender
{
    MKAnnotationView *annotationView = [sender superAnnotationView];
    
    if (!annotationView)
        return;
    
    if ([self.directions isCalculating])
        [self.directions cancel];
    
    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                   addressDictionary:nil];
    
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    
    request.destination = destination;
    request.transportType = MKDirectionsTransportTypeWalking;
    request.requestsAlternateRoutes = YES;
    
    self.directions = [[MKDirections alloc] initWithRequest:request];
    
    [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error)
            [self showAlertWithTitle:@"Error" andMessage:[error localizedDescription]];
        else if ([response.routes count] == 0)
            [self showAlertWithTitle:@"Error" andMessage:@"No routes found"];
        else {
            
            [self.mapView removeOverlays:[self.mapView overlays]];
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (MKRoute *route in response.routes)
                [array addObject:route.polyline];
            
            [self.mapView addOverlays:array level:MKOverlayLevelAboveRoads];
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    [[[UIAlertView alloc]initWithTitle:title
                               message:message
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil] show];
}


@end
