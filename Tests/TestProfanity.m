//
//  TestProfanity.m
//  brainCloudClientObjc
//
//  Created by Preston Jennings on 2015-12-15.
//  Copyright © 2015 bitHeads. All rights reserved.
//


#import "TestFixtureBase.h"
#import "BrainCloudProfanity.hh"

@interface TestProfanity : TestFixtureBase

@end

@implementation TestProfanity

- (bool)authenticateOnSetup { return true; }

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testProfanityCheck
{
    [[m_client profanityService] profanityCheck:@"shitbird fly away"
                                      languages:@"en"
                                      flagEmail:TRUE
                                      flagPhone:TRUE
                                       flagUrls:TRUE
                             completionBlock:successBlock
                        errorCompletionBlock:failureBlock
                                    cbObject:nil];
    [self waitForResult];
}

- (void)testProfanityReplaceText
{
    [[m_client profanityService] profanityReplaceText:@"shitbird fly away"
                                        replaceSymbol:@"*"
                                            languages:@"en"
                                            flagEmail:TRUE
                                            flagPhone:TRUE
                                             flagUrls:TRUE
                                      completionBlock:successBlock
                                 errorCompletionBlock:failureBlock
                                             cbObject:nil];
    [self waitForResult];
}

- (void)testProfanityIdentifyBadWords
{
    [[m_client profanityService] profanityIdentifyBadWords:@"shitbird fly away"
                                                 languages:@"en"
                                                 flagEmail:TRUE
                                                 flagPhone:TRUE
                                                  flagUrls:TRUE
                                           completionBlock:successBlock
                                      errorCompletionBlock:failureBlock
                                                  cbObject:nil];
    [self waitForResult];
}

@end
