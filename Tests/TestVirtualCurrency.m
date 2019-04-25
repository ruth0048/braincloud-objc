//
//  TestVirtualCurrency.m
//  BrainCloud-iOS
//
//  Created by Ryan Ruth on 2018-09-28.
//  Copyright © 2018 BitHeads Inc. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestVirtualCurrency : TestFixtureBase

@end

@implementation TestVirtualCurrency

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGetCurrency
{
    [[m_client virtualCurrencyService] getCurrency:@"brainCloud"
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];
}

- (void)testGetParentCurrency
{
    [[m_client virtualCurrencyService] getParentCurrency:@"invalid_id"
                                               levelName:@"invalid_levelName"
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    [self waitForFailedResult];
}

- (void)testGetPeerCurrency
{
    [[m_client virtualCurrencyService] getPeerCurrency:@"invalid_id"
                                              peerCode:@"invalid_peerCode"
                                       completionBlock:successBlock
                                  errorCompletionBlock:failureBlock
                                              cbObject:nil];
    [self waitForFailedResult];
}

- (void)testAwardCurrency
{
    [[m_client virtualCurrencyService] awardCurrency:@"credits"
                                              amount:100
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
}

- (void)testConsumeCurrency
{
    [[m_client virtualCurrencyService] consumeCurrency:@"credits"
                                                amount:100
                                       completionBlock:successBlock
                                  errorCompletionBlock:failureBlock
                                              cbObject:nil];
    [self waitForResult];
}

- (void)testResetCurrency
{
    [[m_client virtualCurrencyService] resetCurrency:successBlock
                                  errorCompletionBlock:failureBlock
                                              cbObject:nil];
    [self waitForResult];
}

@end
