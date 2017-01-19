//
//  TestEvent.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-12.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestClient : TestFixtureBase

@end

@implementation TestClient

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testPacketTimeouts
{
    NSArray * timeouts = @[@15, @15, @10];
    [m_client setPacketTimeouts:timeouts];
    
    NSArray * readTimeouts = [m_client getPacketTimeouts];
    XCTAssertEqual([[timeouts objectAtIndex:0] integerValue], [[readTimeouts objectAtIndex:0] integerValue]);
    XCTAssertEqual([[timeouts objectAtIndex:1] integerValue], [[readTimeouts objectAtIndex:1] integerValue]);
    XCTAssertEqual([[timeouts objectAtIndex:2] integerValue], [[readTimeouts objectAtIndex:2] integerValue]);
    
    [m_client setPacketTimeoutsToDefault];
    readTimeouts = [m_client getPacketTimeouts];
    XCTAssertEqual([[readTimeouts objectAtIndex:0] integerValue], 10);
    XCTAssertEqual([[readTimeouts objectAtIndex:1] integerValue], 10);
    XCTAssertEqual([[readTimeouts objectAtIndex:2] integerValue], 10);
}

int _globalErrorCount = 0;

- (void)testGlobalErrorCallback
{
    [m_client registerGlobalErrorCallback:^(NSString *serviceName, NSString *serviceOperation, NSInteger statusCode, NSInteger returnCode, NSString *jsonError, BCCallbackObject cbObject) {
        _globalErrorCount++;
    }];
    
    [[m_client playerStateService] logout:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];
    
    [[m_client timeService] readServerTime:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForFailedResult];
    
    [[m_client timeService] readServerTime:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForFailedResult];
    
    [m_client deregisterGlobalErrorCallback];
    
    XCTAssertEqual(_globalErrorCount, 2);
}

- (void)testMessageQueueErrorCallback
{
    [[m_client playerStateService] logout:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];
    
    [m_client initialize:@"https://internal.braincloudservers.com/unittest-fail" secretKey:@"1234" gameId:@"1123" gameVersion:@"123"];
    [m_client registerNetworkErrorCallback:networkErrorBlock];
    [m_client enableNetworkErrorMessageCaching:true];
    
    [[m_client authenticationService] authenticateUniversal:@"abc" password:@"abc" forceCreate:true completionBlock:nil errorCompletionBlock:nil cbObject:nil];
    
    [self waitForFailedResult];
    if (_networkErrorCount == 1)
    {
        [m_client retryCachedMessages];
        [self waitForFailedResult];
        
        if (_networkErrorCount == 2)
        {
            [m_client flushCachedMessages:true];
        }
    }
    
    [m_client deregisterNetworkErrorCallback];
    
    XCTAssertEqual(_networkErrorCount, 2);
}

@end
