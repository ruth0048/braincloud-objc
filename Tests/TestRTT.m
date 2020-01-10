//
//  TestRTT.m
//  BrainCloud
//
//  Created by David St-Louis on 2020-01-07.
//  Copyright © 2020 BitHeads Inc. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestRTT : TestFixtureBase

@end

@implementation TestRTT

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testRTTRegisterWithoutEnableRTT
{
    // Register for RTT event
    [[m_client rttService] registerRTTEventCallback:rttEventBlock cbObject:nil];

    // Enable
    [[m_client rttService]
     enableRTT:NO
     successCompletionBlock:rttConnectSuccessBlock
     failureCompletionBlock:rttConnectFailureBlock
     cbObject:nil];
    [self waitForResult];
    
    // Send an event
    NSString* profileId = [TestFixtureBase getUser:@"UserA"].m_profileId;
    [[m_client eventService] sendEvent:profileId
                             eventType:@"test"
                         jsonEventData:@"{\"testData\":42}"
                       completionBlock:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForResultExpectedCount:2];
}

- (void)testRequestClientConnection
{
    [[m_client rttService]
     requestClientConnection:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];

    [self waitForResult];
}

- (void)testEnableDisableRTTWithTCP
{
    // Disable RTT
    [[m_client rttService] disableRTT];

    // Enable RTT
    [[m_client rttService]
     enableRTT:NO
     successCompletionBlock:rttConnectSuccessBlock
     failureCompletionBlock:rttConnectFailureBlock
     cbObject:nil];
    [self waitForResult];
}

- (void)testEnableDisableRTTWithWS
{
    // Disable RTT
    [[m_client rttService] disableRTT];

    // Enable RTT
    [[m_client rttService]
        enableRTT:YES
        successCompletionBlock:rttConnectSuccessBlock
        failureCompletionBlock:rttConnectFailureBlock
        cbObject:nil];
    [self waitForResult];
}

- (void)testChatCallback
{
    // Enable RTT
    [[m_client rttService]
        enableRTT:rttConnectSuccessBlock
        failureCompletionBlock:rttConnectFailureBlock
        cbObject:nil];
    [self waitForResult];

    // Get channel Id
    [[m_client chatService] getChannelId:@"gl"
                            channelSubId:@"valid"
                         completionBlock:successBlock
                    errorCompletionBlock:failureBlock
                                cbObject:nil];
    [self waitForResult];
    NSData *data = [self.jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
    NSString* channelId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"channelId"];

    // Connect to channel
    [[m_client chatService] channelConnect:channelId
                                 maxReturn:50
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];

    // Register for RTT chat
    [[m_client rttService] registerRTTChatCallback:rttEventBlock cbObject:nil];

    // Send a chat message
    [[m_client chatService] postChatMessageSimple:channelId
                                             text:@"Unit test message"
                                  recordInHistory:true
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResultExpectedCount:2];
}

- (void)testLobbyCallback
{
    // Enable RTT
    [[m_client rttService]
        enableRTT:rttConnectSuccessBlock
        failureCompletionBlock:rttConnectFailureBlock
        cbObject:nil];
    [self waitForResult];

    // Register for RTT lobby
    [[m_client rttService] registerRTTLobbyCallback:rttEventBlock cbObject:nil];

    // Create a lobby
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
    [self waitForResultExpectedCount:2];
}

@end
