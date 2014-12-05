// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recruiter.h instead.

#import <CoreData/CoreData.h>

extern const struct RecruiterAttributes {
	 NSString *email;
	 NSString *firstName;
	 NSString *lastName;
	 NSString *photoUrl;
	 NSString *skypeAccount;
} RecruiterAttributes;

extern const struct RecruiterRelationships {
	 NSString *interviews;
} RecruiterRelationships;

@class InterviewAppointment;

@interface RecruiterID : NSManagedObjectID {}
@end

@interface _Recruiter : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RecruiterID* objectID;

@property (nonatomic, retain) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* photoUrl;

//- (BOOL)validatePhotoUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* skypeAccount;

//- (BOOL)validateSkypeAccount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet *interviews;

- (NSMutableSet*)interviewsSet;

@end

@interface _Recruiter (InterviewsCoreDataGeneratedAccessors)
- (void)addInterviews:(NSSet*)value_;
- (void)removeInterviews:(NSSet*)value_;
- (void)addInterviewsObject:(InterviewAppointment*)value_;
- (void)removeInterviewsObject:(InterviewAppointment*)value_;

@end

@interface _Recruiter (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;

- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;

- (NSString*)primitivePhotoUrl;
- (void)setPrimitivePhotoUrl:(NSString*)value;

- (NSString*)primitiveSkypeAccount;
- (void)setPrimitiveSkypeAccount:(NSString*)value;

- (NSMutableSet*)primitiveInterviews;
- (void)setPrimitiveInterviews:(NSMutableSet*)value;

@end
