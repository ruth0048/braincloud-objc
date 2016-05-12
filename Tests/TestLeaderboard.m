//
//  TestLeaderboard.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-10.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"
#include <time.h>

@interface TestLeaderboard : TestFixtureBase

@end

@implementation TestLeaderboard

NSString *globalLeaderboardId = @"testLeaderboard";
NSString *socialLeaderboardId = @"testSocialLeaderboard";
NSString *dynamicLeaderboardId = @"testDynamicLeaderboard";
NSString *eventId = @"tournamentRewardTest";

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testGetSocialLeaderboard
{
    [[m_client leaderboardService] getSocialLeaderboard:globalLeaderboardId
                                      replaceName:true
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
}

- (void)testGetMultiSocialLeaderboard
{
    [self testPostScoreToLeaderboard];
    [self testPostScoreToDynamicLeaderboard];
    NSArray * lbIds = [NSArray arrayWithObjects:globalLeaderboardId, dynamicLeaderboardId, nil];
    [[m_client leaderboardService] getMultiSocialLeaderboard:lbIds
                                      leaderboardResultCount:10
                                                 replaceName:true
                                             completionBlock:successBlock
                                        errorCompletionBlock:failureBlock
                                                    cbObject:nil];
    [self waitForResult];
}

- (void)testPostScoreToLeaderboard
{
    [[m_client leaderboardService] postScoreToLeaderboard:globalLeaderboardId
                                                    score:10
                                            jsonOtherData:@""
                                          completionBlock:successBlock
                                     errorCompletionBlock:failureBlock
                                                 cbObject:nil];
    [self waitForResult];
}

- (void)testResetLeaderboardScore
{
    [[m_client leaderboardService] resetLeaderboardScore:globalLeaderboardId
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testGetGlobalLeaderboardPage
{
    [[m_client leaderboardService] getGlobalLeaderboardPage:globalLeaderboardId
                                                  sortOrder:HIGH_TO_LOW
                                                 startIndex:0
                                                   endIndex:10
                                     includeLeaderboardSize:true
                                            completionBlock:successBlock
                                       errorCompletionBlock:failureBlock
                                                   cbObject:nil];
    [self waitForResult];
}

- (void)testGetCompletedLeaderboardTournament
{
    [[m_client leaderboardService] getCompletedLeaderboardTournament:socialLeaderboardId
                                                         replaceName:true
                                                     completionBlock:successBlock
                                                errorCompletionBlock:failureBlock
                                                            cbObject:nil];
    [self waitForResult];
}

- (void)testGetGlobalLeaderboardPageByVersion
{
    [[m_client leaderboardService] getGlobalLeaderboardPageByVersion:globalLeaderboardId
                                                           sortOrder:HIGH_TO_LOW
                                                          startIndex:0
                                                            endIndex:10
                                              includeLeaderboardSize:true
                                                           versionId:1
                                                     completionBlock:successBlock
                                                errorCompletionBlock:failureBlock
                                                            cbObject:nil];
    [self waitForResult];
}

- (void)testGetGlobalLeaderboardVersions
{
    [[m_client leaderboardService] getGlobalLeaderboardVersions:globalLeaderboardId
                                                completionBlock:successBlock
                                           errorCompletionBlock:failureBlock
                                                       cbObject:nil];
    [self waitForResult];
}

- (void)testGetGlobalLeaderboardView
{
    [[m_client leaderboardService] getGlobalLeaderboardView:globalLeaderboardId
                                                  sortOrder:LOW_TO_HIGH
                                                beforeCount:0
                                                 afterCount:10
                                     includeLeaderboardSize:true
                                            completionBlock:successBlock
                                       errorCompletionBlock:failureBlock
                                                   cbObject:nil];
    [self waitForResult];
}

- (void)testGetGlobalLeaderboardViewByVersion
{
    [[m_client leaderboardService] getGlobalLeaderboardViewByVersion:globalLeaderboardId
                                                           sortOrder:LOW_TO_HIGH
                                                         beforeCount:0
                                                          afterCount:10
                                              includeLeaderboardSize:true
                                                           versionId:1
                                                     completionBlock:successBlock
                                                errorCompletionBlock:failureBlock
                                                            cbObject:nil];
    [self waitForResult];
}

- (void)testTriggerSocialLeaderboardTournamentReward
{
    [[m_client leaderboardService] triggerSocialLeaderboardTournamentReward:socialLeaderboardId
                                                                  eventName:eventId
                                                            eventMultiplier:100
                                                            completionBlock:successBlock
                                                       errorCompletionBlock:failureBlock
                                                                   cbObject:nil];
    [self waitForResult];
}

- (void)testPostScoreToDynamicLeaderboard
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;

    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate =
        [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];

    [[m_client leaderboardService] postScoreToDynamicLeaderboard:dynamicLeaderboardId
                                                           score:100
                                                        jsonData:@""
                                                 leaderboardType:LOW_VALUE
                                                    rotationType:WEEKLY
                                                  roatationReset:nextDate
                                                   retainedCount:2
                                                 completionBlock:successBlock
                                            errorCompletionBlock:failureBlock
                                                        cbObject:nil];
    [self waitForResult];
}

- (void)testGetGroupSocialLeaderboard
{
    [[m_client groupService] createGroup:@"testGroup"
                               groupType:@"test"
                             isOpenGroup:NO
                                     acl:@""
                                jsonData:@""
                     jsonOwnerAttributes:@""
             jsonDefaultMemberAttributes:@""
                         completionBlock:successBlock
                    errorCompletionBlock:failureBlock
                                cbObject:nil];
    [self waitForResult];

    NSData *data = [self.jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObj =
    [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableContainers
                                      error:nil];

    NSString* groupId =
    [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"groupId"];

    [[m_client leaderboardService] getGroupSocialLeaderboard:socialLeaderboardId
                                                                  groupId:groupId
                                                            completionBlock:successBlock
                                                       errorCompletionBlock:failureBlock
                                                                   cbObject:nil];
    [self waitForResult];

    [[m_client groupService] deleteGroup:groupId
                                 version:-1
                         completionBlock:successBlock
                    errorCompletionBlock:failureBlock
                                cbObject:nil];
    [self waitForResult];
}

@end
