//
//  TestAuthentication.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-07.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestAuthentication : TestFixtureBase

@end

@implementation TestAuthentication

- (bool)authenticateOnSetup { return false; }

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testAuthenticateUniversal
{
    [[m_client authenticationService]
        authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
                     password:[TestFixtureBase getUser:@"UserA"].m_password
                  forceCreate:true
              completionBlock:successBlock
         errorCompletionBlock:failureBlock
                     cbObject:nil];
    [self waitForResult];
}

- (void)testAuthenticateEmailPassword
{
    [[m_client authenticationService]
        authenticateEmailPassword:[TestFixtureBase getUser:@"UserB"].m_email
                     password:[TestFixtureBase getUser:@"UserB"].m_password
                  forceCreate:true
              completionBlock:successBlock
         errorCompletionBlock:failureBlock
                     cbObject:nil];
    [self waitForResult];
}
- (void)testResetEmailPassword
{
    NSString* email = @"braincloudunittest@gmail.com";
    
    [[m_client authenticationService] resetEmailPassword:email
                                     withCompletionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

@end
