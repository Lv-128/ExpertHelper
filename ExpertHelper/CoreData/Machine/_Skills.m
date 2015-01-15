// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Skills.m instead.

#import "_Skills.h"

const struct SkillsAttributes SkillsAttributes = {
	.id = @"id",
	.title = @"title",
};

const struct SkillsRelationships SkillsRelationships = {
	.idExternalInterview = @"idExternalInterview",
	.idGroup = @"idGroup",
	.level = @"level",
};

@implementation SkillsID
@end

@implementation _Skills

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Skills" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Skills";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Skills" inManagedObjectContext:moc_];
}

- (SkillsID*)objectID {
	return (SkillsID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic id;

- (int32_t)idValue {
	NSNumber *result = [self id];
	return [result intValue];
}

- (void)setIdValue:(int32_t)value_ {
	[self setId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result intValue];
}

- (void)setPrimitiveIdValue:(int32_t)value_ {
	[self setPrimitiveId:[NSNumber numberWithInt:value_]];
}

@dynamic title;

@dynamic idExternalInterview;

@dynamic idGroup;

@dynamic level;

@end

