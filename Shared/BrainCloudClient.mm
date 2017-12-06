//
//  BrainCloudClient.mm
//  brainCloudClientObjc
//
//  Copyright (c) 2016 bitHeads. All rights reserved.
//

#import "BrainCloudClient.hh"
#include "TargetConditionals.h"
#include "braincloud/BrainCloudClient.h"

class ObjCEventCallback : public BrainCloud::IEventCallback
{
  public:
    BCEventCompletionBlock _eventCallback;

    virtual void eventCallback(std::string const &jsonData)
    {
        if (_eventCallback != nil)
        {
            const char *cstr = jsonData.c_str();
            NSString *nsJsonData = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
            _eventCallback(nsJsonData);
        }
    }
};

class ObjCRewardCallback : public BrainCloud::IRewardCallback
{
  public:
    BCRewardCompletionBlock _rewardCallback;

    virtual void rewardCallback(std::string const &jsonData)
    {
        if (_rewardCallback != nil)
        {
            const char *cstr = jsonData.c_str();
            NSString *nsJsonData = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
            _rewardCallback(nsJsonData);
        }
    }
};

class ObjCFileUploadCallback : public BrainCloud::IFileUploadCallback
{
  public:
    BCFileUploadCompletedCompletionBlock _uploadCompletedCallback;
    BCFileUploadFailedCompletionBlock _uploadFailedCallback;

    virtual void fileUploadCompleted(const char *in_fileUploadId, const std::string &in_jsonResponse)
    {
        if (_uploadCompletedCallback != nil)
        {
            const char *cstr = in_jsonResponse.c_str();
            NSString *nsJsonResponse = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
            NSString *nsFileUploadId = [NSString stringWithCString:in_fileUploadId encoding:NSUTF8StringEncoding];
            _uploadCompletedCallback(nsFileUploadId, nsJsonResponse);
        }
    }

    virtual void fileUploadFailed(const char *in_fileUploadId, int in_statusCode, int in_reasonCode,
                                  const std::string &in_jsonResponse)
    {
        if (_uploadFailedCallback != nil)
        {
            const char *cstr = in_jsonResponse.c_str();
            NSString *nsJsonResponse = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
            NSString *nsFileUploadId = [NSString stringWithCString:in_fileUploadId encoding:NSUTF8StringEncoding];
            _uploadFailedCallback(nsFileUploadId, in_statusCode, in_reasonCode, nsJsonResponse);
        }
    }
};

class ObjCGlobalErrorCallback : public BrainCloud::IGlobalErrorCallback
{
  public:
    BCErrorCompletionBlock _globalErrorCallback;
    // due to the C++ architecture not supporting callback objects,
    // there is no way to return the passed in ObjC callback object
    // in the global error handler.
    //BCCallbackObject m_cbObject;

    virtual void globalError(BrainCloud::ServiceName serviceName, BrainCloud::ServiceOperation serviceOperation,
                             int statusCode, int returnCode, const std::string &jsonError)
    {
        if (_globalErrorCallback)
        {
            _globalErrorCallback(
                [NSString stringWithCString:serviceName.getValue().c_str() encoding:NSUTF8StringEncoding],
                [NSString stringWithCString:serviceOperation.getValue().c_str() encoding:NSUTF8StringEncoding],
                statusCode, returnCode, [NSString stringWithCString:jsonError.c_str() encoding:NSUTF8StringEncoding],
                nil);
                //m_cbObject);
        }
    }
};

class ObjCNetworkErrorCallback : public BrainCloud::INetworkErrorCallback
{
  public:
    BCNetworkErrorCompletionBlock _networkErrorCallback;
    BCCallbackObject m_cbObject;

    virtual void networkError()
    {
        if (_networkErrorCallback)
        {
            _networkErrorCallback();
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
    ObjCGlobalErrorCallback _objcGlobalErrorCallback;
    ObjCNetworkErrorCallback _objcNetworkErrorCallback;
    
    BrainCloudAuthentication *_authenticationService;
    BrainCloudScript *_scriptService;
    BrainCloudPushNotification *_pushNotificationService;
    BrainCloudProduct *_productService;
    BrainCloudPlayerState *_playerStateService;
    BrainCloudPlayerStatistics *_playerStatisticsService;
    BrainCloudGlobalStatistics *_globalStatisticsService;
    BrainCloudEntity *_entityService;
    BrainCloudGlobalEntity *_globalEntityService;
    BrainCloudLeaderboard *_leaderboardService;
    BrainCloudGlobalApp *_globalAppService;
    BrainCloudFriend *_friendService;
    BrainCloudMail *_mailService;
    BrainCloudMatchMaking *_matchMakingService;
    BrainCloudAsyncMatch *_asyncMatchService;
    BrainCloudOneWayMatch *_oneWayMatchService;
    BrainCloudPlaybackStream *_playbackStreamService;
    BrainCloudGamification *_gamificationService;
    BrainCloudEvent *_eventService;
    BrainCloudPlayerStatisticsEvent *_playerStatisticsEventService;
    BrainCloudTime *_timeService;
    BrainCloudTournament *_tournamentService;
    BrainCloudS3Handling *_s3HandlingService;
    BrainCloudIdentity *_identityService;
    BrainCloudRedemptionCode *_redemptionCodeService;
    BrainCloudDataStream *_dataStreamService;
    BrainCloudProfanity *_profanityService;
    BrainCloudFile *_fileService;
    BrainCloudGroup *_groupService;

}
@end

@implementation BrainCloudClient

static BrainCloudClient *s_instance = nil;

+ (BrainCloudClient *)getInstance
{
    NSAssert(BrainCloud::BrainCloudClient::EnableSingletonMode, [NSString stringWithUTF8String:BrainCloud::BrainCloudClient::SingletonUseErrorMessage]);
    
    @synchronized(self) {
        if(s_instance == nil) {
            s_instance = [[BrainCloudClient alloc] init];
        }
    }
    return s_instance;
}

+ (void)setInstance: (BrainCloudClient *) instance
{
    s_instance = instance;
}

+ (void) setEnableSingletonMode: (bool) state
{
    BrainCloud::BrainCloudClient::EnableSingletonMode = state;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _client = new BrainCloud::BrainCloudClient();
        
        _client->getFileService();
        _timer = nil;
        _timerDisabled = false;
        _client->getAuthenticationService()->setClientLib("objc");
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
            gameId:(NSString *)appId
       gameVersion:(NSString *)appVersion
{
    _client->initialize([serverURL UTF8String], [secretKey UTF8String], [appId UTF8String], [appVersion UTF8String]);

    if (!_timerDisabled)
    {
        if (_timer != nil)
        {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 // every 100 ms
                                                  target:self
                                                selector:@selector(runCallBacks)
                                                userInfo:nil
                                                 repeats:TRUE];
    }
}

- (void)initialize:(NSString *)serverURL
         secretKey:(NSString *)secretKey
             appId:(NSString *)appId
           version:(NSString *)appVersion
{
    _client->initialize([serverURL UTF8String], [secretKey UTF8String], [appId UTF8String], [appVersion UTF8String]);

    if (!_timerDisabled)
    {
        if (_timer != nil)
        {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 // every 100 ms
                                                  target:self
                                                selector:@selector(runCallBacks)
                                                userInfo:nil
                                                 repeats:TRUE];
    }
}

- (void)initialize:(NSString *)serverURL
         secretKey:(NSString *)secretKey
             appId:(NSString *)appId
        appVersion:(NSString *)appVersion
{
    _client->initialize([serverURL UTF8String], [secretKey UTF8String], [appId UTF8String], [appVersion UTF8String]);

    if (!_timerDisabled)
    {
        if (_timer != nil)
        {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 // every 100 ms
                                                  target:self
                                                selector:@selector(runCallBacks)
                                                userInfo:nil
                                                 repeats:TRUE];
    }
}

- (void)enableLogging:(bool)shouldEnable { _client->enableLogging(shouldEnable); }

- (bool)isInitialized { return _client->isInitialized(); }

- (bool)isAuthenticated { return _client->isAuthenticated(); }

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

- (void)initializeIdentity:(NSString *)profileId anonymousId:(NSString *)anonymousId
{
    const char *szProfileId = "";
    const char *szAnonymousId = "";
    if (profileId != nil)
    {
        szProfileId = profileId.UTF8String;
    }
    if (anonymousId != nil)
    {
        szAnonymousId = anonymousId.UTF8String;
    }
    _client->initializeIdentity(szProfileId, szAnonymousId);
}

- (void)runCallBacks { _client->runCallbacks(); }

- (void)resetCommunication { _client->resetCommunication(); }

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

- (void)registerGlobalErrorCallback:(BCErrorCompletionBlock)ecb
{
    _objcGlobalErrorCallback._globalErrorCallback = ecb;
    _client->registerGlobalErrorCallback(&_objcGlobalErrorCallback);
}

- (void)deregisterGlobalErrorCallback
{
    _objcGlobalErrorCallback._globalErrorCallback = nil;
    _client->deregisterGlobalErrorCallback();
}

- (void)registerNetworkErrorCallback:(BCNetworkErrorCompletionBlock)ecb
{
    _objcNetworkErrorCallback._networkErrorCallback = ecb;
    _client->registerNetworkErrorCallback(&_objcNetworkErrorCallback);
}

- (void)deregisterNetworkErrorCallback
{
    _objcNetworkErrorCallback._networkErrorCallback = nil;
    _client->deregisterNetworkErrorCallback();
}

- (const char *)sessionId { return _client->getSessionId(); }

- (NSArray *)getPacketTimeouts
{
    NSMutableArray *timeouts = [NSMutableArray array];
    std::vector<int> v = _client->getPacketTimeouts();
    for (size_t i = 0, isize = v.size(); i < isize; ++i)
    {
        NSNumber *n = [NSNumber numberWithInt:v.at(i)];
        [timeouts addObject:n];
    }
    return timeouts;
}

- (void)setPacketTimeouts:(NSArray *)timeouts
{
    std::vector<int> v;
    for (unsigned int i = 0; i < [timeouts count]; ++i)
    {
        v.push_back((int)[[timeouts objectAtIndex:i] integerValue]);
    }
    _client->setPacketTimeouts(v);
}

- (void)setPacketTimeoutsToDefault { _client->setPacketTimeoutsToDefault(); }

- (int)getAuthenticationPacketTimeout { return _client->getAuthenticationPacketTimeout(); }

- (void)setAuthenticationPacketTimeout:(int)timeoutSecs { _client->setAuthenticationPacketTimeout(timeoutSecs); }

- (void)setOldStyleStatusMessageErrorCallback:(bool)enabled { _client->setOldStyleStatusMessageErrorCallback(enabled); }

- (void)setErrorCallbackOn202Status:(bool)isError { _client->setErrorCallbackOn202Status(isError); }

- (void)setHeartbeatInterval:(int)intervalInMilliseconds { _client->setHeartbeatInterval(intervalInMilliseconds); }

- (int)getUploadLowTransferRateTimeout { return _client->getUploadLowTransferRateTimeout(); }

- (void)setUploadLowTransferRateTimeout:(int)in_timeoutSecs
{
    _client->setUploadLowTransferRateTimeout(in_timeoutSecs);
}

- (int)getUploadLowTransferRateThreshold { return _client->getUploadLowTransferRateThreshold(); }

- (void)setUploadLowTransferRateThreshold:(int)in_bytesPerSec
{
    _client->setUploadLowTransferRateThreshold(in_bytesPerSec);
}

- (void)enableNetworkErrorMessageCaching:(bool)in_enabled { _client->enableNetworkErrorMessageCaching(in_enabled); }

- (void)retryCachedMessages { _client->retryCachedMessages(); }

- (void)flushCachedMessages:(bool)in_sendApiErrorCallbacks { _client->flushCachedMessages(in_sendApiErrorCallbacks); }

- (void)insertEndOfMessageBundleMarker { _client->insertEndOfMessageBundleMarker(); }

- (void)overrideCountryCode:(NSString *)countryCode { _client->overrideCountryCode([countryCode UTF8String]); }

- (void)overrideLanguageCode:(NSString *)languageCode { _client->overrideLanguageCode([languageCode UTF8String]); }

#pragma mark - Properties

- (BrainCloudAuthentication *)authenticationService
{
    if (!_authenticationService) _authenticationService = [[BrainCloudAuthentication alloc] init: _client];
    return _authenticationService;
}

- (BrainCloudScript *)scriptService
{
    if (!_scriptService) _scriptService = [[BrainCloudScript alloc] init: _client];
    return _scriptService;
}

- (BrainCloudPushNotification *)pushNotificationService
{
    if (!_pushNotificationService) _pushNotificationService = [[BrainCloudPushNotification alloc] init: _client];
    return _pushNotificationService;
}

- (BrainCloudProduct *)productService
{
    if (!_productService) _productService = [[BrainCloudProduct alloc] init: _client];
    return _productService;
}

- (BrainCloudPlayerState *)playerStateService
{
    if (!_playerStateService) _playerStateService = [[BrainCloudPlayerState alloc] init: _client];
    return _playerStateService;
}

- (BrainCloudPlayerStatistics *)playerStatisticsService
{
    if (!_playerStatisticsService) _playerStatisticsService = [[BrainCloudPlayerStatistics alloc] init: _client];
    return _playerStatisticsService;
}

- (BrainCloudGlobalStatistics *)globalStatisticsService
{
    if (!_globalStatisticsService) _globalStatisticsService = [[BrainCloudGlobalStatistics alloc] init: _client];
    return _globalStatisticsService;
}

- (BrainCloudEntity *)entityService
{
    if (!_entityService) _entityService = [[BrainCloudEntity alloc] init: _client];
    return _entityService;
}

- (BrainCloudGlobalEntity *)globalEntityService
{
    if (!_globalEntityService) _globalEntityService = [[BrainCloudGlobalEntity alloc] init: _client];
    return _globalEntityService;
}

- (BrainCloudLeaderboard *)leaderboardService
{
    if (!_leaderboardService) _leaderboardService = [[BrainCloudLeaderboard alloc] init: _client];
    return _leaderboardService;
}

- (BrainCloudGlobalApp *)globalAppService
{
    if (!_globalAppService) _globalAppService = [[BrainCloudGlobalApp alloc] init: _client];
    return _globalAppService;
}

- (BrainCloudFriend *)friendService
{
    if (!_friendService) _friendService = [[BrainCloudFriend alloc] init: _client];
    return _friendService;
}

- (BrainCloudMail *)mailService
{
    if (!_mailService) _mailService = [[BrainCloudMail alloc] init: _client];
    return _mailService;
}

- (BrainCloudMatchMaking *)matchMakingService
{
    if (!_matchMakingService) _matchMakingService = [[BrainCloudMatchMaking alloc] init: _client];
    return _matchMakingService;
}

- (BrainCloudAsyncMatch *)asyncMatchService
{
    if (!_asyncMatchService) _asyncMatchService = [[BrainCloudAsyncMatch alloc] init: _client];
    return _asyncMatchService;
}

- (BrainCloudOneWayMatch *)oneWayMatchService
{
    if (!_oneWayMatchService) _oneWayMatchService = [[BrainCloudOneWayMatch alloc] init: _client];
    return _oneWayMatchService;
}

- (BrainCloudPlaybackStream *)playbackStreamService
{
    if (!_playbackStreamService) _playbackStreamService = [[BrainCloudPlaybackStream alloc] init: _client];
    return _playbackStreamService;
}

- (BrainCloudGamification *)gamificationService
{
    if (!_gamificationService) _gamificationService = [[BrainCloudGamification alloc] init: _client];
    return _gamificationService;
}

- (BrainCloudEvent *)eventService
{
    if (!_eventService) _eventService = [[BrainCloudEvent alloc] init: _client];
    return _eventService;
}

- (BrainCloudPlayerStatisticsEvent *)playerStatisticsEventService
{
    if (!_playerStatisticsEventService) _playerStatisticsEventService = [[BrainCloudPlayerStatisticsEvent alloc] init: _client];
    return _playerStatisticsEventService;
}

- (BrainCloudTime *)timeService
{
    if (!_timeService) _timeService = [[BrainCloudTime alloc] init: _client];
    return _timeService;
}

- (BrainCloudTournament *)tournamentService
{
    if (!_tournamentService) _tournamentService = [[BrainCloudTournament alloc] init: _client];
    return _tournamentService;
}

- (BrainCloudS3Handling *)s3HandlingService
{
    if (!_s3HandlingService) _s3HandlingService = [[BrainCloudS3Handling alloc] init: _client];
    return _s3HandlingService;
}

- (BrainCloudIdentity *)identityService
{
    if (!_identityService) _identityService = [[BrainCloudIdentity alloc] init: _client];
    return _identityService;
}

- (BrainCloudRedemptionCode *)redemptionCodeService
{
    if (!_redemptionCodeService) _redemptionCodeService = [[BrainCloudRedemptionCode alloc] init: _client];
    return _redemptionCodeService;
}

- (BrainCloudDataStream *)dataStreamService
{
    if (!_dataStreamService) _dataStreamService = [[BrainCloudDataStream alloc] init: _client];
    return _dataStreamService;
}

- (BrainCloudProfanity *)profanityService
{
    if (!_profanityService) _profanityService = [[BrainCloudProfanity alloc] init: _client];
    return _profanityService;
}

- (BrainCloudFile *)fileService
{
    if (!_fileService) _fileService = [[BrainCloudFile alloc] init: _client];
    return _fileService;
}

- (BrainCloudGroup *)groupService
{
    if (!_groupService) _groupService = [[BrainCloudGroup alloc] init: _client];
    return _groupService;
}

+ (BrainCloudClient *)defaultClient { return [BrainCloudClient getInstance]; }

@end
