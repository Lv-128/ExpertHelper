// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recruiter.h instead.

#import <CoreData/CoreData.h>

extern const struct RecruiterAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *photoUrl;
	__unsafe_unretained NSString *skypeAccount;
} RecruiterAttributes;

extern const struct RecruiterRelationships {
	__unsafe_unretained NSString *interviews;
} RecruiterRelationships;

@class InterviewAppointment;

@interface RecruiterID : NSManagedObjectID {}
@end

@interface _Recruiter : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RecruiterID* objectID;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* photoUrl;

//- (BOOL)validatePhotoUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* skypeAccount;

//- (BOOL)validateSkypeAccount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *interviews;

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
