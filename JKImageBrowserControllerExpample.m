//
//  JKImagePickerView.h
//
//  Created by Jack/Zark on 2019/5/10.
//  Copyright © Jack/Zark All rights reserved.
//

#import "MyClass.h"
#import "JKImagePickerView.h"

//浏览大图
#import "JKImageBrowserViewController.h"
#import "JKImageBrowserTransitionParameter.h"
#import "JKTransitionDelegate.h"

@interface MyClass () {
    JKImagePickerView *_imagePicker;
    
    //浏览大图
    JKTransitionDelegate *transitionDelegate;
}

@property (weak, nonatomic) IBOutlet UIView *photo_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photo_view_height;

@end

@implementation MyClass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认有车";
    
    [self setupUI];
}

- (void)setupUI {
    //上传图片（自定义的照片墙，可忽略setupUI此段）
    JKImagePickerViewLayoutConfig *config = [[JKImagePickerViewLayoutConfig alloc] init];
    config.maxItemCount = 3;
    config.width = ScreenWidth - 40;
    
    _imagePicker = [[JKImagePickerView alloc] initWithConfig:config startPoint:CGPointMake(10, 50)];
    _imagePicker.image_name_prefix = @"MyClass";
    _imagePicker.canAddImage = YES;
    [self.photo_view addSubview:_imagePicker];
    
    __weak typeof(self) weakSelf = self;
    _imagePicker.zoomOutEvent = ^(NSInteger item) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf imageTapAt:item];
    };
    
    CGFloat photo_view_height = [config viewHeightForItemCount:1];
    self.photo_view_height.constant = 60 + photo_view_height;

}

#pragma mark - touch event

#pragma mark - 点击浏览大图
- (void)imageTapAt: (NSInteger)index {
    NSMutableArray *sourceImageArray = [_imagePicker copySourceImageModels];    //要浏览图片的数组，item必须为JKImagePickerModel对象。请将你要浏览的图片的urlString或者UIImage赋值给JKImagePickerModel对象（只需要给image或者urlString复制，其他参数未用到）
    JKImageBrowserTransitionParameter *parameter = [[JKImageBrowserTransitionParameter alloc] init];
    parameter.imageIndex = index;
    parameter.sourceImageModel = sourceImageArray[index];
    parameter.delegate = self;
    
    transitionDelegate = [[JKTransitionDelegate alloc] init];
    transitionDelegate.transitionParameter = parameter;
    
    JKImageBrowserViewController *browser = [[JKImageBrowserViewController alloc] init];
    browser.transitioningDelegate = transitionDelegate;     //如果要多次使用delgate，必须在外部持有该对象！否则 presented vc内部使用一次delegate执行动画之后，就会释放掉该对象！
    browser.sourceImageArray = sourceImageArray;
    [self presentViewController:browser animated:YES completion:nil];
}

//浏览大图
#pragma mark - JKImageBrowserOriginImageInfoDelegate

//获取对应index图片在UIScreen上的初始frame，用于动画过渡。
- (CGRect)getOriginImageFrameAt:(NSInteger)index {
    if (index < 0 || index > 2) {//在总共只有3张图片时，超出数组边界的返回rect zero.
        return CGRectZero;
    }
    return [_imagePicker getOriginFrameof:index];   //_imagePicker是一个网格图片容器。你只需要提供你页面对应index下图片在Screen上的frame即可。
}
//计算出index对应图片在UIScreen上（放大后）最终的位置，用于动画过渡。
- (CGRect)getFinalImageFrameAt:(NSInteger)index {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    UIImage *image = [_imagePicker getImageof:index];       //对应index下的image，必须是UIImage对象。根据图片的宽高比，屏幕宽高比计算图片放大策略和最终frame.
    CGSize imageSize = CGSizeMake(1, 1);
    if (image) {
        imageSize = image.size;
    }
    CGFloat aspectRatio = imageSize.width/imageSize.height;
    
    CGFloat width = 0;
    CGFloat height = 0;
    if (aspectRatio > screenWidth/screenHeight) {
        width = screenWidth;
        height = width/aspectRatio;
    }else {
        height = screenHeight;
        width = height*aspectRatio;
    }
    
    CGFloat fx = (screenWidth - width)/2.0;
    CGFloat fy = (screenHeight - height)/2.0;
    
    return CGRectMake(fx, fy, width, height);
}
@end
