//
//  TestGroup.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2016-05-11.
//  Copyright (c) 2016 bitHeads. All rights reserved.
//

#import "ACL.hh"
#import "TestFixtureBase.h"

@interface TestGroup : TestFixtureBase

@end

@implementation TestGroup

NSString *groupType = @"test";
NSString *groupEntityType = @"test";
NSString *testJsonPair = @"{ \"test\": 123 }";
NSString *testAcl = @"{ \"other\": 2, \"member\": 2 }";

NSString *groupId = @"";

- (bool)authenticateOnSetup { return false; }

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)testAcceptGroupInvitation
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] inviteGroupMember:groupId
                                     profileId:[TestFixtureBase getUser:@"UserB"].m_profileId
                                          role:MEMBER
                                jsonAttributes:testJsonPair
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];

    [self logout];
    [self authenticate:@"UserB"];

    [[m_client groupService] acceptGroupInvitation:groupId
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];

    [self logout];
    [self deleteGroupAsUserA];
}

- (void)testAutoJoinGroup
{
    [self createGroupAsUserA:YES];
    [self authenticate:@"UserB"];

    [[m_client groupService] autoJoinGroup:groupType
                          autoJoinStrategy:JoinFirstGroup
                             dataQueryJson:nil
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];

    [self logout];
    [self deleteGroupAsUserA];
}

- (void)testAddGroupMember
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] addGroupMember:groupId
                                  profileId:[TestFixtureBase getUser:@"UserB"].m_profileId
                                       role:ADMIN
                             jsonAttributes:testJsonPair
                            completionBlock:successBlock
                       errorCompletionBlock:failureBlock
                                   cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testApproveGroupJoinRequest
{
    [self createGroupAsUserA];
    [self authenticate:@"UserB"];

    [[m_client groupService] joinGroup:groupId
                       completionBlock:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForResult];

    [self logout];
    [self authenticate:@"UserA"];

    [[m_client groupService] approveGroupJoinRequest:groupId
                                           profileId:[TestFixtureBase getUser:@"UserB"].m_profileId
                                                role:MEMBER
                                      jsonAttributes:testJsonPair
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testCancelGroupInvitation
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] inviteGroupMember:groupId
                                     profileId:[TestFixtureBase getUser:@"UserB"].m_profileId
                                          role:MEMBER
                                jsonAttributes:testJsonPair
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];

    [[m_client groupService] cancelGroupInvitation:groupId
                                         profileId:[TestFixtureBase getUser:@"UserB"].m_profileId
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testCreateGroup
{
    [self authenticate:@"UserA"];
    [self createGroup];
    [self deleteGroup];
    [self logout];
}

- (void)testCreateGroupWithSummaryData
{
    [self authenticate:@"UserA"];
    [self createGroupWithSummaryData:true];
    [self deleteGroup];
    [self logout];
}

- (void)testDeleteGroup
{
    [self authenticate:@"UserA"];
    [self createGroup];
    [self deleteGroup];
    [self logout];
}

- (void)testDeleteGroupEntity
{
    [self authenticate:@"UserA"];
    [self createGroup];

    NSString *entityId = [self createGroupEntity];

    [[m_client groupService] deleteGroupEntity:groupId
                                      entityId:entityId
                                       version:1
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
    [self logout];
}

- (void)testGetMyGroups
{
    [self authenticate:@"UserA"];

    [[m_client groupService] getMyGroups:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];

    [self logout];
}

- (void)testIncrementGroupData
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] incrementGroupData:groupId
                                       jsonData:testJsonPair
                                completionBlock:successBlock
                           errorCompletionBlock:failureBlock
                                       cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
    [self logout];
}

- (void)testIncrementGroupEntityData
{
    [self authenticate:@"UserA"];
    [self createGroup];

    NSString *entityId = [self createGroupEntity];

    [[m_client groupService] incrementGroupEntityData:groupId
                                             entityId:entityId
                                             jsonData:testJsonPair
                                      completionBlock:successBlock
                                 errorCompletionBlock:failureBlock
                                             cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
    [self logout];
}

- (void)testInviteGroupMember
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] inviteGroupMember:groupId
                                     profileId:[TestFixtureBase getUser:@"UserB"].m_profileId
                                          role:MEMBER
                                jsonAttributes:testJsonPair
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testJoinGroup
{
    [self createGroupAsUserA];
    [self authenticate:@"UserB"];

    [[m_client groupService] joinGroup:groupId
                       completionBlock:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForResult];

    [self deleteGroupAsUserA];
}

- (void)testLeaveGroup
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] leaveGroup:groupId
                        completionBlock:successBlock
                   errorCompletionBlock:failureBlock
                               cbObject:nil];
    [self waitForResult];
}

- (void)testListGroupsPage
{
    [self authenticate:@"UserA"];

    NSString *context = [self createContext:@"groupType" searchValue:groupType];

    [[m_client groupService] listGroupsPage:context
                            completionBlock:successBlock
                       errorCompletionBlock:failureBlock
                                   cbObject:nil];
    [self waitForResult];
}

- (void)testListGroupsPageByOffset
{
    [self authenticate:@"UserA"];

    NSString *context = [self createContext:@"groupType" searchValue:groupType];

    [[m_client groupService] listGroupsPage:context
                            completionBlock:successBlock
                       errorCompletionBlock:failureBlock
                                   cbObject:nil];
    [self waitForResult];

    context = [self getContext:_jsonResponse];

    [[m_client groupService] listGroupsPageByOffset:context
                                         pageOffset:1
                                    completionBlock:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForResult];
}

- (void)testReadGroup
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] readGroup:groupId
                       completionBlock:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testReadGroupData
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] readGroupData:groupId
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testReadGroupEntitiesPage
{
    [self authenticate:@"UserA"];
    [self createGroup];

    NSString *context = [self createContext:@"groupId" searchValue:groupId];

    [[m_client groupService] readGroupEntitiesPage:context
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];
    [self deleteGroup];
}

- (void)testReadGroupEntitiesPageByOffset
{
    [self authenticate:@"UserA"];
    [self createGroup];

    NSString *context = [self createContext:@"groupId" searchValue:groupId];

    [[m_client groupService] readGroupEntitiesPage:context
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];

    context = [self getContext:_jsonResponse];

    [[m_client groupService] readGroupEntitiesPageByOffset:context
                                                pageOffset:1
                                           completionBlock:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];
    [self deleteGroup];
}

- (void)testReadGroupEntity
{
    [self authenticate:@"UserA"];
    [self createGroup];

    NSString *entityId = [self createGroupEntity];

    [[m_client groupService] readGroupEntity:groupId
                                    entityId:entityId
                             completionBlock:successBlock
                        errorCompletionBlock:failureBlock
                                    cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testReadGroupMembers
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] readGroupMembers:groupId
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testRejectGroupInvitation
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] inviteGroupMember:groupId
                                     profileId:[TestFixtureBase getUser:@"UserB"].m_profileId
                                          role:MEMBER
                                jsonAttributes:testJsonPair
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];

    [self logout];
    [self authenticate:@"UserB"];

    [[m_client groupService] rejectGroupInvitation:groupId
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];

    [self logout];
    [self deleteGroupAsUserA];
}

- (void)testRejectGroupJoinRequest
{
    [self createGroupAsUserA];
    [self authenticate:@"UserB"];

    [[m_client groupService] joinGroup:groupId
                       completionBlock:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForResult];

    [self logout];
    [self authenticate:@"UserA"];

    [[m_client groupService] rejectGroupJoinRequest:groupId
                                          profileId:[TestFixtureBase getUser:@"UserB"].m_profileId
                                    completionBlock:successBlock
                               errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testRemoveGroupMember
{
    [self createGroupAsUserA];
    [self authenticate:@"UserB"];

    [[m_client groupService] joinGroup:groupId
                       completionBlock:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForResult];

    [self logout];
    [self authenticate:@"UserA"];

    [[m_client groupService] approveGroupJoinRequest:groupId
                                           profileId:[TestFixtureBase getUser:@"UserB"].m_profileId
                                                role:MEMBER
                                      jsonAttributes:testJsonPair
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];

    [[m_client groupService] removeGroupMember:groupId
                                     profileId:[TestFixtureBase getUser:@"UserB"].m_profileId
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];

    [self deleteGroup];
}

- (void)testUpdateGroupData
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] updateGroupData:groupId
                                     version:1
                                    jsonData:testJsonPair
                             completionBlock:successBlock
                        errorCompletionBlock:failureBlock
                                    cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testUpdateGroupEntityData
{
    [self authenticate:@"UserA"];
    [self createGroup];

    NSString *entityId = [self createGroupEntity];

    [[m_client groupService] updateGroupEntityData:groupId
                                          entityId:entityId
                                           version:1
                                          jsonData:testJsonPair
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testUpdateGroupMember
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] updateGroupMember:groupId
                                     profileId:[TestFixtureBase getUser:@"UserA"].m_profileId
                                          role:UNKNOWN
                                jsonAttributes:testJsonPair
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testUpdateGroupName
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] updateGroupName:groupId
                                        name:@"testName2"
                             completionBlock:successBlock
                        errorCompletionBlock:failureBlock
                                    cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

- (void)testSetGroupOpen
{
    [[m_client groupService] setGroupOpen:@"invalidGroupID"
                              isOpenGroup:true
                          completionBlock:successBlock
                     errorCompletionBlock:failureBlock
                                 cbObject:nil];
    //no group exists
    [self waitForFailedResult];
}

- (void)testPost
{
    [[m_client groupService] setGroupOpen:@"invalidGroupID"
                              isOpenGroup:true
                          completionBlock:successBlock
                     errorCompletionBlock:failureBlock
                                 cbObject:nil];
    //no group exists
    [self waitForFailedResult];
}

- (void)testUpdateGroupSummary
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] updateGroupSummaryData:@"invalidgroupId"
                                            version:-1
                                        summaryData:@""
                                    completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                           cbObject:nil];
    [self waitForFailedResult];

    [self deleteGroup];
}

- (void)testGetRandomGroupsMatching
{
    [self authenticate:@"UserA"];
    [self createGroup];

    [[m_client groupService] getRandomGroupsMatching:@"{\"groupType\": \"BLUE\"}"
                                           maxReturn:1
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    [self waitForResult];

    [self deleteGroup];
}

/* Helper functions */

- (void)createGroupAsUserA { [self createGroupAsUserA:NO]; }

- (void)createGroupAsUserA:(BOOL)isOpen
{
    [self authenticate:@"UserA"];
    [self createGroup:isOpen];
    [self logout];
}

- (void)deleteGroupAsUserA
{
    [self authenticate:@"UserA"];
    [self deleteGroup];
    [self logout];
}

- (void)authenticate:(NSString *)user
{
    [[m_client authenticationService] authenticateUniversal:[TestFixtureBase getUser:user].m_id
                                                   password:[TestFixtureBase getUser:user].m_password
                                                forceCreate:true
                                            completionBlock:successBlock
                                       errorCompletionBlock:failureBlock
                                                   cbObject:nil];
    [self waitForResult];
}

- (void)createGroup { [self createGroup:NO]; }

- (void)createGroup:(BOOL)isOpen
{
    [[m_client groupService] createGroup:@"testGroup"
                               groupType:groupType
                             isOpenGroup:isOpen
                                     acl:testAcl
                                jsonData:testJsonPair
                     jsonOwnerAttributes:testJsonPair
             jsonDefaultMemberAttributes:testJsonPair
                         completionBlock:successBlock
                    errorCompletionBlock:failureBlock
                                cbObject:nil];
    [self waitForResult];

    NSData *data = [self.jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObj =
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    groupId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"groupId"];
}

- (void)createGroupWithSummaryData:(BOOL)isOpen
{
    [[m_client groupService] createGroup:@"testGroup"
                               groupType:groupType
                             isOpenGroup:isOpen
                                     acl:testAcl
                                jsonData:testJsonPair
                     jsonOwnerAttributes:testJsonPair
             jsonDefaultMemberAttributes:testJsonPair
                         jsonSummaryData:testJsonPair
                         completionBlock:successBlock
                    errorCompletionBlock:failureBlock
                                cbObject:nil];
    [self waitForResult];
    
    NSData *data = [self.jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObj =
    [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    groupId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"groupId"];
}

- (NSString *)createGroupEntity
{
    [[m_client groupService] createGroupEntity:groupId
                                    entityType:groupEntityType
                          isOwnedByGroupMember:NO
                                           acl:testAcl
                                      jsonData:testJsonPair
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    [self waitForResult];

    NSData *data = [self.jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObj =
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    return [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"entityId"];
}

- (void)deleteGroup
{
    [[m_client groupService] deleteGroup:groupId
                                 version:-1
                         completionBlock:successBlock
                    errorCompletionBlock:failureBlock
                                cbObject:nil];
    [self waitForResult];
}

- (void)logout
{
    [[m_client playerStateService] logout:successBlock errorCompletionBlock:failureBlock cbObject:nil];
    [self waitForResult];
    [[m_client authenticationService] clearSavedProfile];
}

- (NSString *)createContext:(NSString *)searchField searchValue:(NSString *)value
{
    NSDictionary *page = @{ @"rowsPerPage" : @50, @"pageNumber" : @1 };
    NSDictionary *search = @{searchField : value};

    NSDictionary *dict = @{ @"pagination" : page, @"searchCriteria" : search };

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)getContext:(NSString *)jsonReturn
{
    NSData *data = [jsonReturn dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObj =
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    return [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"context"];
}

@end
