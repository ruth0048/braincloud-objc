//
//  TestTime.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-12.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestTime : TestFixtureBase

@end

@implementation TestTime

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testReadServerTime
{
    [[m_client timeService] readServerTime:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

@end
