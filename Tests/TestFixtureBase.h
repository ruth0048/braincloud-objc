//
//  TestFixtureBase.h
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-05.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#pragma once

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import "BrainCloudClient.hh"
#import "BrainCloudCompletionBlocks.hh"
#import "TestUser.h"

@interface FileUploadCompletedDetails : NSObject
@property NSString *fileUploadId;
@property NSString *jsonResponse;
@end

@interface FileUploadFailedDetails : NSObject
@property NSString *fileUploadId;
@property NSInteger status;
@property NSInteger reasonCode;
@property NSString *jsonResponse;
@end

@interface TestFixtureBase : XCTestCase
{
  @protected
    BrainCloudClient *m_client;
    NSString *m_parentLevel;
    NSString *m_childAppId;
    NSString *m_serverUrl;
    NSString *m_appId;
    NSString *m_secret;
    NSString *m_version;
    NSString *m_peerName;
    Boolean m_initUsers;

    __block bool _result;
    __block int _apiCountExpected;
    __block NSString *_jsonResponse;
    __block NSInteger _statusCode;
    __block NSInteger _reasonCode;
    __block NSString *_statusMessage;
    __block bool _eventCallbackReceived;
    __block NSString *_eventCallbackJson;
    __block int _rewardCallbacksReceived;
    __block int _apiRewardsReceived;
    __block NSString *_rewardCallbackJson;
    __block NSMutableArray *_fileUploadCompletedReceived;
    __block NSMutableArray *_fileUploadFailedReceived;
    __block int _expectFail;
    __block int _globalErrorCount;
    __block int _networkErrorCount;

    BCCompletionBlock successBlock;
    BCErrorCompletionBlock failureBlock;
    BCEventCompletionBlock eventBlock;
    BCRewardCompletionBlock rewardBlock;
    BCErrorCompletionBlock globalErrorBlock;
    BCNetworkErrorCompletionBlock networkErrorBlock;
    BCFileUploadCompletedCompletionBlock fileUploadCompletedBlock;
    BCFileUploadFailedCompletionBlock fileUploadFailedBlock;
}

@property bool result;
@property NSString *jsonResponse;
@property NSInteger statusCode;
@property NSInteger reasonCode;
@property NSString *statusMessage;

+ (TestUser *)getUser:(NSString *)userId;
+ (NSDictionary *)getDataFromResponse:(NSString *)jsonResponse;
+ (NSString *)getJsonString:(id)object;

- (void)setUp;
- (void)tearDown;
- (void)waitForResult;
- (void)waitForFailedResult;
- (void)waitForResultExpectedCount:(int)numApiCalls;
- (void)waitForResultExpectedCount:(int)numApiCalls
                        expectFail:(bool)expectFail;
- (void)reset;

- (bool)goToChildProfile;
- (bool)goToParentProfile;
- (bool)attachPeer:(NSString*)user;
- (bool)detachPeer;

- (bool)authenticateOnSetup;

@end
