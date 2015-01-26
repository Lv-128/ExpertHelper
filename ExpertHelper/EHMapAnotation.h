//
//  EHMapAnotation.h
//  ExpertHelper
//
//  Created by adminaccount on 1/21/15.
//  Copyright (c) 2015 Katolyk S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface EHMapAnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
