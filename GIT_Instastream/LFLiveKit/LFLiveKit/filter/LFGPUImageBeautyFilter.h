#if __has_include(<GPUImage/GPUImageFramework.h>)
#import <GPUImage/GPUImageFramework.h>
#elif __has_include(<GPUImage/GPUImage.h>)
#import <GPUImage/GPUImage.h>
#else
#import "GPUImage.h"
#endif
@interface LFGPUImageBeautyFilter : GPUImageFilter {
}

@property (nonatomic, assign) CGFloat beautyLevel;
@property (nonatomic, assign) CGFloat brightLevel;
@property (nonatomic, assign) CGFloat toneLevel;
@end
