//
//  BrainCloudScript.hh
//  brainCloudClientObjc
//
//  Created by Ryan Homer on 29/4/2015.
//  Copyright (c) 2016 bitHeads. All rights reserved.
//

#pragma once

#import "BrainCloudCompletionBlocks.hh"
#import <Foundation/Foundation.h>

@interface BrainCloudScript : NSObject

/**
* Executes a script on the server.
*
* Service Name - Script
* Service Operation - Run
*
* @param scriptName The name of the script to be run
* @param jsonScriptData Data to be sent to the script in json format
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server response
* @param cbObject User object sent to the completion blocks
* @see The API documentation site for more details on cloud code
*/
- (void)runScript:(NSString *)scriptName
          jsonScriptData:(NSString *)jsonScriptData
         completionBlock:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject;

/**
* Allows cloud script executions to be scheduled
*
* Service Name - Script
* Service Operation - ScheduleCloudScript
*
* @param scriptName The name of the script to be run
* @param jsonScriptData Data to be sent to the script in json format
* @param startDateInUTC The start date as a time struct
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server response
* @param cbObject User object sent to the completion blocks
* @see The API documentation site for more details on cloud code
*/
- (void)scheduleRunScriptUTC:(NSString *)scriptName
              jsonScriptData:(NSString *)jsonScriptData
              startDateInUTC:(NSDate *)startDateInUTC
             completionBlock:(BCCompletionBlock)cb
        errorCompletionBlock:(BCErrorCompletionBlock)ecb
                    cbObject:(BCCallbackObject)cbObject;

/**
* Allows cloud script executions to be scheduled
*
* Service Name - Script
* Service Operation - ScheduleCloudScript
*
* @param scriptName The name of the script to be run
* @param jsonScriptData Data to be sent to the script in json format
* @param minutesFromNow Number of minutes from now to run script
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server response
* @param cbObject User object sent to the completion blocks
* @see The API documentation site for more details on cloud code
*/
- (void)scheduleRunScriptMinutes:(NSString *)scriptName
                  jsonScriptData:(NSString *)jsonScriptData
                  minutesFromNow:(int)minutesFromNow
                 completionBlock:(BCCompletionBlock)cb
            errorCompletionBlock:(BCErrorCompletionBlock)ecb
                        cbObject:(BCCallbackObject)cbObject;

/**
* Run a cloud script in a parent app
*
* Service Name - Script
* Service Operation - RUN_PARENT_SCRIPT
*
* @param scriptName The name of the script to be run
* @param scriptData Data to be sent to the script in json format
* @param parentLevel The level name of the parent to run the script from
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server response
* @param cbObject User object sent to the completion blocks
* @see The API documentation site for more details on cloud code
*/
- (void)runParentScript:(NSString *)scriptName
         jsonScriptData:(NSString *)jsonScriptData
        parentLevelName:(NSString *)parentLevelName
        completionBlock:(BCCompletionBlock)cb
   errorCompletionBlock:(BCErrorCompletionBlock)ecb
               cbObject:(BCCallbackObject)cbObject;

/**
 * Cancels a scheduled cloud code script
 *
 * Service Name - Script
 * Service Operation - CANCEL_SCHEDULED_SCRIPT
 *
 * @param jobId ID of script job to cancel
 * @param completionBlock Block to call on return of successful server response
 * @param errorCompletionBlock Block to call on return of unsuccessful server response
 * @param cbObject User object sent to the completion blocks
 */
- (void)cancelScheduledScript:(NSString *)jobId
              completionBlock:(BCCompletionBlock)cb
         errorCompletionBlock:(BCErrorCompletionBlock)ecb
                     cbObject:(BCCallbackObject)cbObject;

@end
