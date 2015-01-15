// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to VoiceRecorders.m instead.

#import "_VoiceRecorders.h"

const struct VoiceRecordersAttributes VoiceRecordersAttributes = {
	.fileUrl = @"fileUrl",
	.recordName = @"recordName",
};

const struct VoiceRecordersRelationships VoiceRecordersRelationships = {
	.idGeneralInfo = @"idGeneralInfo",
};

@implementation VoiceRecordersID
@end

@implementation _VoiceRecorders

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"VoiceRecorders" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"VoiceRecorders";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"VoiceRecorders" inManagedObjectContext:moc_];
}

- (VoiceRecordersID*)objectID {
	return (VoiceRecordersID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic fileUrl;

@dynamic recordName;

@dynamic idGeneralInfo;

@end

