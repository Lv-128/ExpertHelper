// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GeneralInfo.m instead.

#import "_GeneralInfo.h"

const struct GeneralInfoAttributes GeneralInfoAttributes = {
	.competenceGroup = @"competenceGroup",
	.creatingDate = @"creatingDate",
	.expertName = @"expertName",
	.hire = @"hire",
	.levelEstimate = @"levelEstimate",
	.potentialCandidate = @"potentialCandidate",
	.projectType = @"projectType",
	.recommendations = @"recommendations",
	.skillsSummary = @"skillsSummary",
	.techEnglish = @"techEnglish",
};

const struct GeneralInfoRelationships GeneralInfoRelationships = {
	.idExternalInterview = @"idExternalInterview",
	.voiceRecords = @"voiceRecords",
};

@implementation GeneralInfoID
@end

@implementation _GeneralInfo

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"GeneralInfo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"GeneralInfo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"GeneralInfo" inManagedObjectContext:moc_];
}

- (GeneralInfoID*)objectID {
	return (GeneralInfoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"hireValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hire"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic competenceGroup;

@dynamic creatingDate;

@dynamic expertName;

@dynamic hire;

- (BOOL)hireValue {
	NSNumber *result = [self hire];
	return [result boolValue];
}

- (void)setHireValue:(BOOL)value_ {
	[self setHire:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHireValue {
	NSNumber *result = [self primitiveHire];
	return [result boolValue];
}

- (void)setPrimitiveHireValue:(BOOL)value_ {
	[self setPrimitiveHire:[NSNumber numberWithBool:value_]];
}

@dynamic levelEstimate;

@dynamic potentialCandidate;

@dynamic projectType;

@dynamic recommendations;

@dynamic skillsSummary;

@dynamic techEnglish;

@dynamic idExternalInterview;

@dynamic voiceRecords;

- (NSMutableSet*)voiceRecordsSet {
	[self willAccessValueForKey:@"voiceRecords"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"voiceRecords"];

	[self didAccessValueForKey:@"voiceRecords"];
	return result;
}

@end

