// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SkillsLevels.h instead.

#import <CoreData/CoreData.h>

extern const struct SkillsLevelsAttributes {
	 __unsafe_unretained NSString *comment;
	 __unsafe_unretained NSString *level;
} SkillsLevelsAttributes;

extern const struct SkillsLevelsRelationships {
	 __unsafe_unretained NSString *idSkill;
} SkillsLevelsRelationships;

@class Skills;

@interface SkillsLevelsID : NSManagedObjectID {}
@end

@interface _SkillsLevels : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SkillsLevelsID* objectID;

@property (nonatomic, retain) NSString* comment;

//- (BOOL)validateComment:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) NSNumber* level;

@property (atomic) int32_t levelValue;
- (int32_t)levelValue;
- (void)setLevelValue:(int32_t)value_;

//- (BOOL)validateLevel:(id*)value_ error:(NSError**)error_;

@property (nonatomic, retain) Skills *idSkill;

//- (BOOL)validateIdSkill:(id*)value_ error:(NSError**)error_;

@end

@interface _SkillsLevels (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveComment;
- (void)setPrimitiveComment:(NSString*)value;

- (NSNumber*)primitiveLevel;
- (void)setPrimitiveLevel:(NSNumber*)value;

- (int32_t)primitiveLevelValue;
- (void)setPrimitiveLevelValue:(int32_t)value_;

- (Skills*)primitiveIdSkill;
- (void)setPrimitiveIdSkill:(Skills*)value;

@end
