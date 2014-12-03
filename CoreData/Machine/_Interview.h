// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Interview.h instead.

#import <CoreData/CoreData.h>

extern const struct InterviewAttributes {
	__unsafe_unretained NSString *idType;
	__unsafe_unretained NSString *interviewDate;
	__unsafe_unretained NSString *interviewLocation;
	__unsafe_unretained NSString *interviewUrl;
} InterviewAttributes;

extern const struct InterviewRelationships {
	__unsafe_unretained NSString *idExternal;
	__unsafe_unretained NSString *idItaInterview;
	__unsafe_unretained NSString *idRecruiter;
} InterviewRelationships;

@class ExternalInterview;
@class ItaEstimate;
@class Recruiter;

@interface InterviewID : NSManagedObjectID {}
@end

@interface _Interview : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) InterviewID* objectID;

@property (nonatomic, retain) NSNumber* idType;

@property (atomic) int32_t idTypeValue;
- (int32_t)idTypeValue;
- (void)setIdTypeValue:(int32_t)value_;

//- (BOOL)validateIdType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSDate* interviewDate;

//- (BOOL)validateInterviewDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* interviewLocation;

//- (BOOL)validateInterviewLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* interviewUrl;

//- (BOOL)validateInterviewUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) ExternalInterview *idExternal;

//- (BOOL)validateIdExternal:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet *idItaInterview;

- (NSMutableSet*)idItaInterviewSet;

@property (nonatomic, retain) Recruiter *idRecruiter;

//- (BOOL)validateIdRecruiter:(id*)value_ error:(NSError**)error_;

@end

@interface _Interview (IdItaInterviewCoreDataGeneratedAccessors)
- (void)addIdItaInterview:(NSSet*)value_;
- (void)removeIdItaInterview:(NSSet*)value_;
- (void)addIdItaInterviewObject:(ItaEstimate*)value_;
- (void)removeIdItaInterviewObject:(ItaEstimate*)value_;

@end

@interface _Interview (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIdType;
- (void)setPrimitiveIdType:(NSNumber*)value;

- (int32_t)primitiveIdTypeValue;
- (void)setPrimitiveIdTypeValue:(int32_t)value_;

- (NSDate*)primitiveInterviewDate;
- (void)setPrimitiveInterviewDate:(NSDate*)value;

- (NSString*)primitiveInterviewLocation;
- (void)setPrimitiveInterviewLocation:(NSString*)value;

- (NSString*)primitiveInterviewUrl;
- (void)setPrimitiveInterviewUrl:(NSString*)value;

- (ExternalInterview*)primitiveIdExternal;
- (void)setPrimitiveIdExternal:(ExternalInterview*)value;

- (NSMutableSet*)primitiveIdItaInterview;
- (void)setPrimitiveIdItaInterview:(NSMutableSet*)value;

- (Recruiter*)primitiveIdRecruiter;
- (void)setPrimitiveIdRecruiter:(Recruiter*)value;

@end
