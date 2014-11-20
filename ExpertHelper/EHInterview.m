//
//  EHInterview.m
//  ExpertHelper
//
//  Created by alena on 11/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHInterview.h"

@implementation EHInterview



-(id) initWithFirstName : (NSString *)firstName
                lastName: (NSString *)lastName
         nameOfRecruiter: (NSString *)nameOfRecruiter
     lastnameOfRecruiter: (NSString *)lastnameOfRecruiter
         dateOfInterview: (NSDate *) dateOfInterview
     locationOfInterview: (NSString *)locationOfInterview
         typeOfInterview:(NSString *)typeOfInterview
    
{
    self= [super init];
    if (self)
    {
        _nameOfCandidate = firstName;
        _lastNameOfCandidate = lastName;
        _dateOfInterview = dateOfInterview;
        _locationOfInterview  = locationOfInterview;
        _typeOfInterview = typeOfInterview;
        _nameOfRecruiter = nameOfRecruiter;
        _lastNameOfRecruiter = lastnameOfRecruiter;
    }
    return self;
}

- (void)dealloc {
    _nameOfCandidate = nil;
    _lastNameOfCandidate = nil;
    _dateOfInterview=nil;
    _locationOfInterview = nil;
    _typeOfInterview=nil;
    
    
}@end
