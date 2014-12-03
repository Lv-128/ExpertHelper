// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recruiter.m instead.

#import "_Recruiter.h"

const struct RecruiterAttributes RecruiterAttributes = {
	.recruiterLastName = @"recruiterLastName",
	.recruiterMail = @"recruiterMail",
	.recruiterName = @"recruiterName",
	.recruiterPhotoUrl = @"recruiterPhotoUrl",
	.recruiterSkype = @"recruiterSkype",
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

@dynamic recruiterLastName;

@dynamic recruiterMail;

@dynamic recruiterName;

@dynamic recruiterPhotoUrl;

@dynamic recruiterSkype;

@dynamic interviews;

- (NSMutableSet*)interviewsSet {
	[self willAccessValueForKey:@"interviews"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"interviews"];

	[self didAccessValueForKey:@"interviews"];
	return result;
}

@end

