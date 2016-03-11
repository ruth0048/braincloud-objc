//
//  TestFile.m
//  brainCloudClientObjc
//
//  Copyright (c) 2015 bitHeads. All rights reserved.
//

#import "TestFixtureBase.h"
#import "StatusCodes.hh"
#import "ReasonCodes.hh"

@interface TestFile : TestFixtureBase
- (bool) simpleUpload:(NSInteger)mb
            cloudPath:(NSString *)cloudPath
        cloudFilename:(NSString *)cloudFilename
             uploadId:(NSString **)uploadId;
@end

@implementation TestFile

- (void)setUp { [super setUp]; }

- (void)tearDown { [super tearDown]; }

long createFile(const char * in_path, int in_size)
{
    FILE* fp = NULL;
    fp = fopen(in_path, "w");
    if (fp == NULL)
    {
        return -1;
    }
    for (int i = 0; i < in_size; ++i)
    {
        fputc('!', fp);
    }
    fseek(fp, 0, SEEK_END);
    long fileLen = ftell(fp);
    fclose(fp);
    fp = NULL;
    return fileLen;
}

- (bool) simpleUpload:(NSInteger)mb
            cloudPath:(NSString *)cloudPath
        cloudFilename:(NSString *)cloudFilename
             uploadId:(NSString **)uploadId
{
    *uploadId = nil;
    
    const char * localPath = [cloudFilename UTF8String];
    createFile(localPath, mb*1024*1024);
    
    
    [[m_client fileService] uploadFile:cloudPath
                         cloudFilename:cloudFilename
                             shareable:true
                       replaceIfExists:true
                             localPath:cloudFilename
                       completionBlock:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    
    [self waitForResult];
    
    *uploadId = [[[TestFixtureBase getDataFromResponse:self.jsonResponse] valueForKey:@"fileDetails"] valueForKey:@"uploadId"];
    
    [m_client registerFileUploadCallback:fileUploadCompletedBlock failedBlock:fileUploadFailedBlock];
    while ([_fileUploadCompletedReceived count] == 0 && [_fileUploadFailedReceived count] == 0)
    {
        int64_t transferred = [[m_client fileService] getUploadBytesTransferred:*uploadId];
        int64_t total = [[m_client fileService] getUploadTotalBytesToTransfer:*uploadId];
        double progress = [[m_client fileService] getUploadProgress:*uploadId];
        NSLog(@"%lld transfered %lld total %f progress\n", transferred, total, progress);

        [NSThread sleepForTimeInterval:0.3f];
        [m_client runCallBacks];
    }
    [m_client deregisterFileUploadCallback];
    
    return true;
}

- (void)testUploadSimpleFile
{
    NSString * uploadId = nil;
    if (![self simpleUpload:5 cloudPath:@"" cloudFilename:@"uploadsimplefile.txt" uploadId:&uploadId])
    {
        return;
    }
    
    if ([_fileUploadCompletedReceived count] != 1)
    {
        _XCTPrimitiveFail(self, @"Uploads completed not 1");
    }
    if ([_fileUploadFailedReceived count] != 0)
    {
        _XCTPrimitiveFail(self, @"Uploads failed not 0");
    }
}

- (void)testUploadSimpleFileAndCancel
{
    NSString * cloudFilename = @"uploadsimplefile.txt";
    const char * localPath = [cloudFilename UTF8String];
    createFile(localPath, 8*1024*1024);
    
    [[m_client fileService] uploadFile:@"a/b"
                         cloudFilename:cloudFilename
                             shareable:true
                       replaceIfExists:true
                             localPath:cloudFilename
                       completionBlock:successBlock
                  errorCompletionBlock:failureBlock
                              cbObject:nil];
    [self waitForResult];
    
    NSString * uploadId = [[[TestFixtureBase getDataFromResponse:self.jsonResponse] valueForKey:@"fileDetails"] valueForKey:@"uploadId"];
    
    [m_client registerFileUploadCallback:fileUploadCompletedBlock failedBlock:fileUploadFailedBlock];
    bool transferHasStarted = false;
    while(!transferHasStarted)
    {
        int64_t transferred = [[m_client fileService] getUploadBytesTransferred:uploadId];
        int64_t total = [[m_client fileService] getUploadTotalBytesToTransfer:uploadId];
        double progress = [[m_client fileService] getUploadProgress:uploadId];
        NSLog(@"%lld transfered %lld total %f progress\n", transferred, total, progress);
        
        if (transferred > 0)
        {
            transferHasStarted = true;
        }
        else
        {
            [NSThread sleepForTimeInterval:0.3f];
            [m_client runCallBacks];
        }
    }
    
    NSLog(@"Cancelling upload...");
    
    [[m_client fileService] cancelUpload:uploadId];
    while ([_fileUploadCompletedReceived count] == 0 && [_fileUploadFailedReceived count] == 0)
    {
        [NSThread sleepForTimeInterval:0.3f];
        [m_client runCallBacks];
    }
    [m_client deregisterFileUploadCallback];
    
    if ([_fileUploadCompletedReceived count] != 0)
    {
        _XCTPrimitiveFail(self, @"Uploads completed not 0");
    }
    if ([_fileUploadFailedReceived count] != 1)
    {
        _XCTPrimitiveFail(self, @"Uploads failed not 1");
    }
    
    if ([(FileUploadFailedDetails*)[_fileUploadFailedReceived objectAtIndex:0] status] != HTTP_CUSTOM)
    {
        _XCTPrimitiveFail(self, @"Wrong http status");
    }
    if ([(FileUploadFailedDetails*)[_fileUploadFailedReceived objectAtIndex:0] reasonCode] != CLIENT_UPLOAD_FILE_CANCELLED)
    {
        _XCTPrimitiveFail(self, @"Wrong reason code");
    }
}


- (void)testListUserFiles
{
    [[m_client fileService] listUserFiles:successBlock
                     errorCompletionBlock:failureBlock
                                 cbObject:nil];
    [self waitForResult];
}


- (void)testUploadMultipleFiles
{
    NSString * cloudFilename = @"uploadsimplefile.txt";
    const char * localPath = [cloudFilename UTF8String];
    createFile(localPath, 4*1024*1024);
    
    int numTransfers = 3;
    NSMutableArray * uploadIds = [[NSMutableArray alloc] init];
    for (int i = 0; i < numTransfers; ++i)
    {
        [[m_client fileService] uploadFile:@""
                             cloudFilename:[NSString stringWithFormat:@"%@_%d", cloudFilename, i]
                                 shareable:true
                           replaceIfExists:true
                                 localPath:cloudFilename
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
        [self waitForResult];
        NSString * uploadId = [[[TestFixtureBase getDataFromResponse:self.jsonResponse] valueForKey:@"fileDetails"] valueForKey:@"uploadId"];
        if (uploadId == nil)
        {
            _XCTPrimitiveFail(self, @"Upload id not present in return JSON!");
            return;
        }
        [uploadIds addObject:uploadId];
    }
    
    [m_client registerFileUploadCallback:fileUploadCompletedBlock failedBlock:fileUploadFailedBlock];
    while ([_fileUploadCompletedReceived count] + [_fileUploadFailedReceived count] < numTransfers)
    {
        for (int i = 0; i < numTransfers; ++i)
        {
            int64_t transferred = [[m_client fileService] getUploadBytesTransferred:[uploadIds objectAtIndex:i]];
            int64_t total = [[m_client fileService] getUploadTotalBytesToTransfer:[uploadIds objectAtIndex:i]];
            double progress = [[m_client fileService] getUploadProgress:[uploadIds objectAtIndex:i]];
            if (transferred >= 0)
            {
                NSLog(@"File%d %lld transfered %lld total %f progress\n", i, transferred, total, progress);
            }
        }
        [NSThread sleepForTimeInterval:0.3f];
        [m_client runCallBacks];
    }
    [m_client deregisterFileUploadCallback];
    
    if ([_fileUploadCompletedReceived count] != numTransfers)
    {
        _XCTPrimitiveFail(self, @"Not all uploads succeeded");
    }
    if ([_fileUploadFailedReceived count] != 0)
    {
        _XCTPrimitiveFail(self, @"Uploads failed not 0");
    }
}


- (void)testDeleteFile
{
    NSString * filename = @"uploadsimplefile.txt";
    NSString * uploadId = nil;
    if (![self simpleUpload:5 cloudPath:@"" cloudFilename:filename uploadId:&uploadId])
    {
        return;
    }
    
    if ([_fileUploadCompletedReceived count] != 1)
    {
        _XCTPrimitiveFail(self, @"Uploads completed not 1");
        return;
    }
    if ([_fileUploadFailedReceived count] != 0)
    {
        _XCTPrimitiveFail(self, @"Uploads failed not 0");
        return;
    }
    
    [[m_client fileService] deleteUserFile:@""
                             cloudFilename:filename
                           completionBlock:successBlock
                      errorCompletionBlock:failureBlock
                                  cbObject:nil];
    [self waitForResult];
}

@end
