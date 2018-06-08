//
//  StreamImagesHelper.m
//  InstaStream
//
//  Created by Eric Lanini on 4/23/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "StreamImagesHelper.h"
#import <GPUImage/GPUImage.h>
#import <Crashlytics/Crashlytics.h>
#include <stdlib.h>

#define FPS 24.0f
#define CHANGE_INTERVAL 6.0f
#define ZOOM_STEP (0.2f/CHANGE_INTERVAL/FPS)

typedef enum {
  ISTransformTypeLeft = 0,
  ISTransformTypeRight,
  ISTransformTypeDown,
  ISTransformTypeUp,
  ISTransformTypeIn,
  ISTransformTypeMax
} ISTransformType;



@interface StreamImagesHelper()

@property (nonatomic, strong) GPUImageAlphaBlendFilter *overlayFilter;
@property (nonatomic, strong) GPUImagePicture *pictureInput;
@property (nonatomic, strong) GPUImageTransformFilter *videoTransformFilter;
@property (nonatomic, strong) GPUImageTransformFilter *pictureTransformFilter;
@property (nonatomic, strong) GPUImageCropFilter *cameraCropFilter;
@property (nonatomic, strong) GPUImageCropFilter *outputCropFilter;

@property (nonatomic, strong) UIImage *borderImage;
@property (nonatomic, strong) GPUImagePicture *borderImageFilter;
@property (nonatomic, strong) GPUImageTransformFilter *borderTransformFilter;
@property (nonatomic, strong) GPUImageAlphaBlendFilter *borderBlendFilter;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) ISTransformType transformType;

@property (nonatomic, assign) BOOL stop;
@property (nonatomic, assign) BOOL pause;
@property (nonatomic, assign) BOOL shouldInitFilters;
@property (nonatomic, weak) LFLiveSession *session;

@property (nonatomic, assign) CGFloat changeInterval;

@property (nonatomic, strong) NSTimer *currentTimer;
@property (nonatomic, assign) NSTimeInterval timeLeft;


//PRASHI
@property (nonatomic, assign)  NSArray *selectedImages;


@end

//TODO: blend filter for transitions and changing the current image etc
//TODO: check if imageQueue is nil on all functions
//TODO: pass down an FPS
//TODO: shouldStartEffect - once bcman receives URL and stream is going
//XXX: stop disabling reference counting

@implementation StreamImagesHelper

-(StreamImagesHelper*)initWithSession:(LFLiveSession*)session images:(NSArray <UIImage*>*)images
{
  self = [super init];
  if (self) {
//    [self initFiltersWithSession:session];
    //need to remove this
    self.changeInterval = 6.0;
    self.pause = NO;
    self.stop = NO;
    self.shouldInitFilters = YES;
    self.session = session;
   // self.imageQueue = [[ISPhotoManager alloc] initWithAssetURLs:images];
      _selectedImages = images;
      count = 0;
    [self shouldChangeImage:nil];
  }
  
  return self;
}

-(void)shouldChangeImage:(id)sender
{
  
      CLS_LOG(@"ISF1 dispatch queue %@", dispatch_get_current_queue());
  if (self.stop ||  self.pause) {  //self.imageQueue == nil ||
    return;
  }
    if (count == _selectedImages.count)
        count = 0;
    @synchronized (self) {
    typeof(self) __weak weakSelf = self;
        UIImage *img = _selectedImages[count];
        count ++;
        //[UIImage imageNamed:@"photography.jpg"];
//  [self.imageQueue nextImage:^(UIImage *img) {
    if (img == nil) {
      self.stop = YES;
      return;
    }
    CLS_LOG(@"nextImage callback received");
    if (self.shouldInitFilters) {
      CLS_LOG(@"received img from nextImage and shouldInitFilters is YES");
      self.shouldInitFilters = NO;
      [self initFiltersWithImage:img];
    } else {
      [self swapImage:img];
      [self initTransform];
    }
      CLS_LOG(@"ISF2 dispatch queue %@", dispatch_get_current_queue());
      dispatch_async(dispatch_get_main_queue(), ^() {
      CLS_LOG(@"ISF3 dispatch queue %@", dispatch_get_current_queue());
        weakSelf.currentTimer = [NSTimer scheduledTimerWithTimeInterval:_changeInterval
                                         target:weakSelf
                                       selector:@selector(shouldChangeImage:)
                                       userInfo:nil
                                        repeats:NO];
      });
  //}
   //];
 
   //since this is called the timer was fired and its invalid
    //make a new timer
    //set to _changeInterval
    //start it in main thread
    //save it
    
  CLS_LOG(@"shouldChangeImage called");
  }
}


-(void)transformCurrentImage
{
  if (self.stop || !self.image  || self.pause) //|| !self.imageQueue
    return;
  
  @synchronized (self) {
  //need to figure out blends
    //shouldChangeImage sets a mix, we change it until it hits 1/0
  //switch statement for moving the image in a certain way
  CGAffineTransform t = self.pictureTransformFilter.affineTransform;
    CGSize is = _image.size;
    CGFloat xstep = ((1.2*is.width  -  is.width) / (is.width  * FPS * _changeInterval));
    CGFloat ystep = ((1.2*is.height - is.height) / (is.height * FPS * _changeInterval));
  switch(_transformType) {
    case ISTransformTypeIn: {
      CGSize s = currentScale(t);
      t = CGAffineTransformScale(t, (s.width+ZOOM_STEP)/s.width, (s.height+ZOOM_STEP)/s.height);
      break;
    }
    case ISTransformTypeUp: {
      t = CGAffineTransformTranslate(t, 0, -ystep);
      break;
    }
    case ISTransformTypeDown: {
      t = CGAffineTransformTranslate(t, 0, ystep);
      break;
    }
    case ISTransformTypeLeft: {
      t = CGAffineTransformTranslate(t, -xstep, 0);
      break;
    }
    case ISTransformTypeRight: {
      t = CGAffineTransformTranslate(t, xstep, 0);
      break;
    }
    default: break;
  }
 
//    GPUImageFramebuffer *fb = [_pictureTransformFilter valueForKey:@"framebufferForOutput"];
    
//    CLS_LOG(@"fb = %@ refc = %lu", fb, (unsigned long)[fb valueForKey:@"framebufferReferenceCount"]);
  [self.pictureTransformFilter setAffineTransform:t];
  [self.pictureInput processImage];
  //scale the transform based on width/height and time
  //nextImage should be called before with hit a border
  }
}

-(void)initTransform
{
  
if (!self.image) //|| !self.imageQueue
    return;
  @synchronized (self) {
    ISTransformType randomTransform = (ISTransformType)(arc4random()%(int)ISTransformTypeMax);
    self.transformType = randomTransform;
    
//    do the initial scale or translate based on type
    CGAffineTransform t = CGAffineTransformIdentity;
    CGSize is = self.image.size;
    switch(randomTransform) {
      case ISTransformTypeIn: break; //noop
      case ISTransformTypeUp: {//should translate to bottom
        CGFloat ty = ((1.2*is.height - is.height)/(2*is.height));
        t = CGAffineTransformScale(t, 1.2, 1.2);
        t = CGAffineTransformTranslate(t, 0, ty);
        break;
      }
      case ISTransformTypeDown:{ //should translate to top
        CGFloat ty = ((1.2*is.height - is.height)/(2*is.height));
        t = CGAffineTransformScale(t, 1.2, 1.2);
        t = CGAffineTransformTranslate(t, 0, -ty);
        break;
      }
      case ISTransformTypeLeft:{ //translate to right
        CGFloat tx = ((1.2*is.width - is.width)/ (2.0 * is.width));
        t = CGAffineTransformScale(t, 1.2, 1.2);
        t = CGAffineTransformTranslate(t, tx, 0);
        break;
      }
      case ISTransformTypeRight:{ //translate to left
        CGFloat tx = ((1.2*is.width - is.width)/ (2.0 * is.width));
        t = CGAffineTransformScale(t, 1.2, 1.2);
        t = CGAffineTransformTranslate(t, -tx, 0);
        break;
      }
      default: break;
    }
    [self.pictureTransformFilter setAffineTransform:t];
    [self.pictureInput processImage];
  }
}

-(void)swapImage:(UIImage*)img {
  @synchronized (self) {
    GPUImagePicture *newPic = [[GPUImagePicture alloc] initWithImage:img];
    GPUImagePicture *old = self.pictureInput;
    [newPic addTarget:self.pictureTransformFilter atTextureLocation:0];
    [self.pictureTransformFilter forceProcessingAtSizeRespectingAspectRatio:img.size];
    [self.outputCropFilter setCropRegion:[self cropRectForImage:img]];
    [self.outputCropFilter forceProcessingAtSizeRespectingAspectRatio:img.size];
    self.pictureInput = newPic;
    if (self.image) {
      [old removeAllTargets];
    }
    //0-3 + 3 -> 3-6
    _changeInterval = (CGFloat)((arc4random() % 4) + 3);
    CLS_LOG(@"changeint = %f", _changeInterval);
    self.image = img;
  }
}

//TODO: set up with image queueing
- (void)initFiltersWithImage:(UIImage*)img {
  @synchronized (self) {
    GPUImageVideoCamera *source = self.session.sourceFilter;
    GPUImageFilter *sink = self.session.sinkFilter;
    CGAffineTransform vt = CGAffineTransformIdentity;
    
    
    
    self.videoTransformFilter = [[GPUImageTransformFilter alloc] init];
    self.pictureTransformFilter = [[GPUImageTransformFilter alloc] init];
    self.overlayFilter = [[GPUImageAlphaBlendFilter alloc] init];
    self.overlayFilter.mix = 1.0;
    self.outputCropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0, 0, 1, 1)];
    self.borderImage = [UIImage imageNamed:@"borderImage.png"];
    self.borderImageFilter = [[GPUImagePicture alloc] initWithImage:self.borderImage];
    [self.borderImageFilter processImage];
    self.borderBlendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    self.borderBlendFilter.mix = 1.0;
    
    [self.pictureTransformFilter setBackgroundColorRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self swapImage:img];
    [self initTransform];
    
    
    //pictransform setup
    //pic -> pictransform
    [self.pictureInput addTarget:self.pictureTransformFilter];
   
    
    //pictransform -> overlay
    [self.pictureTransformFilter addTarget:self.outputCropFilter];
    [self.outputCropFilter addTarget:self.overlayFilter];
    
    vt = CGAffineTransformTranslate(vt, 0.5, 0.7);
    vt = CGAffineTransformScale(vt, 0.185, 0.25);//(vt, 0.185, 0.25)
    [self.videoTransformFilter setAffineTransform:vt];
    [self.videoTransformFilter setBackgroundColorRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    //vidtransform -> overlay
    [self.borderBlendFilter addTarget:self.overlayFilter];
    [self.videoTransformFilter addTarget:self.borderBlendFilter];
    [self.borderImageFilter addTarget:self.borderBlendFilter];
    [self.borderImageFilter processImage];
    
    
    
    
    
   
    
    //crop -> sink
//    [self.borderImageFilter processImageUpToFilter:sink withCompletionHandler:^(UIImage *processedImage) {
//      CLS_LOG(@"complete");
//    }];
//    [self.pictureInput processImageUpToFilter:sink withCompletionHandler:^(UIImage *processedImage) {
//      CLS_LOG(@"complete");
//    }];
    //source -> vidtransform
    [self.borderImageFilter processImage];
    [self.pictureInput processImage];
    [source removeAllTargets];
    [source addTarget:self.videoTransformFilter];
    [self.overlayFilter addTarget:sink];
    self.session.useCustomFilters = true;
    CLS_LOG(@"filters set");
  }
}

-(void)pauseChanged:(BOOL)p {
  //if we are pausing:
    //we need to
    //get current time interval date
    //invalidate timer
    //save the time difference between fireDate and now
  //unpausing:
    //create new timer with the saved time difference
  
  if (self.pause != p) {
    @synchronized (self) {
      self.pause = p;
      if (p == YES) {
        NSDate *fireDate = self.currentTimer.fireDate;
        [self.currentTimer invalidate];
        self.timeLeft = [fireDate timeIntervalSinceNow];
        self.currentTimer = nil;
      } else {
        typeof(self) __weak weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^() {
          weakSelf.currentTimer = [NSTimer scheduledTimerWithTimeInterval:weakSelf.timeLeft target:weakSelf selector:@selector(shouldChangeImage:) userInfo:nil repeats:NO];
          weakSelf.timeLeft = 0;
        });
      }
    }
  }
}

-(CGRect)cropRectForImage:(UIImage *)image {
  CGRect rect;
  CGFloat cut;
  CGSize sz = image.size;
  if (sz.width > sz.height) {
    cut = (1-(sz.height/sz.width))/2;
    rect.origin.x = cut;
    rect.origin.y = 0;
    rect.size.width = 1-(2*cut);
    rect.size.height = 1;
  } else if (sz.width < sz.height) {
    cut = (1-(sz.width/sz.height))/2;
    rect.origin.x = 0;
    rect.origin.y = cut;
    rect.size.width = 1;
    rect.size.height = 1-(2*cut);
  } else {
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = 1;
    rect.size.height = 1;
  }
  CLS_LOG(@"cropRect: image=%fx%f \nrect.x = %f y = %f height = %f width = %f", sz.height, sz.width,
        rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
  return rect;
}

-(void)dumpFilters:(GPUImageOutput *)top indent:(NSInteger)indent {
  NSString *indentString = [@"" stringByPaddingToLength:indent withString:@" " startingAtIndex:0];
  CLS_LOG(@"%@%@ width %f height %f", indentString, top, top.framebufferForOutput.size.width,top.framebufferForOutput.size.height);
  for (id filter in [top targets]) {
    if ([filter isKindOfClass:[GPUImageOutput class]])
      [self dumpFilters:filter indent:indent+1];
  }
}
-(void)shouldStopStream
{
  [self.currentTimer invalidate];
  self.currentTimer = nil;
//  self.imageQueue = nil;
  self.session = nil;
}

-(void)dealloc {
  CLS_LOG(@"StreamImagesHelper dealloc");
  CLS_LOG(@"StreamImagesHelper dealloc");
  CLS_LOG(@"StreamImagesHelper dealloc");
//  self.session.useCustomFilters = NO;
  [self.overlayFilter removeAllTargets];
  [self.overlayFilter removeOutputFramebuffer];
  [self.borderBlendFilter removeAllTargets];
  [self.borderBlendFilter removeOutputFramebuffer];
  
  [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
}

#pragma mark util
static inline CGSize currentScale(CGAffineTransform t) {
  CGFloat x = sqrt(t.a*t.a + t.c*t.c);
  CGFloat y = sqrt(t.b*t.b + t.d*t.d);
  return CGSizeMake(x, y);
}


@end

