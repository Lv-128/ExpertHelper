//
//  EHSkillsProfilesParser.m
//  ExpertHelper
//
//  Created by Katolyk S. on 12/10/14.
//  Copyright (c) 2014 Katolyk S. All rights reserved.
//

#import "EHSkillsProfilesParser.h"

@implementation EHGroups

- (id)init
{
    self = [super init];
    if (self)
    {
        _skills = [NSArray array];
    }
    return self;
}

- (void)dealloc {
    self.skills = nil;
    self.nameOfSections = nil;
}

@end

@implementation EHSkill

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)setEstimate:(NSString *)estimate
{
    _estimate = estimate;
}

- (void)dealloc {
    self.estimate = nil;
    self.nameOfSkill = nil;
    self.comment = nil;
}

@end

@implementation EHGenInfo
- (id)init
{
    self = [super init];
    if (self)
    {
        _records = [NSArray array];
    }
    return self;
}

- (void)dealloc {
    self.expertName = nil;
    self.dateOfInterview = nil;
    self.competenceGroup = nil;
    self.typeOfProject = nil;
    self.techEnglish = nil;
    self.recommendations = nil;
    self.skillsSummary = nil;
    self.potentialCandidate = nil;
    self.levelEstimate = nil;
    self.records = nil;
}

@end


@implementation EHSkillsProfilesParser

- (id)initWithDataGroups:(NSArray *)groups andInterview:(InterviewAppointment *)interview andGenInfo:(EHGenInfo *)genInfo
{
    self = [super init];
    if(self)
    {
        _groups = groups;
        _interview = interview;
        _genInfo = genInfo;
        _externalInterview = interview.idExternal;
        EHAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        _managedObjectContext = [appDelegate managedObjectContext];
        
        if (groups != nil && genInfo != nil) {
            [self saveInfoToDB];
        }
    }
    return self;
}

- (GeneralInfo *)createGeneralInfoEntity
{
     NSManagedObjectContext *context = [self managedObjectContext];
    GeneralInfo *genInfo = [NSEntityDescription
                            insertNewObjectForEntityForName:[GeneralInfo entityName]
                            inManagedObjectContext:context];
    genInfo.competenceGroup = _genInfo.competenceGroup;
    genInfo.creatingDate = _genInfo.dateOfInterview;
    genInfo.expertName = _genInfo.expertName;
    
    NSNumber *hireResult;
    (_genInfo.hire) ? (hireResult = [NSNumber numberWithInt:1]) : (hireResult = 0);
    
    genInfo.hire = hireResult;
    genInfo.levelEstimate = _genInfo.levelEstimate;
    genInfo.potentialCandidate = _genInfo.potentialCandidate;
    genInfo.projectType = _genInfo.typeOfProject;
    genInfo.recommendations = _genInfo.recommendations;
    genInfo.skillsSummary = _genInfo.skillsSummary;
    genInfo.techEnglish = _genInfo.techEnglish;
    
    return genInfo;
}

- (void)saveInfoToDB
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    GeneralInfo *genInfo = [self createGeneralInfoEntity];
    genInfo.idExternalInterview = _interview.idExternal;
    _interview.idExternal = genInfo.idExternalInterview;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    for (int i = 0; i < _groups.count; i++)
    {
        Group *group;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[Group entityName]
                                                  inManagedObjectContext:context];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", [[_groups objectAtIndex:i]nameOfSections]];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
        
        if(fetchedObjects.count > 0)// we don't need this actually
        {
            group = fetchedObjects[0];
        }
        else
        {
            group = [NSEntityDescription
                     insertNewObjectForEntityForName:[Group entityName]
                     inManagedObjectContext:context];
            group.title = [[_groups objectAtIndex:i]nameOfSections];
        }
        
        for (EHSkill *skill in [_groups[i] skills])
        {
            Skills *curSkill = [NSEntityDescription
                                insertNewObjectForEntityForName:[Skills entityName]
                                inManagedObjectContext:context];
            curSkill.title = skill.nameOfSkill;
            SkillsLevels *skillLevel = [NSEntityDescription
                                        insertNewObjectForEntityForName:[SkillsLevels entityName]                                                                            inManagedObjectContext:context];
            skillLevel.comment = skill.comment;
            skillLevel.level = 0;//skill.estimate;
            
            skillLevel.idSkill = curSkill;
            curSkill.level = skillLevel;
            
            curSkill.idGroup = group;
            [group.allSkillsSet addObject:curSkill];
            curSkill.idExternalInterview = _interview.idExternal;
            [_interview.idExternal.skillsSet addObject:curSkill];
        }
    }
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[Group entityName]
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    if(fetchedObjects.count > 0)// we don't need this actually
    {
        for(Group *gr in fetchedObjects)
        {
            NSLog(@"%@", gr.title);
        }
    }
    
    entity = [NSEntityDescription entityForName:[Skills entityName]
                         inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    if(fetchedObjects.count > 0)// we don't need this actually
    {
        for(Group *gr in fetchedObjects)
        {
            NSLog(@"%@", gr.title);
        }
    }
}

@end
