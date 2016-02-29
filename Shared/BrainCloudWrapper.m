//
//  BrainCloudWrapper.m
//  BrainCloud
//
//  Created by Benoit Sarrazin on 2016-02-29.
//  Copyright © 2016 BitHeads Inc. All rights reserved.
//

#import "BrainCloudWrapper.h"

#import "BrainCloudSaveDataHelper.h"

@interface BrainCloudWrapper ()

@property (strong, nonatomic, readwrite) BrainCloudClient *client;
@property (strong, nonatomic) BrainCloudSaveDataHelper *helper;

@property (copy, nonatomic) NSString *lastGameID;
@property (copy, nonatomic) NSString *lastGameVersion;
@property (copy, nonatomic) NSString *lastSecretKey;
@property (strong, nonatomic) NSURL *lastURL;

@end

@implementation BrainCloudWrapper

NSString * const kAuthenticationAnonymous          = @"anonymous";
NSString * const kAuthenticationFacebook           = @"facebook";
NSString * const kPersistenceKeyAnonymousID        = @"anonymousId";
NSString * const kPersistenceKeyAuthenticationType = @"authenticationType";
NSString * const kPersistenceKeyProfileID          = @"profileId";

#pragma mark - Getters & Setters

- (BrainCloudClient *)client {
    if (_client)
        return _client;
    
    _client = [[BrainCloudClient alloc] init];
    return _client;
}

- (void)setStoredAnonymousID:(NSString *)storedAnonymousID {
    [self.helper saveString:storedAnonymousID forKey:kPersistenceKeyAnonymousID];
}

- (NSString *)storedAnonymousID {
    return [self.helper stringForKey:kPersistenceKeyAnonymousID];
}

- (void)setStoredAuthenticationType:(NSString *)storedAuthenticationType {
    [self.helper saveString:storedAuthenticationType forKey:kPersistenceKeyAuthenticationType];
}

- (NSString *)storedAuthenticationType {
    return [self.helper stringForKey:kPersistenceKeyAuthenticationType];
}

- (void)setStoredProfileID:(NSString *)storedProfileID {
    [self.helper saveString:storedProfileID forKey:kPersistenceKeyProfileID];
}

- (NSString *)storedProfileID {
    return [self.helper stringForKey:kPersistenceKeyProfileID];
}

#pragma mark - C++ Initialization

- (void)_initializeIdentity {
    NSString *profileID = self.storedProfileID;
    NSString *anonymousID = self.storedAnonymousID;
    
    if (nil == self.storedAnonymousID || (nil != self.storedAnonymousID && nil == self.storedProfileID)) {
        self.storedAnonymousID = [self.client.authenticationService generateGUID];
    }
    
    [self.client initializeIdentity:profileID.UTF8String
                        anonymousId:anonymousID.UTF8String];
}

- (void)initializeWithURL:(NSURL *)URL companyName:(NSString *)companyName secretKey:(NSString *)secretKey gameID:(NSString *)gameID gameName:(NSString *)gameName gameVersion:(NSString *)gameVersion {
    self.lastGameID      = gameID;
    self.lastGameVersion = gameVersion;
    self.lastSecretKey   = secretKey;
    self.lastURL         = URL;
    
    [self.client initialize:URL.absoluteString
                  secretKey:secretKey
                     gameId:gameID
                gameVersion:gameVersion];
        
    self.helper = [[BrainCloudSaveDataHelper alloc] initWithCompanyName:companyName gameName:gameName];
}

#pragma mark - Authentication

- (void)authenticateAnonymousWithSuccess:(BrainCloudWrapperSuccessfulCompletion)success failure:(BrainCloudWrapperFailedCompletion)failure {
    [self _initializeIdentity];
    self.storedAuthenticationType = kAuthenticationAnonymous;
    [[self.client authenticationService] authenticateAnonymous:YES
                                               completionBlock:success
                                          errorCompletionBlock:failure
                                                      cbObject:nil];
}

- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password success:(BrainCloudWrapperSuccessfulCompletion)success failure:(BrainCloudWrapperFailedCompletion)failure {
    [[self.client authenticationService] authenticateEmailPassword:email
                                                          password:password
                                                       forceCreate:YES
                                                   completionBlock:success
                                              errorCompletionBlock:failure
                                                          cbObject:nil];
}

- (void)authenticateWithFacebookUserID:(NSString *)facebookUserID authenticationToken:(NSString *)authenticationToken success:(BrainCloudWrapperSuccessfulCompletion)success failure:(BrainCloudWrapperFailedCompletion)failure {
    [[self.client authenticationService] authenticateFacebook:facebookUserID
                                          authenticationToken:authenticationToken
                                                  forceCreate:YES
                                              completionBlock:success
                                         errorCompletionBlock:failure
                                                     cbObject:nil];
}

- (void)authenticateWithUniversalUserID:(NSString *)userID password:(NSString *)password success:(BrainCloudWrapperSuccessfulCompletion)success failure:(BrainCloudWrapperFailedCompletion)failure {
    [[self.client authenticationService] authenticateUniversal:userID
                                                      password:password
                                                   forceCreate:YES
                                               completionBlock:success
                                          errorCompletionBlock:failure
                                                      cbObject:nil];
}

- (void)reauthenticateWithSuccess:(BrainCloudWrapperSuccessfulCompletion)success failure:(BrainCloudWrapperFailedCompletion)failure {
    [self initializeWithURL:self.lastURL
                companyName:nil
                  secretKey:self.lastSecretKey
                     gameID:self.lastGameID
                   gameName:nil
                gameVersion:self.lastGameVersion];
    
    if ([self.storedAuthenticationType isEqualToString:kAuthenticationAnonymous])
        [self authenticateAnonymousWithSuccess:success failure:failure];
    
}

#pragma mark - Updates

- (void)update {
    [self.client runCallBacks];
}

@end
