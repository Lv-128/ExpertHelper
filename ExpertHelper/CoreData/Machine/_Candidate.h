// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Candidate.h instead.

#import <CoreData/CoreData.h>

extern const struct CandidateAttributes {
	__unsafe_unretained NSString *candidateLastName;
	__unsafe_unretained NSString *candidateName;
	__unsafe_unretained NSString *candidatePhotoURL;
} CandidateAttributes;

extern const struct CandidateRelationships {
	__unsafe_unretained NSString *idEstimates;
	__unsafe_unretained NSString *idExternalInterview;
} CandidateRelationships;

@class ItaEstimate;
@class ExternalInterview;

@interface CandidateID : NSManagedObjectID {}
@end

@interface _Candidate : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CandidateID* objectID;

@property (nonatomic, retain) NSString* candidateLastName;

//- (BOOL)validateCandidateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* candidateName;

//- (BOOL)validateCandidateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* candidatePhotoURL;

//- (BOOL)validateCandidatePhotoURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet *idEstimates;

- (NSMutableSet*)idEstimatesSet;

@property (nonatomic, retain) NSSet *idExternalInterview;

- (NSMutableSet*)idExternalInterviewSet;

@end

@interface _Candidate (IdEstimatesCoreDataGeneratedAccessors)
- (void)addIdEstimates:(NSSet*)value_;
- (void)removeIdEstimates:(NSSet*)value_;
- (void)addIdEstimatesObject:(ItaEstimate*)value_;
- (void)removeIdEstimatesObject:(ItaEstimate*)value_;

@end

@interface _Candidate (IdExternalInterviewCoreDataGeneratedAccessors)
- (void)addIdExternalInterview:(NSSet*)value_;
- (void)removeIdExternalInterview:(NSSet*)value_;
- (void)addIdExternalInterviewObject:(ExternalInterview*)value_;
- (void)removeIdExternalInterviewObject:(ExternalInterview*)value_;

@end

@interface _Candidate (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCandidateLastName;
- (void)setPrimitiveCandidateLastName:(NSString*)value;

- (NSString*)primitiveCandidateName;
- (void)setPrimitiveCandidateName:(NSString*)value;

- (NSString*)primitiveCandidatePhotoURL;
- (void)setPrimitiveCandidatePhotoURL:(NSString*)value;

- (NSMutableSet*)primitiveIdEstimates;
- (void)setPrimitiveIdEstimates:(NSMutableSet*)value;

- (NSMutableSet*)primitiveIdExternalInterview;
- (void)setPrimitiveIdExternalInterview:(NSMutableSet*)value;

@end
