//
//  BrainCloudClient.mm
//  brainCloudClientObjc
//
//  Created by Ryan Homer on 7/4/2015.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BrainCloudClient.hh"
#include "BrainCloudClient.h"
#include "TargetConditionals.h"

class ObjCEventCallback : public BrainCloud::IEventCallback
{
public:
    BCEventCompletionBlock _eventCallback;
    
    virtual void eventCallback(std::string const & jsonData)
    {
        if (_eventCallback != nil)
        {
            const char * cstr = jsonData.c_str();
            NSString * nsJsonData = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
            _eventCallback(nsJsonData);
        }
    }
};

class ObjCRewardCallback : public BrainCloud::IRewardCallback
{
public:
    BCRewardCompletionBlock _rewardCallback;
    
    virtual void rewardCallback(std::string const & jsonData)
    {
        if (_rewardCallback != nil)
        {
            const char * cstr = jsonData.c_str();
            NSString * nsJsonData = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
            _rewardCallback(nsJsonData);
        }
    }
};

class ObjCFileUploadCallback : public BrainCloud::IFileUploadCallback
{
public:
    BCFileUploadCompletedCompletionBlock _uploadCompletedCallback;
    BCFileUploadFailedCompletionBlock _uploadFailedCallback;
    
    virtual void fileUploadCompleted(const char * in_fileUploadId, const std::string & in_jsonResponse)
    {
        if (_uploadCompletedCallback != nil)
        {
            const char * cstr = in_jsonResponse.c_str();
            NSString * nsJsonResponse = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
            NSString * nsFileUploadId = [NSString stringWithCString:in_fileUploadId encoding:NSUTF8StringEncoding];
            _uploadCompletedCallback(nsFileUploadId, nsJsonResponse);
        }
    }
    
    virtual void fileUploadFailed(const char * in_fileUploadId, int in_statusCode, int in_reasonCode, const std::string & in_jsonResponse)
    {
        if (_uploadFailedCallback != nil)
        {
            const char * cstr = in_jsonResponse.c_str();
            NSString * nsJsonResponse = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
            NSString * nsFileUploadId = [NSString stringWithCString:in_fileUploadId encoding:NSUTF8StringEncoding];
            _uploadFailedCallback(nsFileUploadId, in_statusCode, in_reasonCode, nsJsonResponse);
        }
    }
};

@interface BrainCloudClient ()
{
    BrainCloud::BrainCloudClient *_client;
    bool _timerDisabled;
    NSTimer *_timer;
    ObjCEventCallback _objcEventCallback;
    ObjCRewardCallback _objcRewardCallback;
    ObjCFileUploadCallback _objcFileUploadCallback;
}
@end

@implementation BrainCloudClient

+ (BrainCloudClient *)defaultClient
{
    static BrainCloudClient *s_instance = nil;
    static dispatch_once_t onceToken = 0;

    dispatch_once(&onceToken, ^{
      s_instance = [[BrainCloudClient alloc] init];
    });
    return s_instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _client = BrainCloud::BrainCloudClient::getInstance();
        _client->SINGLE_THREADED = true;
        _timer = nil;
        _timerDisabled = false;
    }
    return self;
}

- (void)disableInternalTimer
{
    if (_timer == nil)
    {
        _timerDisabled = true;
    }
}

- (void)initialize:(NSString *)serverURL
         secretKey:(NSString *)secretKey
            gameId:(NSString *)gameId
       gameVersion:(NSString *)gameVersion
{
    _client->initialize([serverURL UTF8String], [secretKey UTF8String], [gameId UTF8String],
                        [gameVersion UTF8String]);

    if (!_timerDisabled)
    {
        if (_timer != nil)
        {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 // every 100 ms
                                                  target: self
                                                selector:@selector(runCallBacks)
                                                userInfo:nil
                                                 repeats:TRUE];
    }
}

- (void)enableLogging:(bool)shouldEnable
{
    _client->enableLogging(shouldEnable);
}

- (void)dealloc
{
    if (!_timerDisabled)
    {
        if (_timer != nil)
        {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)initializeIdentity:(const char *)profileId anonymousId:(const char *)anonymousId
{
    _client->initializeIdentity(profileId, anonymousId);
}

- (void)runCallBacks
{
    _client->runCallbacks();
}

- (void)resetCommunication
{
    _client->resetCommunication();
}

- (void)registerEventCallback:(BCEventCompletionBlock)ecb
{
    _objcEventCallback._eventCallback = ecb;
    _client->registerEventCallback(&_objcEventCallback);
}

- (void)deregisterEventCallback
{
    _objcEventCallback._eventCallback = nil;
    _client->deregisterEventCallback();
}


- (void)registerFileUploadCallback:(BCFileUploadCompletedCompletionBlock)completedBlock
                 failedBlock:(BCFileUploadFailedCompletionBlock)failedBlock;
{
    _objcFileUploadCallback._uploadCompletedCallback = completedBlock;
    _objcFileUploadCallback._uploadFailedCallback = failedBlock;
    _client->registerFileUploadCallback(&_objcFileUploadCallback);
}

- (void)deregisterFileUploadCallback
{
    _objcFileUploadCallback._uploadCompletedCallback = nil;
    _objcFileUploadCallback._uploadFailedCallback = nil;
    _client->deregisterFileUploadCallback();
}

- (void)registerRewardCallback:(BCRewardCompletionBlock)rcb
{
    _objcRewardCallback._rewardCallback = rcb;
    _client->registerRewardCallback(&_objcRewardCallback);
}

- (void)deregisterRewardCallback
{
    _objcRewardCallback._rewardCallback = nil;
    _client->deregisterRewardCallback();
}

- (const char *)sessionId
{
    return _client->getSessionId();
}

- (NSArray *) getPacketTimeouts
{
    NSMutableArray * timeouts = [NSMutableArray array];
    std::vector<int> v = _client->getPacketTimeouts();
    for (size_t i = 0, isize = v.size(); i < isize; ++i)
    {
        NSNumber * n = [NSNumber numberWithInt:v.at(i)];
        [timeouts addObject:n];
    }
    return timeouts;
}

- (void)setPacketTimeouts:(NSArray *)timeouts
{
    std::vector<int> v;
    for (unsigned int i = 0; i < [timeouts count]; ++i)
    {
        v.push_back((int) [[timeouts objectAtIndex:i] integerValue]);
    }
    _client->setPacketTimeouts(v);
}

- (void)setPacketTimeoutsToDefault
{
    _client->setPacketTimeoutsToDefault();
}

- (int) getAuthenticationPacketTimeout
{
    return _client->getAuthenticationPacketTimeout();
}

- (void) setAuthenticationPacketTimeout:(int)timeoutSecs
{
    _client->setAuthenticationPacketTimeout(timeoutSecs);
}

- (void) setOldStyleStatusMessageErrorCallback:(bool)enabled
{
    _client->setOldStyleStatusMessageErrorCallback(enabled);
}

- (void)setHeartbeatInterval:(int)intervalInMilliseconds
{
    _client->setHeartbeatInterval(intervalInMilliseconds);
}

- (int) getUploadLowTransferRateTimeout
{
    return _client->getUploadLowTransferRateTimeout();
}

- (void) setUploadLowTransferRateTimeout:(int)in_timeoutSecs
{
    _client->setUploadLowTransferRateTimeout(in_timeoutSecs);
}

- (int) getUploadLowTransferRateThreshold
{
    return _client->getUploadLowTransferRateThreshold();
}

- (void) setUploadLowTransferRateThreshold:(int)in_bytesPerSec
{
    _client->setUploadLowTransferRateThreshold(in_bytesPerSec);
}

#pragma mark - Properties

- (BrainCloudAuthentication *)authenticationService
{
    static BrainCloudAuthentication *_authenticationService = nil;
    if (!_authenticationService) _authenticationService = [[BrainCloudAuthentication alloc] init];
    return _authenticationService;
}

- (BrainCloudScript *)scriptService
{
    static BrainCloudScript *_scriptService = nil;
    if (!_scriptService) _scriptService = [[BrainCloudScript alloc] init];
    return _scriptService;
}

- (BrainCloudPushNotification *)pushNotificationService
{
    static BrainCloudPushNotification *_pushNotificationService = nil;
    if (!_pushNotificationService)
        _pushNotificationService = [[BrainCloudPushNotification alloc] init];
    return _pushNotificationService;
}

- (BrainCloudProduct *)productService
{
    static BrainCloudProduct *_productService = nil;
    if (!_productService) _productService = [[BrainCloudProduct alloc] init];
    return _productService;
}

- (BrainCloudPlayerState *)playerStateService
{
    static BrainCloudPlayerState *_playerStateService = nil;
    if (!_playerStateService) _playerStateService = [[BrainCloudPlayerState alloc] init];
    return _playerStateService;
}

- (BrainCloudPlayerStatistics *)playerStatisticsService
{
    static BrainCloudPlayerStatistics *_playerStatisticsService = nil;
    if (!_playerStatisticsService)
        _playerStatisticsService = [[BrainCloudPlayerStatistics alloc] init];
    return _playerStatisticsService;
}

- (BrainCloudGlobalStatistics *)globalStatisticsService
{
    static BrainCloudGlobalStatistics *_globalStatisticsService = nil;
    if (!_globalStatisticsService)
        _globalStatisticsService = [[BrainCloudGlobalStatistics alloc] init];
    return _globalStatisticsService;
}

- (BrainCloudEntity *)entityService
{
    static BrainCloudEntity *_entityService = nil;
    if (!_entityService) _entityService = [[BrainCloudEntity alloc] init];
    return _entityService;
}

- (BrainCloudGlobalEntity *)globalEntityService
{
    static BrainCloudGlobalEntity *_globalEntityService = nil;
    if (!_globalEntityService) _globalEntityService = [[BrainCloudGlobalEntity alloc] init];
    return _globalEntityService;
}

- (BrainCloudLeaderboard *)leaderboardService
{
    static BrainCloudLeaderboard *_leaderboardService = nil;
    if (!_leaderboardService) _leaderboardService = [[BrainCloudLeaderboard alloc] init];
    return _leaderboardService;
}

- (BrainCloudGlobalApp *)globalAppService
{
    static BrainCloudGlobalApp *_globalAppService = nil;
    if (!_globalAppService) _globalAppService = [[BrainCloudGlobalApp alloc] init];
    return _globalAppService;
}

- (BrainCloudFriend *)friendService
{
    static BrainCloudFriend *_friendService = nil;
    if (!_friendService) _friendService = [[BrainCloudFriend alloc] init];
    return _friendService;
}

- (BrainCloudMatchMaking *)matchMakingService
{
    static BrainCloudMatchMaking *_matchMakingService = nil;
    if (!_matchMakingService) _matchMakingService = [[BrainCloudMatchMaking alloc] init];
    return _matchMakingService;
}

- (BrainCloudAsyncMatch *)asyncMatchService
{
    static BrainCloudAsyncMatch *_asyncMatchService = nil;
    if (!_asyncMatchService) _asyncMatchService = [[BrainCloudAsyncMatch alloc] init];
    return _asyncMatchService;
}

- (BrainCloudOneWayMatch *)oneWayMatchService
{
    static BrainCloudOneWayMatch *_oneWayMatchService = nil;
    if (!_oneWayMatchService) _oneWayMatchService = [[BrainCloudOneWayMatch alloc] init];
    return _oneWayMatchService;
}

- (BrainCloudPlaybackStream *)playbackStreamService
{
    static BrainCloudPlaybackStream *_playbackStreamService = nil;
    if (!_playbackStreamService) _playbackStreamService = [[BrainCloudPlaybackStream alloc] init];
    return _playbackStreamService;
}

- (BrainCloudGamification *)gamificationService
{
    static BrainCloudGamification *_gamificationService = nil;
    if (!_gamificationService) _gamificationService = [[BrainCloudGamification alloc] init];
    return _gamificationService;
}

- (BrainCloudEvent *)eventService
{
    static BrainCloudEvent *_eventService = nil;
    if (!_eventService) _eventService = [[BrainCloudEvent alloc] init];
    return _eventService;
}

- (BrainCloudPlayerStatisticsEvent *)playerStatisticsEventService
{
    static BrainCloudPlayerStatisticsEvent *_playerStatisticsEventService = nil;
    if (!_playerStatisticsEventService)
        _playerStatisticsEventService = [[BrainCloudPlayerStatisticsEvent alloc] init];
    return _playerStatisticsEventService;
}

- (BrainCloudTime *)timeService
{
    static BrainCloudTime *_timeService = nil;
    if (!_timeService) _timeService = [[BrainCloudTime alloc] init];
    return _timeService;
}

- (BrainCloudS3Handling *)s3HandlingService
{
    static BrainCloudS3Handling *_s3HandlingService = nil;
    if (!_s3HandlingService) _s3HandlingService = [[BrainCloudS3Handling alloc] init];
    return _s3HandlingService;
}

- (BrainCloudIdentity *)identityService
{
    static BrainCloudIdentity *_identityService = nil;
    if (!_identityService) _identityService = [[BrainCloudIdentity alloc] init];
    return _identityService;
}

- (BrainCloudRedemptionCode *)redemptionCodeService
{
    static BrainCloudRedemptionCode *_redemptionCodeService = nil;
    if (!_redemptionCodeService) _redemptionCodeService = [[BrainCloudRedemptionCode alloc] init];
    return _redemptionCodeService;
}

- (BrainCloudDataStream *)dataStreamService
{
    static BrainCloudDataStream *_dataStreamService = nil;
    if (!_dataStreamService) _dataStreamService = [[BrainCloudDataStream alloc] init];
    return _dataStreamService;
}

- (BrainCloudProfanity *)profanityService
{
    static BrainCloudProfanity *_profanityService = nil;
    if (!_profanityService) _profanityService = [[BrainCloudProfanity alloc] init];
    return _profanityService;
}

- (BrainCloudFile *)fileService
{
    static BrainCloudFile *_fileService = nil;
    if (!_fileService) _fileService = [[BrainCloudFile alloc] init];
    return _fileService;
}

@end
