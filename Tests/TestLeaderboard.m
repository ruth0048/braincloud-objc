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
NSString *groupLeaderboardId = @"groupLeaderboardConfig";
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

- (void)testGetSocialLeaderboardByVersion
{
    [[m_client leaderboardService] getSocialLeaderboardByVersion:globalLeaderboardId
                                                     replaceName:true
                                                       versionId:0
                                                 completionBlock:successBlock
                                            errorCompletionBlock:failureBlock
                                                        cbObject:nil];
    [self waitForResult];
}

- (void)testGetMultiSocialLeaderboard
{
    [self testPostScoreToLeaderboard];
    [self testPostScoreToDynamicLeaderboard];
    NSArray *lbIds = [NSArray arrayWithObjects:globalLeaderboardId, dynamicLeaderboardId, nil];
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

- (void)testGetGlobalLeaderboardPage
{
    [[m_client leaderboardService] getGlobalLeaderboardPage:globalLeaderboardId
                                                  sortOrder:HIGH_TO_LOW
                                                 startIndex:0
                                                   endIndex:10
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
                                                           versionId:1
                                                     completionBlock:successBlock
                                                errorCompletionBlock:failureBlock
                                                            cbObject:nil];
    [self waitForResult];
}

- (void)getGlobalLeaderboardEntryCount
{
    [[m_client leaderboardService] getGlobalLeaderboardEntryCount:globalLeaderboardId
                                                  completionBlock:successBlock
                                             errorCompletionBlock:failureBlock
                                                         cbObject:nil];
    [self waitForResult];
}

- (void)getGlobalLeaderboardEntryCountByVersion
{
    [[m_client leaderboardService] getGlobalLeaderboardEntryCountByVersion:globalLeaderboardId
                                                                 versionId:1
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
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];

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

- (void)testPostScoreToDynamicLeaderboardDays
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;

    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    NSString *name = [NSString stringWithFormat:@"%@Days_%d", dynamicLeaderboardId, arc4random_uniform(1000000)];

    [[m_client leaderboardService] postScoreToDynamicLeaderboardDays:name
                                                               score:100
                                                            jsonData:@""
                                                     leaderboardType:LOW_VALUE
                                                      roatationReset:nextDate
                                                       retainedCount:2
                                                     numDaysToRotate:3
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
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    NSString *groupId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"groupId"];

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

- (void)testGetGroupSocialLeaderboardByVersion
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
    [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *groupId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"groupId"];
    
    [[m_client leaderboardService] getGroupSocialLeaderboardByVersion:socialLeaderboardId
                                                              groupId:groupId
                                                            versionId:0
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

- (void)testGetPlayersSocialLeaderboard
{
    [[m_client leaderboardService] getPlayersSocialLeaderboard:socialLeaderboardId
                                                    profileIds:@[ [TestFixtureBase getUser:@"UserB"].m_profileId ]
                                               completionBlock:successBlock
                                          errorCompletionBlock:failureBlock
                                                      cbObject:nil];
    [self waitForResult];
}

- (void)testGetPlayersSocialLeaderboardByVersion
{
    [[m_client leaderboardService] getPlayersSocialLeaderboardByVersion:socialLeaderboardId
                                                             profileIds:@[ [TestFixtureBase getUser:@"UserB"].m_profileId ]
                                                              versionId:0
                                                        completionBlock:successBlock
                                                   errorCompletionBlock:failureBlock
                                                               cbObject:nil];
    [self waitForResult];
}

- (void)testListAllLeaderboards
{
    [[m_client leaderboardService] listAllLeaderboards:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];
}

- (void)testRemovePlayerScore
{
    [[m_client leaderboardService] removePlayerScore:socialLeaderboardId
                                           versionId:-1
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
}

- (void)testGetPlayerScore
{
    [[m_client leaderboardService] postScoreToLeaderboard:globalLeaderboardId
                                                    score:1023
                                            jsonOtherData:@""
                                          completionBlock:successBlock
                                     errorCompletionBlock:failureBlock
                                                 cbObject:nil];
    [self waitForResult];

    [[m_client leaderboardService] getPlayerScore:globalLeaderboardId
                                        versionId:-1
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
}

- (void)testGetPlayerScoresFromLeaderboards
{
    [[m_client leaderboardService] getPlayerScoresFromLeaderboards:@[ socialLeaderboardId ]
                                                   completionBlock:successBlock
                                              errorCompletionBlock:failureBlock
                                                          cbObject:nil];
    [self waitForResult];
}

- (void)testPostScoreToGroupLeaderboard
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
    [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *groupId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"groupId"];
    
    [[m_client leaderboardService] postScoreToGroupLeaderboard:groupLeaderboardId
                                                       groupId:groupId
                                                         score:100
                                                      jsonData:@""
                                                   completionBlock:successBlock
                                              errorCompletionBlock:failureBlock
                                                          cbObject:nil];
    [self waitForResult];
}

- (void)testPostScoreToDynamicGroupLeaderboard
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
    [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *groupId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"groupId"];
    
    [[m_client leaderboardService] postScoreToDynamicGroupLeaderboard:groupLeaderboardId
                                                              groupId:groupId
                                                                score:100
                                                             jsonData:@""
                                                      leaderboardType:@"HIGH_VALUE"
                                                         rotationType:@"WEEKLY"
                                                    rotationResetTime:15708182
                                                        retainedCount:2
                                               completionBlock:successBlock
                                          errorCompletionBlock:failureBlock
                                                      cbObject:nil];
    [self waitForResult];
}

- (void)testRemoveGroupScore
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
    [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *groupId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"groupId"];
    
    [[m_client leaderboardService] removeGroupScore:groupLeaderboardId
                                            groupId:groupId
                                          versionId:-1
                                    completionBlock:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForResult];
}

- (void)testGetGroupLeaderboardView
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
    [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *groupId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"groupId"];
    
    [[m_client leaderboardService] getGroupLeaderboardView:groupLeaderboardId
                                                   groupId:groupId
                                                      sort:HIGH_TO_LOW
                                               beforeCount:5
                                                afterCount:5
                                           completionBlock:successBlock
                                      errorCompletionBlock:failureBlock
                                              cbObject:nil];
    [self waitForResult];
}

- (void)testGetGroupLeaderboardViewByVersion
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
    [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSString *groupId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"groupId"];
    
    [[m_client leaderboardService] getGroupLeaderboardViewByVersion:groupLeaderboardId
                                                            groupId:groupId
                                                          versionId:-1
                                                               sort:HIGH_TO_LOW
                                                        beforeCount:5
                                                         afterCount:5
                                                    completionBlock:successBlock
                                               errorCompletionBlock:failureBlock
                                                           cbObject:nil];
    [self waitForResult];
}

@end
