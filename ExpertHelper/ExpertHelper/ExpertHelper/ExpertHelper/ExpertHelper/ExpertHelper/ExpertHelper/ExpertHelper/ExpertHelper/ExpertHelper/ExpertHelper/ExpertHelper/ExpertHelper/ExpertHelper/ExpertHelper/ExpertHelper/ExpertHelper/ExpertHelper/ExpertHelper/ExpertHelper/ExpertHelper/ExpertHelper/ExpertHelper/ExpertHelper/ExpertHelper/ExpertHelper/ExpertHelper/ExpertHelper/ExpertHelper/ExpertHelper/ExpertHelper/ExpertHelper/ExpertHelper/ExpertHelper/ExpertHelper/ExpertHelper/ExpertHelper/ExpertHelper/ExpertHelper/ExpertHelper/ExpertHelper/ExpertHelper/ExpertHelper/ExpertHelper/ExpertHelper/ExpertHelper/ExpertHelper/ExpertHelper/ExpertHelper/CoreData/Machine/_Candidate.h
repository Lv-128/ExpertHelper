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
} CandidateRelationships;

@class ExternalInterview;

@interface CandidateID : NSManagedObjectID {}
@end

@interface _Candidate : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CandidateID* objectID;

@property (nonatomic, retain) NSString* firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* photoURL;

//- (BOOL)validatePhotoURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSSet *idExternalInterview;

- (NSMutableSet*)idExternalInterviewSet;

@end

@interface _Candidate (IdExternalInterviewCoreDataGeneratedAccessors)
- (void)addIdExternalInterview:(NSSet*)value_;
- (void)removeIdExternalInterview:(NSSet*)value_;
- (void)addIdExternalInterviewObject:(ExternalInterview*)value_;
- (void)removeIdExternalInterviewObject:(ExternalInterview*)value_;

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

@end
