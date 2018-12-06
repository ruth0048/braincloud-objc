//
//  TestChat.m
//  BrainCloud-iOS
//
//  Created by Ryan Ruth on 2018-11-07.
//  Copyright © 2018 BitHeads Inc. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestChat : TestFixtureBase

@end

@implementation TestChat

- (bool)authenticateOnSetup { return false; }

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }


- (void)testChannelConnect
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    NSString* _channelId =@"20001:gl:valid";
    
    [[m_client chatService] channelConnect:_channelId
                                 maxReturn:10
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

- (void)testChannelDisconnect
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    NSString* _channelId =@"20001:gl:valid";
    
    [[m_client chatService] channelConnect:_channelId
                                 maxReturn:10
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

- (void)testdeleteChatMessage
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    NSString* _channelId = @"20001:gl:valid";
    NSString* _msgId = @"123456";
    
    [[m_client chatService] deleteChatMessage:_channelId
                                     peerCode:_msgId
                                      version:1
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
}

- (void)testGetChannelId
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    NSString* _channelType =@"gl";
    NSString* _channelSubId =@"valid";
    
    [[m_client chatService] getChannelId:_channelType
                            channelSubId:_channelSubId
                         completionBlock:successBlock
                    errorCompletionBlock:failureBlock
                                cbObject:nil];
    [self waitForResult];
}

- (void)testGetChannelInfo
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    NSString* _channelId = @"20001:gl:valid";
    
    [[m_client chatService] getChannelInfo:_channelId
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

- (void)testGetChatMessage
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    NSString* _channelId = @"20001:gl:valid";
    NSString* _msgId = @"789217398211996";
    
    [[m_client chatService] getChatMessage:_channelId
                                     msgId:_msgId
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

- (void)testGetRecentChatMessages
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    NSString* _channelId = @"20001:gl:valid";

    [[m_client chatService] getRecentChatMessages:_channelId
                                        maxReturn:10
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
}

- (void)testGetSubscribedChannels
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    NSString* _channelType =@"gl";
    
    [[m_client chatService] getSubscribedChannels:_channelType
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
}

- (void)testPostChatMessageSimple
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    NSString* _channelId = @"20001:gl:valid";
    NSString* _text =@"testPost";
    
    [[m_client chatService] postChatMessageSimple:_channelId
                                             text:_text
                                  recordInHistory:true
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
}

- (void)testPostChatMessage
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    NSString* _channelId = @"20001:gl:valid";
    NSString* _jsonRich = @"{\"content\":\"test\"}";
    
    [[m_client chatService] postChatMessage:_channelId
                                    content:_jsonRich
                            recordInHistory:true
                            completionBlock:successBlock
                       errorCompletionBlock:failureBlock
                                   cbObject:nil];
    [self waitForResult];
}

- (void)testUpdateChatMessage
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    [[m_client chatService] updateChatMessage:@"20001:gl:valid"
                                        msgId:@"123456"
                                      version:1
                                  jsonContent:@"{\"text\":\"edited message\"}"
                              completionBlock:successBlock
                        errorCompletionBlock:failureBlock
                                     cbObject:nil];
    
    [self waitForResult];
}

@end
