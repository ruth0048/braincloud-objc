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

@interface BrainCloudEntity : NSObject

/**
* Method creates a new entity on the server.
*
* Service Name - Entity
* Service Operation - Create
*
* @param entityType The entity type as defined by the user
* @param jsonEntityData The entity's data as a json string
* @param jsonEntityAcl The entity's access control list as json. A null acl
* implies default
* permissions which make the entity readable/writeable by only the player.
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server
* response
* @param cbObject User object sent to the completion blocks
*/
- (void)createEntity:(NSString *)entityType
      jsonEntityData:(NSString *)jsonEntityData
       jsonEntityAcl:(NSString *)jsonEntityAcl
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject;

/**
* Method updates a new entity on the server. This operation results in the
* entity
* data being completely replaced by the passed in JSON string.
*
* Service Name - Entity
* Service Operation - Update
*
* @param entityId The id of the entity to update
* @param entityType The entity type as defined by the user
* @param jsonEntityData The entity's data as a json string.
* @param jsonEntityAcl The entity's access control list as json. A null acl
* implies default
* permissions which make the entity readable/writeable by only the player.
* @param version Current version of the entity. If the version of the
* entity on the server does not match the version passed in, the
* server operation will fail. Use -1 to skip version checking.
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server
* response
* @param cbObject User object sent to the completion blocks
*/
- (void)updateEntity:(NSString *)entityId
          entityType:(NSString *)entityType
      jsonEntityData:(NSString *)jsonEntityData
       jsonEntityAcl:(NSString *)jsonEntityAcl
             version:(int64_t)version
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject;

/**
* Method updates a new singleton entity on the server. This operation results in
* the entity
* data being completely replaced by the passed in JSON string. If the entity
* doesn't exists it is created
*
* Service Name - Entity
* Service Operation - UpdateSingleton
*
* @param entityType The entity type as defined by the user
* @param jsonEntityData The entity's data as a json string.
* permissions which make the entity readable/writeable by only the player.
* @param jsonEntityAcl The entity's access control list as json. A null acl
* implies default
* permissions which make the entity readable/writeable by only the player.
* @param version Current version of the entity. If the version of the
* entity on the server does not match the version passed in, the
* server operation will fail. Use -1 to skip version checking.
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server
* response
* @param cbObject User object sent to the completion blocks
*/
- (void)updateSingleton:(NSString *)entityType
         jsonEntityData:(NSString *)jsonEntityData
          jsonEntityAcl:(NSString *)jsonEntityAcl
                version:(int64_t)version
        completionBlock:(BCCompletionBlock)completionBlock
   errorCompletionBlock:(BCErrorCompletionBlock)ecb
               cbObject:(BCCallbackObject)cbObject;

/**
* Method deletes the given entity on the server.
*
* Service Name - Entity
* Service Operation - Delete
*
* @param entityId The id of the entity to update
* @param version Current version of the entity. If the version of the
* entity on the server does not match the version passed in, the
* server operation will fail. Use -1 to skip version checking.
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server
* response
* @param cbObject User object sent to the completion blocks
*/
- (void)deleteEntity:(NSString *)entityId
             version:(int64_t)version
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject;

/**
* Method deletes the given singleton entity on the server.
*
* Service Name - Entity
* Service Operation - DeleteSingleton
*
* @param entityType The type of the entity to delete
* @param version Current version of the entity. If the version of the
* entity on the server does not match the version passed in, the
* server operation will fail. Use -1 to skip version checking.
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server
* response
* @param cbObject User object sent to the completion blocks
*/
- (void)deleteSingleton:(NSString *)entityType
                version:(int64_t)version
        completionBlock:(BCCompletionBlock)completionBlock
   errorCompletionBlock:(BCErrorCompletionBlock)ecb
               cbObject:(BCCallbackObject)cbObject;

/** Method to get a specific entity.
*
* Service Name - Entity
* Service Operation - Read
*
* @param entityId The entity id
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server
* response
* @param cbObject User object sent to the completion blocks
*/
- (void)getEntity:(NSString *)entityId
         completionBlock:(BCCompletionBlock)completionBlock
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject;

/**
 * Method retreives a singleton entity on the server. If the entity doesn't
 * exist, null is returned.
 *
 * Service Name - Entity
 * Service Operation - GetSingleton
 *
 * @param entityType The entity type as defined by the user
 * @param completionBlock Block to call on return of successful server response
 * @param errorCompletionBlock Block to call on return of unsuccessful server
 * response
 * @param cbObject User object sent to the completion blocks
 */
- (void)getSingleton:(NSString *)entityType
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject;

/** Method returns all player entities that match the given type.
* Service Name - Entity
* Service Operation - ReadByType
*
* @param entityType The entity type to search for
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server
* response
* @param cbObject User object sent to the completion blocks
*/
- (void)getEntitiesByType:(NSString *)entityType
          completionBlock:(BCCompletionBlock)completionBlock
     errorCompletionBlock:(BCErrorCompletionBlock)ecb
                 cbObject:(BCCallbackObject)cbObject;

/**
 * Method returns a shared entity for the given player and entity ID.
 * An entity is shared if its ACL allows for the currently logged
 * in player to read the data.
 *
 * Service Name - Entity
 * Service Operation - READ_SHARED_ENTITY
 *
 * @param playerId The the profile ID of the player who owns the entity
 * @param entityId The ID of the entity that will be retrieved
 * @param completionBlock Block to call on return of successful server response
 * @param errorCompletionBlock Block to call on return of unsuccessful server
 * response
 * @param cbObject User object sent to the completion blocks
 */
- (void)getSharedEntityForPlayerId:(NSString *)playerId
                          entityId:(NSString *)entityId
                   completionBlock:(BCCompletionBlock)completionBlock
              errorCompletionBlock:(BCErrorCompletionBlock)ecb
                          cbObject:(BCCallbackObject)cbObject;

/**
* Method returns all shared entities for the given player id.
* An entity is shared if its ACL allows for the currently logged
* in player to read the data.
*
* Service Name - Entity
* Service Operation - ReadShared
*
* @param playerId The player id to retrieve shared entities for
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server
* response
* @param cbObject User object sent to the completion blocks
*/
- (void)getSharedEntitiesForPlayerId:(NSString *)playerId
                     completionBlock:(BCCompletionBlock)completionBlock
                errorCompletionBlock:(BCErrorCompletionBlock)ecb
                            cbObject:(BCCallbackObject)cbObject;

/**
* Method updates a shared entity owned by another player. This operation results
* in the entity
* data being completely replaced by the passed in JSON string.
*
* Service Name - Entity
* Service Operation - UpdateShared
*
* @param entityId The id of the entity to update
* @param targetPlayerId The id of the player who owns the shared entity
* @param entityType The entity type as defined by the user
* @param jsonEntityData The entity's data as a json string.
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server
* response
* @param cbObject User object sent to the completion blocks
*/
- (void)updateSharedEntity:(NSString *)entityId
            targetPlayerId:(NSString *)targetPlayerId
                entityType:(NSString *)entityType
            jsonEntityData:(NSString *)jsonEntityData
                   version:(int64_t)version
           completionBlock:(BCCompletionBlock)completionBlock
      errorCompletionBlock:(BCErrorCompletionBlock)ecb
                  cbObject:(BCCallbackObject)cbObject;

/**
 * Method gets list of entities from the server base on type and/or where clause
 *
 * Service Name - Entity
 * Service Operation - GET_LIST
 *
 * @param whereJson Mongo style query string
 * @param orderByJson Sort order
 * @param maxReturn The maximum number of entities to return
 * @param completionBlock Block to call on return of successful server response
 * @param errorCompletionBlock Block to call on return of unsuccessful server
 * response
 * @param cbObject User object sent to the completion blocks
 */
- (void)getList:(NSString *)whereJson
                 orderBy:(NSString *)orderByJson
               maxReturn:(int64_t)maxReturn
         completionBlock:(BCCompletionBlock)completionBlock
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject;

/**
 * Method gets list of shared entities for the specified player based on type and/or where clause
 *
 * Service Name - Entity
 * Service Operation - READ_SHARED_ENTITIES_LIST
 *
 * @param playerId The player ID to retrieve shared entities for
 * @param whereJson Mongo style query
 * @param orderByJson Sort order
 * @param maxReturn The maximum number of entities to return
 * @param completionBlock Block to call on return of successful server response
 * @param errorCompletionBlock Block to call on return of unsuccessful server response
 * @param cbObject User object sent to the completion blocks
 */
- (void)getSharedEntitiesListForPlayerId:(NSString *)playerId
                               whereJson:(NSString *)whereJson
                                 orderByJson:(NSString *)orderByJson
                               maxReturn:(int32_t)maxReturn
                         completionBlock:(BCCompletionBlock)completionBlock
                    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                                cbObject:(BCCallbackObject)cbObject;

/**
* Method gets a count of entities based on the where clause
*
* Service Name - Entity
* Service Operation - GET_LIST_COUNT
*
* @param whereJson Mongo style query string
* @param completionBlock Block to call on return of successful server response
* @param errorCompletionBlock Block to call on return of unsuccessful server
* response
* @param cbObject User object sent to the completion blocks
*/
- (void)getListCount:(NSString *)whereJson
     completionBlock:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)ecb
            cbObject:(BCCallbackObject)cbObject;

/**
 * Method uses a paging system to iterate through entities
 * After retrieving a page of entities with this method,
 * use GetPageOffset() to retrieve previous or next pages.
 *
 * Service Name - Entity
 * Service Operation - GetPage
 *
 * @param context The json context for the page request.
 *                   See the portal appendix documentation for format.
 * @param completionBlock Block to call on return of successful server response
 * @param errorCompletionBlock Block to call on return of unsuccessful server
 * response
 * @param cbObject User object sent to the completion blocks
 */
- (void)getPage:(NSString *)context
         completionBlock:(BCCompletionBlock)completionBlock
    errorCompletionBlock:(BCErrorCompletionBlock)ecb
                cbObject:(BCCallbackObject)cbObject;

/**
 * Method to retrieve previous or next pages after having called the GetPage
 * method.
 *
 * Service Name - Entity
 * Service Operation - GetPageOffset
 *
 * @param context The context string returned from the server from a
 *      previous call to GetPage or GetPageOffset
 * @param pageOffset The positive or negative page offset to fetch. Uses the
 * last page
 *      retrieved using the context string to determine a starting point.
 * @param completionBlock Block to call on return of successful server response
 * @param errorCompletionBlock Block to call on return of unsuccessful server
 * response
 * @param cbObject User object sent to the completion blocks
 */
- (void)getPageOffset:(NSString *)context
           pageOffset:(int)pageOffset
      completionBlock:(BCCompletionBlock)completionBlock
 errorCompletionBlock:(BCErrorCompletionBlock)ecb
             cbObject:(BCCallbackObject)cbObject;


/**
 * Partial increment of entity data field items. Partial set of items incremented as specified.
 *
 * Service Name - entity
 * Service Operation - INCREMENT_USER_ENTITY_DATA
 *
 * @param entityId The id of the entity to update
 * @param targetPlayerId Profile ID of the entity owner
 * @param jsonData The entity's data object
 * @param returnData Should the entity be returned in the response?
 * @param completionBlock Block to call on return of successful server response
 * @param errorCompletionBlock Block to call on return of unsuccessful server response
 * @param cbObject User object sent to the completion blocks
 */
- (void)incrementUserEntityData:(NSString *)entityId
                 targetPlayerId:(NSString *)targetPlayerId
                       jsonData:(NSString *)jsonData
                     returnData:(BOOL)returnData
                completionBlock:(BCCompletionBlock)completionBlock
           errorCompletionBlock:(BCErrorCompletionBlock)ecb
                       cbObject:(BCCallbackObject)cbObject;

@end