// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.m instead.

#import "_Group.h"

const struct GroupAttributes GroupAttributes = {
	.title = @"title",
};

const struct GroupRelationships GroupRelationships = {
	.allSkills = @"allSkills",
};

@implementation GroupID
@end

@implementation _Group

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Group";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Group" inManagedObjectContext:moc_];
}

- (GroupID*)objectID {
	return (GroupID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic title;

@dynamic allSkills;

- (NSMutableSet*)allSkillsSet {
	[self willAccessValueForKey:@"allSkills"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"allSkills"];

	[self didAccessValueForKey:@"allSkills"];
	return result;
}

@end

