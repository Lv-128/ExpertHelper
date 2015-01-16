// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ITAInterview.m instead.

#import "_ITAInterview.h"

const struct ITAInterviewAttributes ITAInterviewAttributes = {
	.itaGroupName = @"itaGroupName",
	.pass = @"pass",
	.scores = @"scores",
};

const struct ITAInterviewRelationships ITAInterviewRelationships = {
	.candidates = @"candidates",
	.idInterview = @"idInterview",
};

@implementation ITAInterviewID
@end

@implementation _ITAInterview

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ITAInterview" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ITAInterview";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ITAInterview" inManagedObjectContext:moc_];
}

- (ITAInterviewID*)objectID {
	return (ITAInterviewID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic itaGroupName;

@dynamic pass;

@dynamic scores;

@dynamic candidates;

@dynamic idInterview;

@end

