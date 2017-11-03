//
//  VernePickImage.m
//  GoodTeam
//
//  Created by vernepung on 15/8/17.
//  Copyright (c) 2015年 vernepung. All rights reserved.
//

#import "VPPickImageView.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIAlertView+Blocks.h"
#import "UtilsMacro.h"
static VPPickImageView *vpPickImageViewInstance;
@interface VPPickImageView()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *       _pickViewController;
}
@end

@implementation VPPickImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isCompressAndCrop = YES;
    }
    return self;
}

//+ (VPPickImageView *)shareInstance{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        vpPickImageViewInstance = [[VPPickImageView alloc]init];
//    });
//    return vpPickImageViewInstance;
//}



- (void)show
{
    if (self.takePhotoType == VPTakePhotoTypeCamera){
        [self presentViewControllerWithType:UIImagePickerControllerSourceTypeCamera];
    }
    else if (self.takePhotoType == VPTakePhotoTypeAblum){
        [self presentViewControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc ] init];
        actionSheet.title = @"选择图片";
        actionSheet.delegate = self;
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"取消"];
        if ([self isRearCameraAvailable]){
            [actionSheet addButtonWithTitle:@"相机"];
        }
        if ([self isFrontCameraAvailable]){
            [actionSheet addButtonWithTitle:@"相册"];
        }
        
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (BOOL)canPhotoService{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusDenied || author == ALAuthorizationStatusRestricted){
        NSString *msg = [NSString stringWithFormat:@"请开启\"%@\"的相册服务。",appName()];
        RIButtonItem *settingBtn = [RIButtonItem new];
        settingBtn.label = @"去设置";
        settingBtn.action = ^{
            openUrlInSafari(UIApplicationOpenSettingsURLString);
        };
        RIButtonItem *cancelBtn = [RIButtonItem new];
        cancelBtn.label = @"知道了";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg cancelButtonItem:cancelBtn otherButtonItems:settingBtn, nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (BOOL)canVideoService{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == ALAuthorizationStatusDenied || authStatus == ALAuthorizationStatusRestricted){
        NSString *msg = [NSString stringWithFormat:@"请开启\"%@\"的相机服务。",appName()];
        RIButtonItem *settingBtn = [RIButtonItem new];
        settingBtn.label = @"去设置";
        settingBtn.action = ^{
            openUrlInSafari(UIApplicationOpenSettingsURLString);
        };
        RIButtonItem *cancelBtn = [RIButtonItem new];
        cancelBtn.label = @"知道了";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg cancelButtonItem:cancelBtn otherButtonItems:settingBtn, nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark -UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)return;
    switch (buttonIndex) {
        case 1:// 相机
            if ([self canPhotoService] && [self canVideoService])
            {
                if (self.chooseCameraBlock)
                    self.chooseCameraBlock();
                else
                    [self presentViewControllerWithType:UIImagePickerControllerSourceTypeCamera];
            }
            break;
        case 2:// 相册
            if ([self canPhotoService]){
                if (self.chooseAblumBlock)
                    self.chooseAblumBlock();
                else
                    [self presentViewControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            break;
            
        default:
            break;
    }
}

- (void)presentViewControllerWithType:(UIImagePickerControllerSourceType)type{
    _pickViewController = [[UIImagePickerController alloc] init];
    _pickViewController.delegate = self;
    _pickViewController.allowsEditing = self.isCompressAndCrop;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    _pickViewController.mediaTypes = mediaTypes;
    _pickViewController.sourceType = type;
    
    UIViewController *viewController = self.currentViewController ?: [UIApplication sharedApplication].keyWindow.rootViewController;
    _pickViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [viewController presentViewController:_pickViewController animated:YES completion:^(){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
}

#pragma mark -UIImagePickerControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 设置导航返回按钮文字的颜色
    if (self.navigationBarTintColor) {
        [[UINavigationBar appearance] setTintColor:self.navigationBarTintColor];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    UIViewController *viewController = self.currentViewController ?: [UIApplication sharedApplication].keyWindow.rootViewController;
    [viewController dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    DLog(@"%@",info);
    NSString *pickType = [info valueForKey:UIImagePickerControllerMediaType];
    if ([pickType isEqualToString:@"public.image"])
    {
        NSData *imageData ;
        UIImage *editedImage = [info valueForKey:UIImagePickerControllerEditedImage];
        if (self.isCompressAndCrop)
        {
            editedImage = [self imageWithImage:editedImage scaledToSize:CGSizeMake(500, 500)];
            imageData = UIImageJPEGRepresentation(editedImage,0.5);
        }
        else
        {
            editedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
            imageData = UIImageJPEGRepresentation(editedImage, 1);
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(didPickedImageWithData:)])
        {
            [self.delegate didPickedImageWithData:imageData];
        }
    }
    UIViewController *viewController = self.currentViewController ?: [UIApplication sharedApplication].keyWindow.rootViewController;
    [viewController dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


#pragma mark - CameraUtility
- (BOOL) isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos
{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) canUserPickVideosFromPhotoLibrary
{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary
{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType
{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


@end
