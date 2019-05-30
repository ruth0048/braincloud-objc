//
//  TestLobby.m
//  BrainCloud-iOS
//
//  Created by Ryan Ruth on 2018-11-07.
//  Copyright © 2018 BitHeads Inc. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestLobby : TestFixtureBase

@end

@implementation TestLobby

- (bool)authenticateOnSetup { return false; }

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testCreateLobby
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
    
    NSString* _lobbyType = @"MATCH_UNRANKED";
    NSArray* _otherUserCxIds = @[];
    NSString* _extraJson = @"{}";
    NSString* _settings = @"{}";
    NSString* _teamCode = @"all";
    
    [[m_client lobbyService] createLobby:_lobbyType
                                 rating:0
                         otherUserCxIds:_otherUserCxIds
                                isReady:false
                              extraJson:_extraJson
                               teamCode:_teamCode
                               settings:_settings
                        completionBlock:successBlock
                   errorCompletionBlock:failureBlock
                               cbObject:nil];
    [self waitForResult];
}

- (void)testFindLobby
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
    
    NSString* _lobbyType = @"MATCH_UNRANKED";
    NSArray* _otherUserCxIds = @[];
    NSString* _extraJson = @"{}";
    NSString* _settings = @"{}";
    NSString* _teamCode = @"all";
    NSString* _algo = @"{\"strategy\":\"ranged-absolute\",\"alignment\":\"center\",\"ranges\":[1000]}";
    NSString* _filterJson = @"{}";
    
    [[m_client lobbyService] findLobby:_lobbyType
                               rating:0
                             maxSteps:1
                                 algo:_algo
                           filterJson:_filterJson
                       otherUserCxIds:_otherUserCxIds
                              isReady:true
                            extraJson:_extraJson
                             teamCode:_teamCode
                      completionBlock:successBlock
                 errorCompletionBlock:failureBlock
                             cbObject:nil];
    [self waitForResult];
}

- (void)testFindOrCreateLobby
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
    
    NSString* _lobbyType = @"MATCH_UNRANKED";
    NSArray* _otherUserCxIds = @[];
    NSString* _extraJson = @"{}";
    NSString* _settings = @"{}";
    NSString* _teamCode = @"all";
    NSString* _algo = @"{\"strategy\":\"ranged-absolute\",\"alignment\":\"center\",\"ranges\":[1000]}";
    NSString* _filterJson = @"{}";
    
    [[m_client lobbyService] findOrCreateLobby:_lobbyType
                                        rating:0
                                      maxSteps:1
                                          algo:_algo
                                    filterJson:_filterJson
                                otherUserCxIds:_otherUserCxIds
                                       isReady:true
                                     extraJson:_extraJson
                                      teamCode:_teamCode
                                      settings:_settings
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];
}

- (void)testGetLobbyData
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
    
    [[m_client lobbyService] getLobbyData:@"badLobbyId"
                          completionBlock:successBlock
                     errorCompletionBlock:failureBlock
                                 cbObject:nil];
    [self waitForFailedResult];
}

- (void)testLeaveLobby
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
    
    [[m_client lobbyService] leaveLobby:@"badLobbyId"
                       completionBlock:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForFailedResult];
}

- (void)testRemoveMember
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
    
    [[m_client lobbyService] removeMember:@"badLobbyId"
                                    cxId:@"wrongId"
                         completionBlock:successBlock
                    errorCompletionBlock:failureBlock
                                cbObject:nil];
    [self waitForFailedResult];
}

- (void)testSendSignals
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
    
    [[m_client lobbyService] sendSignal:@"badLobbyId"
                             signalData:@"{\"message\":\"test\"}"
                        completionBlock:successBlock
                   errorCompletionBlock:failureBlock
                               cbObject:nil];
    [self waitForFailedResult];
}

- (void)testSwitchTeam
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
    
    [[m_client lobbyService] switchTeam:@"badLobbyId"
                               teamCode:@"all"
                        completionBlock:successBlock
                   errorCompletionBlock:failureBlock
                               cbObject:nil];
    [self waitForFailedResult];
}

- (void)testUpdateReady
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
    
    [[m_client lobbyService] updateReady:@"badLobbyId"
                                 isReady:true
                               extraJson:@"{}"
                         completionBlock:successBlock
                    errorCompletionBlock:failureBlock
                                cbObject:nil];
    [self waitForFailedResult];
}

- (void)testUpdateSettings
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
    
    [[m_client lobbyService]updateSettings:@"badLobbyId"
                                  settings:@"{}"
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForFailedResult];
}

- (void)testJoinLobby
{
    NSString* id = @"Id";
    NSArray* ids = [NSArray arrayWithObjects:id, nil];
    //expect bad lobby
    [[m_client lobbyService]joinLobby:@"badLobbyId"
                              isReady:true
                            extraJson:@"{}"
                             teamCode:@"red"
                       otherUserCxIds:ids
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForFailedResult];
}

@end
