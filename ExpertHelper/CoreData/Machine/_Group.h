// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.h instead.

#import <CoreData/CoreData.h>

extern const struct GroupAttributes {
	__unsafe_unretained NSString *title;
} GroupAttributes;

extern const struct GroupRelationships {
	__unsafe_unretained NSString *allSkills;
} GroupRelationships;

@class Skills;

@interface GroupID : NSManagedObjectID {}
@end

@interface _Group : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) GroupID* objectID;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *allSkills;

- (NSMutableSet*)allSkillsSet;

@end

@interface _Group (AllSkillsCoreDataGeneratedAccessors)
- (void)addAllSkills:(NSSet*)value_;
- (void)removeAllSkills:(NSSet*)value_;
- (void)addAllSkillsObject:(Skills*)value_;
- (void)removeAllSkillsObject:(Skills*)value_;

@end

@interface _Group (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSMutableSet*)primitiveAllSkills;
- (void)setPrimitiveAllSkills:(NSMutableSet*)value;

@end
