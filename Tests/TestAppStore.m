//
//  TestAppStore.m
//  BrainCloud-iOS
//
//  Created by Ryan Ruth on 2018-09-28.
//  Copyright © 2018 BitHeads Inc. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestAppStore : TestFixtureBase

@end

@implementation TestAppStore

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testVerifyPurchase
{
    [[m_client appStoreService] verifyPurchase:@"invalid_storeId"
                                   receiptData:@"{}"
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForFailedResult];
}

- (void)testGetEligiblePromotions
{
    [[m_client appStoreService] getEligiblePromotions:successBlock
                                 errorCompletionBlock:failureBlock
                                             cbObject:nil];
    [self waitForResult];
}

- (void)testGetSalesInventory
{
    [[m_client appStoreService] getSalesInventory:@"invalid_storeid"
                                     userCurrency:@"invalid_user_currency"
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    [self waitForFailedResult];
}

- (void)testGetSalesInventoryByCategory
{
    [[m_client appStoreService] getSalesInventoryByCategory:@"invalid_storeid"
                                               userCurrency:@"invalid_currency"
                                                   category:@"invalid_category"
                                            completionBlock:successBlock
                                       errorCompletionBlock:failureBlock
                                                   cbObject:nil];
    [self waitForFailedResult];
}

- (void)testStartPurchase
{
    [[m_client appStoreService] startPurchase:@"invalid_storeId"
                                 purchaseData:@"{}"
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForFailedResult];
}

- (void)testFinalizePurchase
{
    [[m_client appStoreService] finalizePurchase:@"invalid_storeId"
                                   transactionId:@"{}"
                                 transactionData:@"{}"
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForFailedResult];
}

@end
