//
//  TestGamification.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-12.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestGamification : TestFixtureBase

@end

@implementation TestGamification

NSString *achievementId01 = @"testAchievement01";
NSString *achievementId02 = @"testAchievement02";

NSString *userStatsCategory = @"playerStats";
NSString *milestonesCategory = @"Experience";
NSString *milestoneId = @"2";

NSString *questsCategory = @"Experience";

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testAwardAchievements
{
    NSArray* array = @[achievementId01, achievementId02];
    
    [[m_client gamificationService]
           awardAchievements:array
             completionBlock:successBlock
        errorCompletionBlock:failureBlock
                    cbObject:nil];
    [self waitForResult];
}

- (void)testReadAchievedAchievements
{
    [[m_client gamificationService] readAchievedAchievements:true
                                             completionBlock:successBlock
                                        errorCompletionBlock:failureBlock
                                                    cbObject:nil];
    [self waitForResult];
}

- (void)testReadAchievements
{
    [[m_client gamificationService] readAchievements:true
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
}

- (void)testReadMilestones
{
    [[m_client gamificationService] readMilestones:true
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];
}

- (void)testReadCompletedMilestones
{
    [[m_client gamificationService] readCompletedMilestones:true
                                            completionBlock:successBlock
                                       errorCompletionBlock:failureBlock
                                                   cbObject:nil];
    [self waitForResult];
}

- (void)testReadInProgressMilestones
{
    [[m_client gamificationService] readInProgressMilestones:true
                                             completionBlock:successBlock
                                        errorCompletionBlock:failureBlock
                                                    cbObject:nil];
    [self waitForResult];
}

- (void)testReadMilestonesByCategory
{
    [[m_client gamificationService] readMilestonesByCategory:milestonesCategory
                                             includeMetaData:true
                                             completionBlock:successBlock
                                        errorCompletionBlock:failureBlock
                                                    cbObject:nil];
    [self waitForResult];
}

- (void)testResetMilestones
{
    NSArray* array = @[milestoneId];
    [[m_client gamificationService] resetMilestones:array
                                    completionBlock:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForResult];
}

- (void)testReadQuests
{
    [[m_client gamificationService] readQuests:true
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];
}

- (void)testReadCompletedQuests
{
    [[m_client gamificationService] readCompletedQuests:true
                                        completionBlock:successBlock
                                   errorCompletionBlock:failureBlock
                                               cbObject:nil];
    [self waitForResult];
}

- (void)testReadNotStartedQuests
{
    [[m_client gamificationService] readNotStartedQuests:true
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testReadInProgressQuests
{
    [[m_client gamificationService] readInProgressQuests:true
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testReadQuestsByCategory
{
    [[m_client gamificationService] readQuestsByCategory:questsCategory
                                         includeMetaData:true
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testReadQuestsWithBasicPercentage
{
    [[m_client gamificationService] readQuestsWithBasicPercentage:true
                                                  completionBlock:successBlock
                                             errorCompletionBlock:failureBlock
                                                         cbObject:nil];
    [self waitForResult];
}

- (void)testReadQuestsWithComplexPercentage
{
    [[m_client gamificationService] readQuestsWithComplexPercentage:true
                                                    completionBlock:successBlock
                                               errorCompletionBlock:failureBlock
                                                           cbObject:nil];
    [self waitForResult];
}

- (void)testReadQuestsWithStatus
{
    [[m_client gamificationService] readQuestsWithStatus:true
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testReadXpLevelsMetaData
{
    [[m_client gamificationService] readXpLevelsMetaData:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testReadAllGamification
{
    [[m_client gamificationService] readAllGamification:true
                                        completionBlock:successBlock
                                   errorCompletionBlock:failureBlock
                                               cbObject:nil];
    [self waitForResult];
}

@end
