//
//  TestPushNotification.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-07.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"
#import "PlatformObjc.hh"

@interface TestPushNotification : TestFixtureBase

@end

@implementation TestPushNotification

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testDeregisterAllTokens
{
    [[m_client pushNotificationService] deregisterAllPushNotificationDeviceTokens:successBlock
                                                             errorCompletionBlock:failureBlock
                                                                         cbObject:nil];
    [self waitForResult];
}

- (void)testDeregisterToken
{
    PlatformObjc * platform = [PlatformObjc iOS];
    [[m_client pushNotificationService] registerPushNotificationDeviceToken:platform
                                                                deviceToken:@"GARBAGE_TOKEN"
                                                            completionBlock:successBlock
                                                       errorCompletionBlock:failureBlock
                                                                   cbObject:nil];
    [self waitForResult];
    
    [self reset];
    [[m_client pushNotificationService] deregisterPushNotificationDeviceToken:platform
                                                                deviceToken:@"GARBAGE_TOKEN"
                                                            completionBlock:successBlock
                                                       errorCompletionBlock:failureBlock
                                                                   cbObject:nil];
    [self waitForResult];
}

- (void)testRegisterToken
{
    PlatformObjc * platform = [PlatformObjc iOS];
    [[m_client pushNotificationService] registerPushNotificationDeviceToken:platform
                                                                deviceToken:@"GARBAGE_TOKEN"
                                                            completionBlock:successBlock
                                                       errorCompletionBlock:failureBlock
                                                                   cbObject:nil];
    [self waitForResult];
}

- (void)testSendSimpleNotification
{
    [[m_client pushNotificationService] sendSimplePushNotification:[TestFixtureBase getUser:@"UserA"].m_profileId
                                                                message:@"Test message."
                                                            completionBlock:successBlock
                                                       errorCompletionBlock:failureBlock
                                                                   cbObject:nil];
    [self waitForResult];
}

- (void)testSendRichNotification
{
    [[m_client pushNotificationService] sendRichPushNotification:[TestFixtureBase getUser:@"UserA"].m_profileId
                                                      notificationTemplateId:1
                                                   completionBlock:successBlock
                                              errorCompletionBlock:failureBlock
                                                          cbObject:nil];
    [self waitForResult];
}

- (void)testSendRichNotificationWithParams
{
    [[m_client pushNotificationService] sendRichPushNotificationWithParams:[TestFixtureBase getUser:@"UserA"].m_profileId
                                          notificationTemplateId:1
                                                          substitutionJson:@"{\"1\":\"test sub\"}"
                                                 completionBlock:successBlock
                                            errorCompletionBlock:failureBlock
                                                        cbObject:nil];
    [self waitForResult];
}

@end
