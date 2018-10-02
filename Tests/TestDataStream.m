#import "TestFixtureBase.h"

@interface TestDataStream : TestFixtureBase

@end

@implementation TestDataStream


- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testCustomPageEvent
{
    [[m_client dataStreamService] customPageEvent:@"testPage" jsonEventProperties:@"{ \"testProperty\":\"1\"}" completionBlock:successBlock
        errorCompletionBlock:failureBlock
        cbObject:nil];
}

- (void)testCustomScreenEvent
{
    [[m_client dataStreamService] customScreenEvent:@"testScreen" jsonEventProperties:@"{ \"testProperty\":\"1\"}" completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
}

- (void)testCustomTrackEvent
{
    [[m_client dataStreamService] customTrackEvent:@"testTrack" jsonEventProperties:@"{ \"testProperty\":\"1\"}" completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
}

@end
