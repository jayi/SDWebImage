//
//  UIImage+WebP.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 07/06/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#ifdef SD_WEBP
#import "UIImage+WebP.h"
#import <YYImage/YYImageCoder.h>

@implementation UIImage (WebP)

+ (UIImage *)sd_imageWithWebPData:(NSData *)data {
    @autoreleasepool {
        YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:[UIScreen mainScreen].scale];
        UIImage *image;
        if (decoder.frameCount > 1) {
            NSMutableArray *images = [NSMutableArray new];
            CGFloat duration = 0;
            for (int i = 0; i < decoder.frameCount; ++i) {
                UIImage *image = [decoder frameAtIndex:i decodeForDisplay:YES].image;
                if (image != nil) {
                    [images addObject:image];
                    CGFloat frameDuration = [decoder frameDurationAtIndex:i];
                    duration += frameDuration > 1e-3 ? frameDuration : 0.15;
                }
            }
            image = [UIImage animatedImageWithImages:images duration:duration];
        } else {
            image = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
        }
        return image;
    }
}

@end

#if !COCOAPODS
// Functions to resolve some undefined symbols when using WebP and force_load flag
void WebPInitPremultiplyNEON(void) {}
void WebPInitUpsamplersNEON(void) {}
void VP8DspInitNEON(void) {}
#endif

#endif
