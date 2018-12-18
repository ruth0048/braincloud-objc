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
    [m_bcWrapper initialize:m_serverUrl secretKey:m_secret appId:m_appId appVersion:m_version companyName:@"wrapper" appName:@"unittest"];

    //reset ids
    [m_bcWrapper setStoredProfileId:@""];
    [m_bcWrapper setStoredAnonymousId:@""];
    
    [m_bcWrapper authenticateAnonymous:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForResult];
    [self reset];
    
    NSString *anonId = [m_bcWrapper storedAnonymousId];
    NSString *profileId = [m_bcWrapper storedProfileId];
    
    [[[m_bcWrapper getBCClient] authenticationService] clearSavedProfile];
    
    [m_bcWrapper authenticateAnonymous:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForResult];
    
    if (![anonId isEqualToString:[m_bcWrapper storedAnonymousId] ])
    {
        _XCTPrimitiveFail(self, @"Anonymous ids not equal");
    }
    
    if (![profileId isEqualToString:[m_bcWrapper storedProfileId] ])
    {
        _XCTPrimitiveFail(self, @"Profile ids not equal");
    }
}

- (void)testAuthenticateUniversal
{
    [m_bcWrapper initialize:m_serverUrl secretKey:m_secret appId:m_appId appVersion:m_version companyName:@"wrapper" appName:@"unittest"];
    
    [m_bcWrapper authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
                                                  password:[TestFixtureBase getUser:@"UserA"].m_password
                                               forceCreate:YES
                                           completionBlock:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];
    [self reset];
    
    m_bcWrapper.alwaysAllowProfileSwitch = YES;

    [m_bcWrapper
      authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
                   password:[TestFixtureBase getUser:@"UserA"].m_password
                forceCreate:true
            completionBlock:successBlock
       errorCompletionBlock:failureBlock
                   cbObject:nil];
    [self waitForResult];
}

- (void)testSwitchAnonToUniversal
{
    [m_bcWrapper initialize:m_serverUrl secretKey:m_secret appId:m_appId appVersion:m_version companyName:@"wrapper" appName:@"unittest"];
    
    //reset ids
    [m_bcWrapper setStoredProfileId:@""];
    [m_bcWrapper setStoredAnonymousId:@""];
    
    //[[[m_bcWrapper getBCClient] authenticationService] clearSavedProfile];
    //[m_bcWrapper authenticateAnonymous:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    //[self waitForResult];
    //[self reset];
    
    //This works, but sometimes jenkins hiccups and can't successfuly track this.
    [m_bcWrapper smartSwitchAuthenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
                                         password:[TestFixtureBase getUser:@"UserA"].m_password
                                      forceCreate:YES
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
    
    //so we check for something else. expected 40307 - token not matching user
    [m_bcWrapper smartSwitchAuthenticateUniversal:@"invalidprofileID"
                                         password:[TestFixtureBase getUser:@"UserA"].m_password
                                      forceCreate:YES
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForFailedResult];
    
    [self reset];
    
}

- (void)testSwitchUniversalToEmail
{
    [m_bcWrapper initialize:m_serverUrl secretKey:m_secret appId:m_appId appVersion:m_version companyName:@"wrapper" appName:@"unittest"];
    
    //reset ids
    [m_bcWrapper setStoredProfileId:@""];
    [m_bcWrapper setStoredAnonymousId:@""];
    
    [[[m_bcWrapper getBCClient] authenticationService] clearSavedProfile];
    
    [m_bcWrapper authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id password:[TestFixtureBase getUser:@"UserA"].m_password forceCreate:true completionBlock:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    
    [self waitForResult];
    [self reset];
    
    
    
    [m_bcWrapper smartSwitchAuthenticateEmailPassword:[TestFixtureBase getUser:@"UserA"].m_email
                                         password:[TestFixtureBase getUser:@"UserA"].m_password
                                      forceCreate:YES
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
    [self reset];
    
    
}


- (void)testSwitchNoAuth
{
    [m_bcWrapper initialize:m_serverUrl secretKey:m_secret appId:m_appId appVersion:m_version companyName:@"wrapper" appName:@"unittest"];
    
    //reset ids
    [m_bcWrapper setStoredProfileId:@""];
    [m_bcWrapper setStoredAnonymousId:@""];
    
    [[[m_bcWrapper getBCClient] authenticationService] clearSavedProfile];
    
    
    [m_bcWrapper smartSwitchAuthenticateEmailPassword:[TestFixtureBase getUser:@"UserA"].m_email
                                             password:[TestFixtureBase getUser:@"UserA"].m_password
                                          forceCreate:YES
                                      completionBlock:successBlock
                                 errorCompletionBlock:failureBlock
                                             cbObject:nil];
    [self waitForResult];
    [self reset];
    
}




- (void)testReconnect
{
    [m_bcWrapper initialize:m_serverUrl secretKey:m_secret appId:m_appId appVersion:m_version companyName:@"wrapper" appName:@"unittest"];

    [m_bcWrapper authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
                                                  password:[TestFixtureBase getUser:@"UserA"].m_password
                                               forceCreate:YES
                                           completionBlock:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];

    [[[m_bcWrapper getBCClient] playerStateService]logout:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];

    
    [m_bcWrapper reconnect:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];

    [[[m_bcWrapper getBCClient] timeService]readServerTime:successBlock errorCompletionBlock:failureBlock cbObject:nil];
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
