//
//  ServiceName.mm
//  brainCloudClientObjc
//
//  Created by Ryan Homer on 19/4/2015.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "ServiceName.hh"
#import "ServiceName.h"

// Do not compare string pointers with '='; use NSString's isEqualToString:

NSString const *const BrainCloudServiceNameNone =
    [NSString stringWithCString:BrainCloud::ServiceName::None.getValue().c_str()
                       encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceAuthenticate = [NSString
    stringWithCString:BrainCloud::ServiceName::Authenticate.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceAuthenticateV2 = [NSString
    stringWithCString:BrainCloud::ServiceName::AuthenticateV2.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceIdentity = [NSString
    stringWithCString:BrainCloud::ServiceName::Identity.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceCurrency = [NSString
    stringWithCString:BrainCloud::ServiceName::Currency.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceFriendData = [NSString
    stringWithCString:BrainCloud::ServiceName::FriendData.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceHeartBeat = [NSString
    stringWithCString:BrainCloud::ServiceName::HeartBeat.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceServerTime = [NSString
    stringWithCString:BrainCloud::ServiceName::ServerTime.getValue().c_str()
             encoding:NSASCIIStringEncoding];

NSString const *const BrainCloudServicePushNotification = [NSString
    stringWithCString:BrainCloud::ServiceName::PushNotification.getValue()
                          .c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceGlobalGameStatistics = [NSString
    stringWithCString:BrainCloud::ServiceName::GlobalGameStatistics.getValue()
                          .c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServicePlayerStatisticsEvent = [NSString
    stringWithCString:BrainCloud::ServiceName::PlayerStatisticsEvent.getValue()
                          .c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceTwitter = [NSString
    stringWithCString:BrainCloud::ServiceName::Twitter.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceSteam = [NSString
    stringWithCString:BrainCloud::ServiceName::Steam.getValue().c_str()
             encoding:NSASCIIStringEncoding];

NSString const *const BrainCloudServicePlayerState = [NSString
    stringWithCString:BrainCloud::ServiceName::PlayerState.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceEntity = [NSString
    stringWithCString:BrainCloud::ServiceName::Entity.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceGlobalEntity = [NSString
    stringWithCString:BrainCloud::ServiceName::GlobalEntity.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceFriend = [NSString
    stringWithCString:BrainCloud::ServiceName::Friend.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceTime =
    [NSString stringWithCString:BrainCloud::ServiceName::Time.getValue().c_str()
                       encoding:NSASCIIStringEncoding];

NSString const *const BrainCloudServiceSocialLeaderBoard = [NSString
    stringWithCString:BrainCloud::ServiceName::SocialLeaderboard.getValue()
                          .c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceEvent = [NSString
    stringWithCString:BrainCloud::ServiceName::Event.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceProduct = [NSString
    stringWithCString:BrainCloud::ServiceName::Product.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServicePlayerStatistics = [NSString
    stringWithCString:BrainCloud::ServiceName::PlayerStatistics.getValue()
                          .c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceGlobalStatistics = [NSString
    stringWithCString:BrainCloud::ServiceName::GlobalStatistics.getValue()
                          .c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceAsyncMatch = [NSString
    stringWithCString:BrainCloud::ServiceName::AsyncMatch.getValue().c_str()
             encoding:NSASCIIStringEncoding];

NSString const *const BrainCloudServiceScript = [NSString
    stringWithCString:BrainCloud::ServiceName::Script.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceMatchMaking = [NSString
    stringWithCString:BrainCloud::ServiceName::MatchMaking.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceOneWayMatch = [NSString
    stringWithCString:BrainCloud::ServiceName::OneWayMatch.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServicePlaybackStream = [NSString
    stringWithCString:BrainCloud::ServiceName::PlaybackStream.getValue().c_str()
             encoding:NSASCIIStringEncoding];
NSString const *const BrainCloudServiceGamification = [NSString
    stringWithCString:BrainCloud::ServiceName::Gamification.getValue().c_str()
             encoding:NSASCIIStringEncoding];

NSString const *const BrainCloudServiceGlobalApp = [NSString
    stringWithCString:BrainCloud::ServiceName::GlobalApp.getValue().c_str()
             encoding:NSASCIIStringEncoding];
