//
//  StreamImagesHelper.h
//  InstaStream
//
//  Created by Eric Lanini on 4/23/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LFLiveKit/LFLiveKit.h>

@interface StreamImagesHelper : NSObject
{
    int count;
}

-(StreamImagesHelper*)initWithSession:(LFLiveSession*)session images:(NSArray <UIImage*>*)images;
//-(void)setImages:(NSArray<NSString*>*)images;

-(void)transformCurrentImage;
-(void)pauseChanged:(BOOL)p;
-(void)shouldStopStream;
- (void)initFiltersWithImage:(UIImage*)img;
-(void)swapImage:(UIImage*)img;
-(void)initTransform;
@end

