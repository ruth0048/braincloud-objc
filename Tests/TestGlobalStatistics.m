//
//  TestGlobalStatistics.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-07.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestGlobalStatistics : TestFixtureBase

@end

@implementation TestGlobalStatistics

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testIncrementGlobalStats
{
    NSString *data = @"{ \"highestScore\":\"RESET\" }";
    [[m_client globalStatisticsService] incrementGlobalStats:data
                                             completionBlock:successBlock
                                        errorCompletionBlock:failureBlock
                                                    cbObject:nil];
    [self waitForResult];
}

- (void)testReadAllGlobalStats
{
    [[m_client globalStatisticsService] readAllGlobalStats:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];
}

- (void)testReadGlobalStatsSubset
{
    NSArray * array = @[@"testStat", @"testStat2"];
    [[m_client globalStatisticsService] readGlobalStatsSubset:array
                                              completionBlock:successBlock
                                         errorCompletionBlock:failureBlock
                                                     cbObject:nil];
    [self waitForResult];
}

- (void)testReadGlobalStatsForCategory
{
    [[m_client globalStatisticsService] readGlobalStatsForCategory:@"Test"
                                                 completionBlock:successBlock
                                            errorCompletionBlock:failureBlock
                                                        cbObject:nil];
    [self waitForResult];
}

- (void)testProcessStatistics
{
    NSString *data = @"{ \"highestScore\":\"RESET\" }";
    [[m_client globalStatisticsService] processStatistics:data
                                             completionBlock:successBlock
                                        errorCompletionBlock:failureBlock
                                                    cbObject:nil];
    [self waitForResult];
}

@end
