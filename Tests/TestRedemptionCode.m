//
//  TestRedemptionCode.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-10-26.
//  Copyright © 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestRedemptionCode : TestFixtureBase

@end

@implementation TestRedemptionCode

NSString *lastUsedCodeStatName = @"lastCodeUsed";
NSString *codeType = @"default";

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testRedeemCode
{
    NSString *dataStr = [NSString stringWithFormat: @"{ \"%@\":\"+1\" }", lastUsedCodeStatName];
    [[m_client globalStatisticsService] incrementGlobalStats:dataStr
                                             completionBlock:successBlock
                                        errorCompletionBlock:failureBlock
                                                    cbObject:nil];
    [self waitForResult];
    
    NSDictionary * data = [TestFixtureBase getDataFromResponse:self.jsonResponse];
    NSNumber* code = (NSNumber*)[[data objectForKey:@"statistics"] objectForKey:lastUsedCodeStatName];
    
    [[m_client redemptionCodeService] redeemCode:[code stringValue]
                                        codeType:codeType
                            jsonCustomRedemptionInfo:nil
                                    completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

- (void)testGetRedeemedCodes
{
    [[m_client redemptionCodeService] getRedeemedCodes:codeType
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
}


@end
