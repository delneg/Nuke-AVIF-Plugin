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
#endif
#import "SDSources/Conversion.h"
#import <Accelerate/Accelerate.h>


@implementation AVIFDataDecoder {
    avifDecoder *_idec;
}


- (void)dealloc {
    if (_idec) {
        avifDecoderDestroy(_idec);
        _idec = NULL;
    }
}

- (nullable Image *)incrementallyDecodeData:(NSData *)data {

    if (!_idec) {
        _idec = avifDecoderCreate();
        // Disable strict mode to keep some AVIF image compatible
        _idec->strictFlags = AVIF_STRICT_DISABLED;
        if (!_idec) {
            return nil;
        }
        
    }

    Image *image;
    CGFloat scale = 1;
    
    avifDecoderSetIOMemory(_idec, data.bytes, data.length);
    avifResult decodeResult = avifDecoderParse(_idec);

    if (decodeResult != AVIF_RESULT_OK && decodeResult != AVIF_RESULT_TRUNCATED_DATA) {
        NSLog(@"Failed to decode image: %s", avifResultToString(decodeResult));
        avifDecoderDestroy(_idec);
        _idec = NULL;
        return nil;
    }
    
    // Static image
    if (_idec->imageCount == 1) {
        avifResult nextImageResult = avifDecoderNextImage(_idec);
        NSLog(@"nextImageResult %s", avifResultToString(nextImageResult));
//        if (nextImageResult != AVIF_RESULT_OK ) {
//            NSLog(@"Failed to decode image: %s", avifResultToString(nextImageResult));
//            avifDecoderDestroy(_idec);
//            _idec = NULL;
//            return nil;
//        }
    
        
//        avifRGBImage rgb;
//        memset(&rgb, 0, sizeof(rgb));
//        // Now available (for this frame):
//        // * All decoder->image YUV pixel data (yuvFormat, yuvPlanes, yuvRange, yuvChromaSamplePosition, yuvRowBytes)
//        // * decoder->image alpha data (alphaRange, alphaPlane, alphaRowBytes)
//        // * this frame's sequence timing
//
//        avifRGBImageSetDefaults(&rgb, _idec->image);
//        // Override YUV(A)->RGB(A) defaults here: depth, format, chromaUpsampling, ignoreAlpha, alphaPremultiplied, libYUVUsage, etc
//
//        // Alternative: set rgb.pixels and rgb.rowBytes yourself, which should match your chosen rgb.format
//        // Be sure to use uint16_t* instead of uint8_t* for rgb.pixels/rgb.rowBytes if (rgb.depth > 8)
//        avifRGBImageAllocatePixels(&rgb);
//
//        // Now available:
//        // * RGB(A) pixel data (rgb.pixels, rgb.rowBytes)
//
//        if (rgb.depth > 8) {
//            uint16_t * firstPixel = (uint16_t *)rgb.pixels;
//            printf(" * First pixel: RGBA(%u,%u,%u,%u)\n", firstPixel[0], firstPixel[1], firstPixel[2], firstPixel[3]);
//        } else {
//            uint8_t * firstPixel = rgb.pixels;
//            printf(" * First pixel: RGBA(%u,%u,%u,%u)\n", firstPixel[0], firstPixel[1], firstPixel[2], firstPixel[3]);
//        }
        int width = _idec -> image->width;
        int height = _idec -> image -> height;
        int last_y = 0;
        // image properties
        BOOL const monochrome = _idec->image->yuvPlanes[1] == NULL || _idec->image->yuvPlanes[2] == NULL;
        BOOL const hasAlpha = _idec->image->alphaPlane != NULL;
        size_t const components = (monochrome ? 1 : 3) + (hasAlpha ? 1 : 0);
        size_t const rowBytes = components * sizeof(uint8_t) * width;
        uint8_t* resultBufferData = calloc(components * rowBytes * height, sizeof(uint8_t));
        vImage_Buffer resultBuffer = {
            .data = resultBufferData,
            .width = width,
            .height = height,
            .rowBytes = width * components,
        };
//        _idec -> image ->
//        uint8_t *rgba = avifRgb(_idec, &last_y, &width, &height, &stride);
    
        if (0 < width + height) {
//            size_t rgbaSize = last_y * stride;
//            CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rgba, rgbaSize, NULL);
//            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
//            size_t components = 4;
//            CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
//
//            CGImageRef imageRef = CGImageCreate(width, last_y, 8, components * 8, components * width, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
//
            CGImageRef imageRef = CreateImageFromBuffer(_idec->image,&resultBuffer);
            
            if (!imageRef) {
                return nil;
            }
    
            CGColorSpaceRef canvasColorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGContextRef canvas = CGBitmapContextCreate(NULL, width, height, 8, 0, canvasColorSpaceRef, bitmapInfo);
            if (!canvas) {
                CGImageRelease(imageRef);
                CGColorSpaceRelease(canvasColorSpaceRef);
                return nil;
            }
    
            CGContextDrawImage(canvas, CGRectMake(0, height - last_y, width, last_y), imageRef);
            CGImageRef newImageRef = CGBitmapContextCreateImage(canvas);
    
            CGImageRelease(imageRef);
    
            if (!newImageRef) {
                return nil;
            }
    
            CGContextRelease(canvas);
            CGColorSpaceRelease(canvasColorSpaceRef);
    

    #if AVIF_PLUGIN_MAC
            image = [[NSImage alloc] initWithCGImage:newImageRef size:CGSizeZero];
    #else
            image = [UIImage imageWithCGImage:newImageRef scale:scale orientation:UIImageOrientationUp];
    #endif
            CGImageRelease(newImageRef);

            return image;
        }
    } else if (_idec->imageCount < 1){
        NSLog(@"ImageCount < 1");
        return nil;
    } else {
        NSLog(@"Animated images are not supported yet");
        avifDecoderDestroy(_idec);
        _idec = NULL;
        return image;
    }
    return image;
}

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
