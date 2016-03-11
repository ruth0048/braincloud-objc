//
//  TestUser.m
//  brainCloudClientObjc
//
//  Created by Hill, Bradley on 2015-08-05.
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestUser.h"

@implementation TestUser

- (id)initWithIds:(NSString *)prefix suffix:(uint32_t)suffix
{
    self = [super init];

    if (self)
    {
        self.m_id = [NSString stringWithFormat:@"%@%@%u", prefix, @"_ObjC_", suffix];
        self.m_email = [NSString stringWithFormat:@"%@%@", self.m_id, @"@bctestuser.com"];
        self.m_password = [NSString stringWithString:self.m_id];
    }

    return self;
}

@end