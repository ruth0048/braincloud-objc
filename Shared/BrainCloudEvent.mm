//
//  BrainCloudEvent.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-12.
//  Copyright (c) 2016 bitHeads. All rights reserved.
//

#import "BrainCloudEvent.hh"

#include "braincloud/BrainCloudClient.h"
#include "BrainCloudCallback.hh"

@implementation BrainCloudEvent

- (void)sendEvent:(NSString *)toProfileId
               eventType:(NSString *)eventType
           jsonEventData:(NSString *)eventData
         completionBlock:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getEventService()->sendEvent(
        [toProfileId UTF8String], [eventType UTF8String], [eventData UTF8String],
        new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)updateIncomingEventData:(NSString *)evId
                  jsonEventData:(NSString *)eventData
                completionBlock:(BCCompletionBlock)cb
           errorCompletionBlock:(BCErrorCompletionBlock)ecb
                       cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getEventService()->updateIncomingEventData(
        [evId UTF8String], [eventData UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)deleteIncomingEvent:(NSString *)evId
            completionBlock:(BCCompletionBlock)cb
       errorCompletionBlock:(BCErrorCompletionBlock)ecb
                   cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getEventService()->deleteIncomingEvent(
        [evId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)getEvents:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getEventService()->getEvents(
        new BrainCloudCallback(cb, ecb, cbObject));
}

@end
