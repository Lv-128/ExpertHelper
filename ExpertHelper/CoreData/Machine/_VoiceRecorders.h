// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to VoiceRecorders.h instead.

#import <CoreData/CoreData.h>

extern const struct VoiceRecordersAttributes {
	__unsafe_unretained NSString *fileUrl;
	__unsafe_unretained NSString *recordName;
} VoiceRecordersAttributes;

extern const struct VoiceRecordersRelationships {
	__unsafe_unretained NSString *idGeneralInfo;
} VoiceRecordersRelationships;

@class GeneralInfo;

@interface VoiceRecordersID : NSManagedObjectID {}
@end

@interface _VoiceRecorders : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) VoiceRecordersID* objectID;

@property (nonatomic, strong) NSString* fileUrl;

//- (BOOL)validateFileUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* recordName;

//- (BOOL)validateRecordName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) GeneralInfo *idGeneralInfo;

//- (BOOL)validateIdGeneralInfo:(id*)value_ error:(NSError**)error_;

@end

@interface _VoiceRecorders (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveFileUrl;
- (void)setPrimitiveFileUrl:(NSString*)value;

- (NSString*)primitiveRecordName;
- (void)setPrimitiveRecordName:(NSString*)value;

- (GeneralInfo*)primitiveIdGeneralInfo;
- (void)setPrimitiveIdGeneralInfo:(GeneralInfo*)value;

@end
