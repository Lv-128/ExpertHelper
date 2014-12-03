// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Skills.m instead.

#import "_Skills.h"

const struct SkillsAttributes SkillsAttributes = {
	.comment = @"comment",
	.skillDescription = @"skillDescription",
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

	return keyPaths;
}

@dynamic comment;

@dynamic skillDescription;

@dynamic idExternalInterview;

@dynamic idGroup;

@dynamic level;

@end

