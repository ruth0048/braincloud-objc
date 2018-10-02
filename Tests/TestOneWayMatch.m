//
//  TestOneWayMatch.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-12.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestOneWayMatch : TestFixtureBase

@end

@implementation TestOneWayMatch

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testStartMatch
{
    NSString *matchId = [self startMatch];
    [self cancelMatch:matchId];
}

- (void)testCancelMatch
{
    NSString *matchId = [self startMatch];
    [self cancelMatch:matchId];
}

- (void)testCompleteMatch
{
    NSString *matchId = [self startMatch];
    [[m_client oneWayMatchService] completeMatch:matchId
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
}

/// Helper Functions ///
- (NSString *)startMatch
{
    [[m_client oneWayMatchService] startMatch:[TestFixtureBase getUser:@"UserC"].m_profileId
                                   rangeDelta:100
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
    return
        [[TestFixtureBase getDataFromResponse:self.jsonResponse] objectForKey:@"playbackStreamId"];
}

- (void)cancelMatch:(NSString *)streamId
{
    [[m_client oneWayMatchService] cancelMatch:streamId
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];
}

@end
