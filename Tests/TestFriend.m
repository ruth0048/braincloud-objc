//
//  TestFriend.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-10.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

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

- (void)testGetExternalIdForProfileId
{
    [[m_client friendService] getExternalIdForProfileId:[TestFixtureBase getUser:@"UserA"].m_profileId
                                    authenticationType:@"Facebook"
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];
}

@end
