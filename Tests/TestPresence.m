//
//  TestPresence.m
//  BrainCloud
//
//  Created by Ryan Ruth on 2018-09-13.
//  Copyright © 2018 BitHeads Inc. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestPresence : TestFixtureBase

@end

@implementation TestPresence

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }


- (void)testForcePush
{
    [[m_client presenceService] forcePush:successBlock
                     errorCompletionBlock:failureBlock
                                 cbObject:nil];
    [self waitForResult];
}

- (void)testGetPresenceOfFriends
{
    [[m_client presenceService] getPresenceOfFriends:@"brainCloud"
                                      includeOffline:true
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
}

- (void)testGetPresenceOfGroup
{
    [[m_client presenceService] getPresenceOfGroup:@"_invalidId"
                                    includeOffline:true
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForFailedResult];
}

- (void)testGetPresenceOfUsers
{
    NSArray * array = @[@"user1", @"user2"];
    
    [[m_client presenceService] getPresenceOfUsers:array
                                    includeOffline:true
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];
}

- (void)testRegisterListenersForFriends
{
    [[m_client presenceService] registerListenersForFriends:@"brainCloud"
                                              bidirectional:true
                                            completionBlock:successBlock
                                       errorCompletionBlock:failureBlock
                                                   cbObject:nil];
    [self waitForResult];
}

- (void)testRegsiterListenersForGroup
{
    [[m_client presenceService] registerListenersForGroup:@"brainCloud"
                                            bidirectional:true
                                          completionBlock:successBlock
                                     errorCompletionBlock:failureBlock
                                                 cbObject:nil];
    //no group exists
    [self waitForFailedResult];
}

- (void)testRegisterListenersForProfiles
{
    NSArray * array = @[@"user1", @"user2"];
    
    [[m_client presenceService] registerListenersForProfiles:array
                                               bidirectional:true
                                             completionBlock:successBlock
                                        errorCompletionBlock:failureBlock
                                                    cbObject:nil];
    [self waitForResult];
}

- (void)testSetVisibility
{
    [[m_client presenceService] setVisibility:true
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForFailedResult];
}

- (void)testStopListening
{
    [[m_client presenceService] stopListening:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForFailedResult];
}

- (void)testUpdateActivity
{
    [[m_client presenceService] updateActivity:@"_invalidId"
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForFailedResult];
}

@end
