// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recruiter.h instead.

#import <CoreData/CoreData.h>

extern const struct RecruiterAttributes {
	__unsafe_unretained NSString *recruiterLastName;
	__unsafe_unretained NSString *recruiterMail;
	__unsafe_unretained NSString *recruiterName;
	__unsafe_unretained NSString *recruiterPhotoUrl;
	__unsafe_unretained NSString *recruiterSkype;
} RecruiterAttributes;

extern const struct RecruiterRelationships {
	__unsafe_unretained NSString *interviews;
} RecruiterRelationships;

@class Interview;

@interface RecruiterID : NSManagedObjectID {}
@end

@interface _Recruiter : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RecruiterID* objectID;

@property (nonatomic, retain) NSString* recruiterLastName;

//- (BOOL)validateRecruiterLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* recruiterMail;

//- (BOOL)validateRecruiterMail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* recruiterName;

//- (BOOL)validateRecruiterName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* recruiterPhotoUrl;

//- (BOOL)validateRecruiterPhotoUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* recruiterSkype;

//- (BOOL)validateRecruiterSkype:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet *interviews;

- (NSMutableSet*)interviewsSet;

@end

@interface _Recruiter (InterviewsCoreDataGeneratedAccessors)
- (void)addInterviews:(NSSet*)value_;
- (void)removeInterviews:(NSSet*)value_;
- (void)addInterviewsObject:(Interview*)value_;
- (void)removeInterviewsObject:(Interview*)value_;

@end

@interface _Recruiter (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveRecruiterLastName;
- (void)setPrimitiveRecruiterLastName:(NSString*)value;

- (NSString*)primitiveRecruiterMail;
- (void)setPrimitiveRecruiterMail:(NSString*)value;

- (NSString*)primitiveRecruiterName;
- (void)setPrimitiveRecruiterName:(NSString*)value;

- (NSString*)primitiveRecruiterPhotoUrl;
- (void)setPrimitiveRecruiterPhotoUrl:(NSString*)value;

- (NSString*)primitiveRecruiterSkype;
- (void)setPrimitiveRecruiterSkype:(NSString*)value;

- (NSMutableSet*)primitiveInterviews;
- (void)setPrimitiveInterviews:(NSMutableSet*)value;

@end
