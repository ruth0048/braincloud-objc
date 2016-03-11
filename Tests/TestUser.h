//
//  TestUser.h
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-05.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma once

@interface TestUser : NSObject

- (id)initWithIds:(NSString *)prefix suffix:(uint32_t)suffix;

@property NSString *m_id;
@property NSString *m_password;
@property NSString *m_profileId;
@property NSString *m_email;

@end
