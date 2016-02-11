//
//  BrainCloudCompletionBlocks.h
//  brainCloudClientObjc
//
//  Created by Ryan Homer on 30/4/2015.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#ifndef brainCloudClientObjc_BrainCloudCompletionBlocks_h
#define brainCloudClientObjc_BrainCloudCompletionBlocks_h

#import <Foundation/Foundation.h>

typedef NSObject *BCCallbackObject;

typedef void (^BCCompletionBlock)(NSString *serviceName, NSString *serviceOperation,
                                  NSString *jsonData, BCCallbackObject cbObject);

typedef void (^BCErrorCompletionBlock)(NSString *serviceName, NSString *serviceOperation,
                                       NSInteger statusCode, NSInteger returnCode,
                                       NSString *jsonError, BCCallbackObject cbObject);

typedef void (^BCEventCompletionBlock)(NSString *json);

typedef void (^BCRewardCompletionBlock)(NSString *json);

typedef void (^BCFileUploadCompletedCompletionBlock)(NSString *fileUploadId, NSString *json);
typedef void (^BCFileUploadFailedCompletionBlock)(NSString *fileUploadId, NSInteger statusCode, NSInteger returnCode, NSString *json);
#endif
