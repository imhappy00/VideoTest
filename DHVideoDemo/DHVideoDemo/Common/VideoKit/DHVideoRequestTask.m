//
//  DHVideoRequest.m
//  DHVideoDemo
//
//  Created by DuHongXing on 2017/11/7.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import "DHVideoRequestTask.h"
@interface DHVideoRequestTask()<NSURLSessionDelegate>
@property (copy, nonatomic) NSURL *url;
@property (assign, nonatomic) BOOL once;
@property (strong, nonatomic) NSURLSession *videoSession;
@property (strong, nonatomic) NSFileHandle *fileHandle;
@property (strong, nonatomic) NSURLSessionDownloadTask *videoConnectionTask;

@property (copy, nonatomic) NSString *tempPath;
@end
@implementation DHVideoRequestTask

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//        self.taskArray = [NSMutableArray array];
        self.tempPath = [document stringByAppendingPathComponent:@"temp.mp4"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.tempPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:self.tempPath error:nil];
        }
        [[NSFileManager defaultManager]createFileAtPath:self.tempPath contents:nil attributes:nil];
    }
    return self;
}

- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset {
    _url = url;
    _offset = offset;
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    actualURLComponents.scheme = @"https";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[actualURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    _downLoadingOffset = 0;
    if (self.videoConnectionTask && self.videoConnectionTask.state != NSURLSessionTaskStateCompleted) {
         [[NSFileManager defaultManager] removeItemAtPath:self.tempPath error:nil];
    }
    
    if (_offset > 0 && _videoLength >0) {
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)self.offset,(unsigned long)self.videoLength - 1] forHTTPHeaderField:@"Range"];
    }
    self.videoSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    self.videoConnectionTask = [self.videoSession downloadTaskWithRequest:request];
    [self.videoConnectionTask resume];
}

- (void)cancle {
    [self.videoConnectionTask cancel];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"》》》》》开始相应");
    self.isFinishedLoad = NO;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    NSDictionary *dic = (NSDictionary *)[httpResponse allHeaderFields] ;
    
    NSString *content = [dic valueForKey:@"Content-Range"];
    NSArray *array = [content componentsSeparatedByString:@"/"];
    NSString *length = array.lastObject;
    
    NSUInteger videoLength;
    
    if ([length integerValue] == 0) {
        videoLength = (NSUInteger)httpResponse.expectedContentLength;
    } else {
        videoLength = [length integerValue];
    }
    self.videoLength = videoLength;
    self.mimeType = @"video/mp4";
    if ([self.delegate respondsToSelector:@selector(task:didReceiveVideoLength:mimeType:)]) {
        [self.delegate task:self didReceiveVideoLength:self.videoLength mimeType:self.mimeType];
    }
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.tempPath];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSLog(@"》》》》》接受数据");
    [self.fileHandle seekToEndOfFile];
    [self.fileHandle writeData:data];
    _downLoadingOffset += data.length;
    if ([self.delegate respondsToSelector:@selector(didReceiveVideoDataWithTask:)]) {
        [self.delegate didReceiveVideoDataWithTask:self];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"》》》》》完成下载");
    self.isFinishedLoad = YES;
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *movePath = [documentPath stringByAppendingPathComponent:@"local.mp4"];
    [[NSFileManager defaultManager] createFileAtPath:movePath contents:nil attributes:nil];
    BOOL isSuccess = [[NSFileManager defaultManager]copyItemAtPath:self.tempPath toPath:movePath error:nil];
    if (isSuccess) {
        //TODO
    }
    if ([self.delegate respondsToSelector:@selector(didFinishLoadingWithTask:)]) {
        [self.delegate didFinishLoadingWithTask:self];
    }
}

//网络中断：-1005
//无网络连接：-1009
//请求超时：-1001
//服务器内部错误：-1004
//找不到服务器：-1003
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    if (error.code == -1001 && !self.once) {      //网络超时，重连一次
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self continueLoading];
        });
    }
    if ([self.delegate respondsToSelector:@selector(didFailLoadingWithTask:WithError:)]) {
        [self.delegate didFailLoadingWithTask:self WithError:error.code];
    }
    if (error.code == -1009) {
        NSLog(@"无网络连接");
    }
}

#pragma mark - private
- (void)cancel {
    [self.videoConnectionTask cancel];
    [self clearData];
}

- (void)clearData {
    [self.videoConnectionTask cancel];
    [[NSFileManager defaultManager]removeItemAtPath:self.tempPath error:nil];
}

- (void)continueLoading {
    self.once = YES;
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:_url resolvingAgainstBaseURL:NO];
    actualURLComponents.scheme = @"http";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[actualURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)_downLoadingOffset, (unsigned long)self.videoLength - 1] forHTTPHeaderField:@"Range"];
    
    
    [self.videoConnectionTask cancel];
//    self.videoSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.videoConnectionTask = [self.videoSession downloadTaskWithRequest:request];
    
    [self.videoConnectionTask resume];
}
@end
