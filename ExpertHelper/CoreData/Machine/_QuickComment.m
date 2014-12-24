// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to QuickComment.m instead.

#import "_QuickComment.h"

const struct QuickCommentAttributes QuickCommentAttributes = {
	.comment = @"comment",
};

@implementation QuickCommentID
@end

@implementation _QuickComment

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"QuickComment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"QuickComment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"QuickComment" inManagedObjectContext:moc_];
}

- (QuickCommentID*)objectID {
	return (QuickCommentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic comment;

@end

