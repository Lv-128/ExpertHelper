// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ExternalInterview.h instead.

#import <CoreData/CoreData.h>

extern const struct ExternalInterviewAttributes {
	__unsafe_unretained NSString *expert;
	__unsafe_unretained NSString *pass;
} ExternalInterviewAttributes;

extern const struct ExternalInterviewRelationships {
	__unsafe_unretained NSString *audioRecords;
	__unsafe_unretained NSString *idCandidate;
	__unsafe_unretained NSString *idGeneralInfo;
	__unsafe_unretained NSString *idInterview;
	__unsafe_unretained NSString *skills;
} ExternalInterviewRelationships;

@class AudioRecord;
@class Candidate;
@class GeneralInfo;
@class InterviewAppointment;
@class Skills;

@interface ExternalInterviewID : NSManagedObjectID {}
@end

@interface _ExternalInterview : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ExternalInterviewID* objectID;

@property (nonatomic, strong) NSString* expert;

//- (BOOL)validateExpert:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* pass;

@property (atomic) BOOL passValue;
- (BOOL)passValue;
- (void)setPassValue:(BOOL)value_;

//- (BOOL)validatePass:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *audioRecords;

- (NSMutableSet*)audioRecordsSet;

@property (nonatomic, strong) Candidate *idCandidate;

//- (BOOL)validateIdCandidate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) GeneralInfo *idGeneralInfo;

//- (BOOL)validateIdGeneralInfo:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) InterviewAppointment *idInterview;

//- (BOOL)validateIdInterview:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *skills;

- (NSMutableSet*)skillsSet;

@end

@interface _ExternalInterview (AudioRecordsCoreDataGeneratedAccessors)
- (void)addAudioRecords:(NSSet*)value_;
- (void)removeAudioRecords:(NSSet*)value_;
- (void)addAudioRecordsObject:(AudioRecord*)value_;
- (void)removeAudioRecordsObject:(AudioRecord*)value_;

@end

@interface _ExternalInterview (SkillsCoreDataGeneratedAccessors)
- (void)addSkills:(NSSet*)value_;
- (void)removeSkills:(NSSet*)value_;
- (void)addSkillsObject:(Skills*)value_;
- (void)removeSkillsObject:(Skills*)value_;

@end

@interface _ExternalInterview (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveExpert;
- (void)setPrimitiveExpert:(NSString*)value;

- (NSNumber*)primitivePass;
- (void)setPrimitivePass:(NSNumber*)value;

- (BOOL)primitivePassValue;
- (void)setPrimitivePassValue:(BOOL)value_;

- (NSMutableSet*)primitiveAudioRecords;
- (void)setPrimitiveAudioRecords:(NSMutableSet*)value;

- (Candidate*)primitiveIdCandidate;
- (void)setPrimitiveIdCandidate:(Candidate*)value;

- (GeneralInfo*)primitiveIdGeneralInfo;
- (void)setPrimitiveIdGeneralInfo:(GeneralInfo*)value;

- (InterviewAppointment*)primitiveIdInterview;
- (void)setPrimitiveIdInterview:(InterviewAppointment*)value;

- (NSMutableSet*)primitiveSkills;
- (void)setPrimitiveSkills:(NSMutableSet*)value;

@end
