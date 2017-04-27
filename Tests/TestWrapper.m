//
//  TestAuthentication.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-07.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"
#import "BrainCloudWrapper.hh"

@interface TestWrapper : TestFixtureBase

@end

@implementation TestWrapper

- (bool)authenticateOnSetup { return false; }

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testAuthenticateAnonymous
{
    [[BrainCloudWrapper getInstance] initialize:m_serverUrl secretKey:m_secret appId:m_appId version:m_version companyName:@"wrapper" name:@"unittest"];

    //reset ids
    [[BrainCloudWrapper getInstance] setStoredProfileId:@""];
    [[BrainCloudWrapper getInstance] setStoredAnonymousId:@""];
    
    [[BrainCloudWrapper getInstance] authenticateAnonymous:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];
    [self reset];
    
    NSString *anonId = [[BrainCloudWrapper getInstance] storedAnonymousId];
    NSString *profileId = [[BrainCloudWrapper getInstance] storedProfileId];
    
    //[[[BrainCloudWrapper getBC]authenticationService]clearSavedProfile];
    
    [[BrainCloudWrapper getInstance] authenticateAnonymous:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];
    
    if (![anonId isEqualToString:[[BrainCloudWrapper getInstance] storedAnonymousId] ])
    {
        _XCTPrimitiveFail(self, @"Anonymous ids not equal");
    }
    
    if (![profileId isEqualToString:[[BrainCloudWrapper getInstance] storedProfileId] ])
    {
        _XCTPrimitiveFail(self, @"Profile ids not equal");
    }
}

- (void)testAuthenticateUniversal
{
    [[BrainCloudWrapper getInstance] initialize:m_serverUrl secretKey:m_secret appId:m_appId version:m_version companyName:@"wrapper" name:@"unittest"];
    
    [[BrainCloudWrapper getInstance] authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
                                                  password:[TestFixtureBase getUser:@"UserA"].m_password
                                               forceCreate:YES
                                           completionBlock:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];
    [self reset];
    
    [BrainCloudWrapper getInstance].alwaysAllowProfileSwitch = YES;

    [[BrainCloudWrapper getInstance]
      authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
                   password:[TestFixtureBase getUser:@"UserA"].m_password
                forceCreate:true
            completionBlock:successBlock
       errorCompletionBlock:failureBlock
                   cbObject:nil];
    [self waitForResult];
}

- (void)testReconnect
{
    [[BrainCloudWrapper getInstance] initialize:m_serverUrl secretKey:m_secret appId:m_appId version:m_version companyName:@"wrapper" name:@"unittest"];

    [[BrainCloudWrapper getInstance] authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
                                                  password:[TestFixtureBase getUser:@"UserA"].m_password
                                               forceCreate:YES
                                           completionBlock:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];

    [[[BrainCloudWrapper getBC] playerStateService]logout:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];

    [[BrainCloudWrapper getInstance] reconnect:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];

    [[[BrainCloudWrapper getBC] timeService]readServerTime:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];
}

/*


TEST_F(TestBCWrapper, AuthenticateEmailPassword)
{
    BrainCloud::BrainCloudWrapper::getInstance()->initialize(m_serverUrl.c_str(), m_secret.c_str(), m_appId.c_str(), m_version.c_str(), "wrapper", "unittest");
    
    std::string email = GetUser(UserA)->m_email;
    email.append("_wrapper");
    
    TestResult tr;
    BrainCloud::BrainCloudWrapper::getInstance()->authenticateEmailPassword(email.c_str(), GetUser(UserA)->m_password, true, &tr);
    tr.run(m_bc);
    
    Logout();
}

TEST_F(TestBCWrapper, AuthenticateUniversal)
{
    BrainCloud::BrainCloudWrapper::getInstance()->initialize(m_serverUrl.c_str(), m_secret.c_str(), m_appId.c_str(), m_version.c_str(), "wrapper", "unittest");
    
    TestResult tr;
    std::string uid = GetUser(UserA)->m_id;
    uid.append("_wrapper");
    BrainCloud::BrainCloudWrapper::getInstance()->authenticateUniversal(uid.c_str(), GetUser(UserA)->m_password, true, &tr);
    tr.run(m_bc);
    
    Logout();
}

*/

@end
