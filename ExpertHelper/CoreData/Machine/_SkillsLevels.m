// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SkillsLevels.m instead.

#import "_SkillsLevels.h"

const struct SkillsLevelsAttributes SkillsLevelsAttributes = {
	.comment = @"comment",
	.level = @"level",
};

const struct SkillsLevelsRelationships SkillsLevelsRelationships = {
	.idSkill = @"idSkill",
};

@implementation SkillsLevelsID
@end

@implementation _SkillsLevels

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SkillsLevels" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SkillsLevels";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SkillsLevels" inManagedObjectContext:moc_];
}

- (SkillsLevelsID*)objectID {
	return (SkillsLevelsID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"levelValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"level"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic comment;

@dynamic level;

- (int32_t)levelValue {
	NSNumber *result = [self level];
	return [result intValue];
}

- (void)setLevelValue:(int32_t)value_ {
	[self setLevel:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLevelValue {
	NSNumber *result = [self primitiveLevel];
	return [result intValue];
}

- (void)setPrimitiveLevelValue:(int32_t)value_ {
	[self setPrimitiveLevel:[NSNumber numberWithInt:value_]];
}

@dynamic idSkill;

@end

