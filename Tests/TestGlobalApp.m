//
//  TestGlobalApp.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-10.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestGlobalApp : TestFixtureBase

@end

@implementation TestGlobalApp

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testReadProperties
{
    [[m_client globalAppService] readProperties:successBlock
                           errorCompletionBlock:failureBlock
                                       cbObject:nil];
    [self waitForResult];
}

@end
