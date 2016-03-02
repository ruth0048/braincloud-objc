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
    return [BrainCloudClient defaultClient];
}

+ (BrainCloudWrapper *) sharedWrapper {
    static BrainCloudWrapper *sharedWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWrapper = [[self alloc] init];
    });
    return sharedWrapper;
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
    
    const char * szProfileID = "";
    const char * szAnonymousID = "";
    if (profileID != nil)
    {
        szProfileID = profileID.UTF8String;
    }
    if (anonymousID != nil)
    {
        szAnonymousID = self.storedAnonymousID.UTF8String;
    }
    
    [[BrainCloudClient defaultClient] initializeIdentity:szProfileID anonymousId:szAnonymousID];
}

- (void)initializeWithURL:(NSURL *)URL companyName:(NSString *)companyName secretKey:(NSString *)secretKey gameID:(NSString *)gameID gameName:(NSString *)gameName gameVersion:(NSString *)gameVersion {
    self.lastGameID      = gameID;
    self.lastGameVersion = gameVersion;
    self.lastSecretKey   = secretKey;
    self.lastURL         = URL;
    
    [[BrainCloudClient defaultClient ] initialize:URL.absoluteString
                  secretKey:secretKey
                     gameId:gameID
                gameVersion:gameVersion];
        
    self.helper = [[BrainCloudSaveDataHelper alloc] initWithCompanyName:companyName gameName:gameName];
}

#pragma mark - Authentication

- (void)authenticateAnonymousWithSuccess:(BrainCloudWrapperSuccessfulCompletion)success failure:(BrainCloudWrapperFailedCompletion)failure {
    [self _initializeIdentity];
    self.storedAuthenticationType = kAuthenticationAnonymous;
    [[[BrainCloudClient defaultClient] authenticationService] authenticateAnonymous:YES
        completionBlock:^(NSString *serviceName, NSString *serviceOperation, NSString *jsonData, BCCallbackObject cbObject)
        {
            NSData *data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
            
            self.storedProfileID = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"profileId"];
            success(serviceName, serviceOperation, jsonData, cbObject);
        }
        errorCompletionBlock:^(NSString *serviceName, NSString *serviceOperation, NSInteger statusCode, NSInteger returnCode, NSString *jsonError, BCCallbackObject cbObject)
        {
            failure(serviceName, serviceOperation, statusCode, returnCode, jsonError, cbObject);
        }
        cbObject:nil];
}

- (void)authenticateWithEmail:(NSString *)email password:(NSString *)password success:(BrainCloudWrapperSuccessfulCompletion)success failure:(BrainCloudWrapperFailedCompletion)failure {
    [[[BrainCloudClient defaultClient] authenticationService] authenticateEmailPassword:email
                                                          password:password
                                                       forceCreate:YES
                                                   completionBlock:success
                                              errorCompletionBlock:failure
                                                          cbObject:nil];
}

- (void)authenticateWithFacebookUserID:(NSString *)facebookUserID authenticationToken:(NSString *)authenticationToken success:(BrainCloudWrapperSuccessfulCompletion)success failure:(BrainCloudWrapperFailedCompletion)failure {
    [[[BrainCloudClient defaultClient] authenticationService] authenticateFacebook:facebookUserID
                                          authenticationToken:authenticationToken
                                                  forceCreate:YES
                                              completionBlock:success
                                         errorCompletionBlock:failure
                                                     cbObject:nil];
}

- (void)authenticateWithUniversalUserID:(NSString *)userID password:(NSString *)password success:(BrainCloudWrapperSuccessfulCompletion)success failure:(BrainCloudWrapperFailedCompletion)failure {
    [[[BrainCloudClient defaultClient] authenticationService] authenticateUniversal:userID
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
    [[BrainCloudClient defaultClient] runCallBacks];
}

@end
