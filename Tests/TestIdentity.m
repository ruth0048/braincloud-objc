//
//  TestIdentity.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-10.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"
#import "AuthenticationTypeObjC.hh"

@interface TestIdentity : TestFixtureBase

@end

@implementation TestIdentity

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testSwitchToChildProfile
{
    [[m_client identityService] switchToChildProfile:nil
                                          childAppId:m_childAppId
                                         forceCreate:true
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
    
    [[m_client playerStateService] deletePlayer:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
}

- (void)testSwitchToSingletonChildProfile
{
    [[m_client identityService] switchToSingletonChildProfile:m_childAppId
                                         forceCreate:true
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
}

- (void)testSwitchToParentProfile
{
    [[m_client identityService] switchToSingletonChildProfile:m_childAppId
                                         forceCreate:true
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
    
    [[m_client identityService] switchToParentProfile:m_parentLevel
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
}

- (void)testGetChildProfiles
{
    [[m_client identityService] getChildProfiles:true
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
}

- (void)testGetIdentities
{
    [[m_client identityService] getIdentities:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
}

- (void)testGetExpiredIdentities
{
    [[m_client identityService] getExpiredIdentities:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
}

- (void)testRefreshIdentity
{
    [[m_client identityService] refreshIdentity:[TestFixtureBase getUser:@"UserA"].m_id
                            authenticationToken:[TestFixtureBase getUser:@"UserA"].m_password
                             authenticationType:[AuthenticationTypeObjc Universal]
                           completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForFailedResult];
}

@end
