//
//  TestPlayerState.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-07.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestPlayerState : TestFixtureBase

@end

@implementation TestPlayerState

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testDeletePlayer
{
    [[m_client playerStateService] deleteUser:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
    
    [[m_client authenticationService] authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
                                                   password:[TestFixtureBase getUser:@"UserA"].m_password
                                                forceCreate:true
                                            completionBlock:successBlock
                                       errorCompletionBlock:failureBlock
                                                   cbObject:nil];
    [self waitForResult];
    [TestFixtureBase getUser:@"UserA"].m_profileId = [m_client authenticationService].profileID;
}

- (void)testGetAttributes
{
    [[m_client playerStateService] getAttributes:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
}

- (void)testLogout
{
    [[m_client playerStateService] logout:successBlock
                     errorCompletionBlock:failureBlock
                                 cbObject:nil];
    [self waitForResult];
}

- (void)testReadPlayerState
{
    [[m_client playerStateService] readUserState:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
}

- (void)testRemoveAttributes
{
    NSArray * array = @[@"test1", @"test2"];

    [[m_client playerStateService] removeAttributes:array
                                    completionBlock:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForResult];
}

- (void)testUpdateAttributes
{
    NSString *data = @"{\"test1\" : \"value1\"}";

    [[m_client playerStateService] updateAttributes:data
                                       wipeExisting:false
                                    completionBlock:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForResult];
}

- (void)testResetPlayerState
{
    [[m_client playerStateService] resetUserState:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
}

- (void)testUpdateName
{
    [[m_client playerStateService] updateName:@"TestName"
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
}

- (void)testUpdatePlayerPictureUrl
{
    [[m_client playerStateService] updateUserPictureUrl:@"https://some.domain.com/mypicture.jpg"
                                        completionBlock:successBlock
                                   errorCompletionBlock:failureBlock
                                               cbObject:nil];
    [self waitForResult];
}

- (void)testUpdateContactEmail
{
    [[m_client playerStateService] updateUserPictureUrl:@"something@testdomain.com"
                                        completionBlock:successBlock
                                   errorCompletionBlock:failureBlock
                                               cbObject:nil];
    [self waitForResult];
}

@end
