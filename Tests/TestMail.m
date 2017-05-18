//
//  TestScript.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-10.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"
#include <time.h>

@interface TestMail : TestFixtureBase

@end

@implementation TestMail

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testSendBasicEmail
{
    [[m_client mailService] sendBasicEmail:[TestFixtureBase getUser:@"UserB"].m_profileId
                                   subject:@"Test Subject - TestSendBasicEmail"
                                      body:@"Test body"
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

- (void)testSendAdvancedEmail
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"Test Subject - TestSendAdvancedEmailSendGrid" forKey:@"subject"];
    [dict setObject:@"Test body" forKey:@"body"];
    [dict setObject:[NSArray arrayWithObjects:@"unit-test", nil] forKey:@"categories"];

    NSString * jsonData = [TestFixtureBase getJsonString:dict];

    [[m_client mailService] sendAdvancedEmail:[TestFixtureBase getUser:@"UserB"].m_profileId
                                   jsonServiceParams:jsonData
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

- (void)testSendAdvancedEmailByAddress
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"Test Subject - TestSendAdvancedEmailSendGrid" forKey:@"subject"];
    [dict setObject:@"Test body" forKey:@"body"];
    [dict setObject:[NSArray arrayWithObjects:@"unit-test", nil] forKey:@"categories"];

    NSString * jsonData = [TestFixtureBase getJsonString:dict];

    [[m_client mailService] sendAdvancedEmail:[TestFixtureBase getUser:@"UserB"].m_email
                            jsonServiceParams:jsonData
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
}

@end
