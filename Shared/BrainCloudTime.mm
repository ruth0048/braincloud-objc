//
//  BrainCloudTime.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-12.
//  Copyright (c) 2016 bitHeads. All rights reserved.
//

#include "braincloud/BrainCloudClient.h"
#include "BrainCloudCallback.hh"

#import "BrainCloudTime.hh"

@interface BrainCloudTime ()
{
    BrainCloud::BrainCloudClient *_client;
}
@end

@implementation BrainCloudTime

- (instancetype) init: (BrainCloud::BrainCloudClient*) client
{
    self = [super init];

    if(self) {
        _client = client;
    }

    return self;
}

- (void)readServerTime:(BCCompletionBlock)cb
  errorCompletionBlock:(BCErrorCompletionBlock)ecb
              cbObject:(BCCallbackObject)cbObject
{
    _client->getTimeService()->readServerTime(
        new BrainCloudCallback(cb, ecb, cbObject));
}

@end
