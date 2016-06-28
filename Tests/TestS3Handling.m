//
//  TestS3Handling.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-13.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"

@interface TestS3Handling : TestFixtureBase

@end

@implementation TestS3Handling

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testGetFileList
{
    [[m_client s3HandlingService] getFileList:@"test"
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
}

- (void)testGetCDNUrl
{
    [[m_client s3HandlingService] getFileList:@"test"
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];

    NSData* jsonData =  [[self jsonResponse] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSString* fileId = [[[[json objectForKey:@"data"] objectForKey:@"fileDetails"] objectAtIndex:0] objectForKey:@"fileId"];

    [[m_client s3HandlingService] getCDNUrl:fileId
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
}

@end
