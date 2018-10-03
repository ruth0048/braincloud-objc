//
//  TestProduct.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-07.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"
#import "BrainCloudProduct.hh"

@interface TestProduct : TestFixtureBase

@end

@implementation TestProduct

NSString *currencyType = @"credits";
NSString *platform = @"windows";
NSString *productCategory = @"Test";

- (bool)authenticateOnSetup { return true; }

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the
    // class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the
    // class.
    [super tearDown];
}

- (void)testGetCurrency
{
    [[m_client productService] getCurrency:currencyType
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

- (void)testAwardCurrency
{
    [[m_client productService] awardCurrency:currencyType
                                      amount:100
                             completionBlock:successBlock
                        errorCompletionBlock:failureBlock
                                    cbObject:nil];
    [self waitForResult];
}

- (void)testConsumeCurrency
{
    [[m_client productService] consumeCurrency:currencyType
                                        amount:10
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];
}

- (void)testResetCurrency
{
    [[m_client productService] resetCurrency:successBlock
                        errorCompletionBlock:failureBlock
                                    cbObject:nil];
    [self waitForResult];
}

- (void)testGetEligiblePromotions
{
    [[m_client productService] getEligiblePromotions:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
}

- (void)testGetSalesInventory
{
    [[m_client productService] getSalesInventory:platform
                                    userCurrency:@"CAD"
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
}

- (void)testGetSalesInventoryByCategory
{
    [[m_client productService] getSalesInventoryByCategory:platform
                                              userCurrency:@"CAD"
                                                  category:productCategory
                                           completionBlock:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];
}

@end
