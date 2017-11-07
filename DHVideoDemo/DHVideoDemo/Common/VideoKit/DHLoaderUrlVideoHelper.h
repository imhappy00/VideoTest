//
//  DHLoaderUrlVideoHelper.h
//  DHVideoDemo
//
//  Created by DuHongXing on 2017/11/7.
//  Copyright © 2017年 duxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class DHVideoRequestTask;
@protocol DHLoaderUrlVideoHelperDelegate <NSObject>

- (void)didFinishLoadingWithTask:(DHVideoRequestTask *)task;
- (void)didFailLoadingWithTask:(DHVideoRequestTask *)task WithError:(NSInteger )errorCode;

@end

@interface DHLoaderUrlVideoHelper : NSObject<AVAssetResourceLoaderDelegate>
@property (nonatomic, strong) DHVideoRequestTask *task;
@property (copy, nonatomic) id<DHLoaderUrlVideoHelperDelegate> delegate;
- (NSURL *)getSchemeVideoURL:(NSURL *)url;

@end
