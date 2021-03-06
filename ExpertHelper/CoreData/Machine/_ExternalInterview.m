// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ExternalInterview.m instead.

#import "_ExternalInterview.h"

const struct ExternalInterviewAttributes ExternalInterviewAttributes = {
	.expert = @"expert",
	.pass = @"pass",
};

const struct ExternalInterviewRelationships ExternalInterviewRelationships = {
	.audioRecords = @"audioRecords",
	.idCandidate = @"idCandidate",
	.idGeneralInfo = @"idGeneralInfo",
	.idInterview = @"idInterview",
	.skills = @"skills",
};

@implementation ExternalInterviewID
@end

@implementation _ExternalInterview

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ExternalInterview" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ExternalInterview";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ExternalInterview" inManagedObjectContext:moc_];
}

- (ExternalInterviewID*)objectID {
	return (ExternalInterviewID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"passValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pass"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic expert;

@dynamic pass;

- (BOOL)passValue {
	NSNumber *result = [self pass];
	return [result boolValue];
}

- (void)setPassValue:(BOOL)value_ {
	[self setPass:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePassValue {
	NSNumber *result = [self primitivePass];
	return [result boolValue];
}

- (void)setPrimitivePassValue:(BOOL)value_ {
	[self setPrimitivePass:[NSNumber numberWithBool:value_]];
}

@dynamic audioRecords;

- (NSMutableSet*)audioRecordsSet {
	[self willAccessValueForKey:@"audioRecords"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"audioRecords"];

	[self didAccessValueForKey:@"audioRecords"];
	return result;
}

@dynamic idCandidate;

@dynamic idGeneralInfo;

@dynamic idInterview;

@dynamic skills;

- (NSMutableSet*)skillsSet {
	[self willAccessValueForKey:@"skills"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"skills"];

	[self didAccessValueForKey:@"skills"];
	return result;
}

@end

