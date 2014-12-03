// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ItaEstimate.m instead.

#import "_ItaEstimate.h"

const struct ItaEstimateAttributes ItaEstimateAttributes = {
	.itaComment = @"itaComment",
	.itaPass = @"itaPass",
	.itaScore = @"itaScore",
};

const struct ItaEstimateRelationships ItaEstimateRelationships = {
	.idCandidate = @"idCandidate",
	.idInterview = @"idInterview",
};

const struct ItaEstimateUserInfo ItaEstimateUserInfo = {
	.key = @"value",
};

@implementation ItaEstimateID
@end

@implementation _ItaEstimate

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ItaInterview" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ItaInterview";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ItaInterview" inManagedObjectContext:moc_];
}

- (ItaEstimateID*)objectID {
	return (ItaEstimateID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"itaPassValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"itaPass"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"itaScoreValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"itaScore"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic itaComment;

@dynamic itaPass;

- (BOOL)itaPassValue {
	NSNumber *result = [self itaPass];
	return [result boolValue];
}

- (void)setItaPassValue:(BOOL)value_ {
	[self setItaPass:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveItaPassValue {
	NSNumber *result = [self primitiveItaPass];
	return [result boolValue];
}

- (void)setPrimitiveItaPassValue:(BOOL)value_ {
	[self setPrimitiveItaPass:[NSNumber numberWithBool:value_]];
}

@dynamic itaScore;

- (double)itaScoreValue {
	NSNumber *result = [self itaScore];
	return [result doubleValue];
}

- (void)setItaScoreValue:(double)value_ {
	[self setItaScore:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveItaScoreValue {
	NSNumber *result = [self primitiveItaScore];
	return [result doubleValue];
}

- (void)setPrimitiveItaScoreValue:(double)value_ {
	[self setPrimitiveItaScore:[NSNumber numberWithDouble:value_]];
}

@dynamic idCandidate;

@dynamic idInterview;

@end

