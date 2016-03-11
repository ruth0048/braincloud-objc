//
//  TestEvent.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-12.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestEvent : TestFixtureBase

@end

@implementation TestEvent

NSString *eventType = @"TestEvent";
NSString *eventData = @"{ \"globalTestName\":\"testValue\" }";

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testSendEvent
{
    [self sendEvent:false];
    if (!_eventCallbackReceived)
    {
        __weak TestFixtureBase *weakSelf = self;
       _XCTPrimitiveFail(weakSelf, @"No callback event received");
    }
    else
    {
        NSLog(@"Event JSON");
        NSLog(@"%@", _eventCallbackJson);
    }
}

- (void)testDeleteSentEvent
{
    uint64_t eventId = [self sendEvent:true];
    [[m_client eventService] deleteSentEvent:[TestFixtureBase getUser:@"UserA"].m_profileId
                                     eventId:eventId
                             completionBlock:successBlock
                        errorCompletionBlock:failureBlock
                                    cbObject:nil];
    [self waitForResult];
}

- (void)testUpdateIncomingEventData
{
    uint64_t eventId = [self sendEvent:false];
    [[m_client eventService] updateIncomingEventData:[TestFixtureBase getUser:@"UserA"].m_profileId
                                             eventId:eventId
                                       jsonEventData:eventData
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
}

- (void)testDeleteIncomingEvent
{
    uint64_t eventId = [self sendEvent:true];
    [[m_client eventService] deleteIncomingEvent:[TestFixtureBase getUser:@"UserA"].m_profileId
                                         eventId:eventId
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
}

- (void)testGetEvents
{
    [self sendEvent:true];
    [[m_client eventService] getEvents:true
                 includeSentEvents:true
                       completionBlock:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForResult];
}

- (uint64_t)sendEvent:(bool)recordLocal
{
    [m_client registerEventCallback:eventBlock];
    [[m_client eventService] sendEvent:[TestFixtureBase getUser:@"UserA"].m_profileId
                             eventType:eventType
                         jsonEventData:eventData
                         recordLocally:recordLocal
                       completionBlock:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForResult];
    [m_client deregisterEventCallback];
    return [(NSNumber *)[[TestFixtureBase getDataFromResponse:self.jsonResponse]
        valueForKey:@"eventId"] unsignedLongLongValue];
}

@end
