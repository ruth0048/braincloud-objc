//
//  BrainCloudGroup.mm
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2016-05-11.
//  Copyright (c) 2016 bitHeads. All rights reserved.
//

#include "BrainCloudCallback.hh"
#include "braincloud/BrainCloudClient.h"

#import "BrainCloudGroup.hh"
#import "TypeHelpers.hh"

@implementation BrainCloudGroup

- (void)acceptGroupInvitation:(NSString *)groupId
              completionBlock:(BCCompletionBlock)cb
         errorCompletionBlock:(BCErrorCompletionBlock)ecb
                     cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->acceptGroupInvitation(
        [groupId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)addGroupMember:(NSString *)groupId
             profileId:(NSString *)profileId
                  role:(GroupMemberRole)role
        jsonAttributes:(NSString *)jsonAttrib
       completionBlock:(BCCompletionBlock)cb
  errorCompletionBlock:(BCErrorCompletionBlock)ecb
              cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->addGroupMember(
        [groupId UTF8String], [profileId UTF8String], (BrainCloud::eGroupMember::Role)role,
        TypeHelpers::NSStringToStdString(jsonAttrib), new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)approveGroupJoinRequest:(NSString *)groupId
                      profileId:(NSString *)profileId
                           role:(GroupMemberRole)role
                 jsonAttributes:(NSString *)jsonAttrib
                completionBlock:(BCCompletionBlock)cb
           errorCompletionBlock:(BCErrorCompletionBlock)ecb
                       cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->approveGroupJoinRequest(
        [groupId UTF8String], [profileId UTF8String], (BrainCloud::eGroupMember::Role)role,
        TypeHelpers::NSStringToStdString(jsonAttrib), new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)autoJoinGroup:(NSString *)groupType
     autoJoinStrategy:(AutoJoinStrategy)autoJoinStrategy
        dataQueryJson:(NSString *)dataQueryJson
      completionBlock:(BCCompletionBlock)cb
 errorCompletionBlock:(BCErrorCompletionBlock)ecb
             cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->autoJoinGroup(
        [groupType UTF8String], (BrainCloud::eAutoJoinStrategy::Strategy)autoJoinStrategy,
        TypeHelpers::NSStringToStdString(dataQueryJson), new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)cancelGroupInvitation:(NSString *)groupId
                    profileId:(NSString *)profileId
              completionBlock:(BCCompletionBlock)cb
         errorCompletionBlock:(BCErrorCompletionBlock)ecb
                     cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->cancelGroupInvitation(
        [groupId UTF8String], [profileId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)createGroup:(NSString *)name
                      groupType:(NSString *)type
                    isOpenGroup:(BOOL)isOpenGroup
                            acl:(NSString *)acl
                       jsonData:(NSString *)jsonData
            jsonOwnerAttributes:(NSString *)jsonOwnerAttributes
    jsonDefaultMemberAttributes:(NSString *)jsonDefaultMemberAttributes
                completionBlock:(BCCompletionBlock)cb
           errorCompletionBlock:(BCErrorCompletionBlock)ecb
                       cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->createGroup(
        [name UTF8String], [type UTF8String], isOpenGroup ? true : false, [acl UTF8String],
        TypeHelpers::NSStringToStdString(jsonOwnerAttributes),
        TypeHelpers::NSStringToStdString(jsonDefaultMemberAttributes), TypeHelpers::NSStringToStdString(jsonData),
        new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)createGroupEntity:(NSString *)groupId
               entityType:(NSString *)entityType
     isOwnedByGroupMember:(BOOL)isOwnedByGroupMember
                      acl:(NSString *)acl
                 jsonData:(NSString *)jsonData
          completionBlock:(BCCompletionBlock)cb
     errorCompletionBlock:(BCErrorCompletionBlock)ecb
                 cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->createGroupEntity(
        [groupId UTF8String], [entityType UTF8String], isOwnedByGroupMember ? true : false, [acl UTF8String],
        [jsonData UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)deleteGroup:(NSString *)groupId
                 version:(int32_t)version
         completionBlock:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->deleteGroup(
        [groupId UTF8String], version, new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)deleteGroupEntity:(NSString *)groupId
                 entityId:(NSString *)entityId
                  version:(int32_t)version
          completionBlock:(BCCompletionBlock)cb
     errorCompletionBlock:(BCErrorCompletionBlock)ecb
                 cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->deleteGroupEntity(
        [groupId UTF8String], [entityId UTF8String], version, new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)getMyGroups:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->getMyGroups(
        new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)incrementGroupData:(NSString *)groupId
                  jsonData:(NSString *)jsonData
           completionBlock:(BCCompletionBlock)cb
      errorCompletionBlock:(BCErrorCompletionBlock)ecb
                  cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->incrementGroupData(
        [groupId UTF8String], [jsonData UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)incrementGroupEntityData:(NSString *)groupId
                        entityId:(NSString *)entityId
                        jsonData:(NSString *)jsonData
                 completionBlock:(BCCompletionBlock)cb
            errorCompletionBlock:(BCErrorCompletionBlock)ecb
                        cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->incrementGroupEntityData(
        [groupId UTF8String], [entityId UTF8String], [jsonData UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)inviteGroupMember:(NSString *)groupId
                profileId:(NSString *)profileId
                     role:(GroupMemberRole)role
           jsonAttributes:(NSString *)jsonAttrib
          completionBlock:(BCCompletionBlock)cb
     errorCompletionBlock:(BCErrorCompletionBlock)ecb
                 cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->inviteGroupMember(
        [groupId UTF8String], [profileId UTF8String], (BrainCloud::eGroupMember::Role)role,
        TypeHelpers::NSStringToStdString(jsonAttrib), new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)joinGroup:(NSString *)groupId
         completionBlock:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->joinGroup(
        [groupId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)leaveGroup:(NSString *)groupId
         completionBlock:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->leaveGroup(
        [groupId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)listGroupsPage:(NSString *)jsonContext
       completionBlock:(BCCompletionBlock)cb
  errorCompletionBlock:(BCErrorCompletionBlock)ecb
              cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->listGroupsPage(
        [jsonContext UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)listGroupsPageByOffset:(NSString *)encodedContext
                    pageOffset:(int32_t)offset
               completionBlock:(BCCompletionBlock)cb
          errorCompletionBlock:(BCErrorCompletionBlock)ecb
                      cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->listGroupsPageByOffset(
        [encodedContext UTF8String], offset, new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)listGroupsWithMember:(NSString *)profileId
             completionBlock:(BCCompletionBlock)cb
        errorCompletionBlock:(BCErrorCompletionBlock)ecb
                    cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->listGroupsWithMember(
        [profileId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)readGroup:(NSString *)groupId
         completionBlock:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->readGroup(
        [groupId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)readGroupData:(NSString *)groupId
      completionBlock:(BCCompletionBlock)cb
 errorCompletionBlock:(BCErrorCompletionBlock)ecb
             cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->readGroupData(
        [groupId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)readGroupEntitiesPage:(NSString *)jsonContext
              completionBlock:(BCCompletionBlock)cb
         errorCompletionBlock:(BCErrorCompletionBlock)ecb
                     cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->readGroupEntitiesPage(
        [jsonContext UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)readGroupEntitiesPageByOffset:(NSString *)encodedContext
                           pageOffset:(int32_t)offset
                      completionBlock:(BCCompletionBlock)cb
                 errorCompletionBlock:(BCErrorCompletionBlock)ecb
                             cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->readGroupEntitiesPageByOffset(
        [encodedContext UTF8String], offset, new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)readGroupEntity:(NSString *)groupId
               entityId:(NSString *)entityId
        completionBlock:(BCCompletionBlock)cb
   errorCompletionBlock:(BCErrorCompletionBlock)ecb
               cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->readGroupEntity(
        [groupId UTF8String], [entityId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)readGroupMembers:(NSString *)groupId
         completionBlock:(BCCompletionBlock)cb
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->readGroupMembers(
        [groupId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)rejectGroupInvitation:(NSString *)groupId
              completionBlock:(BCCompletionBlock)cb
         errorCompletionBlock:(BCErrorCompletionBlock)ecb
                     cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->rejectGroupInvitation(
        [groupId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)rejectGroupJoinRequest:(NSString *)groupId
                     profileId:(NSString *)profileId
               completionBlock:(BCCompletionBlock)cb
          errorCompletionBlock:(BCErrorCompletionBlock)ecb
                      cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->rejectGroupJoinRequest(
        [groupId UTF8String], [profileId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)removeGroupMember:(NSString *)groupId
                profileId:(NSString *)profileId
          completionBlock:(BCCompletionBlock)cb
     errorCompletionBlock:(BCErrorCompletionBlock)ecb
                 cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->removeGroupMember(
        [groupId UTF8String], [profileId UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)updateGroupData:(NSString *)groupId
                version:(int32_t)version
               jsonData:(NSString *)jsonData
        completionBlock:(BCCompletionBlock)cb
   errorCompletionBlock:(BCErrorCompletionBlock)ecb
               cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->updateGroupData(
        [groupId UTF8String], version, [jsonData UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)updateGroupEntityData:(NSString *)groupId
                     entityId:(NSString *)entityId
                      version:(int32_t)version
                     jsonData:(NSString *)jsonData
              completionBlock:(BCCompletionBlock)cb
         errorCompletionBlock:(BCErrorCompletionBlock)ecb
                     cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->updateGroupEntityData(
        [groupId UTF8String], [entityId UTF8String], version, [jsonData UTF8String],
        new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)updateGroupMember:(NSString *)groupId
                profileId:(NSString *)profileId
                     role:(GroupMemberRole)role
           jsonAttributes:(NSString *)jsonAttrib
          completionBlock:(BCCompletionBlock)cb
     errorCompletionBlock:(BCErrorCompletionBlock)ecb
                 cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->updateGroupMember(
        [groupId UTF8String], [profileId UTF8String], (BrainCloud::eGroupMember::Role)role,
        TypeHelpers::NSStringToStdString(jsonAttrib), new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)updateGroupName:(NSString *)groupId
                   name:(NSString *)name
        completionBlock:(BCCompletionBlock)cb
   errorCompletionBlock:(BCErrorCompletionBlock)ecb
               cbObject:(BCCallbackObject)cbObject;
{
    BrainCloud::BrainCloudClient::getInstance()->getGroupService()->updateGroupName(
        [groupId UTF8String], [name UTF8String], new BrainCloudCallback(cb, ecb, cbObject));
}

@end
