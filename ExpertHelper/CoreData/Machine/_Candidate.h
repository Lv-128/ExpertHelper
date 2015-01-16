// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Candidate.h instead.

#import <CoreData/CoreData.h>

extern const struct CandidateAttributes {
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *photoURL;
} CandidateAttributes;

extern const struct CandidateRelationships {
	__unsafe_unretained NSString *idExternalInterview;
	__unsafe_unretained NSString *idITAInterview;
} CandidateRelationships;

@class ExternalInterview;
@class ITAInterview;

@interface CandidateID : NSManagedObjectID {}
@end

@interface _Candidate : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CandidateID* objectID;

@property (nonatomic, strong) NSString* firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* photoURL;

//- (BOOL)validatePhotoURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *idExternalInterview;

- (NSMutableSet*)idExternalInterviewSet;

@property (nonatomic, strong) NSSet *idITAInterview;

- (NSMutableSet*)idITAInterviewSet;

@end

@interface _Candidate (IdExternalInterviewCoreDataGeneratedAccessors)
- (void)addIdExternalInterview:(NSSet*)value_;
- (void)removeIdExternalInterview:(NSSet*)value_;
- (void)addIdExternalInterviewObject:(ExternalInterview*)value_;
- (void)removeIdExternalInterviewObject:(ExternalInterview*)value_;

@end

@interface _Candidate (IdITAInterviewCoreDataGeneratedAccessors)
- (void)addIdITAInterview:(NSSet*)value_;
- (void)removeIdITAInterview:(NSSet*)value_;
- (void)addIdITAInterviewObject:(ITAInterview*)value_;
- (void)removeIdITAInterviewObject:(ITAInterview*)value_;

@end

@interface _Candidate (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;

- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;

- (NSString*)primitivePhotoURL;
- (void)setPrimitivePhotoURL:(NSString*)value;

- (NSMutableSet*)primitiveIdExternalInterview;
- (void)setPrimitiveIdExternalInterview:(NSMutableSet*)value;

- (NSMutableSet*)primitiveIdITAInterview;
- (void)setPrimitiveIdITAInterview:(NSMutableSet*)value;

@end
