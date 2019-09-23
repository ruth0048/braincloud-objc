#import "TestFixtureBase.h"

@interface TestItemCatalog : TestFixtureBase

@end

@implementation TestItemCatalog

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

- (void)getCatalogItemDefinition
{
    [[m_client itemCatalogService]  getCatalogItemDefinition:@"sword001"
                                             completionBlock:successBlock
                                        errorCompletionBlock:failureBlock
                                                    cbObject:nil];
    
    [self waitForResult];
}

- (void)getCatalogItemsPage
{
    NSString* context = @"{\"test\": \"Testing\"}";
    [[m_client itemCatalogService]  getCatalogItemsPage:context
                                             completionBlock:successBlock
                                        errorCompletionBlock:failureBlock
                                                    cbObject:nil];
    
    [self waitForResult];
}

- (void)getCatalogItemsPageOffset
{
    NSString* context = @"";
    [[m_client itemCatalogService]  getCatalogItemsPage:context
                                        completionBlock:successBlock
                                   errorCompletionBlock:failureBlock
                                               cbObject:nil];
    
    [self waitForFailedResult];
}


@end
