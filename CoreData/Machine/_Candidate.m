// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Candidate.m instead.

#import "_Candidate.h"

const struct CandidateAttributes CandidateAttributes = {
	.candidateLastName = @"candidateLastName",
	.candidateName = @"candidateName",
	.candidatePhotoURL = @"candidatePhotoURL",
};

const struct CandidateRelationships CandidateRelationships = {
	.idEstimates = @"idEstimates",
	.idExternalInterview = @"idExternalInterview",
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

@dynamic candidateLastName;

@dynamic candidateName;

@dynamic candidatePhotoURL;

@dynamic idEstimates;

- (NSMutableSet*)idEstimatesSet {
	[self willAccessValueForKey:@"idEstimates"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"idEstimates"];

	[self didAccessValueForKey:@"idEstimates"];
	return result;
}

@dynamic idExternalInterview;

- (NSMutableSet*)idExternalInterviewSet {
	[self willAccessValueForKey:@"idExternalInterview"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"idExternalInterview"];

	[self didAccessValueForKey:@"idExternalInterview"];
	return result;
}

@end

