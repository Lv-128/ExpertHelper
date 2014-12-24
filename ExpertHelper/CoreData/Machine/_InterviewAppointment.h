// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to InterviewAppointment.h instead.

#import <CoreData/CoreData.h>

extern const struct InterviewAppointmentAttributes {
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *eventId;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *url;
} InterviewAppointmentAttributes;

extern const struct InterviewAppointmentRelationships {
	__unsafe_unretained NSString *idExternal;
	__unsafe_unretained NSString *idRecruiter;
} InterviewAppointmentRelationships;

@class ExternalInterview;
@class Recruiter;

@interface InterviewAppointmentID : NSManagedObjectID {}
@end

@interface _InterviewAppointment : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) InterviewAppointmentID* objectID;

@property (nonatomic, strong) NSDate* endDate;

//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* eventId;

//- (BOOL)validateEventId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* startDate;

//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* type;
/*
@property (atomic) int32_t typeValue;
- (int32_t)typeValue;
- (void)setTypeValue:(int32_t)value_;
*/
//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) ExternalInterview *idExternal;

//- (BOOL)validateIdExternal:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Recruiter *idRecruiter;

//- (BOOL)validateIdRecruiter:(id*)value_ error:(NSError**)error_;

@end

@interface _InterviewAppointment (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;

- (NSString*)primitiveEventId;
- (void)setPrimitiveEventId:(NSString*)value;

- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;

- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (ExternalInterview*)primitiveIdExternal;
- (void)setPrimitiveIdExternal:(ExternalInterview*)value;

- (Recruiter*)primitiveIdRecruiter;
- (void)setPrimitiveIdRecruiter:(Recruiter*)value;

@end
