// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ItaEstimate.h instead.

#import <CoreData/CoreData.h>

extern const struct ItaEstimateAttributes {
	__unsafe_unretained NSString *itaComment;
	__unsafe_unretained NSString *itaPass;
	__unsafe_unretained NSString *itaScore;
} ItaEstimateAttributes;

extern const struct ItaEstimateRelationships {
	__unsafe_unretained NSString *idCandidate;
	__unsafe_unretained NSString *idInterview;
} ItaEstimateRelationships;

extern const struct ItaEstimateUserInfo {
	__unsafe_unretained NSString *key;
} ItaEstimateUserInfo;

@class Candidate;
@class Interview;

@interface ItaEstimateID : NSManagedObjectID {}
@end

@interface _ItaEstimate : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ItaEstimateID* objectID;

@property (nonatomic, retain) NSString* itaComment;

//- (BOOL)validateItaComment:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSNumber* itaPass;

@property (atomic) BOOL itaPassValue;
- (BOOL)itaPassValue;
- (void)setItaPassValue:(BOOL)value_;

//- (BOOL)validateItaPass:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSNumber* itaScore;

@property (atomic) double itaScoreValue;
- (double)itaScoreValue;
- (void)setItaScoreValue:(double)value_;

//- (BOOL)validateItaScore:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) Candidate *idCandidate;

//- (BOOL)validateIdCandidate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) Interview *idInterview;

//- (BOOL)validateIdInterview:(id*)value_ error:(NSError**)error_;

@end

@interface _ItaEstimate (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveItaComment;
- (void)setPrimitiveItaComment:(NSString*)value;

- (NSNumber*)primitiveItaPass;
- (void)setPrimitiveItaPass:(NSNumber*)value;

- (BOOL)primitiveItaPassValue;
- (void)setPrimitiveItaPassValue:(BOOL)value_;

- (NSNumber*)primitiveItaScore;
- (void)setPrimitiveItaScore:(NSNumber*)value;

- (double)primitiveItaScoreValue;
- (void)setPrimitiveItaScoreValue:(double)value_;

- (Candidate*)primitiveIdCandidate;
- (void)setPrimitiveIdCandidate:(Candidate*)value;

- (Interview*)primitiveIdInterview;
- (void)setPrimitiveIdInterview:(Interview*)value;

@end
