#import "BrainCloudWrapper.hh"

#import "BrainCloudSaveDataHelper.h"

@interface BrainCloudWrapper ()

@property (strong, nonatomic) BrainCloudSaveDataHelper *helper;

@property (copy, nonatomic) NSString *lastAppId;
@property (copy, nonatomic) NSString *lastAppVersion;
@property (copy, nonatomic) NSString *lastSecretKey;
@property (strong, nonatomic) NSString *lastServerUrl;

@property (copy) BCCompletionBlock authSuccessCompletionBlock;
@property (copy) BCErrorCompletionBlock authErrorCompletionBlock;

@property (strong, nonatomic) BrainCloudClient *bcClient;

@end

@interface AuthenticationCallbackObject : NSObject
@property (strong, nonatomic) BCCompletionBlock completionBlock;
@property (strong, nonatomic) BCErrorCompletionBlock errorCompletionBlock;
@property (strong, nonatomic) BCCallbackObject cbObject;
@end

@implementation AuthenticationCallbackObject
@end

@implementation BrainCloudWrapper

NSString * const kAuthenticationAnonymous          = @"anonymous";
NSString * const kPersistenceKeyAnonymousId        = @"anonymousId";
NSString * const kPersistenceKeyAuthenticationType = @"authenticationType";
NSString * const kPersistenceKeyProfileId          = @"profileId";


#pragma mark - Getters & Setters

static BrainCloudWrapper *sharedWrapper = nil;

+ (BrainCloudWrapper *) getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWrapper = [[self alloc] init];
        sharedWrapper.alwaysAllowProfileSwitch = YES;
        
        // the generic authentication completion blocks
        
        sharedWrapper.authSuccessCompletionBlock = ^(NSString *serviceName, NSString *serviceOperation, NSString *jsonData, BCCallbackObject cbObject)
        {
            NSData *data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
            
            sharedWrapper.storedProfileId = [(NSDictionary *)[jsonObj objectForKey:@"data"] objectForKey:@"profileId"];
            
            AuthenticationCallbackObject *aco = (AuthenticationCallbackObject*) cbObject;
            if (aco.completionBlock != nil)
            {
                aco.completionBlock(serviceName, serviceOperation, jsonData, aco.cbObject);
            }
        };
        
        sharedWrapper.authErrorCompletionBlock = ^(NSString *serviceName, NSString *serviceOperation, NSInteger statusCode, NSInteger returnCode, NSString *jsonError, BCCallbackObject cbObject)
        {
            AuthenticationCallbackObject *aco = (AuthenticationCallbackObject*) cbObject;
            if (aco.errorCompletionBlock != nil)
            {
                aco.errorCompletionBlock(serviceName, serviceOperation, statusCode, returnCode, jsonError, aco.cbObject);
            }
        };
    });
    
    return sharedWrapper;
}

- (BrainCloudWrapper*) init
{
    _bcClient = [self getBCClient];
    
    return self;
}

+ (BrainCloudClient *) getBC
{
    return [[self getInstance] getBCClient];
}

- (BrainCloudClient *) getBCClient
{
    if(self == sharedWrapper) {
        return [BrainCloudClient getInstance];
    } else if(_bcClient == NULL) {
        _bcClient = [[BrainCloudClient alloc] init];
    }
    
    return _bcClient;
}


- (void)setStoredAnonymousId:(NSString *)storedAnonymousId
{
    [self.helper saveString:storedAnonymousId forKey:kPersistenceKeyAnonymousId];
}

- (NSString *)storedAnonymousId
{
    return [self.helper stringForKey:kPersistenceKeyAnonymousId];
}

- (void)setStoredAuthenticationType:(NSString *)storedAuthenticationType
{
    [self.helper saveString:storedAuthenticationType forKey:kPersistenceKeyAuthenticationType];
}

- (NSString *)storedAuthenticationType
{
    return [self.helper stringForKey:kPersistenceKeyAuthenticationType];
}

- (void)setStoredProfileId:(NSString *)storedProfileId
{
    [self.helper saveString:storedProfileId forKey:kPersistenceKeyProfileId];
}

- (NSString *)storedProfileId
{
    return [self.helper stringForKey:kPersistenceKeyProfileId];
}

#pragma mark - C++ Initialization


- (void)initialize:(NSString *)serverUrl
         secretKey:(NSString *)secretKey
            gameId:(NSString *)appId
       gameVersion:(NSString *)appVersion
       companyName:(NSString *)companyName
          gameName:(NSString *)appName
{
    self.lastAppId      = appId;
    self.lastAppVersion = appVersion;
    self.lastSecretKey   = secretKey;
    self.lastServerUrl   = serverUrl;

    [_bcClient initialize:serverUrl
                                     secretKey:secretKey
                                         appId:appId
                                    appVersion:appVersion];

    self.helper = [[BrainCloudSaveDataHelper alloc] initWithCompanyName:companyName appName:appName];
}

- (void)initialize:(NSString *)serverUrl
         secretKey:(NSString *)secretKey
            appId:(NSString *)appId
       version:(NSString *)appVersion
       companyName:(NSString *)companyName
          appName:(NSString *)appName
{
    self.lastAppId      = appId;
    self.lastAppVersion = appVersion;
    self.lastSecretKey   = secretKey;
    self.lastServerUrl   = serverUrl;

    [_bcClient initialize:serverUrl
                                     secretKey:secretKey
                                         appId:appId
                                    appVersion:appVersion];

    self.helper = [[BrainCloudSaveDataHelper alloc] initWithCompanyName:companyName appName:appName];
}



- (void)initialize:(NSString *)serverUrl
         secretKey:(NSString *)secretKey
             appId:(NSString *)appId
        appVersion:(NSString *)appVersion
       companyName:(NSString *)companyName
           appName:(NSString *)appName
{
    self.lastAppId      = appId;
    self.lastAppVersion = appVersion;
    self.lastSecretKey   = secretKey;
    self.lastServerUrl   = serverUrl;

    [_bcClient initialize:serverUrl
                                     secretKey:secretKey
                                         appId:appId
                                    appVersion:appVersion];
        
    self.helper = [[BrainCloudSaveDataHelper alloc] initWithCompanyName:companyName appName:appName];
}


- (void)_initializeIdentity:(BOOL) isAnonymousAuth
{
    NSString *profileId = self.storedProfileId;
    NSString *anonymousId = self.storedAnonymousId;
    if (profileId != nil && [profileId length] == 0)
    {
        profileId = nil;
    }
    if (anonymousId != nil && [anonymousId length] == 0)
    {
        anonymousId = nil;
    }
    
    if (nil == self.storedAnonymousId || (nil != self.storedAnonymousId && nil == self.storedProfileId))
    {
        anonymousId= [[_bcClient authenticationService] generateAnonymousId];
        profileId = @"";
        self.storedAnonymousId = anonymousId;
        self.storedProfileId = profileId;
    }
    
    NSString *profileIdToAuthenticateWith = profileId;
    if (!isAnonymousAuth && self.alwaysAllowProfileSwitch)
    {
        profileIdToAuthenticateWith = @"";
    }
    self.storedAuthenticationType = isAnonymousAuth ? kAuthenticationAnonymous : @"";
    
    // send our IDs to brainCloud
    [_bcClient initializeIdentity:profileIdToAuthenticateWith anonymousId:anonymousId];
}

- (void)authenticateAnonymous:(BCCompletionBlock)completionBlock
         errorCompletionBlock:(BCErrorCompletionBlock)errorCompletionBlock
                     cbObject:(BCCallbackObject)cbObject
{
    [self _initializeIdentity:TRUE];
    
    AuthenticationCallbackObject *aco = [[AuthenticationCallbackObject alloc] init];
    aco.completionBlock = completionBlock;
    aco.errorCompletionBlock = errorCompletionBlock;
    aco.cbObject = cbObject;
    
    [[_bcClient authenticationService] authenticateAnonymous:TRUE
                                                                  completionBlock:self.authSuccessCompletionBlock
                                                             errorCompletionBlock:self.authErrorCompletionBlock
                                                                         cbObject:aco];
}

- (void)authenticateEmailPassword:(NSString *)email
                         password:(NSString *)password
                      forceCreate:(BOOL)forceCreate
                  completionBlock:(BCCompletionBlock)completionBlock
             errorCompletionBlock:(BCErrorCompletionBlock)errorCompletionBlock
                         cbObject:(BCCallbackObject)cbObject
{
    [self _initializeIdentity:FALSE];
    
    AuthenticationCallbackObject *aco = [[AuthenticationCallbackObject alloc] init];
    aco.completionBlock = completionBlock;
    aco.errorCompletionBlock = errorCompletionBlock;
    aco.cbObject = cbObject;
    
    [[_bcClient authenticationService] authenticateEmailPassword:email
                                                                             password:password
                                                                          forceCreate:YES
                                                                      completionBlock:self.authSuccessCompletionBlock
                                                                 errorCompletionBlock:self.authErrorCompletionBlock
                                                                             cbObject:aco];
}

- (void)authenticateExternal:(NSString *)userId
         authenticationToken:(NSString *)authToken
  externalAuthenticationName:(NSString *)externalAuthName
                 forceCreate:(BOOL)forceCreate
             completionBlock:(BCCompletionBlock)completionBlock
        errorCompletionBlock:(BCErrorCompletionBlock)errorCompletionBlock
                    cbObject:(BCCallbackObject)cbObject
{
    [self _initializeIdentity:FALSE];
    
    AuthenticationCallbackObject *aco = [[AuthenticationCallbackObject alloc] init];
    aco.completionBlock = completionBlock;
    aco.errorCompletionBlock = errorCompletionBlock;
    aco.cbObject = cbObject;
    
    [[_bcClient authenticationService] authenticateExternal:userId
                                                             authenticationToken:authToken
                                                      externalAuthenticationName:externalAuthName
                                                                     forceCreate:YES
                                                                 completionBlock:self.authSuccessCompletionBlock
                                                            errorCompletionBlock:self.authErrorCompletionBlock
                                                                        cbObject:aco];

}

- (void)authenticateFacebook:(NSString *)fbUserId
         authenticationToken:(NSString *)fbAuthToken
                 forceCreate:(BOOL)forceCreate
             completionBlock:(BCCompletionBlock)completionBlock
        errorCompletionBlock:(BCErrorCompletionBlock)errorCompletionBlock
                    cbObject:(BCCallbackObject)cbObject
{
    [self _initializeIdentity:FALSE];
    
    AuthenticationCallbackObject *aco = [[AuthenticationCallbackObject alloc] init];
    aco.completionBlock = completionBlock;
    aco.errorCompletionBlock = errorCompletionBlock;
    aco.cbObject = cbObject;
    
    [[_bcClient authenticationService] authenticateFacebook:fbUserId
                                                             authenticationToken:fbAuthToken
                                                                     forceCreate:YES
                                                                 completionBlock:self.authSuccessCompletionBlock
                                                            errorCompletionBlock:self.authErrorCompletionBlock
                                                                        cbObject:aco];
    
}

- (void)authenticateGameCenter:(NSString *)gameCenterId
                   forceCreate:(BOOL)forceCreate
               completionBlock:(BCCompletionBlock)completionBlock
          errorCompletionBlock:(BCErrorCompletionBlock)errorCompletionBlock
                      cbObject:(BCCallbackObject)cbObject
{
    [self _initializeIdentity:FALSE];
    
    AuthenticationCallbackObject *aco = [[AuthenticationCallbackObject alloc] init];
    aco.completionBlock = completionBlock;
    aco.errorCompletionBlock = errorCompletionBlock;
    aco.cbObject = cbObject;
    
    [[_bcClient authenticationService] authenticateGameCenter:gameCenterId
                                                                     forceCreate:YES
                                                                 completionBlock:self.authSuccessCompletionBlock
                                                            errorCompletionBlock:self.authErrorCompletionBlock
                                                                        cbObject:aco];
    
}

- (void)authenticateGoogle:(NSString *)userID
                     token:(NSString *)token
               forceCreate:(BOOL)forceCreate
           completionBlock:(BCCompletionBlock)completionBlock
      errorCompletionBlock:(BCErrorCompletionBlock)errorCompletionBlock
                  cbObject:(BCCallbackObject)cbObject
{
    [self _initializeIdentity:FALSE];
    
    AuthenticationCallbackObject *aco = [[AuthenticationCallbackObject alloc] init];
    aco.completionBlock = completionBlock;
    aco.errorCompletionBlock = errorCompletionBlock;
    aco.cbObject = cbObject;
    
    [[_bcClient authenticationService] authenticateGoogle:userID
                                                                         token:token
                                                                     forceCreate:YES
                                                                 completionBlock:self.authSuccessCompletionBlock
                                                            errorCompletionBlock:self.authErrorCompletionBlock
                                                                        cbObject:aco];
}


- (void)authenticateSteam:(NSString *)userId
            sessionTicket:(NSString *)sessionticket
              forceCreate:(BOOL)forceCreate
          completionBlock:(BCCompletionBlock)completionBlock
     errorCompletionBlock:(BCErrorCompletionBlock)errorCompletionBlock
                 cbObject:(BCCallbackObject)cbObject
{
    [self _initializeIdentity:FALSE];
    
    AuthenticationCallbackObject *aco = [[AuthenticationCallbackObject alloc] init];
    aco.completionBlock = completionBlock;
    aco.errorCompletionBlock = errorCompletionBlock;
    aco.cbObject = cbObject;
    
    [[_bcClient authenticationService] authenticateSteam:userId
                                                                sessionTicket:sessionticket
                                                                  forceCreate:YES
                                                              completionBlock:self.authSuccessCompletionBlock
                                                         errorCompletionBlock:self.authErrorCompletionBlock
                                                                     cbObject:aco];
}

- (void)authenticateTwitter:(NSString *)userId
                      token:(NSString *)token
                     secret:(NSString *)secret
                forceCreate:(BOOL)forceCreate
            completionBlock:(BCCompletionBlock)completionBlock
       errorCompletionBlock:(BCErrorCompletionBlock)errorCompletionBlock
                   cbObject:(BCCallbackObject)cbObject
{
    [self _initializeIdentity:FALSE];
    
    AuthenticationCallbackObject *aco = [[AuthenticationCallbackObject alloc] init];
    aco.completionBlock = completionBlock;
    aco.errorCompletionBlock = errorCompletionBlock;
    aco.cbObject = cbObject;
    
    [[_bcClient authenticationService] authenticateTwitter:userId
                                                                          token:token
                                                                         secret:secret
                                                                    forceCreate:YES
                                                                completionBlock:self.authSuccessCompletionBlock
                                                           errorCompletionBlock:self.authErrorCompletionBlock
                                                                       cbObject:aco];
}

- (void)authenticateUniversal:(NSString *)userId
                     password:(NSString *)password
                  forceCreate:(BOOL)forceCreate
              completionBlock:(BCCompletionBlock)completionBlock
         errorCompletionBlock:(BCErrorCompletionBlock)errorCompletionBlock
                     cbObject:(BCCallbackObject)cbObject
{
    [self _initializeIdentity:FALSE];
    
    AuthenticationCallbackObject *aco = [[AuthenticationCallbackObject alloc] init];
    aco.completionBlock = completionBlock;
    aco.errorCompletionBlock = errorCompletionBlock;
    aco.cbObject = cbObject;
    
    [[_bcClient authenticationService] authenticateUniversal:userId
                                                                         password:password
                                                                      forceCreate:YES
                                                                  completionBlock:self.authSuccessCompletionBlock
                                                             errorCompletionBlock:self.authErrorCompletionBlock
                                                                         cbObject:aco];
}

- (void)reconnect:(BCCompletionBlock)completionBlock
errorCompletionBlock:(BCErrorCompletionBlock)errorCompletionBlock
            cbObject:(BCCallbackObject)cbObject
{
    [self authenticateAnonymous:completionBlock errorCompletionBlock:errorCompletionBlock cbObject:cbObject];
}

/*
- (void)reauthenticateWithSuccess:(BrainCloudWrapperSuccessfulCompletion)success failure:(BrainCloudWrapperFailedCompletion)failure {
    [self initializeWithURL:self.lastURL
                companyName:nil
                  secretKey:self.lastSecretKey
                     gameID:self.lastGameID
                   appName:nil
                gameVersion:self.lastAppVersion];
    
    if ([self.storedAuthenticationType isEqualToString:kAuthenticationAnonymous])
        [self authenticateAnonymousWithSuccess:success failure:failure];
    
}
 */

#pragma mark - Updates

- (void)runCallbacks
{
    [_bcClient runCallBacks];
}

@end
