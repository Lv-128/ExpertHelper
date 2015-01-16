// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Candidate.m instead.

#import "_Candidate.h"

const struct CandidateAttributes CandidateAttributes = {
	.firstName = @"firstName",
	.lastName = @"lastName",
	.photoURL = @"photoURL",
};

const struct CandidateRelationships CandidateRelationships = {
	.idExternalInterview = @"idExternalInterview",
	.idITAInterview = @"idITAInterview",
};

@implementation CandidateID
@end

@implementation _Candidate

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Candidate" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Candidate";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Candidate" inManagedObjectContext:moc_];
}

- (CandidateID*)objectID {
	return (CandidateID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic firstName;

@dynamic lastName;

@dynamic photoURL;

@dynamic idExternalInterview;

- (NSMutableSet*)idExternalInterviewSet {
	[self willAccessValueForKey:@"idExternalInterview"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"idExternalInterview"];

	[self didAccessValueForKey:@"idExternalInterview"];
	return result;
}

@dynamic idITAInterview;

- (NSMutableSet*)idITAInterviewSet {
	[self willAccessValueForKey:@"idITAInterview"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"idITAInterview"];

	[self didAccessValueForKey:@"idITAInterview"];
	return result;
}

@end

