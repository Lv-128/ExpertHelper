//
//  EHCheckNetworkConnection.m
//  ExpertHelper
//
//  Created by alena on 12/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHCheckNetworkConnection.h"

@implementation EHCheckNetworkConnection

-(id)initWithHost:(NSString*)host
{
    self = [super init];
    if (self)
    {
    // check for internet connection
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"google.com"];
    [hostReachable startNotifier];
    
        [self checkNetworkStatus];
    // now patiently wait for the notification
    }
    return self;
}
-(void) checkNetworkStatus
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
          //  NSLog(@"The internet is down.");
            self.internetActive = NO;
            
            break;
        }
        case ReachableViaWWAN:
        {
            // NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            break;
        }

        case ReachableViaWiFi:
        {
           // NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
           // NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
           // NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
           // NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
        }
    }
}
@end
