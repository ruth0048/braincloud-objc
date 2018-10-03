//
//  TestIdentity.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-10.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"
#import "AuthenticationTypeObjc.hh"

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

    [[m_client playerStateService] deleteUser:successBlock errorCompletionBlock:failureBlock cbObject:nil];
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
    [self goToChildProfile];

    [[m_client identityService] switchToParentProfile:m_parentLevel
                                      completionBlock:successBlock
                                 errorCompletionBlock:failureBlock
                                             cbObject:nil];
    [self waitForResult];
}

- (void)testAttachParentWithIdentity
{
    [self goToChildProfile];

    [[m_client identityService] detachParent:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];

    TestUser *tUser = [TestFixtureBase getUser:@"UserA"];
    [[m_client identityService] attachParentWithIdentity:tUser.m_id
                                     authenticationToken:tUser.m_password
                                      authenticationType:[AuthenticationTypeObjc Universal]
                                        externalAuthName:nil
                                             forceCreate:true
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testDetachParent
{
    [self goToChildProfile];

    [[m_client identityService] detachParent:successBlock errorCompletionBlock:failureBlock cbObject:nil];
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
    [[m_client identityService] getIdentities:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];
}

- (void)testGetExpiredIdentities
{
    [[m_client identityService] getExpiredIdentities:successBlock errorCompletionBlock:failureBlock cbObject:nil];
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

- (void)testChangeEmail
{
    [[m_client identityService] changeEmailIdentity:[TestFixtureBase getUser:@"UserA"].m_email
                                           password:[TestFixtureBase getUser:@"UserA"].m_password
                                    newEmailAddress:[TestFixtureBase getUser:@"UserA"].m_email
                                 updateContactEmail:true
                                    completionBlock:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];

    [self waitForFailedResult];
}

- (void)testAttachPeer
{
    TestUser *tUser = [TestFixtureBase getUser:@"UserA"];
    [[m_client identityService] attachPeerProfile:m_peerName
                                       externalId:tUser.m_id
                              authenticationToken:tUser.m_password
                               authenticationType:[AuthenticationTypeObjc Universal]
                                 externalAuthName:nil
                                      forceCreate:true
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
    [self detachPeer];
}

- (void)testDetachPeer
{
    [self attachPeer:@"UserA"];
    [[m_client identityService] detachPeer:m_peerName
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

- (void)testGetPeerProfiles
{
    [[m_client identityService] getPeerProfiles:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];
}

@end
