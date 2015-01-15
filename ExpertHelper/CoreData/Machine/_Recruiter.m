// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recruiter.m instead.

#import "_Recruiter.h"

const struct RecruiterAttributes RecruiterAttributes = {
	.email = @"email",
	.firstName = @"firstName",
	.lastName = @"lastName",
	.photoUrl = @"photoUrl",
	.skypeAccount = @"skypeAccount",
};

const struct RecruiterRelationships RecruiterRelationships = {
	.interviews = @"interviews",
};

@implementation RecruiterID
@end

@implementation _Recruiter

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Recruiter" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Recruiter";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Recruiter" inManagedObjectContext:moc_];
}

- (RecruiterID*)objectID {
	return (RecruiterID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic email;

@dynamic firstName;

@dynamic lastName;

@dynamic photoUrl;

@dynamic skypeAccount;

@dynamic interviews;

- (NSMutableSet*)interviewsSet {
	[self willAccessValueForKey:@"interviews"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"interviews"];

	[self didAccessValueForKey:@"interviews"];
	return result;
}

@end

