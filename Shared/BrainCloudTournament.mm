//
//  BrainCloudTournament.mm
//  BrainCloud
//
//  Created by Bradley Hill on 2017-01-06.
//  Copyright © 2017 BitHeads Inc. All rights reserved.
//

#include "braincloud/BrainCloudClient.h"
#include "BrainCloudCallback.hh"

#import "BrainCloudTournament.hh"

@implementation BrainCloudTournament

- (void)claimTournamentReward:(NSString *)leaderboardId
                    versionId:(int)versionId
              completionBlock:(BCCompletionBlock)cb
         errorCompletionBlock:(BCErrorCompletionBlock)ecb
                     cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getTournamentService()->claimTournamentReward(
        [leaderboardId UTF8String], versionId, new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)getTournamentStatus:(NSString *)leaderboardId
                  versionId:(int)versionId
            completionBlock:(BCCompletionBlock)cb
       errorCompletionBlock:(BCErrorCompletionBlock)ecb
                   cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getTournamentService()->getTournamentStatus(
        [leaderboardId UTF8String], versionId, new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)joinTournament:(NSString *)leaderboardId
          tournamentCode:(NSString *)tournamentCode
            initialScore:(int)initialScore
         completionBlock:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getTournamentService()->joinTournament(
        [leaderboardId UTF8String], [tournamentCode UTF8String], initialScore,
        new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)leaveTournament:(NSString *)leaderboardId
         completionBlock:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getTournamentService()->leaveTournament(
        [leaderboardId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)postTournamentScore:(NSString *)leaderboardId
                      score:(int)score
                   jsonData:(NSString *)jsonData
           roundStartedTime:(NSDate *)roundStartedTime
            completionBlock:(BCCompletionBlock)cb
       errorCompletionBlock:(BCErrorCompletionBlock)ecb
                   cbObject:(BCCallbackObject)cbObject
{
    time_t time = [roundStartedTime timeIntervalSince1970];
    struct tm *timeStruct = localtime(&time);

    BrainCloud::BrainCloudClient::getInstance()->getTournamentService()->postTournamentScore(
        [leaderboardId UTF8String], score, jsonData == nil ? "" : [jsonData UTF8String], timeStruct,
        new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)viewCurrentReward:(NSString *)leaderboardId
          completionBlock:(BCCompletionBlock)cb
     errorCompletionBlock:(BCErrorCompletionBlock)ecb
                 cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getTournamentService()->viewCurrentReward(
        [leaderboardId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)viewReward:(NSString *)leaderboardId
               versionId:(int)versionId
         completionBlock:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getTournamentService()->viewReward(
        [leaderboardId UTF8String], versionId, new BrainCloudCallback(cb, ecb, cbObject));
}

@end
