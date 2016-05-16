//
//  BrainCloudEvent.h
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-12.
//  Copyright (c) 2016 bitHeads. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import "BrainCloudCompletionBlocks.hh"

@interface BrainCloudEvent : NSObject

/**
* Sends an event to the designated player id with the attached json data.
* Any events that have been sent to a player will show up in their
* incoming event mailbox. If the recordLocally flag is set to true,
* a copy of this event (with the exact same event id) will be stored
* in the sending player's "sent" event mailbox.
*
* Note that the list of sent and incoming events for a player is returned
* in the "ReadPlayerState" call (in the BrainCloudPlayer module).
*
* Service Name - Event
* Service Operation - Send
*
* @param toPlayerId The id of the player who is being sent the event
* @param eventType The user-defined type of the event.
* @param jsonEventData The user-defined data for this event encoded in JSON.
* @param recordLocally If true, a copy of this event will be saved in the
* user's sent events mailbox.
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server response
* @param cbObject User object sent to the completion blocks
*/
- (void)sendEvent:(NSString *)toPlayerId
               eventType:(NSString *)eventType
           jsonEventData:(NSString *)eventData
           recordLocally:(bool)recordLocally
         completionBlock:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject;

/**
* Updates an event in the player's incoming event mailbox.
*
* Service Name - Event
* Service Operation - UpdateEventData
*
* @param fromPlayerId The id of the player who sent the event
* @param eventId The event id
* @param jsonEventData The user-defined data for this event encoded in JSON.
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server response
* @param cbObject User object sent to the completion blocks
*/
- (void)updateIncomingEventData:(NSString *)fromPlayerId
                        eventId:(uint64_t)eventId
                  jsonEventData:(NSString *)eventData
                completionBlock:(BCCompletionBlock)cb
           errorCompletionBlock:(BCErrorCompletionBlock)ecb
                       cbObject:(BCCallbackObject)cbObject;

/**
* Delete an event out of the player's incoming mailbox.
*
* Service Name - Event
* Service Operation - DeleteIncoming
*
* @param fromPlayerId The id of the player who sent the event
* @param eventId The event id
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server response
* @param cbObject User object sent to the completion blocks
*/
- (void)deleteIncomingEvent:(NSString *)fromPlayerId
                    eventId:(uint64_t)eventId
            completionBlock:(BCCompletionBlock)cb
       errorCompletionBlock:(BCErrorCompletionBlock)ecb
                   cbObject:(BCCallbackObject)cbObject;

/**
* Delete an event from the player's sent mailbox.
*
* Note that only events sent with the "recordLocally" flag
* set to true will be added to a player's sent mailbox.
*
* Service Name - Event
* Service Operation - DeleteSent
*
* @param toPlayerId The id of the player who is being sent the even
* @param eventId The event id
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server response
* @param cbObject User object sent to the completion blocks
*/
- (void)deleteSentEvent:(NSString *)toPlayerId
                eventId:(uint64_t)eventId
        completionBlock:(BCCompletionBlock)cb
   errorCompletionBlock:(BCErrorCompletionBlock)ecb
               cbObject:(BCCallbackObject)cbObject;

/**
* Get the events currently queued for the player.
*
* Service Name - Event
* Service Operation - GetEvents
*
* @param includeIncomingEvents Get events sent to the player
* @param includeSentEvents Get events sent from the player
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server response
* @param cbObject User object sent to the completion blocks
*/
- (void)getEvents:(bool)includeIncomingEvents
    includeSentEvents:(bool)includeSentEvents
          completionBlock:(BCCompletionBlock)cb
     errorCompletionBlock:(BCErrorCompletionBlock)ecb
                 cbObject:(BCCallbackObject)cbObject;

@end
