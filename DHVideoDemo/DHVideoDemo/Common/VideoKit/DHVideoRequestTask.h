//
//  DHVideoRequest.h
//  DHVideoDemo
//
//  Created by DuHongXing on 2017/11/7.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DHVideoRequestTask;
@protocol DHVideoRequestTaskDelegate <NSObject>

- (void)task:(DHVideoRequestTask *)task didReceiveVideoLength:(NSUInteger)ideoLength mimeType:(NSString *)mimeType;
- (void)didReceiveVideoDataWithTask:(DHVideoRequestTask *)task;
- (void)didFinishLoadingWithTask:(DHVideoRequestTask *)task;
- (void)didFailLoadingWithTask:(DHVideoRequestTask *)task WithError:(NSInteger )errorCode;

@end

@interface DHVideoRequestTask : NSObject
@property (nonatomic, assign) NSUInteger                 offset;
@property (nonatomic, assign) NSUInteger                 videoLength;
@property (nonatomic, assign) NSUInteger                 downLoadingOffset;

@property (nonatomic, strong) NSString        *mimeType;
@property (assign, nonatomic) BOOL isFinishedLoad;
@property (weak, nonatomic) id<DHVideoRequestTaskDelegate> delegate;

- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset;

- (void)cancel;

- (void)continueLoading;

- (void)clearData;
@end
