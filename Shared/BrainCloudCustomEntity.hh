//
//  BrainCloudEntity.h
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-06.
//  Copyright (c) 2016 bitHeads. All rights reserved.
//

#pragma once

#import "BrainCloudCompletionBlocks.hh"
#import <Foundation/Foundation.h>

@class BrainCloudClient;

@interface BrainCloudCustomEntity : NSObject

/**
 * Initializes the brainCloudService
 */
- (instancetype) init: (BrainCloudClient*) client;

/**
 * Method creates a new entity on the server.
 *
 * @param entityType The entity type as defined by the user
 * @param dataJson The entity's data as a json String
 * @param acl The entity's access control list as json. A null acl implies
 *            default permissions which make the entity readable/writeable
 *            by only the player.
 * @param timeToLive
 * @param isOwned
 * @param callback Callback.
 */
- (void)createEntity:(NSString *)entityType
            dataJson:(NSString *)dataJson
                 acl:(NSString *)acl
          timeToLive:(long)timeToLive
             isOwned:(bool)isOwned
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject;

/**
 * Deletes the specified custom entity on the server, enforcing ownership/ACL permissions.
 *
 * @param entityType The entity type as defined by the user
 * @param entityId
 * @param version
 * @param callback Callback.
 */
- (void)deleteEntity:(NSString *)entityType
            entityId:(NSString *)entityId
      jsonEntityData:(NSString *)jsonEntityData
             version:(int)version
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject;

/**
 * Counts the number of custom entities meeting the specified where clause, enforcing ownership/ACL permissions.
 *
 * @param entityType The entity type as defined by the user
 * @param whereJson
 * @param callback Callback.
 */
- (void)getCount:(NSString *)entityType
           whereJson:(NSString *)whereJson
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject;

/**
 * Retrieves first page of custom entities from the server based on the custom entity type and specified query context, enforcing ownership/ACL permissions.
 *
 * @param entityType The entity type as defined by the user
 * @param rowsPerPage
 * @param searchJson
 * @param sortJson
 * @param doCount
 * @param callback Callback.
 */
- (void)getPage:(NSString *)entityType
             context:(NSString *)context
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject;

/**
 * Gets the page of custom entities from the server based on the encoded context and specified page offset, enforcing ownership/ACL permissions.
 *
 * @param entityType The entity type as defined by the user
 * @param context
 * @param pageOffset
 * @param callback Callback.
 */
- (void)getPageOffset:(NSString *)entityType
              context:(NSString *)context
           pageOffset:(int)pageOffset
      completionBlock:(BCCompletionBlock)completionBlock
 errorCompletionBlock:(BCErrorCompletionBlock)ecb
             cbObject:(BCCallbackObject)cbObject;

/**
 * Reads a custom entity, enforcing ownership/ACL permissions.
 *
 * @param entityType The entity type as defined by the user
 * @param entityId
 * @param callback Callback.
 */
- (void)readEntity:(NSString *)entityType
            entityId:(NSString *)entityId
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject;

/**
 * Replaces the specified custom entity's data, and optionally updates the acl and expiry, on the server, enforcing current ownership/ACL permissions.
 *
 * @param entityType The entity type as defined by the user
 * @param entityId
 * @param version
 * @param dataJson
 * @param acl
 * @param timeToLive
 * @param callback Callback.
 */
- (void)updateEntity:(NSString *)entityType
            entityId:(NSString *)entityId
             version:(int)version
            dataJson:(NSString *)dataJson
                 acl:(NSString *)acl
          timeToLive:(long)timeToLive
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject;

/**
 * Replaces the specified custom entity's data, and optionally updates the acl and expiry, on the server, enforcing current ownership/ACL permissions.
 *
 * @param entityType The entity type as defined by the user
 * @param entityId
 * @param version
 * @param fieldsJson * @param callback Callback.
 */
- (void)updateEntityFields:(NSString *)entityType
                  entityId:(NSString *)entityId
                   version:(int)version
                fieldsJson:(NSString *)fieldsJson
           completionBlock:(BCCompletionBlock)completionBlock
      errorCompletionBlock:(BCErrorCompletionBlock)ecb
                  cbObject:(BCCallbackObject)cbObject;

@end
