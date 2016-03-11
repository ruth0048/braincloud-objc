//
//  TestMatchMaking.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-11.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestMatchMaking : TestFixtureBase

@end

@implementation TestMatchMaking

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testRead
{
    [[m_client matchMakingService] read:successBlock
                   errorCompletionBlock:failureBlock
                               cbObject:nil];
    [self waitForResult];
}

- (void)testSetPlayerRating
{
    [[m_client matchMakingService] setPlayerRating:10
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];
}

- (void)testIncrementPlayerRating
{
    [[m_client matchMakingService] incrementPlayerRating:10
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testDecrementPlayerRating
{
    [[m_client matchMakingService] decrementPlayerRating:10
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testTurnShieldOn
{
    [[m_client matchMakingService] turnShieldOn:successBlock
                           errorCompletionBlock:failureBlock
                                       cbObject:nil];
    [self waitForResult];
}

- (void)testTurnShieldOnFor
{
    [[m_client matchMakingService] turnShieldOnFor:10
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];
}

- (void)testTurnShieldOff
{
    [[m_client matchMakingService] turnShieldOff:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
}

- (void)testGetShieldExpiry
{
    [[m_client matchMakingService] getShieldExpiry:[TestFixtureBase getUser:@"UserA"].m_profileId
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];
}

- (void)testFindPlayers
{
    [[m_client matchMakingService] findPlayers:10
                                         numMatches:5
                                    completionBlock:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForResult];
}

- (void)testFindPlayersUsingFilter
{
    [[m_client matchMakingService] findPlayersUsingFilter:10
                                                   numMatches:5
                                              jsonExtraParams:@""
                                              completionBlock:successBlock
                                         errorCompletionBlock:failureBlock
                                                     cbObject:nil];
    [self waitForResult];
}

@end
