// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GeneralInfo.h instead.

#import <CoreData/CoreData.h>

extern const struct GeneralInfoAttributes {
	__unsafe_unretained NSString *competenceGroup;
	__unsafe_unretained NSString *creatingDate;
	__unsafe_unretained NSString *expertName;
	__unsafe_unretained NSString *hire;
	__unsafe_unretained NSString *levelEstimate;
	__unsafe_unretained NSString *potentialCandidate;
	__unsafe_unretained NSString *projectType;
	__unsafe_unretained NSString *recommendations;
	__unsafe_unretained NSString *skillsSummary;
	__unsafe_unretained NSString *techEnglish;
} GeneralInfoAttributes;

extern const struct GeneralInfoRelationships {
	__unsafe_unretained NSString *idExternalInterview;
	__unsafe_unretained NSString *voiceRecords;
} GeneralInfoRelationships;

@class ExternalInterview;
@class VoiceRecorders;

@interface GeneralInfoID : NSManagedObjectID {}
@end

@interface _GeneralInfo : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) GeneralInfoID* objectID;

@property (nonatomic, strong) NSString* competenceGroup;

//- (BOOL)validateCompetenceGroup:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* creatingDate;

//- (BOOL)validateCreatingDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* expertName;

//- (BOOL)validateExpertName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* hire;

@property (atomic) BOOL hireValue;
- (BOOL)hireValue;
- (void)setHireValue:(BOOL)value_;

//- (BOOL)validateHire:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* levelEstimate;

//- (BOOL)validateLevelEstimate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* potentialCandidate;

//- (BOOL)validatePotentialCandidate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* projectType;

//- (BOOL)validateProjectType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* recommendations;

//- (BOOL)validateRecommendations:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* skillsSummary;

//- (BOOL)validateSkillsSummary:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* techEnglish;

//- (BOOL)validateTechEnglish:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) ExternalInterview *idExternalInterview;

//- (BOOL)validateIdExternalInterview:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *voiceRecords;

- (NSMutableSet*)voiceRecordsSet;

@end

@interface _GeneralInfo (VoiceRecordsCoreDataGeneratedAccessors)
- (void)addVoiceRecords:(NSSet*)value_;
- (void)removeVoiceRecords:(NSSet*)value_;
- (void)addVoiceRecordsObject:(VoiceRecorders*)value_;
- (void)removeVoiceRecordsObject:(VoiceRecorders*)value_;

@end

@interface _GeneralInfo (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCompetenceGroup;
- (void)setPrimitiveCompetenceGroup:(NSString*)value;

- (NSDate*)primitiveCreatingDate;
- (void)setPrimitiveCreatingDate:(NSDate*)value;

- (NSString*)primitiveExpertName;
- (void)setPrimitiveExpertName:(NSString*)value;

- (NSNumber*)primitiveHire;
- (void)setPrimitiveHire:(NSNumber*)value;

- (BOOL)primitiveHireValue;
- (void)setPrimitiveHireValue:(BOOL)value_;

- (NSString*)primitiveLevelEstimate;
- (void)setPrimitiveLevelEstimate:(NSString*)value;

- (NSString*)primitivePotentialCandidate;
- (void)setPrimitivePotentialCandidate:(NSString*)value;

- (NSString*)primitiveProjectType;
- (void)setPrimitiveProjectType:(NSString*)value;

- (NSString*)primitiveRecommendations;
- (void)setPrimitiveRecommendations:(NSString*)value;

- (NSString*)primitiveSkillsSummary;
- (void)setPrimitiveSkillsSummary:(NSString*)value;

- (NSString*)primitiveTechEnglish;
- (void)setPrimitiveTechEnglish:(NSString*)value;

- (ExternalInterview*)primitiveIdExternalInterview;
- (void)setPrimitiveIdExternalInterview:(ExternalInterview*)value;

- (NSMutableSet*)primitiveVoiceRecords;
- (void)setPrimitiveVoiceRecords:(NSMutableSet*)value;

@end
