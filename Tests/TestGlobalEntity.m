//
//  TestGlobalEntity.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-10.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"
#import "ACL.hh"

@interface TestGlobalEntity : TestFixtureBase

@end

@implementation TestGlobalEntity

NSString *globalEntityType = @"testGlobalEntity";
NSString *globalEntityValueName = @"globalTestName";
NSString *globalEntityData = @"{ \"globalTestName\":\"testValue\" }";
NSString *testIndexedId = @"testIndexedId";

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testCreateEntity
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:nil];
    [self deleteEntity:entityId version:1];
}

- (void)testCreateEntityWithIndexedId
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:testIndexedId];
    [self deleteEntity:entityId version:1];
}

- (void)testDeleteEntity
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:nil];
    [self deleteEntity:entityId version:1];
}

- (void)testGetListByIndexedId
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:testIndexedId];

    [[m_client globalEntityService] getListByIndexedId:testIndexedId
                                             maxReturn:32
                                       completionBlock:successBlock
                                  errorCompletionBlock:failureBlock
                                              cbObject:nil];
    [self waitForResult];

    [self deleteEntity:entityId version:1];
}

- (void)testGetList
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:testIndexedId];

    [[m_client globalEntityService] getList:@"{ \"entityType\":\"testEntity\" }"
                                    orderBy:nil
                                  maxReturn:32
                            completionBlock:successBlock
                       errorCompletionBlock:failureBlock
                                   cbObject:nil];
    [self waitForResult];

    [self deleteEntity:entityId version:1];
}

- (void)testGetListCount
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:testIndexedId];

    [[m_client globalEntityService] getListCount:@"{ \"entityType\":\"testGlobalEntity\" }"
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];

    [self deleteEntity:entityId version:1];
}

- (void)testReadEntity
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:nil];
    [[m_client globalEntityService] readEntity:entityId
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:1];
}

- (void)testUpdateEntity
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:nil];
    [[m_client globalEntityService] updateEntity:entityId
                                         version:1
                                  jsonEntityData:globalEntityData
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:2];
}

- (void)testUpdateEntityAcl
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:nil];
    [[m_client globalEntityService] updateEntityAcl:entityId
                                            version:1
                                      jsonEntityAcl:[ACL getAclJson:ReadWrite]
                                    completionBlock:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:2];
}

- (void)testUpdateEntityTimeToLive
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:nil];
    [[m_client globalEntityService] updateEntityTimeToLive:entityId
                                                   version:1
                                                timeToLive:1234
                                           completionBlock:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:2];
}

- (void)testGetPage
{
    [[m_client globalEntityService]
                     getPage:@"{\"pagination\":{\"rowsPerPage\":125,\"pageNumber\":1},"
                     @"\"searchCriteria\":{\"entityType\":\"testGlobalEntity\"}}"
             completionBlock:successBlock
        errorCompletionBlock:failureBlock
                    cbObject:nil];
    [self waitForResult];
}

- (void)testGetPageOffset
{
    [[m_client globalEntityService]
               getPageOffset:@"eyJzZWFyY2hDcml0ZXJpYSI6eyJlbnRpdHlUeXBlIjoidGVzdEdsb2JhbEVudGl0eSIs"
               @"ImdhbWVJZCI6IjEwMTcwIiwiJG9yIjpbeyJvd25lcklkIjoiMTgwNjNkMDUtYmIzYi0"
               @"0MWJmLTgyZTYtYTUxMWVjNjMzOTZlIn0seyJhY2wub3RoZXIiOnsiJG5lIjowfX1dfS"
               @"wic29ydENyaXRlcmlhIjp7fSwicGFnaW5hdGlvbiI6eyJyb3dzUGVyUGFnZSI6MTAwL"
               @"CJwYWdlTnVtYmVyIjoxfSwib3B0aW9ucyI6bnVsbH0"
                  pageOffset:1
             completionBlock:successBlock
        errorCompletionBlock:failureBlock
                    cbObject:nil];
    [self waitForResult];
}

- (void)testIncrementGlobalEntityData
{
    [[m_client globalEntityService] createEntity:globalEntityType
                                      timeToLive:10000
                                   jsonEntityAcl:@""
                                  jsonEntityData:@"{\"test\": 123}"
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];

    NSData *data = [self.jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];

    NSString *entityId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"entityId"];

    [[m_client globalEntityService] incrementGlobalEntityData:entityId
                                             jsonData:@"{\"test\": 123}"
                                      completionBlock:successBlock
                                 errorCompletionBlock:failureBlock
                                             cbObject:nil];
    [self waitForResult];
}

- (void)testGetRandomEntitiesMatching
{
    [[m_client globalEntityService] getRandomEntitiesMatching:@"{\"entityType\": \"address\"}"
                                                    maxReturn: 2
                                              completionBlock:successBlock
                                         errorCompletionBlock:failureBlock
                                                     cbObject:nil];
    [self waitForResult];
}

- (void)testUpdateEntityOwnerAndAcl
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:nil];
    [[m_client globalEntityService] updateEntityOwnerAndAcl:entityId
                                                    version:-1
                                                    ownerId:[TestFixtureBase getUser:@"UserB"].m_profileId
                                              jsonEntityAcl:[ACL getAclJson:ReadWrite]
                                            completionBlock:successBlock
                                       errorCompletionBlock:failureBlock
                                                   cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:2];
}

- (void)testMakeSystemEntity
{
    NSString *entityId = [self createDefultEntity:ReadWrite indexedId:nil];
    [[m_client globalEntityService] makeSystemEntity:entityId
                                             version:-1
                                       jsonEntityAcl:[ACL getAclJson:ReadWrite]
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:2];
}

/* Helper functions */
- (NSString *)createDefultEntity:(Access)access indexedId:(NSString *)indexedId
{
    if (indexedId == nil)
    {
        [[m_client globalEntityService] createEntity:globalEntityType
                                          timeToLive:10000
                                       jsonEntityAcl:[ACL getAclJson:access]
                                      jsonEntityData:globalEntityData
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    }
    else
    {
        [[m_client globalEntityService] createEntityWithIndexedId:globalEntityType
                                                        indexedId:indexedId
                                                       timeToLive:10000
                                                    jsonEntityAcl:[ACL getAclJson:access]
                                                   jsonEntityData:globalEntityData
                                                  completionBlock:successBlock
                                             errorCompletionBlock:failureBlock
                                                         cbObject:nil];
    }
    [self waitForResult];

    NSData *data = [self.jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];

    return [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"entityId"];
}

- (void)deleteEntity:(NSString *)entityId version:(int)version
{
    [[m_client globalEntityService] deleteEntity:entityId
                                         version:version
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
}

@end
