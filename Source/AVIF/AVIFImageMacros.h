//
//  AVIFImageMacros.h
//  Nuke-AVIF-Plugin
//
//  Created by delneg on 2021/12/05.
//  Copyright © 2021 delneg. All rights reserved.
//
#import <TargetConditionals.h>

#ifndef AVIFImageMacros_h
#define AVIFImageMacros_h

#if !TARGET_OS_IPHONE && !TARGET_OS_IOS && !TARGET_OS_TV && !TARGET_OS_WATCH
    #define AVIF_PLUGIN_MAC 1
#else
    #define AVIF_PLUGIN_MAC 0
#endif

#if TARGET_OS_IOS || TARGET_OS_TV
    #define AVIF_PLUGIN_UIKIT 1
#else
    #define AVIF_PLUGIN_UIKIT 0
#endif

#if TARGET_OS_IOS
    #define AVIF_PLUGIN_IOS 1
#else
    #define AVIF_PLUGIN_IOS 0
#endif

#if TARGET_OS_TV
    #define AVIF_PLUGIN_TV 1
#else
    #define AVIF_PLUGIN_TV 0
#endif

#endif /* AVIFImageMacros_h */
