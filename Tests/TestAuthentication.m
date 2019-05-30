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

- (void)testAuthenticateHandoff
{
    [[m_client authenticationService] authenticateHandoff:@"invalid_handoffId"
                                            securityToken:@"invalid_securityToken"
                                          completionBlock:successBlock
                                     errorCompletionBlock:failureBlock
                                                 cbObject:nil];
    [self waitForFailedResult];
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
    NSString* email = @"ryanr@bitheads.com";
    
    [[m_client authenticationService] resetEmailPassword:email
                                     withCompletionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testResetEmailPasswordAdvanced
{
    NSString* email = @"ryanr@bitheads.com";
    NSString* content = @"{\"fromAddress\": \"ryanr@bitheads.com\",\"fromName\": \"ryan\",\"replyToAddress\": \"ryanr@bitheads.com\",\"replyToName\": \"replyToName\", \"templateId\": \"8f14c77d-61f4-4966-ab6d-0bee8b13d090\", \"substitutions\": { \":name\": \"John Doe\",\":resetLink\": \"www.dummuyLink.io\"}, \"categories\": [\"category1\",\"category2\" ]}";
    
    [[m_client authenticationService] resetEmailPasswordAdvanced:email
                                                   serviceParams:content
                                             withCompletionBlock:successBlock
                                            errorCompletionBlock:failureBlock
                                                        cbObject:nil];
    //expect improper from address
    [self waitForResult];
}

- (void)testResetUniversalIdPassword
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    [[m_client authenticationService] resetUniversalIdPassword:[TestFixtureBase getUser:@"UserA"].m_id
                                     withCompletionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForResult];
}

- (void)testResetUniversalIdPasswordAdvanced
{
    [[m_client authenticationService]
     authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
     password:[TestFixtureBase getUser:@"UserA"].m_password
     forceCreate:true
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];

    NSString* content = @"{\"fromAddress\": \"ryanr@bitheads.com\",\"fromName\": \"ryan\",\"replyToAddress\": \"ryanr@bitheads.com\",\"replyToName\": \"replyToName\", \"templateId\": \"8f14c77d-61f4-4966-ab6d-0bee8b13d090\", \"substitutions\": { \":name\": \"John Doe\",\":resetLink\": \"www.dummuyLink.io\"}, \"categories\": [\"category1\",\"category2\" ]}";
    
    [[m_client authenticationService] resetUniversalIdPasswordAdvanced:[TestFixtureBase getUser:@"UserA"].m_id
                                                   serviceParams:content
                                             withCompletionBlock:successBlock
                                            errorCompletionBlock:failureBlock
                                                        cbObject:nil];
    //expect improper from address
    [self waitForResult];
}

@end
