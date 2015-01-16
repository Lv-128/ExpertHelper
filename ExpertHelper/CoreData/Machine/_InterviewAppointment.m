// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to InterviewAppointment.m instead.

#import "_InterviewAppointment.h"

const struct InterviewAppointmentAttributes InterviewAppointmentAttributes = {
	.endDate = @"endDate",
	.eventId = @"eventId",
	.location = @"location",
	.startDate = @"startDate",
	.type = @"type",
	.url = @"url",
};

const struct InterviewAppointmentRelationships InterviewAppointmentRelationships = {
	.idExternal = @"idExternal",
	.idITAInterview = @"idITAInterview",
	.idRecruiter = @"idRecruiter",
};

@implementation InterviewAppointmentID
@end

@implementation _InterviewAppointment

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"InterviewAppointment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"InterviewAppointment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"InterviewAppointment" inManagedObjectContext:moc_];
}

- (InterviewAppointmentID*)objectID {
	return (InterviewAppointmentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic endDate;

@dynamic eventId;

@dynamic location;

@dynamic startDate;

@dynamic type;

- (int32_t)typeValue {
	NSNumber *result = [self type];
	return [result intValue];
}

- (void)setTypeValue:(int32_t)value_ {
	[self setType:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTypeValue {
	NSNumber *result = [self primitiveType];
	return [result intValue];
}

- (void)setPrimitiveTypeValue:(int32_t)value_ {
	[self setPrimitiveType:[NSNumber numberWithInt:value_]];
}

@dynamic url;

@dynamic idExternal;

@dynamic idITAInterview;

@dynamic idRecruiter;

@end

