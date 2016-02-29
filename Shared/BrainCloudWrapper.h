//
//  BrainCloudWrapper.h
//  BrainCloud
//
//  Created by Benoit Sarrazin on 2016-02-29.
//  Copyright © 2016 BitHeads Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BrainCloudClient.hh"

typedef void (^BrainCloudWrapperSuccessfulCompletion)(NSString *serviceName,
                                                      NSString *serviceOperation,
                                                      NSString *jsonData,
                                                      BCCallbackObject cbObject);

typedef void (^BrainCloudWrapperFailedCompletion)(NSString *serviceName,
                                                  NSString *serviceOperation,
                                                  NSInteger statusCode,
                                                  NSInteger returnCode,
                                                  NSString *jsonError,
                                                  BCCallbackObject cbObject);

@interface BrainCloudWrapper : NSObject

#pragma mark - Properties

@property (strong, nonatomic, readonly) BrainCloudClient *client;
@property (copy, nonatomic) NSString *storedAnonymousID;
@property (copy, nonatomic) NSString *storedAuthenticationType;
@property (copy, nonatomic) NSString *storedProfileID;

#pragma mark - C++ Initialization

- (void)initializeWithURL:(NSURL *)URL
              companyName:(NSString *)companyName
                secretKey:(NSString *)secretKey
                   gameID:(NSString *)gameID
                 gameName:(NSString *)gameName
              gameVersion:(NSString *)gameVersion;

#pragma mark - Authentication

- (void)authenticateAnonymousWithSuccess:(BrainCloudWrapperSuccessfulCompletion)success
                                 failure:(BrainCloudWrapperFailedCompletion)failure;

- (void)authenticateWithEmail:(NSString *)email
                     password:(NSString *)password
                      success:(BrainCloudWrapperSuccessfulCompletion)success
                      failure:(BrainCloudWrapperFailedCompletion)failure;

- (void)authenticateWithFacebookUserID:(NSString *)facebookUserID
                   authenticationToken:(NSString *)authenticationToken
                               success:(BrainCloudWrapperSuccessfulCompletion)success
                               failure:(BrainCloudWrapperFailedCompletion)failure;

- (void)authenticateWithUniversalUserID:(NSString *)userID
                               password:(NSString *)password
                                success:(BrainCloudWrapperSuccessfulCompletion)success
                                failure:(BrainCloudWrapperFailedCompletion)failure;

- (void)reauthenticateWithSuccess:(BrainCloudWrapperSuccessfulCompletion)success
                          failure:(BrainCloudWrapperFailedCompletion)failure;

#pragma mark - Updates

- (void)update;

@end
