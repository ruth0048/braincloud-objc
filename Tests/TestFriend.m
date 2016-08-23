//
//  TestFriend.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-10.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "FriendPlatformObjc.hh"
#import "TestFixtureBase.h"

@interface TestFriend : TestFixtureBase

@end

@implementation TestFriend

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testFindPlayerByName
{
    [[m_client friendService] findPlayerByName:@"name"
                                    maxResults:10
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];
}

- (void)testFindUsersByExactName
{
    [[m_client friendService] findUsersByExactName:@"name"
                                    maxResults:10
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];
}

- (void)testFindUsersBySubstrName
{
    [[m_client friendService] findUsersBySubstrName:@"name"
                                    maxResults:10
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];
}

- (void)testGetExternalIdForProfileId
{
    [[m_client friendService] getExternalIdForProfileId:[TestFixtureBase getUser:@"UserA"].m_profileId
                                     authenticationType:@"Facebook"
                                        completionBlock:successBlock
                                   errorCompletionBlock:failureBlock
                                               cbObject:nil];
    [self waitForResult];
}

- (void)testGetSummaryDataForProfileId
{
    [[m_client friendService] getSummaryDataForProfileId:[TestFixtureBase getUser:@"UserA"].m_profileId
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testFindPlayerByUniversalId
{
    [[m_client friendService] findPlayerByUniversalId:@"name"
                                           maxResults:10
                                      completionBlock:successBlock
                                 errorCompletionBlock:failureBlock
                                             cbObject:nil];
    [self waitForResult];
}

- (void)testListFriends
{
    [self addFriend];

    [[m_client friendService] listFriends:[FriendPlatformObjc All]
                       includeSummaryData:false
                          completionBlock:successBlock
                     errorCompletionBlock:failureBlock
                                 cbObject:nil];
    [self waitForResult];
}

- (void)testAddFriends { [self addFriend]; }

- (void)testRemoveFriends
{
    [self addFriend];

    NSArray *array = @[ [TestFixtureBase getUser:@"UserB"].m_profileId ];
    [[m_client friendService] removeFriends:array
                            completionBlock:successBlock
                       errorCompletionBlock:failureBlock
                                   cbObject:nil];
    [self waitForResult];
}

- (void)testGetUsersOnlineStatus
{
    NSArray *array = @[ [TestFixtureBase getUser:@"UserB"].m_profileId ];
    [[m_client friendService] getUsersOnlineStatus:array
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];
}

// Helpers

- (void)addFriend
{
    NSArray *array = @[ [TestFixtureBase getUser:@"UserB"].m_profileId ];

    [[m_client friendService] addFriends:array
                         completionBlock:successBlock
                    errorCompletionBlock:failureBlock
                                cbObject:nil];
    [self waitForResult];
}

@end
