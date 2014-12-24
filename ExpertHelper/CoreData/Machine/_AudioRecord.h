// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AudioRecord.h instead.

#import <CoreData/CoreData.h>

extern const struct AudioRecordAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *url;
} AudioRecordAttributes;

extern const struct AudioRecordRelationships {
	__unsafe_unretained NSString *idExternal;
} AudioRecordRelationships;

@class ExternalInterview;

@interface AudioRecordID : NSManagedObjectID {}
@end

@interface _AudioRecord : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) AudioRecordID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) ExternalInterview *idExternal;

//- (BOOL)validateIdExternal:(id*)value_ error:(NSError**)error_;

@end

@interface _AudioRecord (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (ExternalInterview*)primitiveIdExternal;
- (void)setPrimitiveIdExternal:(ExternalInterview*)value;

@end
