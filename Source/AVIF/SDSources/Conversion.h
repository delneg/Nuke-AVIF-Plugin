//
//  Conversion.h
//  SDWebImageAVIFCoder
//
//  Created by Ryo Hirafuji on 2020/03/15.
//

#pragma once
#if __has_include(<libavif/avif.h>)
#import <libavif/avif.h>
#else
#import "avif/avif.h"
#endif
#import <Accelerate/Accelerate.h>

extern CGImageRef _Nullable SDCreateCGImageFromAVIF(avifImage * _Nonnull avif) __attribute__((visibility("hidden")));
extern CGImageRef _Nullable CreateImageFromBuffer(avifImage * _Nonnull avif, vImage_Buffer* _Nonnull result);
