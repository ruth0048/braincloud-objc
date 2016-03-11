//
//  TestPlayerStatistics.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-07.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestPlayerStatistics : TestFixtureBase

@end

@implementation TestPlayerStatistics

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testReadAllPlayerStats
{
    [[m_client playerStatisticsService] readAllPlayerStats:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];
}

- (void)testReadPlayerStatsSubset
{
    NSArray * array = @[@"currency", @"highestScore"];
    [[m_client playerStatisticsService] readPlayerStatsSubset:array
                                              completionBlock:successBlock
                                         errorCompletionBlock:failureBlock
                                                     cbObject:nil];
    [self waitForResult];
}

- (void)testReadPlayerStatsForCategory
{
    [[m_client playerStatisticsService] readPlayerStatsForCategory:@"Test"
                                                   completionBlock:successBlock
                                              errorCompletionBlock:failureBlock
                                                          cbObject:nil];
    [self waitForResult];
}

- (void)testIncrementPlayerStats
{
    NSString *data = @"{ \"highestScore\":\"RESET\" }";
    [[m_client playerStatisticsService] incrementPlayerStats:data
                                             completionBlock:successBlock
                                        errorCompletionBlock:failureBlock
                                                    cbObject:nil];
    [self waitForResult];
}

- (void)testResetAllPlayerStats
{
    [[m_client playerStatisticsService] resetAllPlayerStats:successBlock
                                       errorCompletionBlock:failureBlock
                                                   cbObject:nil];
    [self waitForResult];
}

- (void)testIncrementExperiencePoints
{
    [[m_client playerStatisticsService] incrementExperiencePoints:10
                                                  completionBlock:successBlock
                                             errorCompletionBlock:failureBlock
                                                         cbObject:nil];
    [self waitForResult];
}

- (void)testGetNextExperienceLevel
{
    [[m_client playerStatisticsService] getNextExperienceLevel:successBlock
                                          errorCompletionBlock:failureBlock
                                                      cbObject:nil];
    [self waitForResult];
}

- (void)testSetExperiencePoints
{
    [[m_client playerStatisticsService] setExperiencePoints:200
                                            completionBlock:successBlock
                                       errorCompletionBlock:failureBlock
                                                   cbObject:nil];
    [self waitForResult];
}

@end
