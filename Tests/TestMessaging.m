//
//  TestMessaging.m
//  BrainCloud-iOS
//
//  Created by Ryan Ruth on 2018-10-30.
//  Copyright © 2018 BitHeads Inc. All rights reserved.
//


#import "TestFixtureBase.h"
#include <time.h>

@interface TestMessaging : TestFixtureBase

@end

@implementation TestMessaging

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testDeleteMessages
{
    NSArray* msgIds = @[@"Id"];
    
    [[m_client messagingService] deleteMessages:@"inbox"
                                         msgIds:msgIds
                                completionBlock:successBlock
                           errorCompletionBlock:failureBlock
                                       cbObject:nil];
    [self waitForResult];
}

- (void)testGetMessageBoxes
{
    [[m_client messagingService] getMessageBoxes:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];
}

- (void)testGetMessageCounts
{
    [[m_client messagingService] getMessageCounts:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
}

- (void)testGetMessages
{
    NSArray* msgIds = @[@"invalidId"];
    
    [[m_client messagingService] getMessages:@"inbox"
                                      msgIds:msgIds
                                  markAsRead:true
                             completionBlock:successBlock
                        errorCompletionBlock:failureBlock
                                    cbObject:nil];
    [self waitForFailedResult];
}

- (void)testGetMessagesPage
{
    [[m_client messagingService] getMessagesPage:@"InvalidContext"
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForFailedResult];
}

- (void)testGetMessagesPageOffset
{
    [[m_client messagingService] getMessagesPageOffset:@"invalidContext"
                                            pageOffset:1
                                       completionBlock:successBlock
                                  errorCompletionBlock:failureBlock
                                              cbObject:nil];
    [self waitForFailedResult];
}

- (void)testSendMessage
{
    NSString* contentJson = @"{ \"subject\": \"Chat and messaging features are here!\", \"text\": \"hi.\"}";
    NSString* profileId = [[m_client authenticationService] profileID];
    NSArray* profileArray = [NSArray arrayWithObjects:profileId, nil];
    
    [[m_client messagingService] sendMessage:profileArray
                                 contentJson:contentJson
                             completionBlock:successBlock
                        errorCompletionBlock:failureBlock
                                    cbObject:nil];
    [self waitForResult];
}

- (void)testSendMessageSimple
{
    NSString* profileId = [[m_client authenticationService] profileID];
    NSArray* profileArray = [NSArray arrayWithObjects:profileId, nil];
    
    [[m_client messagingService] sendMessageSimple:profileArray
                                       messageText:@"this is text"
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];
}

- (void)testMarkMessagesRead
{
    NSString* id = @"Id";
    NSArray* msgId = [NSArray arrayWithObjects:id, nil];
    
    [[m_client messagingService] markMessagesRead:@"inbox"
                                           msgIds:msgId
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
}


@end
