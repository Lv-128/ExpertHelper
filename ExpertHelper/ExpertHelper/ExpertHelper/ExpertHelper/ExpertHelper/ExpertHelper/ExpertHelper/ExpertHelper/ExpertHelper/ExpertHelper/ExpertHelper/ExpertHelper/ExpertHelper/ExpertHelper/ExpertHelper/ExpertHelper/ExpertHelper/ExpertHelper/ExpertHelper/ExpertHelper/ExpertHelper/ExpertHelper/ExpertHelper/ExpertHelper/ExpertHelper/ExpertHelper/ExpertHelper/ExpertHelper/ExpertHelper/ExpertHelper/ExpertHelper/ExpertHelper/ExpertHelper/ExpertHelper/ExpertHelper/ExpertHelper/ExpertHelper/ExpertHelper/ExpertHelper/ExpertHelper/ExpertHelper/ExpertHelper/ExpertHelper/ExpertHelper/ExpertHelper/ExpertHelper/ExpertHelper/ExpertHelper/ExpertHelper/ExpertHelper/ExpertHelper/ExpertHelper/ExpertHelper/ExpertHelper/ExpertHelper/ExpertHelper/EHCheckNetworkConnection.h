//
//  EHCheckNetworkConnection.h
//  ExpertHelper
//
//  Created by alena on 12/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHAppDelegate.h"

@class Reachability;

@interface EHCheckNetworkConnection : NSObject{
    
Reachability* internetReachable;
Reachability* hostReachable;
    
}
@property (nonatomic) BOOL  internetActive;
@property (nonatomic) BOOL  hostActive;
-(void) checkNetworkStatus;
-(id)initWithHost:(NSString*)host;
@end
