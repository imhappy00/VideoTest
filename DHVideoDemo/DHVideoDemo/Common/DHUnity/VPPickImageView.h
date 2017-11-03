//
//  VernePickImage.h
//  GoodTeam
//
//  Created by vernepung on 15/8/17.
//  Copyright (c) 2015年 vernepung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VPTakePhotoType)
{
    VPTakePhotoTypeAll = 0,
    VPTakePhotoTypeCamera = 1,
    VPTakePhotoTypeAblum = 2
};
typedef NS_ENUM(NSInteger,VPPickImageStatusBarStyle) {
    VPPickImageStatusBarStyleDefault = 0,
    VPPickImageStatusBarStyleLight = 1,
};

@protocol VPPickImageDelegate;
@interface VPPickImageView : NSObject

@property (assign, nonatomic) VPPickImageStatusBarStyle statusBarStype;
@property (assign,nonatomic) BOOL isCompressAndCrop;
@property (strong, nonatomic) UIColor *navigationBarTintColor;
@property (assign,nonatomic) VPTakePhotoType takePhotoType;
@property (weak,nonatomic) UIViewController *currentViewController;
@property (copy,nonatomic) void (^chooseCameraBlock)(void);
@property (copy,nonatomic) void (^chooseAblumBlock)(void);
@property (weak,nonatomic) id<VPPickImageDelegate> delegate;
- (BOOL)canPhotoService;
- (void)show;
@end

@protocol VPPickImageDelegate <NSObject>
- (void)didPickedImageWithData:(NSData *)imageData;
@end
