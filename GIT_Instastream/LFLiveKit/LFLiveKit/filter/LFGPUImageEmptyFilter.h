#if __has_include(<GPUImage/GPUImageFramework.h>)
#import <GPUImage/GPUImageFramework.h>
#elif __has_include(<GPUImage/GPUImage.h>)
#import <GPUImage/GPUImage.h>
#else
#import "GPUImage.h"
#endif
@interface LFGPUImageEmptyFilter : GPUImageFilter
{
}

@end
