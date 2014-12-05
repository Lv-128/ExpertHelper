// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to InterviewAppointment.h instead.

#import <CoreData/CoreData.h>

extern const struct InterviewAppointmentAttributes {
	 NSString *endDate;
	 NSString *eventId;
	 NSString *location;
	 NSString *startDate;
	 NSString *type;
	 NSString *url;
} InterviewAppointmentAttributes;

extern const struct InterviewAppointmentRelationships {
	 NSString *idExternal;
	 NSString *idRecruiter;
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

@property (nonatomic, retain) NSDate* endDate;

//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* eventId;

//- (BOOL)validateEventId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSDate* startDate;

//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSNumber* type;

@property (atomic) int32_t typeValue;
- (int32_t)typeValue;
- (void)setTypeValue:(int32_t)value_;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) ExternalInterview *idExternal;

//- (BOOL)validateIdExternal:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) Recruiter *idRecruiter;

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
