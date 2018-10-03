//
//  TestGlobalApp.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-10.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestAsyncMatch : TestFixtureBase

@end

@implementation TestAsyncMatch

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCreateMatch
{
    NSString *matchId = [self createMatch:false];
    [self abandonMatch:matchId];
}

- (void)testAbandonMatch
{
    NSString *matchId = [self createMatch:false];
    [self abandonMatch:matchId];
}

- (void)testCompleteMatch
{
    NSString *matchId = [self createMatch:true];

    [[m_client asyncMatchService] completeMatch:[TestFixtureBase getUser:@"UserA"].m_profileId
                                        matchId:matchId
                                completionBlock:successBlock
                           errorCompletionBlock:failureBlock
                                       cbObject:nil];
    [self waitForResult];
}

- (void)testDeleteMatch
{
    NSString *matchId = [self createMatch:true];

    [[m_client asyncMatchService] deleteMatch:[TestFixtureBase getUser:@"UserA"].m_profileId
                                      matchId:matchId
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
}

- (void)testFindMatches
{
    [[m_client asyncMatchService] findMatches:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
}

- (void)testFindCompletedMatches
{
    [[m_client asyncMatchService] findCompleteMatches:successBlock
                                 errorCompletionBlock:failureBlock
                                             cbObject:nil];
    [self waitForResult];
}

- (void)testReadMatch
{
    NSString *matchId = [self createMatch:true];

    [[m_client asyncMatchService] readMatch:[TestFixtureBase getUser:@"UserA"].m_profileId
                                    matchId:matchId
                            completionBlock:successBlock
                       errorCompletionBlock:failureBlock
                                   cbObject:nil];
    [self waitForResult];
    [self abandonMatch:matchId];
}

- (void)testReadMatchHistory
{
    NSString *matchId = [self createMatch:true];

    [[m_client asyncMatchService] readMatchHistory:[TestFixtureBase getUser:@"UserA"].m_profileId
                                           matchId:matchId
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];
    [self abandonMatch:matchId];
}

- (void)testCreateMatchWithInitialTurn
{
    NSString *matchId = [self createMatch:true];
    [self abandonMatch:matchId];
}

- (void)testSubmitTurn
{
    NSString *matchId = [self createMatch:false];
    [[m_client asyncMatchService] submitTurn:[TestFixtureBase getUser:@"UserA"].m_profileId
                                     matchId:matchId
                                     version:0
                              jsonMatchState:@"{ \"map\":\"level1\" }"
                     pushNotificationMessage:@""
                                  nextPlayer:@""
                                 jsonSummary:@"{ \"summary\":\"test\" }"
                              jsonStatistics:@"{ \"summary\":\"test\" }"
                             completionBlock:successBlock
                        errorCompletionBlock:failureBlock
                                    cbObject:nil];
    [self waitForResult];
    [self abandonMatch:matchId];
}

- (void)testUpdateMatchSummaryData
{
    NSString *matchId = [self createMatch:false];
    [[m_client asyncMatchService]
        updateMatchSummaryData:[TestFixtureBase getUser:@"UserA"].m_profileId
                       matchId:matchId
                       version:0
                   jsonSummary:@"{ \"summary\":\"test\" }"
               completionBlock:successBlock
          errorCompletionBlock:failureBlock
                      cbObject:nil];
    [self waitForResult];
    [self abandonMatch:matchId];
}

/* Helper Methods */
- (NSString *)createMatch:(bool)withInitialTurn
{
    NSDictionary* player1 = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"BC", @"platform",
                             [TestFixtureBase getUser:@"UserB"].m_profileId, @"id", nil];
    
    NSArray* playerArray = [NSArray arrayWithObjects:player1, nil];
    
    NSString *playerArrayJson = [TestFixtureBase getJsonString:playerArray];

    if (!withInitialTurn)
    {
        [[m_client asyncMatchService] createMatch:playerArrayJson
                          pushNotificationMessage:@""
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    }
    else
    {
        [[m_client asyncMatchService] createMatchWithInitialTurn:playerArrayJson
                                                  jsonMatchState:@"{ \"map\":\"level1\" }"
                                         pushNotificationMessage:@""
                                                      nextPlayer:@""
                                                     jsonSummary:@"{ \"summary\":\"test\" }"
                                                 completionBlock:successBlock
                                            errorCompletionBlock:failureBlock
                                                        cbObject:nil];
    }

    [self waitForResult];
    NSData *data = [self.jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];

    return [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"matchId"];
}

- (void)abandonMatch:(NSString *)matchId
{
    [[m_client asyncMatchService] abandonMatch:[TestFixtureBase getUser:@"UserA"].m_profileId
                                       matchId:matchId
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];
}

@end
