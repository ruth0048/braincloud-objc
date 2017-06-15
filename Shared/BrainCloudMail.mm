#include "BrainCloudCallback.hh"
#include "braincloud/BrainCloudClient.h"

#import "BrainCloudMail.hh"

@implementation BrainCloudMail

- (void)sendBasicEmail:(NSString *)profileId
               subject:(NSString *)subject
                  body:(NSString *)body
       completionBlock:(BCCompletionBlock)cb
  errorCompletionBlock:(BCErrorCompletionBlock)ecb
              cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getMailService()->sendBasicEmail(
        [profileId cStringUsingEncoding:NSUTF8StringEncoding], [subject cStringUsingEncoding:NSUTF8StringEncoding],
        [body cStringUsingEncoding:NSUTF8StringEncoding], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)sendAdvancedEmail:(NSString *)profileId
        jsonServiceParams:(NSString *)jsonServiceParams
          completionBlock:(BCCompletionBlock)cb
     errorCompletionBlock:(BCErrorCompletionBlock)ecb
                 cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getMailService()->sendAdvancedEmail(
        [profileId cStringUsingEncoding:NSUTF8StringEncoding],
        [jsonServiceParams cStringUsingEncoding:NSUTF8StringEncoding], new BrainCloudCallback(cb, ecb, cbObject));
}

- (void)sendAdvancedEmailByAddress:(NSString *)emailAddress
                 jsonServiceParams:(NSString *)jsonServiceParams
                   completionBlock:(BCCompletionBlock)cb
              errorCompletionBlock:(BCErrorCompletionBlock)ecb
                          cbObject:(BCCallbackObject)cbObject
{
    BrainCloud::BrainCloudClient::getInstance()->getMailService()->sendAdvancedEmailByAddress(
            [emailAddress cStringUsingEncoding:NSUTF8StringEncoding],
            [jsonServiceParams cStringUsingEncoding:NSUTF8StringEncoding], new BrainCloudCallback(cb, ecb, cbObject));
}

@end