// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Interview.m instead.

#import "_Interview.h"

const struct InterviewAttributes InterviewAttributes = {
	.idType = @"idType",
	.interviewDate = @"interviewDate",
	.interviewLocation = @"interviewLocation",
	.interviewUrl = @"interviewUrl",
};

const struct InterviewRelationships InterviewRelationships = {
	.idExternal = @"idExternal",
	.idItaInterview = @"idItaInterview",
	.idRecruiter = @"idRecruiter",
};

@implementation InterviewID
@end

@implementation _Interview

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Interview" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Interview";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Interview" inManagedObjectContext:moc_];
}

- (InterviewID*)objectID {
	return (InterviewID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"idType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic idType;

- (int32_t)idTypeValue {
	NSNumber *result = [self idType];
	return [result intValue];
}

- (void)setIdTypeValue:(int32_t)value_ {
	[self setIdType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIdTypeValue {
	NSNumber *result = [self primitiveIdType];
	return [result intValue];
}

- (void)setPrimitiveIdTypeValue:(int32_t)value_ {
	[self setPrimitiveIdType:[NSNumber numberWithInt:value_]];
}

@dynamic interviewDate;

@dynamic interviewLocation;

@dynamic interviewUrl;

@dynamic idExternal;

@dynamic idItaInterview;

- (NSMutableSet*)idItaInterviewSet {
	[self willAccessValueForKey:@"idItaInterview"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"idItaInterview"];

	[self didAccessValueForKey:@"idItaInterview"];
	return result;
}

@dynamic idRecruiter;

@end

