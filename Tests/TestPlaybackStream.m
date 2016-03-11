//
//  TestPlaybackStream.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-12.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestPlaybackStream : TestFixtureBase

@end

@implementation TestPlaybackStream

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testStartStream
{
    NSString *streamId = [self startStream];
    [self endStream:streamId];
}

- (void)testEndStream
{
    NSString *streamId = [self startStream];
    [self endStream:streamId];
}

- (void)testDeleteStream
{
    NSString *streamId = [self startStream];
    [[m_client playbackStreamService] deleteStream:streamId
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];
}

- (void)testAddEvent
{
    NSString *streamId = [self startStream];
    [[m_client playbackStreamService] addEvent:streamId
                                 jsonEventData:@"{ \"test\":\"test\" }"
                                   jsonSummary:@"{ \"test\":\"test\" }"
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];
    [self endStream:streamId];
}

- (void)testGetStreamSummariesForTargetPlayer
{
    [[m_client playbackStreamService]
        getStreamSummariesForTargetPlayer:[TestFixtureBase getUser:@"UserB"].m_profileId
                          completionBlock:successBlock
                     errorCompletionBlock:failureBlock
                                 cbObject:nil];
    [self waitForResult];
}

- (void)testGetStreamSummariesForInitiatingPlayer
{
    [[m_client playbackStreamService]
        getStreamSummariesForInitiatingPlayer:[TestFixtureBase getUser:@"UserA"].m_profileId
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
}

- (void)testReadStream
{
    NSString *streamId = [self startStream];
    [[m_client playbackStreamService] readStream:streamId
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
    [self endStream:streamId];
}

/// Helper Functions ///
- (NSString *)startStream
{
    [[m_client playbackStreamService] startStream:[TestFixtureBase getUser:@"UserB"].m_profileId
                                includeSharedData:true
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForResult];
    return
        [[TestFixtureBase getDataFromResponse:self.jsonResponse] objectForKey:@"playbackStreamId"];
}

- (void)endStream:(NSString *)streamId
{
    [[m_client playbackStreamService] endStream:streamId
                                completionBlock:successBlock
                           errorCompletionBlock:failureBlock
                                       cbObject:nil];
    [self waitForResult];
}

@end
