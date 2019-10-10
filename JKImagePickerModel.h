//
//  JKImagePickerView.h
//
//  Created by Jack/Zark on 2019/5/10.
//  Copyright © Jack/Zark All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JKImageStatus) {
    JKImageStatusNotUpload = 0,
    JKImageStatusUploadedSuccess = 1,       //has url
    JKImageStatusUploadedFailed = 2,
    
    JKImageStatusOnline = 100,              //has url
    JKImageStatusOnlineCanDelete = 101,     //has url
    
    JKImageStatusAddIcon = 444
};

@interface JKImagePickerModel : NSObject <NSCopying, NSMutableCopying>

///缩略图
@property (nonatomic, strong) NSString *thumbImageUrlString;
///
@property (nonatomic, strong) NSString *imageUrlString;
///
@property (nonatomic, strong) UIImage *image;
/*
 0：未上传；1：上传成功；2：上传失败
 100：仅仅展示图片，不可操作（删除、添加等）
 444：添加图片按钮
 */
@property (nonatomic, assign) JKImageStatus status;

//相册获取，ALAsset(deprecated) or PHAsset
@property (nonatomic, strong) id asset;
//相册获取，
@property (nonatomic, readonly) NSString *assetIdentifier;

///相机拍照，自定义生成一个id，用于上传图片后记录该图片（根据cameraImageIdentifier找到model）状态和url。
@property (nonatomic, strong) NSString *cameraImageIdentifier;

///智能id，如果是相机，返回cameraImageIdentifier；如果是相册，返回assetIdentifier
@property (nonatomic, readonly) NSString *intellectIdentifier;

//YES，优先选择thumbImageUrlString，否则优先选择imageUrlString
- (NSString *)getImageUrlSmallImageFirst: (BOOL)smallFirst;

@end

NS_ASSUME_NONNULL_END
