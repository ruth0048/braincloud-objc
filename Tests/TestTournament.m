//
//  TestTournament.m
//  BrainCloud
//
//  Created by Bradley Hill on 2017-01-06.
//  Copyright © 2017 BitHeads Inc. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestTournament : TestFixtureBase

@end

@implementation TestTournament

NSString *_tournamentCode = @"testTournament";
NSString *_leaderboardId = @"testTournamentLeaderboard";
NSString *_divSetId = @"testDivSetId";
NSString *_invalidId = @"Invalid_Id";

BOOL _didJoin = false;

- (void)setUp { [super setUp]; }

- (void)tearDown
{
    if (_didJoin) [self leaveTournament];
    [super tearDown];
}

- (void)testClaimTournamentReward
{
    int version = [self joinTournament];

    [[m_client tournamentService] claimTournamentReward:_leaderboardId
                                              versionId:version
                                        completionBlock:successBlock
                                   errorCompletionBlock:failureBlock
                                               cbObject:nil];
    [self waitForFailedResult];
}

- (void)testGetTournamentStatus
{
    int version = [self joinTournament];

    [[m_client tournamentService] getTournamentStatus:_leaderboardId
                                            versionId:version
                                      completionBlock:successBlock
                                 errorCompletionBlock:failureBlock
                                             cbObject:nil];
    [self waitForResult];
}

- (void)testGetDivisionInfo
{
    [[m_client tournamentService] getDivisionInfo:_invalidId
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForFailedResult];
}

- (void)testGetMyDivisions
{
    [[m_client tournamentService] getMyDivisions:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
}

- (void)testJoinDivision
{
    [[m_client tournamentService] joinDivision:_invalidId
                                tournamentCode:_tournamentCode
                                  initialScore:0
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForFailedResult];
}

- (void)testLeaveDivisionInstance
{
    [[m_client tournamentService] getDivisionInfo:_invalidId
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForFailedResult];
}

- (void)testJoinTournament { [self joinTournament]; }

- (void)testLeaveTournament
{
    [self joinTournament];
    [self leaveTournament];
}

- (void)testPostTournamentScore
{
    [self joinTournament];

    [[m_client tournamentService] postTournamentScore:_leaderboardId
                                                score:200
                                             jsonData:nil
                                     roundStartedTime:[NSDate date]
                                      completionBlock:successBlock
                                 errorCompletionBlock:failureBlock
                                             cbObject:nil];
    [self waitForResult];
}

- (void)testPostTournamentScoreWithResults
{
    [self joinTournament];

    [[m_client tournamentService] postTournamentScoreWithResults:_leaderboardId
                                                           score:200
                                                        jsonData:nil
                                                roundStartedTime:[NSDate date]
                                                       sortOrder:HIGH_TO_LOW
                                                     beforeCount:10
                                                      afterCount:10
                                                    initialScore:0
                                                 completionBlock:successBlock
                                            errorCompletionBlock:failureBlock
                                                        cbObject:nil];
    [self waitForResult];
}

- (void)testViewCurrentReward
{
    [self joinTournament];

    [[m_client tournamentService] viewCurrentReward:_leaderboardId
                                    completionBlock:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForResult];
}

- (void)testViewReward
{
    [self joinTournament];

    [[m_client tournamentService] viewReward:_leaderboardId
                                   versionId:-1
                             completionBlock:successBlock
                        errorCompletionBlock:failureBlock
                                    cbObject:nil];
    [self waitForFailedResult];
}

- (int)joinTournament
{
    [[m_client tournamentService] joinTournament:_leaderboardId
                                  tournamentCode:_tournamentCode
                                    initialScore:100
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
    _didJoin = true;

    NSDictionary *jsonObj = [TestFixtureBase getDataFromResponse:self.jsonResponse];
    
    
    int versionId = (int)[[jsonObj objectForKey:@"versionId"] intValue];
    return versionId;
}

- (void)leaveTournament
{
    [[m_client tournamentService] leaveTournament:_leaderboardId
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
    _didJoin = false;
}

@end
