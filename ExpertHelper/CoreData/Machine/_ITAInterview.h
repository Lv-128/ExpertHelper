// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ITAInterview.h instead.

#import <CoreData/CoreData.h>

extern const struct ITAInterviewAttributes {
	__unsafe_unretained NSString *itaGroupName;
	__unsafe_unretained NSString *pass;
	__unsafe_unretained NSString *scores;
} ITAInterviewAttributes;

extern const struct ITAInterviewRelationships {
	__unsafe_unretained NSString *candidates;
	__unsafe_unretained NSString *idInterview;
} ITAInterviewRelationships;

@class Candidate;
@class InterviewAppointment;

@class NSObject;

@class NSObject;

@interface ITAInterviewID : NSManagedObjectID {}
@end

@interface _ITAInterview : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ITAInterviewID* objectID;

@property (nonatomic, strong) NSString* itaGroupName;

//- (BOOL)validateItaGroupName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) id pass;

//- (BOOL)validatePass:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) id scores;

//- (BOOL)validateScores:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Candidate *candidates;

//- (BOOL)validateCandidates:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) InterviewAppointment *idInterview;

//- (BOOL)validateIdInterview:(id*)value_ error:(NSError**)error_;

@end

@interface _ITAInterview (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveItaGroupName;
- (void)setPrimitiveItaGroupName:(NSString*)value;

- (id)primitivePass;
- (void)setPrimitivePass:(id)value;

- (id)primitiveScores;
- (void)setPrimitiveScores:(id)value;

- (Candidate*)primitiveCandidates;
- (void)setPrimitiveCandidates:(Candidate*)value;

- (InterviewAppointment*)primitiveIdInterview;
- (void)setPrimitiveIdInterview:(InterviewAppointment*)value;

@end
