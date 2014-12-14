// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Skills.h instead.

#import <CoreData/CoreData.h>

extern const struct SkillsAttributes {
	 __unsafe_unretained NSString *id;
	 __unsafe_unretained NSString *title;
} SkillsAttributes;

extern const struct SkillsRelationships {
	 __unsafe_unretained NSString *idExternalInterview;
	 __unsafe_unretained NSString *idGroup;
	 __unsafe_unretained NSString *level;
} SkillsRelationships;

@class ExternalInterview;
@class Group;
@class SkillsLevels;

@interface SkillsID : NSManagedObjectID {}
@end

@interface _Skills : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SkillsID* objectID;

@property (nonatomic, retain) NSNumber* id;

@property (atomic) int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) ExternalInterview *idExternalInterview;

//- (BOOL)validateIdExternalInterview:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) Group *idGroup;

//- (BOOL)validateIdGroup:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) SkillsLevels *level;

//- (BOOL)validateLevel:(id*)value_ error:(NSError**)error_;

@end

@interface _Skills (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (ExternalInterview*)primitiveIdExternalInterview;
- (void)setPrimitiveIdExternalInterview:(ExternalInterview*)value;

- (Group*)primitiveIdGroup;
- (void)setPrimitiveIdGroup:(Group*)value;

- (SkillsLevels*)primitiveLevel;
- (void)setPrimitiveLevel:(SkillsLevels*)value;

@end
