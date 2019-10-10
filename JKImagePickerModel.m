//
//  JKImagePickerView.h
//
//  Created by Jack/Zark on 2019/5/10.
//  Copyright © Jack/Zark All rights reserved.
//

#import "JKImagePickerModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation JKImagePickerModel

- (NSString *)assetIdentifier {
    NSString *identifier = nil;
    if (_asset) {
        if ([_asset isKindOfClass:[ALAsset class]]) {
            identifier = [((ALAsset *)_asset) valueForKey:ALAssetPropertyAssetURL];
        }else if ([_asset isKindOfClass:[PHAsset class]]) {
            //eg:B34BAB7A-B628-4A40-9BB7-AA5FA9AA863C/L0/001
            identifier = ((PHAsset *)_asset).localIdentifier;
        }
    }
    return identifier;
}

- (void)setAsset:(id)asset {
    _asset = asset;
    if (asset) {
        _cameraImageIdentifier = nil;
    }
}

- (void)setCameraImageIdentifier:(NSString *)cameraImageIdentifier {
    _cameraImageIdentifier = cameraImageIdentifier;
    if (cameraImageIdentifier) {
        _asset = nil;
    }
}

- (NSString *)intellectIdentifier {
    if (_asset) {
        return self.assetIdentifier;
    }else if (_cameraImageIdentifier) {
        return self.cameraImageIdentifier;
    }else {
        return @"";
    }
}

- (NSString *)getImageUrlSmallImageFirst: (BOOL)smallFirst {
    if (smallFirst) {
        if (_thumbImageUrlString) {
            return _thumbImageUrlString;
        }else {
            return _imageUrlString;
        }
    }else {
        if (_imageUrlString) {
            return _imageUrlString;
        }else {
            return _thumbImageUrlString;
        }
    }
}

//- (BOOL)isFromCamera {
//    if (self.asset == nil) {
//        if (self.status == JKImageStatusNotUpload || self.status == JKImageStatusUploadedSuccess || self.status == JKImageStatusUploadedFailed) {
//            return YES;
//        }
//    }
//    return NO;
//}

#pragma mark - copy

- (id)copyWithZone:(NSZone *)zone {
    JKImagePickerModel *obj = [[JKImagePickerModel alloc] init];
    obj.thumbImageUrlString = [self.thumbImageUrlString copyWithZone:zone];
    obj.imageUrlString = [self.imageUrlString copyWithZone:zone];
    obj.image = [self.image copy];
    obj.asset = [self.asset copyWithZone:zone];
    obj.cameraImageIdentifier = [self.cameraImageIdentifier copyWithZone:zone];
    obj.status = self.status;
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    JKImagePickerModel *obj = [[JKImagePickerModel alloc] init];
    obj.thumbImageUrlString = [self.thumbImageUrlString mutableCopyWithZone:zone];
    obj.imageUrlString = [self.imageUrlString mutableCopyWithZone:zone];
    obj.image = [self.image mutableCopy];
    obj.asset = [self.asset mutableCopyWithZone:zone];
    obj.cameraImageIdentifier = [self.cameraImageIdentifier mutableCopyWithZone:zone];
    obj.status = self.status;
    return obj;
}

@end



