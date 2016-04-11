//
//  TestEntity.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-07.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"
#import "ACL.hh"

@interface TestEntity : TestFixtureBase

@end

@implementation TestEntity

NSString *entityType = @"address";
NSString *entityValueName = @"street";
NSString *entityData = @"{ \"street\":\"testAddress\" }";

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testCreateEntity
{
    NSString *entityId = [self createDefaultEntity:ReadWrite];
    [self deleteEntity:entityId version:1];
}

- (void)testDeleteEntity
{
    NSString *entityId = [self createDefaultEntity:ReadWrite];
    [[m_client entityService] deleteEntity:entityId
                                   version:1
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

- (void)testGetEntity
{
    NSString *entityId = [self createDefaultEntity:ReadWrite];
    [[m_client entityService] getEntity:entityId
                        completionBlock:successBlock
                   errorCompletionBlock:failureBlock
                               cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:1];
}

- (void)testGetSingleton
{
    NSString *entityId = [self createDefaultEntity:None];
    [[m_client entityService] getSingleton:entityType
                        completionBlock:successBlock
                   errorCompletionBlock:failureBlock
                               cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:1];
}

- (void)testUpdateEntity
{
    NSString *entityId = [self createDefaultEntity:ReadWrite];
    [[m_client entityService] updateEntity:entityId
                                entityType:entityType
                            jsonEntityData:entityData
                             jsonEntityAcl:[ACL getAclJson:ReadWrite]
                                   version:1
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:2];
}

- (void)testGetSharedEntityForPlayerId
{
    NSString *entityId = [self createDefaultEntity:ReadWrite];
    [[m_client entityService]
     getSharedEntityForPlayerId:[TestFixtureBase getUser:@"UserA"].m_profileId
     entityId:entityId
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:1];
}

- (void)testGetSharedEntitiesForPlayerId
{
    NSString *entityId = [self createDefaultEntity:ReadWrite];
    [[m_client entityService]
        getSharedEntitiesForPlayerId:[TestFixtureBase getUser:@"UserA"].m_profileId
                     completionBlock:successBlock
                errorCompletionBlock:failureBlock
                            cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:1];
}

- (void)testGetEntitiesByType
{
    NSString *entityId = [self createDefaultEntity:ReadWrite];
    [[m_client entityService] getEntitiesByType:entityType
                                completionBlock:successBlock
                           errorCompletionBlock:failureBlock
                                       cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:1];
}

- (void)testUpdateSharedEntity
{
    NSString *entityId = [self createDefaultEntity:ReadWrite];

    [[m_client entityService] updateSharedEntity:entityId
                                  targetPlayerId:[TestFixtureBase getUser:@"UserA"].m_profileId
                                      entityType:entityType
                                  jsonEntityData:entityData
                                         version:1
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:2];
}

- (void)testUpdateSingleton
{
    NSString *entityId = [self createDefaultEntity:ReadWrite];
    [[m_client entityService] updateSingleton:entityType
                               jsonEntityData:entityData
                                jsonEntityAcl:[ACL getAclJson:ReadWrite]
                                      version:1
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:2];
}

- (void)testDeleteSingleton
{
    NSString *entityId = [self createDefaultEntity:ReadWrite];
    [[m_client entityService] deleteSingleton:entityType
                                      version:1
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];
    [self deleteEntity:entityId version:1];
}

- (void)testGetPage
{
    [[m_client entityService]
     getPage:@"{\"pagination\":{\"rowsPerPage\":125,\"pageNumber\":1},"
     @"\"searchCriteria\":{\"entityType\":\"testEntity\"}}"
     completionBlock:successBlock
     errorCompletionBlock:failureBlock
     cbObject:nil];
    [self waitForResult];
}

- (void)testGetPageOffset
{
    [[m_client entityService]
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

/* Helper functions */
- (NSString *)createDefaultEntity:(Access)access
{
    [[m_client entityService] createEntity:entityType
                            jsonEntityData:entityData
                             jsonEntityAcl:[ACL getAclJson:access]
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];

    NSData *data = [self.jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];

    return [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"entityId"];
}

- (void)deleteEntity:(NSString *)entityId version:(int)version
{
    [[m_client entityService] deleteEntity:entityId
                                   version:version
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

@end
