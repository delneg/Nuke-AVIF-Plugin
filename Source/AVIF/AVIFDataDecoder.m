//
//  AVIFDataDecoder.m
//  Nuke-AVIF-Plugin iOS
//
//  Created by delneg on 2021/12/05.
//  Copyright © 2021 delneg. All rights reserved.
//

#import "AVIFDataDecoder.h"
#import <Foundation/Foundation.h>
#if __has_include(<libavif/avif.h>)
#import <libavif/avif.h>
#else
#import "avif/avif.h"
#import "SDSources/Conversion.h"

#endif

//void free_image_data(void *info, const void *data, size_t size) {
//    if (info != NULL) {
//        WebPFreeDecBuffer(&((WebPDecoderConfig *) info)->output);
//        free(info);
//    }
//
//    WebPFree((void *)data);
//}

@implementation AVIFDataDecoder {
//    AVIFIDecoder *_idec;
}
- (nullable Image *)incrementallyDecodeData:(NSData *)data {
    return nil;
}


//- (void)dealloc {
//    if (_idec) {
//        WebPIDelete(_idec);
//        _idec = NULL;
//    }
//}
//
//- (Image *)incrementallyDecodeData:(NSData *)data {
//
//    if (!_idec) {
//        _idec = WebPINewRGB(MODE_rgbA, NULL, 0, 0);
//        if (!_idec) {
//            return nil;
//        }
//    }
//
//    Image *image;
//
//    VP8StatusCode status = WebPIUpdate(_idec, [data bytes], [data length]);
//    if (status != VP8_STATUS_OK && status != VP8_STATUS_SUSPENDED) {
//        return nil;
//    }
//
//    int width, height, last_y, stride = 0;
//    uint8_t *rgba = WebPIDecGetRGB(_idec, &last_y, &width, &height, &stride);
//
//    if (0 < width + height && 0 < last_y && last_y <= height) {
//        size_t rgbaSize = last_y * stride;
//        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rgba, rgbaSize, NULL);
//        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
//        size_t components = 4;
//        CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
//
//        CGImageRef imageRef = CGImageCreate(width, last_y, 8, components * 8, components * width, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
//
//        if (!imageRef) {
//            return nil;
//        }
//
//        CGColorSpaceRef canvasColorSpaceRef = CGColorSpaceCreateDeviceRGB();
//        CGContextRef canvas = CGBitmapContextCreate(NULL, width, height, 8, 0, canvasColorSpaceRef, bitmapInfo);
//        if (!canvas) {
//            CGImageRelease(imageRef);
//            CGColorSpaceRelease(colorSpaceRef);
//            CGColorSpaceRelease(canvasColorSpaceRef);
//            CGDataProviderRelease(provider);
//            return nil;
//        }
//
//        CGContextDrawImage(canvas, CGRectMake(0, height - last_y, width, last_y), imageRef);
//        CGImageRef newImageRef = CGBitmapContextCreateImage(canvas);
//
//        CGImageRelease(imageRef);
//        CGColorSpaceRelease(colorSpaceRef);
//
//        if (!newImageRef) {
//            CGDataProviderRelease(provider);
//            return nil;
//        }
//
//        CGContextRelease(canvas);
//        CGColorSpaceRelease(canvasColorSpaceRef);
//
//#if WEBP_PLUGIN_MAC
//        image = [[NSImage alloc] initWithCGImage:newImageRef size:CGSizeZero];
//#else
//        image = [UIImage imageWithCGImage:newImageRef];
//#endif
//        CGImageRelease(newImageRef);
//        CGDataProviderRelease(provider);
//    }
//
//    return image;
//}
//
- (nullable Image *)decodeData:(NSData *)data {
    avifDecoder * decoder = avifDecoderCreate();
    avifDecoderSetIOMemory(decoder, data.bytes, data.length);
    CGFloat scale = 1;

    // Disable strict mode to keep some AVIF image compatible
    decoder->strictFlags = AVIF_STRICT_DISABLED;
    avifResult decodeResult = avifDecoderParse(decoder);
    if (decodeResult != AVIF_RESULT_OK) {
        NSLog(@"Failed to decode image: %s", avifResultToString(decodeResult));
        avifDecoderDestroy(decoder);
        return nil;
    }
    // Static image
    if (decoder->imageCount <= 1) {
        avifResult nextImageResult = avifDecoderNextImage(decoder);
        if (nextImageResult != AVIF_RESULT_OK) {
            NSLog(@"Failed to decode image: %s", avifResultToString(nextImageResult));
            avifDecoderDestroy(decoder);
            return nil;
        }
        CGImageRef imageRef = SDCreateCGImageFromAVIF(decoder->image);
        if (!imageRef) {
            avifDecoderDestroy(decoder);
            NSLog(@"CGImageRef is nil");
            return nil;
        }

        Image *image = nil;

#if AVIF_PLUGIN_MAC
        image = [[NSImage alloc] initWithCGImage:imageRef size:CGSizeZero];
#else
        image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
#endif

        CGImageRelease(imageRef);
        avifDecoderDestroy(decoder);
        return image;
    } else {
        NSLog(@"Animated images are not supported yet");
        return nil;
    }

    // Animated image
//    NSMutableArray<Image *> *frames = [NSMutableArray array];
//    while (avifDecoderNextImage(decoder) == AVIF_RESULT_OK) {
//        @autoreleasepool {
//            CGImageRef imageRef = SDCreateCGImageFromAVIF(decoder->image);
//            if (!imageRef) {
//                continue;
//            }
//            Image *image = nil;
//#if AVIF_PLUGIN_MAC
//            image = [[NSImage alloc] initWithCGImage:imageRef size:CGSizeZero];
//#else
//            image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
//#endif
//            NSTimeInterval duration = decoder->imageTiming.duration; // Should use `decoder->imageTiming`, not the `decoder->duration`, see libavif source code
//            SDImageFrame *frame = [SDImageFrame frameWithImage:image duration:duration];
//            [frames addObject:frame];
//        }
//    }
//
//    avifDecoderDestroy(decoder);
//
//    UIImage *animatedImage = [SDImageCoderHelper animatedImageWithFrames:frames];
//    animatedImage.sd_imageLoopCount = 0;
//    animatedImage.sd_imageFormat = SDImageFormatAVIF;
//
//    return animatedImage;
}

@end
