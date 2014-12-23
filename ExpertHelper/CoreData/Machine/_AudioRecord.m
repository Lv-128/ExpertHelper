// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AudioRecord.m instead.

#import "_AudioRecord.h"

const struct AudioRecordAttributes AudioRecordAttributes = {
	.name = @"name",
	.url = @"url",
};

const struct AudioRecordRelationships AudioRecordRelationships = {
	.idExternal = @"idExternal",
};

@implementation AudioRecordID
@end

@implementation _AudioRecord

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AudioRecord" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AudioRecord";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AudioRecord" inManagedObjectContext:moc_];
}

- (AudioRecordID*)objectID {
	return (AudioRecordID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic url;

@dynamic idExternal;

@end

