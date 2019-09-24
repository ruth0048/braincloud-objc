//
//  BrainCloudEntity.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-06.
//  Copyright (c) 2016 bitHeads. All rights reserved.
//

#include "BrainCloudCallback.hh"
#import "TypeHelpers.hh"
#include "braincloud/BrainCloudClient.h"
#import "BrainCloudClient.hh"
#import "BrainCloudCustomEntity.hh"

@interface BrainCloudCustomEntity ()
{
    BrainCloud::BrainCloudClient *_client;
}
@end

@implementation BrainCloudCustomEntity

- (instancetype) init: (BrainCloudClient*) client
{
    self = [super init];

    if(self) {
        _client = (BrainCloud::BrainCloudClient *)[client getInternalClient];
    }

    return self;
}

- (void)createEntity:(NSString *)entityType
            dataJson:(NSString *)dataJson
                 acl:(NSString *)acl
          timeToLive:(long)timeToLive
             isOwned:(bool)isOwned
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject
{
    _client->getCustomEntityService()->createEntity(
                                              [entityType UTF8String],
                                              [dataJson UTF8String],
                                              [acl UTF8String],
                                              timeToLive,
                                              isOwned,
                                              new BrainCloudCallback(completionBlock, ecb, cbObject));
}


- (void)deleteEntity:(NSString *)entityType
            entityId:(NSString *)entityId
      jsonEntityData:(NSString *)jsonEntityData
             version:(int)version
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject
{
    _client->getCustomEntityService()->deleteEntity(
                                                    [entityType UTF8String],
                                                    [entityId UTF8String],
                                                    [jsonEntityData UTF8String],
                                                    version,
                                                    new BrainCloudCallback(completionBlock, ecb, cbObject));
}

- (void)getCount:(NSString *)entityType
       whereJson:(NSString *)whereJson
 completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
        cbObject:(BCCallbackObject)cbObject
{
    _client->getCustomEntityService()->getCount(
                                                    [entityType UTF8String],
                                                    [whereJson UTF8String],
                                                    new BrainCloudCallback(completionBlock, ecb, cbObject));
}

- (void)getPage:(NSString *)entityType
    rowsPerPage:(int)rowsPerPage
     searchJson:(NSString *)searchJson
       sortJson:(NSString *)sortJson
        doCount:(bool)doCount
completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
       cbObject:(BCCallbackObject)cbObject
{
    _client->getCustomEntityService()->getEntityPage(
                                                [entityType UTF8String],
                                                rowsPerPage,
                                                [searchJson UTF8String],
                                                [sortJson UTF8String],
                                                doCount,
                                                new BrainCloudCallback(completionBlock, ecb, cbObject));
}

- (void)getPageOffset:(NSString *)entityType
              context:(NSString *)context
           pageOffset:(int)pageOffset
      completionBlock:(BCCompletionBlock)completionBlock
 errorCompletionBlock:(BCErrorCompletionBlock)ecb
             cbObject:(BCCallbackObject)cbObject
{
    _client->getCustomEntityService()->getEntityPageOffset(
                                                     [entityType UTF8String],
                                                     [context UTF8String],
                                                     pageOffset,
                                                     new BrainCloudCallback(completionBlock, ecb, cbObject));
}

- (void)readEntity:(NSString *)entityType
          entityId:(NSString *)entityId
   completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
          cbObject:(BCCallbackObject)cbObject
{
    _client->getCustomEntityService()->readEntity(
                                                           [entityType UTF8String],
                                                           [entityId UTF8String],
                                                           new BrainCloudCallback(completionBlock, ecb, cbObject));
}

- (void)updateEntity:(NSString *)entityType
            entityId:(NSString *)entityId
             version:(int)version
            dataJson:(NSString *)dataJson
                 acl:(NSString *)acl
          timeToLive:(long)timeToLive
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject
{
    _client->getCustomEntityService()->updateEntity(
                                                    [entityType UTF8String],
                                                    [entityId UTF8String],
                                                    version,
                                                    [dataJson UTF8String],
                                                    [acl UTF8String],
                                                    timeToLive,
                                                  new BrainCloudCallback(completionBlock, ecb, cbObject));
}

- (void)updateEntityFields:(NSString *)entityType
                  entityId:(NSString *)entityId
                   version:(int)version
                fieldsJson:(NSString *)fieldsJson
           completionBlock:(BCCompletionBlock)completionBlock
      errorCompletionBlock:(BCErrorCompletionBlock)ecb
                  cbObject:(BCCallbackObject)cbObject
{
    _client->getCustomEntityService()->updateEntityFields(
                                                    [entityType UTF8String],
                                                    [entityId UTF8String],
                                                    version,
                                                    [fieldsJson UTF8String],
                                                    new BrainCloudCallback(completionBlock, ecb, cbObject));
}


@end
