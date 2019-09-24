#import "TestFixtureBase.h"

@interface TestUserItems : TestFixtureBase

@end

@implementation TestUserItems

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)getCatalogItemDefinition
{
    [[m_client userItemsService]  awardUserItem:@"sword001"
                                      quantity:5
                                    includeDef:true
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    
    [self waitForResult];
}

- (void)dropUserItem
{
    [[m_client userItemsService]  dropUserItem:@"invalidForNow"
                                     quantity:1
                                   includeDef:true
                            completionBlock:successBlock
                       errorCompletionBlock:failureBlock
                                   cbObject:nil];
    
    [self waitForFailedResult];
}

- (void)getUserItemsPage
{
    NSString* context = @"{\"test\": \"Testing\"}";
    [[m_client userItemsService]  getUserItemsPage:context
                                       includeDef:true
                                  completionBlock:successBlock
                             errorCompletionBlock:failureBlock
                                         cbObject:nil];
    
    [self waitForResult];
}

- (void)getUserItemsPageOffset
{
    NSString* context = @"";
    [[m_client userItemsService]  getUserItemsPageOffset:context
                                              pageOffset:1
                                              includeDef:true
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    
    [self waitForFailedResult];
}

- (void)getUserItem
{
    [[m_client userItemsService]  getUserItem:@"invalidForNow"
                                              includeDef:true
                                         completionBlock:successBlock
                                    errorCompletionBlock:failureBlock
                                                cbObject:nil];
    
    [self waitForFailedResult];
}

- (void)giveUserItemTo
{
    [[m_client userItemsService]  giveUserItemTo:[TestFixtureBase getUser:@"UserB"].m_profileId
                                       itemId:@"invalidForNow"
                                      version:1
                                   immediate:true
                              completionBlock:successBlock
                         errorCompletionBlock:failureBlock
                                     cbObject:nil];
    
    [self waitForFailedResult];
}

- (void)purchaseUserItem
{
    [[m_client userItemsService]  purchaseUserItem:@"sword001"
                                         quantity:1
                                            shopId:nil
                                       includeDef:true
                                 completionBlock:successBlock
                            errorCompletionBlock:failureBlock
                                        cbObject:nil];
    
    [self waitForResult];
}

- (void)receiveUserItemFrom
{
    [[m_client userItemsService]  receiveUserItemFrom:[TestFixtureBase getUser:@"UserB"].m_profileId
                                               itemId:@"invalidForNow"
                                   completionBlock:successBlock
                              errorCompletionBlock:failureBlock
                                          cbObject:nil];
    
    [self waitForFailedResult];
}

- (void)sellUserItem
{
    [[m_client userItemsService]  sellUserItem:@"invalidForNow"
                                               version:1
                                      quantity:1
                                        shopId:nil
                                    includeDef:true
                                      completionBlock:successBlock
                                 errorCompletionBlock:failureBlock
                                             cbObject:nil];
    
    [self waitForFailedResult];
}

- (void)updateUserItemData
{
    [[m_client userItemsService]  updateUserItemData:@"InvalidForNow"
                                             version:1
                                         newItemData:@"{\"test\": \"Testing\"}"
                               completionBlock:successBlock
                          errorCompletionBlock:failureBlock
                                      cbObject:nil];
    
    [self waitForFailedResult];
}

- (void)useUserItem
{
    [[m_client userItemsService]  useUserItem:@"invalidForNow"
                                             version:1
                                         newItemData:@"{\"test\": \"Testing\"}"
                                   includeDef:true
                                     completionBlock:successBlock
                                errorCompletionBlock:failureBlock
                                            cbObject:nil];
    
    [self waitForFailedResult];
}


@end
