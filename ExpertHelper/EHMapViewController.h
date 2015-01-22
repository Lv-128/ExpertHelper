//
//  EHMapViewController.h
//  ExpertHelper
//
//  Created by adminaccount on 1/21/15.
//  Copyright (c) 2015 Katolyk S. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;

@interface EHMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView* mapView;
@property (strong, nonatomic) NSString* location;

@end
