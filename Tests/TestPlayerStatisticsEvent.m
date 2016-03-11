//
//  TestPlayerStatisticsEvent.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-12.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestPlayerStatisticsEvent : TestFixtureBase

@end

@implementation TestPlayerStatisticsEvent

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testTriggerPlayerStatisticsEvent
{
    [[m_client playerStatisticsEventService] triggerPlayerStatisticsEvent:@"testEvent01"
                                                          eventMultiplier:10
                                                          completionBlock:successBlock
                                                     errorCompletionBlock:failureBlock
                                                                 cbObject:nil];
    [self waitForResult];
}

- (void)testTriggerPlayerStatisticsEvents
{
    [[m_client playerStatisticsEventService]
        triggerPlayerStatisticsEvents:
            @"[ {  \"eventName\": \"rewardCredits\", \"eventMultiplier\": 10 } ]"
                      completionBlock:successBlock
                 errorCompletionBlock:failureBlock
                             cbObject:nil];
    [self waitForResult];
}

- (void)testRewardHandlerTriggerStatisticsEvents
{
    [m_client registerRewardCallback:rewardBlock];
    
    [[m_client playerStateService] resetPlayerState:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForResult];
    [self reset];
    
    [[m_client playerStatisticsEventService]
        triggerPlayerStatisticsEvents:
        @"[ {  \"eventName\": \"incQuest1Stat\", \"eventMultiplier\": 1 }, {  \"eventName\": \"incQuest2Stat\", \"eventMultiplier\": 1 } ]"
        completionBlock:successBlock
        errorCompletionBlock:failureBlock
        cbObject:nil];
    [self waitForResult];
    [m_client deregisterRewardCallback];
    
    XCTAssertEqual(_rewardCallbacksReceived, 1);
}

- (void)testRewardHandlerMultipleApiCallsInBundle
{
    [m_client registerRewardCallback:rewardBlock];
    
    [[m_client playerStateService] resetPlayerState:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForResult];
    [self reset];
    
    [[m_client playerStatisticsEventService]
     triggerPlayerStatisticsEvents:
     @"[ {  \"eventName\": \"incQuest1Stat\", \"eventMultiplier\": 1 } ]"
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    [[m_client playerStatisticsEventService]
     triggerPlayerStatisticsEvents:
     @"[ {  \"eventName\": \"incQuest2Stat\", \"eventMultiplier\": 1 } ]"
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    
    [self waitForResultExpectedCount:2];
    [m_client deregisterRewardCallback];
    
    XCTAssertEqual(_rewardCallbacksReceived, 1);
    XCTAssertEqual(_apiRewardsReceived, 2);
}

@end
