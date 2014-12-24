// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to QuickComment.h instead.

#import <CoreData/CoreData.h>

extern const struct QuickCommentAttributes {
	__unsafe_unretained NSString *comment;
} QuickCommentAttributes;

@interface QuickCommentID : NSManagedObjectID {}
@end

@interface _QuickComment : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) QuickCommentID* objectID;

@property (nonatomic, strong) NSString* comment;

//- (BOOL)validateComment:(id*)value_ error:(NSError**)error_;

@end

@interface _QuickComment (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveComment;
- (void)setPrimitiveComment:(NSString*)value;

@end
