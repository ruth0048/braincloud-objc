//
//  TestFixtureBase.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-05.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestFixtureBase.h"
#import "TestUser.h"
#include <stdlib.h>

#define MAX_WAIT_SECS 120
#define ID_FILE_NAME = "ids.txt"

@implementation FileUploadCompletedDetails
@end

@implementation FileUploadFailedDetails
@end

@interface TestFixtureBase ()


- (void)loadIds;
- (void)createUsers;
- (void)createUser:(NSString *)prefix suffix:(int)suffix;
- (NSString *)authenticateUser:(NSString *)userId password:(NSString *)password;

@end

NSMutableDictionary *m_users;

@implementation TestFixtureBase

- (id)initWithInvocation:(NSInvocation *)invocation
{
    self = [super initWithInvocation:invocation];

    _fileUploadCompletedReceived = [[NSMutableArray alloc] init];
    _fileUploadFailedReceived = [[NSMutableArray alloc] init];

    if (self)
    {
        __weak TestFixtureBase *weakSelf = self;
        successBlock = ^(NSString *serviceName, NSString *serviceOperation, NSString *jsonData,
                         BCCallbackObject cbObject)
        {
            if(_expectFail >= 1)
            {
                _XCTPrimitiveFail(weakSelf, @"%@", jsonData);
            }
            
            _apiCountExpected -= 1;
            if (_apiCountExpected <= 0)
            {
               _result = true;
            }
            _jsonResponse = jsonData;
        };

        failureBlock = ^(NSString *serviceName, NSString *serviceOperation, NSInteger statusCode,
                         NSInteger returnCode, NSString *statusMessage, BCCallbackObject cbObject)
        {
            if(_expectFail == 0)
            {
                _XCTPrimitiveFail(weakSelf, @"%@", statusMessage);
            }
            
            _apiCountExpected -= 1;
            if (_apiCountExpected <= 0)
            {
                _result = true;
            }
            _statusCode = statusCode;
            _reasonCode = returnCode;
            _statusMessage = statusMessage;
        };
        
        globalErrorBlock = ^(NSString *serviceName, NSString *serviceOperation, NSInteger statusCode,
                              NSInteger returnCode, NSString *statusMessage, BCCallbackObject cbObject)
        {
            if(_expectFail == 0)
            {
                _XCTPrimitiveFail(weakSelf, @"%@", statusMessage);
            }
            
            _apiCountExpected -= 1;
            if (_apiCountExpected <= 0)
            {
                _result = true;
            }
            _statusCode = statusCode;
            _reasonCode = returnCode;
            _statusMessage = statusMessage;
            _globalErrorCount += 1;
        };
        
        networkErrorBlock = ^()
        {
            if(_expectFail == 0)
            {
                _XCTPrimitiveFail(weakSelf, @"Network error block unexpected");
            }
            
            _apiCountExpected -= 1;
            if (_apiCountExpected <= 0)
            {
                _result = true;
            }
           // _statusCode = statusCode;
           // _reasonCode = returnCode;
           // _statusMessage = statusMessage;
            _networkErrorCount += 1;
        };

        eventBlock = ^(NSString *eventsJson) {
            _eventCallbackReceived = true;
            _eventCallbackJson = eventsJson;
        };
        
        fileUploadCompletedBlock = ^(NSString *fileUploadId, NSString *jsonResponse) {
            FileUploadCompletedDetails * details = [[FileUploadCompletedDetails alloc] init];
            [details setFileUploadId:fileUploadId];
            [details setJsonResponse:jsonResponse];
            [_fileUploadCompletedReceived addObject:details];
        };
        fileUploadFailedBlock = ^(NSString *fileUploadId, NSInteger status, NSInteger reasonCode, NSString *jsonResponse) {
            FileUploadFailedDetails * details = [[FileUploadFailedDetails alloc] init];
            [details setFileUploadId:fileUploadId];
            [details setStatus:status];
            [details setReasonCode:reasonCode];
            [details setJsonResponse:jsonResponse];
            [_fileUploadFailedReceived addObject:details];
        };
        
        rewardBlock = ^(NSString *eventsJson) {
            
            NSData *data = [eventsJson dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
            int apiRewardsSize = 0;
            apiRewardsSize = (int) [(NSArray *)[jsonObj objectForKey:@"apiRewards"] count];
            _rewardCallbacksReceived += 1;
            _apiRewardsReceived += apiRewardsSize;
            _rewardCallbackJson = eventsJson;
        };
        
        

    }
    return self;
}

- (void)setUp
{
    [super setUp];
    [self loadIds];
    m_client = [BrainCloudClient getInstance];
    [m_client initialize:m_serverUrl
               secretKey:m_secret
                  gameId:m_appId
             gameVersion:m_version];
    [m_client enableLogging:TRUE];
    [self createUsers];

    if ([self authenticateOnSetup])
    {
        [[m_client authenticationService]
            authenticateUniversal:[TestFixtureBase getUser:@"UserA"].m_id
                         password:[TestFixtureBase getUser:@"UserA"].m_password
                      forceCreate:true
                  completionBlock:successBlock
             errorCompletionBlock:failureBlock
                         cbObject:nil];
        [self waitForResult];
    }
}

- (void)tearDown
{
    [m_client resetCommunication];
    [[m_client authenticationService] clearSavedProfile];
    [super tearDown];
}

- (void)loadIds
{
    // syntax if loading file from bundle of a running app
    // NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ids" ofType:@"txt"];

    // syntax if loading file from XTC
    NSString *filePath =
        [[NSBundle bundleForClass:[self class]] pathForResource:@"ids" ofType:@"txt"];

    NSString *fileContents =
        [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];

    for (NSString *line in
         [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
    {
        if ([line hasPrefix:@"appId"])
        {
            NSRange range = [line rangeOfString:@"="];
            m_appId = [line substringFromIndex:range.location + 1];
        }
        else if ([line hasPrefix:@"serverUrl"])
        {
            NSRange range = [line rangeOfString:@"="];
            m_serverUrl = [line substringFromIndex:range.location + 1];
        }
        else if ([line hasPrefix:@"secret"])
        {
            NSRange range = [line rangeOfString:@"="];
            m_secret = [line substringFromIndex:range.location + 1];
        }
        else if ([line hasPrefix:@"version"])
        {
            NSRange range = [line rangeOfString:@"="];
            m_version = [line substringFromIndex:range.location + 1];
        }
        else if ([line hasPrefix:@"childAppId"])
        {
            NSRange range = [line rangeOfString:@"="];
            m_childAppId = [line substringFromIndex:range.location + 1];
        }
        else if ([line hasPrefix:@"parentLevelName"])
        {
            NSRange range = [line rangeOfString:@"="];
            m_parentLevel = [line substringFromIndex:range.location + 1];
        }
    }
}

- (void)waitForResult
{
    [self waitForResultExpectedCount:1 expectFail:false];
}

- (void)waitForFailedResult
{
    [self waitForResultExpectedCount:1 expectFail:true];
}

- (void)waitForResultExpectedCount:(int)numApiCalls
{
    [self waitForResultExpectedCount:numApiCalls expectFail:false];
}

- (void)waitForResultExpectedCount:(int)numApiCalls
                        expectFail:(bool)expectFail
{
    [self reset];
    _apiCountExpected = numApiCalls;
    _expectFail = expectFail ? 1 : 0;
    
    long maxWait = MAX_WAIT_SECS * 1000;

    while (!_result && maxWait > 0)
    {
        [NSThread sleepForTimeInterval:0.01f];
        maxWait -= 10;
        [m_client runCallBacks];
    }
}

- (void)reset
{
    _result = false;
    _apiCountExpected = 0;
    _jsonResponse = @"";
    _statusCode = 0;
    _reasonCode = 0;
    _statusMessage = @"";
    _eventCallbackReceived = false;
    _eventCallbackJson = @"";
    _rewardCallbacksReceived = 0;
    _rewardCallbackJson = @"";
    _apiRewardsReceived = 0;
    _expectFail = 0;
    
    // [m_client resetCommunication];
    [[m_client authenticationService] clearSavedProfile];
}

- (void)createUsers
{
    if (m_users != nil) return;
    m_users = [[NSMutableDictionary alloc] init];
    [self createUser:@"UserA" suffix:arc4random()];
    [self createUser:@"UserB" suffix:arc4random()];
    [self createUser:@"UserC" suffix:arc4random()];

    [[m_client playerStateService] logout:successBlock
                     errorCompletionBlock:failureBlock
                                 cbObject:nil];
    [self waitForResult];
}

- (void)createUser:(NSString *)prefix suffix:(int)suffix
{
    TestUser *user = [[TestUser alloc] initWithIds:prefix suffix:suffix];
    user.m_profileId = [self authenticateUser:user.m_id password:user.m_password];
    
    [[m_client playerStateService] updateContactEmail:user.m_email
                                          completionBlock:successBlock
                                     errorCompletionBlock:failureBlock
                                                 cbObject:nil];
    [self waitForResult];
    
    [m_users setObject:user forKey:prefix];
}

- (NSString *)authenticateUser:(NSString *)userId password:(NSString *)password
{
    [[m_client authenticationService] authenticateUniversal:userId
                                                   password:password
                                                forceCreate:true
                                            completionBlock:successBlock
                                       errorCompletionBlock:failureBlock
                                                   cbObject:nil];
    [self waitForResult];
    NSString *playerId = [m_client authenticationService].profileID;
    [[m_client authenticationService] clearSavedProfile];
    return playerId;
}

+ (NSDictionary *)getDataFromResponse:(NSString *)jsonResponse
{
    NSData *data = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
    return (NSDictionary *)[jsonObj objectForKey:@"data"];
}

+ (TestUser *)getUser:(NSString *)userId
{
    return [m_users objectForKey:userId];
}

- (bool)authenticateOnSetup { return true; }

- (bool)goToChildProfile
{
    [[m_client identityService] switchToSingletonChildProfile:m_childAppId
                                         forceCreate:true
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
    return self.result;
}

+ (NSString *)getJsonString:(id)object
{
    NSError *writeError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:&writeError];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end
